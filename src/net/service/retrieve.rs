use std::{
    io::Read,
    net::TcpStream,
    path::PathBuf,
    sync::atomic::{AtomicU16, Ordering},
};

use anyhow::Context;
use dicom_dictionary_std::{tags, uids};
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::{
    association::{Association, ServerAssociation},
    pdu::{PDataValue, PDataValueType},
    Pdu,
};
use tracing::warn;

use crate::{
    archive::{ArchiveRetrieveRequest, ArchiveRetrieveService, SqliteArchiveCatalog},
    config::AppConfig,
    db::Database,
    dicom::probe_file_identity,
    dicom::{get_str_opt_from_mem, read_u16_opt_from_mem, DefaultMemObject},
    error::Result,
    models::{LocalInstance, QueryLevel, QueryModel, RemoteNode},
    net::{
        assoc::{
            create_get_response, create_move_response, create_store_request_command,
            AssociationFactory, PDataAccumulator,
        },
        store_scu::{can_stream_source_dataset, open_part10_dataset_reader},
        transfer::can_send_file_with_transfer_syntax,
        ServerMetrics, StoreScu,
    },
};

use super::{DimseServiceKind, ServiceProvider};

const RETRIEVE_COMMAND_FIELDS: &[u16] = &[0x0021, 0x0010];
const RETRIEVE_ABSTRACT_SYNTAXES: &[&str] = &[
    uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE,
    uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE,
    uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_GET,
    uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_GET,
];

#[derive(Debug)]
pub struct RetrieveProvider {
    db: Database,
    retrieve_service: ArchiveRetrieveService,
    store_scu: StoreScu,
    get_store_message_id: AtomicU16,
    metrics: ServerMetrics,
}

#[derive(Debug, Clone, Copy, Default)]
pub struct RetrieveProviderDescriptor;

#[derive(Debug, Clone)]
pub struct MoveCommand {
    pub message_id: u16,
    pub sop_class_uid: String,
    pub move_destination: String,
    pub presentation_context_id: u8,
}

#[derive(Debug, Clone)]
pub struct GetCommand {
    pub message_id: u16,
    pub sop_class_uid: String,
    pub presentation_context_id: u8,
}

#[derive(Debug, Clone, Copy, Default)]
struct MoveCounters {
    completed: u32,
    failed: u32,
    warning: u32,
}

#[derive(Debug, Clone)]
struct GetStoreContext {
    id: u8,
    transfer_syntax: String,
}

#[derive(Debug, Clone, Copy, Default)]
struct GetSuboperationResult {
    counters: MoveCounters,
    canceled: bool,
    remaining: u32,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum GetStoreSuboperationOutcome {
    Status(u16),
    Canceled,
}

impl RetrieveProvider {
    pub fn new(config: AppConfig, db: Database) -> Self {
        Self::with_metrics(config, db, ServerMetrics::default())
    }

    pub fn with_metrics(config: AppConfig, db: Database, metrics: ServerMetrics) -> Self {
        let association_factory = AssociationFactory::new(
            config.local_ae_title.clone(),
            config.max_pdu_length,
            config.strict_pdu,
        );
        let store_scu = StoreScu::new(association_factory, config.preferred_store_transfer_syntax);
        Self {
            db: db.clone(),
            retrieve_service: ArchiveRetrieveService::new(SqliteArchiveCatalog::new(db)),
            store_scu,
            get_store_message_id: AtomicU16::new(1),
            metrics,
        }
    }

    pub fn descriptor() -> RetrieveProviderDescriptor {
        RetrieveProviderDescriptor
    }

    pub fn begin_move_command(
        &self,
        command: &DefaultMemObject,
        presentation_context_id: u8,
    ) -> Result<MoveCommand> {
        let message_id = read_u16_opt_from_mem(command, tags::MESSAGE_ID)
            .ok_or_else(|| {
                crate::net::err_with("error-net-missing-message-id", [("operation", "C-MOVE")])
            })?;
        let sop_class_uid = command
            .element(tags::AFFECTED_SOP_CLASS_UID)
            .context(crate::error::msg_with(
                "error-net-missing-affected-sop",
                [("operation", "C-MOVE")],
            ))?
            .to_str()
            .context(crate::error::msg_with(
                "error-net-invalid-affected-sop",
                [("operation", "C-MOVE")],
            ))?
            .trim_end_matches('\0')
            .to_string();
        let move_destination = get_str_opt_from_mem(command, tags::MOVE_DESTINATION)
            .ok_or_else(|| crate::net::err("error-net-missing-destination"))?;

        Ok(MoveCommand {
            message_id,
            sop_class_uid,
            move_destination,
            presentation_context_id,
        })
    }

    pub fn begin_get_command(
        &self,
        command: &DefaultMemObject,
        presentation_context_id: u8,
    ) -> Result<GetCommand> {
        let message_id = read_u16_opt_from_mem(command, tags::MESSAGE_ID)
            .ok_or_else(|| {
                crate::net::err_with("error-net-missing-message-id", [("operation", "C-GET")])
            })?;
        let sop_class_uid = command
            .element(tags::AFFECTED_SOP_CLASS_UID)
            .context(crate::error::msg_with(
                "error-net-missing-affected-sop",
                [("operation", "C-GET")],
            ))?
            .to_str()
            .context(crate::error::msg_with(
                "error-net-invalid-affected-sop",
                [("operation", "C-GET")],
            ))?
            .trim_end_matches('\0')
            .to_string();

        Ok(GetCommand {
            message_id,
            sop_class_uid,
            presentation_context_id,
        })
    }

    pub fn handle_move_command(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        move_command: &MoveCommand,
        identifier_bytes: &[u8],
    ) -> Result<()> {
        self.metrics.record_c_move_request();
        let context = association
            .presentation_contexts()
            .iter()
            .find(|context| context.id == move_command.presentation_context_id)
            .ok_or_else(|| {
                let id = move_command.presentation_context_id.to_string();
                crate::net::err_with(
                    "error-net-no-presentation-context-id",
                    [("id", id.as_str())],
                )
            })?;
        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| crate::net::err("error-net-unsupported-transfer-syntax"))?;

        let identifier =
            match DefaultMemObject::read_dataset_with_ts(identifier_bytes, transfer_syntax)
                .context(crate::error::msg_with(
                    "error-net-reading-identifier",
                    [("operation", "C-MOVE")],
                ))
            {
                Ok(identifier) => identifier,
                Err(err) => {
                    warn!("invalid C-MOVE identifier: {err:#}");
                    return self.send_move_response(association, move_command, 0xA900, 0, 0, 1, 0);
                }
            };

        let request = match Self::retrieve_request_from_identifier(
            &move_command.sop_class_uid,
            &identifier,
        ) {
            Ok(request) => request,
            Err(err) => {
                warn!("unsupported C-MOVE identifier: {err:#}");
                return self.send_move_response(association, move_command, 0xA900, 0, 0, 1, 0);
            }
        };

        let instances = match self.retrieve_service.resolve(request) {
            Ok(instances) => instances,
            Err(err) => {
                warn!("failed to resolve C-MOVE local instances: {err:#}");
                return self.send_move_response(association, move_command, 0xA900, 0, 0, 1, 0);
            }
        };
        let attempted = instances.len() as u32;

        let Some(destination) = self.resolve_move_destination(&move_command.move_destination)?
        else {
            return self.send_move_response(association, move_command, 0xA801, 0, 0, attempted, 0);
        };

        if attempted > 0 {
            self.send_move_response(association, move_command, 0xFF00, attempted, 0, 0, 0)?;
        }

        let counters =
            self.perform_suboperations(association, move_command, &destination, &instances)?;
        self.metrics
            .record_c_move_suboperations(counters.completed as u64, counters.failed as u64);
        let status = final_status(counters);
        self.send_move_response(
            association,
            move_command,
            status,
            0,
            counters.completed,
            counters.failed,
            counters.warning,
        )
    }

    pub fn handle_get_command(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        get_command: &GetCommand,
        identifier_bytes: &[u8],
    ) -> Result<()> {
        self.metrics.record_c_get_request();
        let context = association
            .presentation_contexts()
            .iter()
            .find(|context| context.id == get_command.presentation_context_id)
            .ok_or_else(|| {
                let id = get_command.presentation_context_id.to_string();
                crate::net::err_with(
                    "error-net-no-presentation-context-id",
                    [("id", id.as_str())],
                )
            })?;
        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| crate::net::err("error-net-unsupported-transfer-syntax"))?;

        let identifier =
            match DefaultMemObject::read_dataset_with_ts(identifier_bytes, transfer_syntax)
                .context(crate::error::msg_with(
                    "error-net-reading-identifier",
                    [("operation", "C-GET")],
                ))
            {
                Ok(identifier) => identifier,
                Err(err) => {
                    warn!("invalid C-GET identifier: {err:#}");
                    return self.send_get_response(association, get_command, 0xA900, 0, 0, 1, 0);
                }
            };

        let request = match Self::get_retrieve_request_from_identifier(
            &get_command.sop_class_uid,
            &identifier,
        ) {
            Ok(request) => request,
            Err(err) => {
                warn!("unsupported C-GET identifier: {err:#}");
                return self.send_get_response(association, get_command, 0xA900, 0, 0, 1, 0);
            }
        };

        let instances = match self.retrieve_service.resolve(request) {
            Ok(instances) => instances,
            Err(err) => {
                warn!("failed to resolve C-GET local instances: {err:#}");
                return self.send_get_response(association, get_command, 0xA900, 0, 0, 1, 0);
            }
        };
        let attempted = instances.len() as u32;

        if attempted > 0 {
            self.send_get_response(association, get_command, 0xFF00, attempted, 0, 0, 0)?;
        }

        let suboperations = self.perform_get_suboperations(association, get_command, &instances)?;
        let status = if suboperations.canceled {
            0xFE00
        } else {
            final_status(suboperations.counters)
        };
        self.send_get_response(
            association,
            get_command,
            status,
            suboperations.remaining,
            suboperations.counters.completed,
            suboperations.counters.failed,
            suboperations.counters.warning,
        )
    }

    fn retrieve_request_from_identifier(
        sop_class_uid: &str,
        identifier: &DefaultMemObject,
    ) -> Result<ArchiveRetrieveRequest> {
        let model = query_model_from_move_sop_class_uid(sop_class_uid)?;
        Self::retrieve_request_with_model(model, identifier, "C-MOVE")
    }

    fn get_retrieve_request_from_identifier(
        sop_class_uid: &str,
        identifier: &DefaultMemObject,
    ) -> Result<ArchiveRetrieveRequest> {
        let model = query_model_from_get_sop_class_uid(sop_class_uid)?;
        Self::retrieve_request_with_model(model, identifier, "C-GET")
    }

    fn retrieve_request_with_model(
        model: QueryModel,
        identifier: &DefaultMemObject,
        operation: &str,
    ) -> Result<ArchiveRetrieveRequest> {
        let level_value = get_str_opt_from_mem(identifier, tags::QUERY_RETRIEVE_LEVEL)
            .ok_or_else(|| {
                crate::net::err_with(
                    "error-net-missing-qr-level",
                    [("operation", operation)],
                )
            })?;
        let level = match level_value.as_str() {
            "PATIENT" => QueryLevel::Patient,
            "STUDY" => QueryLevel::Study,
            "SERIES" => QueryLevel::Series,
            "IMAGE" => QueryLevel::Image,
            other => {
                return Err(crate::net::err_with(
                    "error-net-unsupported-qr-level",
                    [("level", other)],
                ))
            }
        };

        Ok(ArchiveRetrieveRequest {
            model,
            level,
            study_instance_uid: get_str_opt_from_mem(identifier, tags::STUDY_INSTANCE_UID),
            series_instance_uid: get_str_opt_from_mem(identifier, tags::SERIES_INSTANCE_UID),
            sop_instance_uid: get_str_opt_from_mem(identifier, tags::SOP_INSTANCE_UID),
        })
    }

    fn resolve_move_destination(&self, move_destination: &str) -> Result<Option<RemoteNode>> {
        let requested = normalize_ae(move_destination);
        Ok(self
            .db
            .list_remote_nodes()?
            .into_iter()
            .find(|node| normalize_ae(&node.ae_title) == requested))
    }

    fn perform_suboperations(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        move_command: &MoveCommand,
        destination: &RemoteNode,
        instances: &[LocalInstance],
    ) -> Result<MoveCounters> {
        let total = instances.len() as u32;
        let mut counters = MoveCounters::default();

        for instance in instances {
            let path = PathBuf::from(&instance.managed_path);
            match self.store_scu.send_files(destination, &[path]) {
                Ok(outcome) => {
                    counters.completed += outcome.sent as u32;
                    counters.failed += outcome.failed as u32;
                    if outcome.sent == 0 && outcome.failed == 0 {
                        counters.failed += 1;
                    }
                }
                Err(err) => {
                    counters.failed += 1;
                    warn!(
                        sop_instance_uid = %instance.sop_instance_uid,
                        destination = %destination.ae_title,
                        "C-MOVE C-STORE suboperation failed: {err:#}"
                    );
                }
            }

            let done = counters.completed + counters.failed + counters.warning;
            let remaining = total.saturating_sub(done);
            if remaining > 0 {
                self.send_move_response(
                    association,
                    move_command,
                    0xFF00,
                    remaining,
                    counters.completed,
                    counters.failed,
                    counters.warning,
                )?;
            }
        }

        Ok(counters)
    }

    fn perform_get_suboperations(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        get_command: &GetCommand,
        instances: &[LocalInstance],
    ) -> Result<GetSuboperationResult> {
        let total = instances.len() as u32;
        let mut counters = MoveCounters::default();

        for instance in instances {
            match self.send_get_store_suboperation(association, instance) {
                Ok(GetStoreSuboperationOutcome::Status(0x0000)) => counters.completed += 1,
                Ok(GetStoreSuboperationOutcome::Status(status)) => {
                    counters.failed += 1;
                    warn!(
                        sop_instance_uid = %instance.sop_instance_uid,
                        status = %format_args!("0x{status:04X}"),
                        "C-GET C-STORE suboperation returned non-success status"
                    );
                }
                Ok(GetStoreSuboperationOutcome::Canceled) => {
                    let done = counters.completed + counters.failed + counters.warning;
                    return Ok(GetSuboperationResult {
                        counters,
                        canceled: true,
                        remaining: total.saturating_sub(done),
                    });
                }
                Err(err) => {
                    counters.failed += 1;
                    warn!(
                        sop_instance_uid = %instance.sop_instance_uid,
                        "C-GET C-STORE suboperation failed: {err:#}"
                    );
                }
            }

            let done = counters.completed + counters.failed + counters.warning;
            let remaining = total.saturating_sub(done);
            if remaining > 0 {
                self.send_get_response(
                    association,
                    get_command,
                    0xFF00,
                    remaining,
                    counters.completed,
                    counters.failed,
                    counters.warning,
                )?;
            }
        }

        Ok(GetSuboperationResult {
            counters,
            canceled: false,
            remaining: 0,
        })
    }

    fn send_get_store_suboperation(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        instance: &LocalInstance,
    ) -> Result<GetStoreSuboperationOutcome> {
        let path = PathBuf::from(&instance.managed_path);
        let (sop_class_uid, sop_instance_uid, source_transfer_syntax_uid) =
            probe_file_identity(&path)?;
        let context = select_get_store_context(
            association,
            &sop_class_uid,
            &source_transfer_syntax_uid,
        )
        .ok_or_else(|| {
            crate::net::err_with(
                "error-net-no-cget-store-context",
                [
                    ("sop", sop_class_uid.as_str()),
                    ("syntax", source_transfer_syntax_uid.as_str()),
                ],
            )
        })?;
        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| crate::net::err("error-net-unsupported-transfer-syntax"))?;
        let command = create_store_request_command(
            self.next_get_store_message_id(),
            &sop_class_uid,
            &sop_instance_uid,
        );
        let command_bytes = AssociationFactory::write_command_dataset(&command)?;
        let presentation_context_id = context.id;
        let negotiated_transfer_syntax = context.transfer_syntax.clone();

        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Command,
                is_last: true,
                data: command_bytes,
            }],
        })?;

        if can_stream_source_dataset(&negotiated_transfer_syntax, &source_transfer_syntax_uid) {
            let reader = open_part10_dataset_reader(&path)?;
            send_dataset_reader_on_server(association, presentation_context_id, reader)?;
        } else if can_send_file_with_transfer_syntax(
            &source_transfer_syntax_uid,
            &negotiated_transfer_syntax,
        ) {
            let file_obj = dicom_object::open_file(&path).with_context(|| {
                let path = path.display().to_string();
                crate::error::msg_with("error-net-opening-path", [("path", path.as_str())])
            })?;
            let mut dataset_bytes = Vec::new();
            file_obj
                .write_dataset_with_ts(&mut dataset_bytes, transfer_syntax)
                .with_context(|| {
                    let path = path.display().to_string();
                    crate::error::msg_with(
                        "error-net-serializing-cget-dataset",
                        [("path", path.as_str())],
                    )
                })?;
            send_dataset_bytes_on_server(association, presentation_context_id, &dataset_bytes)?;
        } else {
            return Err(crate::net::err_with(
                "error-net-cannot-send-transfer-syntax",
                [
                    ("source", source_transfer_syntax_uid.as_str()),
                    ("negotiated", negotiated_transfer_syntax.as_str()),
                ],
            ));
        }

        wait_for_store_response(association)
    }

    fn next_get_store_message_id(&self) -> u16 {
        self.get_store_message_id.fetch_add(1, Ordering::Relaxed)
    }

    fn send_move_response(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        move_command: &MoveCommand,
        status: u16,
        remaining: u32,
        completed: u32,
        failed: u32,
        warning: u32,
    ) -> Result<()> {
        let command = create_move_response(
            move_command.message_id,
            &move_command.sop_class_uid,
            status,
            remaining,
            completed,
            failed,
            warning,
        );
        let command_bytes = AssociationFactory::write_command_dataset(&command)?;
        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id: move_command.presentation_context_id,
                value_type: PDataValueType::Command,
                is_last: true,
                data: command_bytes,
            }],
        })?;
        Ok(())
    }

    fn send_get_response(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        get_command: &GetCommand,
        status: u16,
        remaining: u32,
        completed: u32,
        failed: u32,
        warning: u32,
    ) -> Result<()> {
        let command = create_get_response(
            get_command.message_id,
            &get_command.sop_class_uid,
            status,
            remaining,
            completed,
            failed,
            warning,
        );
        let command_bytes = AssociationFactory::write_command_dataset(&command)?;
        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id: get_command.presentation_context_id,
                value_type: PDataValueType::Command,
                is_last: true,
                data: command_bytes,
            }],
        })?;
        Ok(())
    }
}

fn select_get_store_context(
    association: &ServerAssociation<TcpStream>,
    sop_class_uid: &str,
    source_transfer_syntax_uid: &str,
) -> Option<GetStoreContext> {
    association
        .presentation_contexts()
        .iter()
        .filter(|context| context.abstract_syntax == sop_class_uid)
        .find(|context| {
            can_send_file_with_transfer_syntax(source_transfer_syntax_uid, &context.transfer_syntax)
        })
        .map(|context| GetStoreContext {
            id: context.id,
            transfer_syntax: context.transfer_syntax.clone(),
        })
}

fn wait_for_store_response(
    association: &mut ServerAssociation<TcpStream>,
) -> Result<GetStoreSuboperationOutcome> {
    let mut command_accumulator = PDataAccumulator::new();

    loop {
        match association.receive()? {
            Pdu::PData { data } => {
                for value in data {
                    match value.value_type {
                        PDataValueType::Command => command_accumulator.feed(&value)?,
                        PDataValueType::Data => {
                            return Err(crate::net::err(
                                "error-net-cget-store-unexpected-dataset",
                            ));
                        }
                    }
                }

                let Some(command) = command_accumulator.take_command()? else {
                    continue;
                };
                let command_field = read_u16_opt_from_mem(&command, tags::COMMAND_FIELD)
                    .ok_or_else(|| crate::net::err("error-net-missing-cstore-rsp-command-field"))?;
                match command_field {
                    0x8001 => {
                        let status = read_u16_opt_from_mem(&command, tags::STATUS)
                            .ok_or_else(|| crate::net::err("error-net-missing-cstore-rsp-status"))?;
                        return Ok(GetStoreSuboperationOutcome::Status(status));
                    }
                    0x0FFF => return Ok(GetStoreSuboperationOutcome::Canceled),
                    _ => {
                        let command = format!("{command_field:04X}");
                        return Err(crate::net::err_with(
                            "error-net-cget-unexpected-command",
                            [("command", command.as_str())],
                        ));
                    }
                }
            }
            Pdu::AbortRQ { source } => {
                let source = format!("{source:?}");
                return Err(crate::net::err_with(
                    "error-net-peer-aborted",
                    [("source", source.as_str())],
                ));
            }
            Pdu::ReleaseRQ => return Err(crate::net::err("error-net-cget-peer-released")),
            other => {
                let pdu = format!("{other:?}");
                return Err(crate::net::err_with(
                    "error-net-cget-unexpected-pdu",
                    [("pdu", pdu.as_str())],
                ));
            }
        }
    }
}

fn send_dataset_bytes_on_server(
    association: &mut ServerAssociation<TcpStream>,
    presentation_context_id: u8,
    dataset_bytes: &[u8],
) -> Result<()> {
    validate_dataset_payload(dataset_bytes.len())?;
    let max_pdv_payload = max_pdv_payload(association.peer_max_pdu_length() as usize);
    let total_chunks = dataset_bytes.len().div_ceil(max_pdv_payload);
    for (index, chunk) in dataset_bytes.chunks(max_pdv_payload).enumerate() {
        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Data,
                is_last: index + 1 == total_chunks,
                data: chunk.to_vec(),
            }],
        })?;
    }
    Ok(())
}

fn send_dataset_reader_on_server<R: Read>(
    association: &mut ServerAssociation<TcpStream>,
    presentation_context_id: u8,
    mut reader: R,
) -> Result<()> {
    let max_pdv_payload = max_pdv_payload(association.peer_max_pdu_length() as usize);
    let mut buf = vec![0_u8; max_pdv_payload];
    let mut previous = Vec::new();

    loop {
        let n = reader.read(&mut buf)?;
        if n == 0 {
            break;
        }

        previous.extend_from_slice(&buf[..n]);
        while previous.len() > max_pdv_payload {
            let remainder = previous.split_off(max_pdv_payload);
            let chunk = std::mem::replace(&mut previous, remainder);
            association.send(&Pdu::PData {
                data: vec![PDataValue {
                    presentation_context_id,
                    value_type: PDataValueType::Data,
                    is_last: false,
                    data: chunk,
                }],
            })?;
        }
    }

    validate_dataset_payload(previous.len())?;
    association.send(&Pdu::PData {
        data: vec![PDataValue {
            presentation_context_id,
            value_type: PDataValueType::Data,
            is_last: true,
            data: previous,
        }],
    })?;
    Ok(())
}

fn validate_dataset_payload(len: usize) -> Result<()> {
    if len == 0 {
        return Err(crate::net::err("error-net-cget-dataset-empty"));
    }
    if !len.is_multiple_of(2) {
        return Err(crate::net::err("error-net-cget-dataset-odd-length"));
    }
    Ok(())
}

fn max_pdv_payload(peer_max_pdu_length: usize) -> usize {
    const PDATA_PDV_OVERHEAD: usize = 12;
    const DEFAULT_PDV_PAYLOAD: usize = 64 * 1024;

    if peer_max_pdu_length == 0 {
        return DEFAULT_PDV_PAYLOAD;
    }
    let usable = peer_max_pdu_length.saturating_sub(PDATA_PDV_OVERHEAD);
    if usable == 0 {
        return DEFAULT_PDV_PAYLOAD;
    }
    (usable & !1).max(2)
}

impl ServiceProvider for RetrieveProvider {
    fn kind(&self) -> DimseServiceKind {
        DimseServiceKind::Retrieve
    }

    fn name(&self) -> &'static str {
        "RetrieveProvider"
    }

    fn abstract_syntaxes(&self) -> &'static [&'static str] {
        RETRIEVE_ABSTRACT_SYNTAXES
    }

    fn command_fields(&self) -> &'static [u16] {
        RETRIEVE_COMMAND_FIELDS
    }
}

impl ServiceProvider for RetrieveProviderDescriptor {
    fn kind(&self) -> DimseServiceKind {
        DimseServiceKind::Retrieve
    }

    fn name(&self) -> &'static str {
        "RetrieveProvider"
    }

    fn abstract_syntaxes(&self) -> &'static [&'static str] {
        RETRIEVE_ABSTRACT_SYNTAXES
    }

    fn command_fields(&self) -> &'static [u16] {
        RETRIEVE_COMMAND_FIELDS
    }
}

fn query_model_from_move_sop_class_uid(sop_class_uid: &str) -> Result<QueryModel> {
    match sop_class_uid.trim_end_matches('\0') {
        uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE => Ok(QueryModel::StudyRoot),
        uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE => Ok(QueryModel::PatientRoot),
        other => Err(crate::net::err_with(
            "error-net-unsupported-model-sop",
            [("operation", "C-MOVE"), ("uid", other)],
        )),
    }
}

fn query_model_from_get_sop_class_uid(sop_class_uid: &str) -> Result<QueryModel> {
    match sop_class_uid.trim_end_matches('\0') {
        uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_GET => Ok(QueryModel::StudyRoot),
        uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_GET => Ok(QueryModel::PatientRoot),
        other => Err(crate::net::err_with(
            "error-net-unsupported-model-sop",
            [("operation", "C-GET"), ("uid", other)],
        )),
    }
}

fn final_status(counters: MoveCounters) -> u16 {
    if counters.failed == 0 && counters.warning == 0 {
        0x0000
    } else if counters.completed > 0 || counters.warning > 0 {
        0xB000
    } else {
        0xA702
    }
}

fn normalize_ae(value: &str) -> String {
    value.trim_end_matches('\0').trim().to_ascii_uppercase()
}
