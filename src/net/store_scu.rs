use std::{
    collections::{BTreeMap, HashMap},
    fs::File,
    io::{Read, Seek, SeekFrom, Write},
    net::TcpStream,
    path::{Path, PathBuf},
    sync::atomic::AtomicBool,
};

use anyhow::{anyhow, Context};
use dicom_dictionary_std::tags;
use dicom_transfer_syntax_registry::{entries, TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::pdu::{AbortRQSource, PDataValue, PDataValueType, Pdu};
use tracing::warn;

use crate::{
    cancel,
    config::StoreTransferSyntaxPreference,
    dicom::probe_file_identity,
    error::Result,
    models::{RemoteNode, SendOutcome},
};

use super::{
    assoc::{
        classify_assoc_receive_error, create_store_request_command, AssociationFactory,
        NegotiatedContext, PDataAccumulator, PresentationContextDefinition,
    },
    malformed_response::{
        require_cmd_u16, validate_common_response_fields, MalformedDimseResponse, Operation,
    },
    transfer::{can_send_file_with_transfer_syntax, common_store_transfer_syntaxes},
};

#[derive(Debug, Clone)]
pub struct StoreScu {
    association_factory: AssociationFactory,
    default_transfer_syntax: StoreTransferSyntaxPreference,
}

#[derive(Debug, Clone)]
struct StoreFile {
    path: PathBuf,
    sop_class_uid: String,
    sop_instance_uid: String,
    transfer_syntax_uid: String,
}

impl StoreScu {
    pub fn new(
        association_factory: AssociationFactory,
        default_transfer_syntax: StoreTransferSyntaxPreference,
    ) -> Self {
        Self {
            association_factory,
            default_transfer_syntax,
        }
    }

    pub fn send_files(&self, node: &RemoteNode, paths: &[PathBuf]) -> Result<SendOutcome> {
        self.send_files_with_cancel(node, paths, None)
    }

    pub fn send_files_cancellable(
        &self,
        node: &RemoteNode,
        paths: &[PathBuf],
        cancel_flag: &AtomicBool,
    ) -> Result<SendOutcome> {
        self.send_files_with_cancel(node, paths, Some(cancel_flag))
    }

    fn send_files_with_cancel(
        &self,
        node: &RemoteNode,
        paths: &[PathBuf],
        cancel_flag: Option<&AtomicBool>,
    ) -> Result<SendOutcome> {
        cancel::ensure_not_cancelled(cancel_flag)?;
        let files = self.inspect_files(paths, cancel_flag)?;
        if files.is_empty() {
            return Ok(SendOutcome::default());
        }

        let contexts = build_contexts(&files, self.default_transfer_syntax);
        cancel::ensure_not_cancelled(cancel_flag)?;
        let mut association = match cancel_flag {
            Some(flag) => self
                .association_factory
                .establish_with_presentation_contexts_cancellable(node, &contexts, flag)?,
            None => self
                .association_factory
                .establish_with_presentation_contexts(node, &contexts)?,
        };

        let negotiated = self.association_factory.negotiated_contexts(&association);
        let mut contexts_by_abstract: HashMap<String, Vec<NegotiatedContext>> = HashMap::new();
        for context in negotiated {
            contexts_by_abstract
                .entry(context.abstract_syntax.clone())
                .or_default()
                .push(context);
        }

        let mut outcome = SendOutcome {
            attempted: files.len(),
            ..SendOutcome::default()
        };
        let mut association_fatal = false;

        for file in files {
            if let Err(err) = cancel::ensure_not_cancelled(cancel_flag) {
                abort_association(&mut association);
                return Err(err);
            }
            let Some(negotiated_contexts) = contexts_by_abstract.get(&file.sop_class_uid) else {
                outcome.failed += 1;
                outcome.failures.push(format!(
                    "{}: no negotiated presentation context",
                    file.path.display()
                ));
                continue;
            };
            let Some(context) = select_negotiated_context(
                negotiated_contexts,
                &file.transfer_syntax_uid,
                self.default_transfer_syntax,
            ) else {
                outcome.failed += 1;
                outcome.failures.push(format!(
                    "{}: no compatible negotiated presentation context for source transfer syntax {}",
                    file.path.display(),
                    file.transfer_syntax_uid
                ));
                continue;
            };

            match self.send_one(&mut association, context, &file, cancel_flag) {
                Ok(()) => outcome.sent += 1,
                Err(err) if cancel::is_cancelled_error(&err.source) => {
                    abort_association(&mut association);
                    return Err(err.source);
                }
                Err(err) => {
                    outcome.failed += 1;
                    outcome
                        .failures
                        .push(format!("{}: {}", file.path.display(), err.source));
                    if err.association_fatal {
                        association_fatal = true;
                        break;
                    }
                }
            }
        }

        if !association_fatal {
            let _ = association.release();
        }
        Ok(outcome)
    }

    fn inspect_files(
        &self,
        paths: &[PathBuf],
        cancel_flag: Option<&AtomicBool>,
    ) -> Result<Vec<StoreFile>> {
        let mut out = Vec::new();

        for path in paths {
            cancel::ensure_not_cancelled(cancel_flag)?;
            let (sop_class_uid, sop_instance_uid, transfer_syntax_uid) = probe_file_identity(path)?;

            out.push(StoreFile {
                path: path.clone(),
                sop_class_uid,
                sop_instance_uid,
                transfer_syntax_uid,
            });
        }

        Ok(out)
    }

    fn send_one(
        &self,
        association: &mut dicom_ul::association::ClientAssociation<TcpStream>,
        context: &NegotiatedContext,
        file: &StoreFile,
        cancel_flag: Option<&AtomicBool>,
    ) -> std::result::Result<(), StoreSendError> {
        cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| anyhow!("unsupported negotiated transfer syntax"))
            .map_err(StoreSendError::recoverable)?;

        let command = create_store_request_command(
            self.association_factory.next_message_id(),
            &file.sop_class_uid,
            &file.sop_instance_uid,
        );

        if can_stream_source_dataset(transfer_syntax.uid(), &file.transfer_syntax_uid) {
            cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
            let mut dataset_reader =
                open_part10_dataset_reader(&file.path).map_err(StoreSendError::recoverable)?;
            let command_bytes = AssociationFactory::write_command_dataset(&command)
                .map_err(StoreSendError::recoverable)?;

            cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
            if let Err(err) = association.send(&Pdu::PData {
                data: vec![PDataValue {
                    presentation_context_id: context.id,
                    value_type: PDataValueType::Command,
                    is_last: true,
                    data: command_bytes,
                }],
            }) {
                abort_association(association);
                return Err(StoreSendError::fatal(err.into()));
            }

            cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
            let send_result = match cancel_flag {
                Some(flag) => AssociationFactory::send_dataset_chunked_from_reader_cancellable(
                    association,
                    context.id,
                    &mut dataset_reader,
                    flag,
                ),
                None => AssociationFactory::send_dataset_chunked_from_reader(
                    association,
                    context.id,
                    &mut dataset_reader,
                ),
            };
            if let Err(err) = send_result {
                abort_association(association);
                return Err(StoreSendError::fatal(
                    err.context("streaming C-STORE dataset"),
                ));
            }
        } else {
            cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
            let in_file = dicom_object::open_file(&file.path)
                .with_context(|| format!("opening {}", file.path.display()))
                .map_err(StoreSendError::recoverable)?;
            let mut dataset_bytes = Vec::new();
            let mut dataset_writer = CancellableVecWriter::new(&mut dataset_bytes, cancel_flag);
            in_file
                .write_dataset_with_ts(&mut dataset_writer, transfer_syntax)
                .with_context(|| {
                    format!(
                        "serializing dataset for {} with transfer syntax {}",
                        file.path.display(),
                        transfer_syntax.uid()
                    )
                })
                .map_err(StoreSendError::recoverable)?;

            cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
            self.send_prepared_dataset(
                association,
                context.id,
                &command,
                &dataset_bytes,
                &file.path,
                cancel_flag,
            )?;
        }

        let mut command_accumulator = PDataAccumulator::new();

        loop {
            cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
            let pdu = association
                .receive()
                .map_err(|err| StoreSendError::fatal(classify_assoc_receive_error(err)))?;
            match pdu {
                Pdu::PData { data } => {
                    if data.is_empty() {
                        continue;
                    }

                    match process_store_response_pdata(&data, &mut command_accumulator) {
                        Ok(Some(status)) => {
                            let Some(status_info) = crate::net::dimse_status::interpret_status(
                                Operation::CStore,
                                status,
                            ) else {
                                return Err(StoreSendError::fatal(anyhow!(
                                    MalformedDimseResponse::new(
                                        Operation::CStore,
                                        format!("unknown or invalid C-STORE status 0x{status:04X}"),
                                    )
                                )));
                            };

                            match status_info.category {
                                crate::net::dimse_status::StatusCategory::Success => return Ok(()),
                                crate::net::dimse_status::StatusCategory::Warning
                                | crate::net::dimse_status::StatusCategory::Failure
                                | crate::net::dimse_status::StatusCategory::Cancel
                                | crate::net::dimse_status::StatusCategory::Pending => {
                                    warn!(
                                        path = %file.path.display(),
                                        sop_class_uid = %file.sop_class_uid,
                                        sop_instance_uid = %file.sop_instance_uid,
                                        status = %format_args!("0x{status:04X}"),
                                        meaning = status_info.meaning,
                                        "remote returned non-success C-STORE status"
                                    );
                                    return Err(StoreSendError::recoverable(anyhow!(
                                        "remote returned C-STORE status 0x{status:04X} ({}){}",
                                        status_info.meaning,
                                        status_info
                                            .hint
                                            .map(|hint| format!("; hint: {hint}"))
                                            .unwrap_or_default()
                                    )));
                                }
                            }
                        }
                        Ok(None) => continue,
                        Err(err) => {
                            warn!(
                                path = %file.path.display(),
                                sop_class_uid = %file.sop_class_uid,
                                sop_instance_uid = %file.sop_instance_uid,
                                error = %err,
                                "C-STORE response failed"
                            );
                            return Err(StoreSendError::fatal(err));
                        }
                    }
                }
                Pdu::AbortRQ { source } => {
                    warn!(
                        path = %file.path.display(),
                        sop_class_uid = %file.sop_class_uid,
                        sop_instance_uid = %file.sop_instance_uid,
                        source = ?source,
                        "remote aborted association during C-STORE"
                    );
                    return Err(StoreSendError::fatal(anyhow!(
                        "remote aborted association: {:?}",
                        source
                    )));
                }
                Pdu::ReleaseRQ => {
                    ensure_complete_store_response(&command_accumulator)
                        .map_err(StoreSendError::fatal)?;
                    warn!(
                        path = %file.path.display(),
                        sop_class_uid = %file.sop_class_uid,
                        sop_instance_uid = %file.sop_instance_uid,
                        "fatal association release during C-STORE"
                    );
                    return Err(StoreSendError::fatal(anyhow!(
                        "unexpected PDU during C-STORE: ReleaseRQ"
                    )));
                }
                other => {
                    warn!(
                        path = %file.path.display(),
                        sop_class_uid = %file.sop_class_uid,
                        sop_instance_uid = %file.sop_instance_uid,
                        pdu = ?other,
                        "unexpected PDU during C-STORE"
                    );
                    return Err(StoreSendError::fatal(anyhow!(
                        "unexpected PDU during C-STORE: {:?}",
                        other
                    )));
                }
            }
        }
    }

    fn send_prepared_dataset(
        &self,
        association: &mut dicom_ul::association::ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        command: &crate::dicom::DefaultMemObject,
        dataset_bytes: &[u8],
        path: &Path,
        cancel_flag: Option<&AtomicBool>,
    ) -> std::result::Result<(), StoreSendError> {
        let command_bytes = AssociationFactory::write_command_dataset(command)
            .map_err(StoreSendError::recoverable)?;

        cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
        if let Err(err) = association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Command,
                is_last: true,
                data: command_bytes,
            }],
        }) {
            abort_association(association);
            return Err(StoreSendError::fatal(err.into()));
        }

        cancel::ensure_not_cancelled(cancel_flag).map_err(StoreSendError::fatal)?;
        match cancel_flag {
            Some(flag) => AssociationFactory::send_dataset_chunked_cancellable(
                association,
                presentation_context_id,
                dataset_bytes,
                flag,
            ),
            None => AssociationFactory::send_dataset_chunked(
                association,
                presentation_context_id,
                dataset_bytes,
            ),
        }
        .with_context(|| format!("sending buffered dataset for {}", path.display()))
        .map_err(|err| {
            abort_association(association);
            StoreSendError::fatal(err)
        })
    }
}

struct CancellableVecWriter<'a> {
    inner: &'a mut Vec<u8>,
    cancel_flag: Option<&'a AtomicBool>,
}

impl<'a> CancellableVecWriter<'a> {
    fn new(inner: &'a mut Vec<u8>, cancel_flag: Option<&'a AtomicBool>) -> Self {
        Self { inner, cancel_flag }
    }
}

impl Write for CancellableVecWriter<'_> {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        if cancel::is_cancelled(self.cancel_flag) {
            return Err(cancel::io_error());
        }
        self.inner.write(buf)
    }

    fn flush(&mut self) -> std::io::Result<()> {
        if cancel::is_cancelled(self.cancel_flag) {
            return Err(cancel::io_error());
        }
        self.inner.flush()
    }
}

#[derive(Debug)]
struct StoreSendError {
    source: anyhow::Error,
    association_fatal: bool,
}

impl StoreSendError {
    fn recoverable(source: anyhow::Error) -> Self {
        Self {
            source,
            association_fatal: false,
        }
    }

    fn fatal(source: anyhow::Error) -> Self {
        Self {
            source,
            association_fatal: true,
        }
    }
}

fn can_stream_source_dataset(negotiated_uid: &str, source_uid: &str) -> bool {
    negotiated_uid == source_uid.trim() && is_streaming_transfer_syntax(negotiated_uid)
}

fn is_streaming_transfer_syntax(uid: &str) -> bool {
    uid == entries::EXPLICIT_VR_LITTLE_ENDIAN.uid()
        || uid == entries::IMPLICIT_VR_LITTLE_ENDIAN.uid()
}

fn open_part10_dataset_reader(path: &Path) -> Result<File> {
    let mut file = File::open(path).with_context(|| format!("opening {}", path.display()))?;
    skip_part10_file_meta(&mut file)
        .with_context(|| format!("locating dataset in {}", path.display()))?;
    Ok(file)
}

fn skip_part10_file_meta(file: &mut File) -> Result<()> {
    let mut preamble = [0_u8; 132];
    file.read_exact(&mut preamble)
        .context("reading Part 10 preamble")?;
    if &preamble[128..] != b"DICM" {
        return Err(anyhow!("missing Part 10 DICM marker"));
    }

    loop {
        let element_start = file.stream_position().context("reading file position")?;
        let mut tag = [0_u8; 4];
        match file.read_exact(&mut tag) {
            Ok(()) => {}
            Err(err) if err.kind() == std::io::ErrorKind::UnexpectedEof => return Ok(()),
            Err(err) => return Err(err).context("reading File Meta Information tag"),
        }

        let group = u16::from_le_bytes([tag[0], tag[1]]);
        if group != 0x0002 {
            file.seek(SeekFrom::Start(element_start))
                .context("rewinding to first dataset element")?;
            return Ok(());
        }

        let mut vr = [0_u8; 2];
        file.read_exact(&mut vr)
            .context("reading File Meta Information VR")?;

        let value_len = if uses_32_bit_explicit_vr_length(&vr) {
            let mut reserved_and_len = [0_u8; 6];
            file.read_exact(&mut reserved_and_len)
                .context("reading File Meta Information length")?;
            u32::from_le_bytes([
                reserved_and_len[2],
                reserved_and_len[3],
                reserved_and_len[4],
                reserved_and_len[5],
            ]) as u64
        } else {
            let mut len = [0_u8; 2];
            file.read_exact(&mut len)
                .context("reading File Meta Information length")?;
            u16::from_le_bytes(len) as u64
        };

        file.seek(SeekFrom::Current(value_len as i64))
            .context("skipping File Meta Information value")?;
    }
}

fn uses_32_bit_explicit_vr_length(vr: &[u8; 2]) -> bool {
    matches!(
        vr,
        b"OB" | b"OD" | b"OF" | b"OL" | b"OV" | b"OW" | b"SQ" | b"UC" | b"UN" | b"UR" | b"UT"
    )
}

fn abort_association(association: &mut dicom_ul::association::ClientAssociation<TcpStream>) {
    let _ = association.send(&Pdu::AbortRQ {
        source: AbortRQSource::ServiceUser,
    });
}

fn process_store_response_pdata(
    data: &[PDataValue],
    command_accumulator: &mut PDataAccumulator,
) -> Result<Option<u16>> {
    if data.is_empty() {
        return Ok(None);
    }

    for value in data {
        match value.value_type {
            PDataValueType::Command => command_accumulator.feed(value)?,
            PDataValueType::Data => {
                return Err(anyhow!("unexpected dataset fragment in C-STORE response"));
            }
        }
    }

    let Some(response) = command_accumulator.take_command()? else {
        return Ok(None);
    };

    validate_common_response_fields(Operation::CStore, &response)?;

    // C-STORE-RSP command field is 0x8001
    let command_field = require_cmd_u16(
        Operation::CStore,
        &response,
        tags::COMMAND_FIELD,
        "CommandField",
    )?;
    if command_field != 0x8001 {
        return Err(anyhow!(MalformedDimseResponse::new(
            Operation::CStore,
            format!(
                "unexpected CommandField 0x{command_field:04X} (expected 0x8001 for C-STORE-RSP)"
            )
        )));
    }

    let status = require_cmd_u16(Operation::CStore, &response, tags::STATUS, "Status")?;
    Ok(Some(status))
}

fn ensure_complete_store_response(command_accumulator: &PDataAccumulator) -> Result<()> {
    if command_accumulator.is_empty() {
        Ok(())
    } else {
        Err(anyhow!("incomplete C-STORE command response"))
    }
}

fn build_contexts(
    files: &[StoreFile],
    default_transfer_syntax: StoreTransferSyntaxPreference,
) -> Vec<PresentationContextDefinition> {
    let mut grouped: BTreeMap<String, Vec<String>> = BTreeMap::new();

    for file in files {
        let entry = grouped.entry(file.sop_class_uid.clone()).or_default();

        for ts in common_store_transfer_syntaxes(default_transfer_syntax, &file.transfer_syntax_uid)
        {
            if !entry.iter().any(|existing| existing == &ts) {
                entry.push(ts);
            }
        }
    }

    grouped
        .into_iter()
        .flat_map(|(abstract_syntax, transfer_syntaxes)| {
            transfer_syntaxes.into_iter().map(move |transfer_syntax| {
                PresentationContextDefinition {
                    abstract_syntax: abstract_syntax.clone(),
                    transfer_syntaxes: vec![transfer_syntax],
                }
            })
        })
        .collect()
}

fn select_negotiated_context<'a>(
    negotiated_contexts: &'a [NegotiatedContext],
    file_transfer_syntax: &str,
    default_transfer_syntax: StoreTransferSyntaxPreference,
) -> Option<&'a NegotiatedContext> {
    for candidate in common_store_transfer_syntaxes(default_transfer_syntax, file_transfer_syntax) {
        if !can_send_file_with_transfer_syntax(file_transfer_syntax, &candidate) {
            continue;
        }

        if let Some(context) = negotiated_contexts
            .iter()
            .find(|context| context.transfer_syntax == candidate)
        {
            return Some(context);
        }
    }

    negotiated_contexts.iter().find(|context| {
        can_send_file_with_transfer_syntax(file_transfer_syntax, &context.transfer_syntax)
    })
}

#[cfg(test)]
mod tests {
    use super::{
        build_contexts, can_stream_source_dataset, ensure_complete_store_response,
        open_part10_dataset_reader, process_store_response_pdata, select_negotiated_context,
        CancellableVecWriter, StoreFile,
    };
    use crate::config::StoreTransferSyntaxPreference;
    use crate::net::assoc::{
        create_store_response, AssociationFactory, NegotiatedContext, PDataAccumulator,
    };
    use dicom_dictionary_std::uids::{
        CT_IMAGE_STORAGE, EXPLICIT_VR_LITTLE_ENDIAN, JPEG2000_LOSSLESS,
    };
    use dicom_ul::pdu::{PDataValue, PDataValueType, Pdu};
    use std::{
        io::{Read, Write},
        path::PathBuf,
        sync::atomic::AtomicBool,
    };

    fn command_bytes(status: u16) -> Vec<u8> {
        let command = create_store_response(1, CT_IMAGE_STORAGE, "1.2.3", status);
        AssociationFactory::write_command_dataset(&command).unwrap()
    }

    fn command_pdata(data: impl Into<Vec<u8>>, is_last: bool) -> PDataValue {
        PDataValue {
            presentation_context_id: 1,
            value_type: PDataValueType::Command,
            is_last,
            data: data.into(),
        }
    }

    fn data_pdata(data: impl Into<Vec<u8>>, is_last: bool) -> PDataValue {
        PDataValue {
            presentation_context_id: 1,
            value_type: PDataValueType::Data,
            is_last,
            data: data.into(),
        }
    }

    fn feed_pdu(pdu: Pdu, accumulator: &mut PDataAccumulator) -> crate::error::Result<Option<u16>> {
        match pdu {
            Pdu::PData { data } => process_store_response_pdata(&data, accumulator),
            other => panic!("unexpected test PDU: {other:?}"),
        }
    }

    #[test]
    fn parses_command_split_within_same_pdu() {
        let bytes = command_bytes(0x0000);
        let split_at = bytes.len() / 2;
        let pdu = Pdu::PData {
            data: vec![
                command_pdata(bytes[..split_at].to_vec(), false),
                command_pdata(bytes[split_at..].to_vec(), true),
            ],
        };
        let mut accumulator = PDataAccumulator::new();

        assert_eq!(feed_pdu(pdu, &mut accumulator).unwrap(), Some(0x0000));
    }

    #[test]
    fn parses_command_split_across_pdu_receives() {
        let bytes = command_bytes(0x0000);
        let split_at = bytes.len() / 2;
        let first = Pdu::PData {
            data: vec![command_pdata(bytes[..split_at].to_vec(), false)],
        };
        let second = Pdu::PData {
            data: vec![command_pdata(bytes[split_at..].to_vec(), true)],
        };
        let mut accumulator = PDataAccumulator::new();

        assert_eq!(feed_pdu(first, &mut accumulator).unwrap(), None);
        assert_eq!(feed_pdu(second, &mut accumulator).unwrap(), Some(0x0000));
    }

    #[test]
    fn empty_pdata_is_ignored() {
        let mut accumulator = PDataAccumulator::new();

        assert_eq!(
            feed_pdu(Pdu::PData { data: Vec::new() }, &mut accumulator).unwrap(),
            None
        );
    }

    #[test]
    fn cancellable_vec_writer_stops_when_cancelled() {
        let cancel_flag = AtomicBool::new(true);
        let mut bytes = Vec::new();
        let mut writer = CancellableVecWriter::new(&mut bytes, Some(&cancel_flag));

        let error: anyhow::Error = writer.write(b"abc").unwrap_err().into();

        assert!(crate::cancel::is_cancelled_error(&error));
        assert!(bytes.is_empty());
    }

    #[test]
    fn incomplete_command_reports_clear_error_when_finalized() {
        let bytes = command_bytes(0x0000);
        let mut accumulator = PDataAccumulator::new();

        assert_eq!(
            feed_pdu(
                Pdu::PData {
                    data: vec![command_pdata(bytes, false)]
                },
                &mut accumulator
            )
            .unwrap(),
            None
        );

        let error = ensure_complete_store_response(&accumulator)
            .unwrap_err()
            .to_string();
        assert!(error.contains("incomplete C-STORE command response"));
    }

    #[test]
    fn unparseable_command_keeps_command_dataset_context() {
        let mut accumulator = PDataAccumulator::new();

        let error = feed_pdu(
            Pdu::PData {
                data: vec![command_pdata([0, 1, 2, 3], true)],
            },
            &mut accumulator,
        )
        .unwrap_err();

        assert!(format!("{error:#}").contains("reading command dataset"));
    }

    #[test]
    fn unexpected_dataset_fragment_errors() {
        let mut accumulator = PDataAccumulator::new();

        let error = feed_pdu(
            Pdu::PData {
                data: vec![data_pdata([1, 2, 3], true)],
            },
            &mut accumulator,
        )
        .unwrap_err()
        .to_string();

        assert!(error.contains("unexpected dataset fragment in C-STORE response"));
    }

    #[test]
    fn non_success_status_is_preserved_for_caller_logging() {
        let mut accumulator = PDataAccumulator::new();

        let status = feed_pdu(
            Pdu::PData {
                data: vec![command_pdata(command_bytes(0xB000), true)],
            },
            &mut accumulator,
        )
        .unwrap();

        assert_eq!(status, Some(0xB000));
    }

    #[test]
    fn part10_dataset_reader_skips_full_file_meta_information() {
        let mut file = tempfile::NamedTempFile::new().unwrap();
        let mut bytes = vec![0_u8; 128];
        bytes.extend_from_slice(b"DICM");
        bytes.extend_from_slice(&[0x02, 0x00, 0x00, 0x00]);
        bytes.extend_from_slice(b"UL");
        bytes.extend_from_slice(&4_u16.to_le_bytes());
        bytes.extend_from_slice(&30_u32.to_le_bytes());
        bytes.extend_from_slice(&[0x02, 0x00, 0x10, 0x00]);
        bytes.extend_from_slice(b"UI");
        let transfer_syntax = b"1.2.840.10008.1.2\0";
        bytes.extend_from_slice(&(transfer_syntax.len() as u16).to_le_bytes());
        bytes.extend_from_slice(transfer_syntax);
        let dataset = [
            0x10, 0x00, 0x10, 0x00, b'P', b'N', 4, 0, b'A', b'B', b'C', b'D',
        ];
        bytes.extend_from_slice(&dataset);
        file.write_all(&bytes).unwrap();

        let mut reader = open_part10_dataset_reader(file.path()).unwrap();
        let mut got = Vec::new();
        reader.read_to_end(&mut got).unwrap();

        assert_eq!(got, dataset);
    }

    #[test]
    fn streaming_requires_matching_little_endian_transfer_syntax() {
        assert!(can_stream_source_dataset(
            EXPLICIT_VR_LITTLE_ENDIAN,
            EXPLICIT_VR_LITTLE_ENDIAN
        ));
        assert!(!can_stream_source_dataset(
            EXPLICIT_VR_LITTLE_ENDIAN,
            dicom_dictionary_std::uids::IMPLICIT_VR_LITTLE_ENDIAN
        ));
        assert!(!can_stream_source_dataset(
            JPEG2000_LOSSLESS,
            JPEG2000_LOSSLESS
        ));
    }

    #[test]
    fn build_contexts_creates_one_presentation_context_per_transfer_syntax() {
        let files = vec![StoreFile {
            path: PathBuf::from("/tmp/a.dcm"),
            sop_class_uid: CT_IMAGE_STORAGE.to_string(),
            sop_instance_uid: "1.2.3".to_string(),
            transfer_syntax_uid: EXPLICIT_VR_LITTLE_ENDIAN.to_string(),
        }];

        let contexts = build_contexts(&files, StoreTransferSyntaxPreference::Jpeg2000Lossless);

        assert!(contexts.iter().any(|context| {
            context.abstract_syntax == CT_IMAGE_STORAGE
                && context.transfer_syntaxes == vec![JPEG2000_LOSSLESS.to_string()]
        }));
        assert!(contexts.iter().any(|context| {
            context.abstract_syntax == CT_IMAGE_STORAGE
                && context.transfer_syntaxes == vec![EXPLICIT_VR_LITTLE_ENDIAN.to_string()]
        }));
    }

    #[test]
    fn select_negotiated_context_skips_unusable_default_transfer_syntax() {
        let negotiated_contexts = vec![
            NegotiatedContext {
                id: 1,
                abstract_syntax: CT_IMAGE_STORAGE.to_string(),
                transfer_syntax: JPEG2000_LOSSLESS.to_string(),
            },
            NegotiatedContext {
                id: 3,
                abstract_syntax: CT_IMAGE_STORAGE.to_string(),
                transfer_syntax: EXPLICIT_VR_LITTLE_ENDIAN.to_string(),
            },
        ];

        let chosen = select_negotiated_context(
            &negotiated_contexts,
            EXPLICIT_VR_LITTLE_ENDIAN,
            StoreTransferSyntaxPreference::Jpeg2000Lossless,
        )
        .expect("a compatible negotiated context");

        assert_eq!(chosen.id, 3);
    }

    #[test]
    fn select_negotiated_context_prefers_matching_default_when_file_already_uses_it() {
        let negotiated_contexts = vec![
            NegotiatedContext {
                id: 1,
                abstract_syntax: CT_IMAGE_STORAGE.to_string(),
                transfer_syntax: JPEG2000_LOSSLESS.to_string(),
            },
            NegotiatedContext {
                id: 3,
                abstract_syntax: CT_IMAGE_STORAGE.to_string(),
                transfer_syntax: EXPLICIT_VR_LITTLE_ENDIAN.to_string(),
            },
        ];

        let chosen = select_negotiated_context(
            &negotiated_contexts,
            JPEG2000_LOSSLESS,
            StoreTransferSyntaxPreference::Jpeg2000Lossless,
        )
        .expect("the matching JPEG 2000 negotiated context");

        assert_eq!(chosen.id, 1);
    }
}
