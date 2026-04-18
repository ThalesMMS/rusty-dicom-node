use std::{
    collections::{BTreeMap, HashMap},
    net::TcpStream,
    path::PathBuf,
};

use anyhow::{anyhow, Context};
use dicom_dictionary_std::tags;
use dicom_object::OpenFileOptions;
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::pdu::{PDataValue, PDataValueType, Pdu};
use tracing::warn;

use crate::{
    config::StoreTransferSyntaxPreference,
    dicom::{inspect_file_identity, DefaultFileObject},
    error::Result,
    models::{RemoteNode, SendOutcome},
};

use super::{
    assoc::{
        create_store_request_command, AssociationFactory, NegotiatedContext, PDataAccumulator,
        PresentationContextDefinition,
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
        let files = self.inspect_files(paths)?;
        if files.is_empty() {
            return Ok(SendOutcome::default());
        }

        let contexts = build_contexts(&files, self.default_transfer_syntax);
        let mut association = self
            .association_factory
            .establish_with_presentation_contexts(node, &contexts)?;

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

        for file in files {
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

            match self.send_one(&mut association, context, &file) {
                Ok(()) => outcome.sent += 1,
                Err(err) => {
                    outcome.failed += 1;
                    outcome
                        .failures
                        .push(format!("{}: {}", file.path.display(), err));
                }
            }
        }

        let _ = association.release();
        Ok(outcome)
    }

    fn inspect_files(&self, paths: &[PathBuf]) -> Result<Vec<StoreFile>> {
        let mut out = Vec::new();

        for path in paths {
            let file_obj = OpenFileOptions::new()
                .read_all()
                .open_file(path)
                .with_context(|| format!("opening {}", path.display()))?;

            let (sop_class_uid, sop_instance_uid, transfer_syntax_uid) =
                inspect_file_identity(&file_obj)?;

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
    ) -> Result<()> {
        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| anyhow!("unsupported negotiated transfer syntax"))?;

        let file_obj: DefaultFileObject =
            OpenFileOptions::new()
                .read_all()
                .open_file(&file.path)
                .with_context(|| format!("opening {}", file.path.display()))?;

        let command = create_store_request_command(
            self.association_factory.next_message_id(),
            &file.sop_class_uid,
            &file.sop_instance_uid,
        );

        let mut dataset_bytes = Vec::new();
        file_obj
            .into_inner()
            .write_dataset_with_ts(&mut dataset_bytes, transfer_syntax)
            .with_context(|| format!("writing dataset for {}", file.path.display()))?;

        AssociationFactory::send_command_and_dataset(
            association,
            context.id,
            &command,
            dataset_bytes,
        )?;

        let mut command_accumulator = PDataAccumulator::new();

        loop {
            match association.receive()? {
                Pdu::PData { data } => {
                    if data.is_empty() {
                        continue;
                    }

                    match process_store_response_pdata(&data, &mut command_accumulator) {
                        Ok(Some(0x0000)) => return Ok(()),
                        Ok(Some(status)) => {
                            warn!(
                                path = %file.path.display(),
                                sop_class_uid = %file.sop_class_uid,
                                sop_instance_uid = %file.sop_instance_uid,
                                status = %format_args!("0x{status:04X}"),
                                "remote returned non-success C-STORE status"
                            );
                            return Err(anyhow!("remote returned C-STORE status 0x{status:04X}"));
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
                            return Err(err);
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
                    return Err(anyhow!("remote aborted association: {:?}", source));
                }
                Pdu::ReleaseRQ => {
                    ensure_complete_store_response(&command_accumulator)?;
                    warn!(
                        path = %file.path.display(),
                        sop_class_uid = %file.sop_class_uid,
                        sop_instance_uid = %file.sop_instance_uid,
                        "unexpected ReleaseRQ during C-STORE"
                    );
                    return Err(anyhow!("unexpected PDU during C-STORE: ReleaseRQ"));
                }
                other => {
                    warn!(
                        path = %file.path.display(),
                        sop_class_uid = %file.sop_class_uid,
                        sop_instance_uid = %file.sop_instance_uid,
                        pdu = ?other,
                        "unexpected PDU during C-STORE"
                    );
                    return Err(anyhow!("unexpected PDU during C-STORE: {:?}", other));
                }
            }
        }
    }
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

    let status = response
        .element(tags::STATUS)
        .context("missing C-STORE response status")?
        .to_int::<u16>()
        .context("invalid C-STORE response status")?;
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
        build_contexts, ensure_complete_store_response, process_store_response_pdata,
        select_negotiated_context, StoreFile,
    };
    use crate::config::StoreTransferSyntaxPreference;
    use crate::net::assoc::{
        create_store_response, AssociationFactory, NegotiatedContext, PDataAccumulator,
    };
    use dicom_dictionary_std::uids::{
        CT_IMAGE_STORAGE, EXPLICIT_VR_LITTLE_ENDIAN, JPEG2000_LOSSLESS,
    };
    use dicom_ul::pdu::{PDataValue, PDataValueType, Pdu};
    use std::path::PathBuf;

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
