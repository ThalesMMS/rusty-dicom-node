use std::{
    collections::HashMap,
    net::TcpStream,
    path::PathBuf,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, Mutex,
    },
    thread::JoinHandle,
    time::Duration,
};

use anyhow::{anyhow, Context};
use dicom_core::{dicom_value, DataElement, PrimitiveValue, VR};
use dicom_dictionary_std::{tags, uids};
use dicom_node_client::{
    config::{StoreTransferSyntaxPreference, RECOMMENDED_MAX_PDU_LENGTH},
    dicom::{get_str_opt, read_u16_opt_from_mem, DefaultMemObject},
    models::RemoteNode,
    net::{
        assoc::{create_echo_response, AssociationFactory},
        transfer::all_supported_transfer_syntaxes,
        StoreScu,
    },
};
use dicom_object::mem::InMemDicomObject;
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::association::ServerAssociationOptions;

use super::{
    bind_test_listener, element_string, is_preflight_probe, negotiated_transfer_syntax,
    next_dimse_message, send_command,
};
use crate::common::services::remote_node_fixture;

#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub enum MoveFailureMode {
    #[default]
    None,
    RefuseDestination,
    PartialFailure {
        failed: u32,
    },
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ReceivedMove {
    pub move_destination: String,
    pub level: Option<String>,
    pub study_instance_uid: Option<String>,
    pub series_instance_uid: Option<String>,
    pub sop_instance_uid: Option<String>,
}

#[derive(Debug)]
pub struct MoveScpBuilder {
    ae_title: String,
    port: u16,
    files: Vec<PathBuf>,
    destinations: HashMap<String, Destination>,
    failure_mode: MoveFailureMode,
}

#[derive(Debug)]
pub struct MoveScp {
    ae_title: String,
    port: u16,
    stop_flag: Arc<AtomicBool>,
    received: Arc<Mutex<Vec<ReceivedMove>>>,
    join_handle: Option<JoinHandle<anyhow::Result<()>>>,
}

#[derive(Debug, Clone)]
struct Destination {
    host: String,
    port: u16,
}

impl MoveScpBuilder {
    pub fn new() -> anyhow::Result<Self> {
        Ok(Self {
            ae_title: "MOVESCP".to_string(),
            port: 0,
            files: Vec::new(),
            destinations: HashMap::new(),
            failure_mode: MoveFailureMode::None,
        })
    }

    pub fn ae_title(mut self, ae_title: impl Into<String>) -> Self {
        self.ae_title = ae_title.into();
        self
    }

    pub fn port(mut self, port: u16) -> Self {
        self.port = port;
        self
    }

    pub fn files(mut self, files: Vec<PathBuf>) -> Self {
        self.files = files;
        self
    }

    pub fn destination(mut self, ae_title: impl Into<String>, port: u16) -> Self {
        self.destinations.insert(
            normalize_ae(ae_title.into()),
            Destination {
                host: "127.0.0.1".to_string(),
                port,
            },
        );
        self
    }

    pub fn destination_node(mut self, node: &RemoteNode) -> Self {
        self.destinations.insert(
            normalize_ae(&node.ae_title),
            Destination {
                host: node.host.clone(),
                port: node.port,
            },
        );
        self
    }

    pub fn failure_mode(mut self, failure_mode: MoveFailureMode) -> Self {
        self.failure_mode = failure_mode;
        self
    }

    pub fn partial_failures(mut self, failed: u32) -> Self {
        self.failure_mode = MoveFailureMode::PartialFailure { failed };
        self
    }

    pub fn refuse_destination(mut self) -> Self {
        self.failure_mode = MoveFailureMode::RefuseDestination;
        self
    }

    pub fn spawn(self) -> anyhow::Result<MoveScp> {
        let listener = bind_test_listener(self.port)?;
        let port = listener
            .local_addr()
            .context("reading move SCP listener port")?
            .port();
        let stop_flag = Arc::new(AtomicBool::new(false));
        let received = Arc::new(Mutex::new(Vec::new()));
        let thread_stop = stop_flag.clone();
        let thread_received = received.clone();
        let ae_title = self.ae_title.clone();
        let files = Arc::new(self.files);
        let destinations = Arc::new(self.destinations);
        let failure_mode = self.failure_mode;

        let join_handle = std::thread::spawn(move || {
            while !thread_stop.load(Ordering::Relaxed) {
                match listener.accept() {
                    Ok((stream, _addr)) => {
                        handle_move_connection(
                            stream,
                            &ae_title,
                            files.as_ref(),
                            destinations.as_ref(),
                            failure_mode,
                            &thread_received,
                        )?;
                    }
                    Err(err) if err.kind() == std::io::ErrorKind::WouldBlock => {
                        std::thread::sleep(Duration::from_millis(25));
                    }
                    Err(err) => return Err(err.into()),
                }
            }
            Ok(())
        });

        Ok(MoveScp {
            ae_title: self.ae_title,
            port,
            stop_flag,
            received,
            join_handle: Some(join_handle),
        })
    }
}

impl MoveScp {
    pub fn builder() -> anyhow::Result<MoveScpBuilder> {
        MoveScpBuilder::new()
    }

    pub fn port(&self) -> u16 {
        self.port
    }

    pub fn remote_node(&self, name: &str) -> RemoteNode {
        remote_node_fixture(name, &self.ae_title, self.port)
    }

    pub fn stop(mut self) -> anyhow::Result<Vec<ReceivedMove>> {
        self.stop_flag.store(true, Ordering::Relaxed);
        if let Some(join_handle) = self.join_handle.take() {
            join_handle
                .join()
                .map_err(|_| anyhow!("move SCP thread panicked"))??;
        }
        let received = self
            .received
            .lock()
            .map_err(|_| anyhow!("move SCP received list lock poisoned"))?
            .clone();
        Ok(received)
    }
}

fn handle_move_connection(
    stream: TcpStream,
    ae_title: &str,
    files: &[PathBuf],
    destinations: &HashMap<String, Destination>,
    failure_mode: MoveFailureMode,
    received: &Arc<Mutex<Vec<ReceivedMove>>>,
) -> anyhow::Result<()> {
    stream
        .set_nonblocking(false)
        .context("setting move SCP stream blocking")?;
    if is_preflight_probe(&stream)? {
        return Ok(());
    }

    let mut options = ServerAssociationOptions::new()
        .accept_called_ae_title()
        .ae_title(ae_title.to_string())
        .strict(true)
        .read_timeout(Duration::from_secs(1))
        .write_timeout(Duration::from_secs(1))
        .with_abstract_syntax(uids::VERIFICATION)
        .with_abstract_syntax(uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE)
        .with_abstract_syntax(uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE);
    for transfer_syntax in all_supported_transfer_syntaxes() {
        options = options.with_transfer_syntax(transfer_syntax);
    }

    let mut association = options.establish(stream)?;

    while let Some(message) = next_dimse_message(&mut association)? {
        let command_field = read_u16_opt_from_mem(&message.command, tags::COMMAND_FIELD)
            .ok_or_else(|| anyhow!("missing command field"))?;
        match command_field {
            0x0030 => {
                let message_id = read_u16_opt_from_mem(&message.command, tags::MESSAGE_ID)
                    .ok_or_else(|| anyhow!("missing C-ECHO message id"))?;
                let response = create_echo_response(message_id, 0x0000);
                send_command(&mut association, message.presentation_context_id, &response)?;
            }
            0x0021 => {
                let transfer_syntax_uid =
                    negotiated_transfer_syntax(&association, message.presentation_context_id)?;
                let transfer_syntax = TransferSyntaxRegistry
                    .get(&transfer_syntax_uid)
                    .ok_or_else(|| anyhow!("unsupported negotiated transfer syntax"))?;
                let identifier = DefaultMemObject::read_dataset_with_ts(
                    message.dataset_bytes.as_slice(),
                    transfer_syntax,
                )
                .context("reading C-MOVE identifier")?;
                let move_destination = element_string(&message.command, tags::MOVE_DESTINATION)
                    .ok_or_else(|| anyhow!("missing C-MOVE destination"))?;
                received
                    .lock()
                    .map_err(|_| anyhow!("move SCP received list lock poisoned"))?
                    .push(received_move_from_identifier(
                        &identifier,
                        move_destination.clone(),
                    ));

                let message_id = read_u16_opt_from_mem(&message.command, tags::MESSAGE_ID)
                    .ok_or_else(|| anyhow!("missing C-MOVE message id"))?;
                let sop_class_uid = element_string(&message.command, tags::AFFECTED_SOP_CLASS_UID)
                    .unwrap_or_else(|| {
                        uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE.to_string()
                    });

                if should_refuse_move(&move_destination, destinations, failure_mode) {
                    let final_response = move_response_command(
                        message_id,
                        &sop_class_uid,
                        0xA801,
                        0,
                        0,
                        files.len() as u32,
                        0,
                    );
                    send_command(
                        &mut association,
                        message.presentation_context_id,
                        &final_response,
                    )?;
                    continue;
                }

                let attempted = matching_move_files(files, &identifier)?.len() as u32;
                let pending =
                    move_response_command(message_id, &sop_class_uid, 0xFF00, attempted, 0, 0, 0);
                send_command(&mut association, message.presentation_context_id, &pending)?;

                let outcome = perform_move(
                    ae_title,
                    files,
                    destinations,
                    &move_destination,
                    failure_mode,
                    &identifier,
                )?;
                let final_response = move_response_command(
                    message_id,
                    &sop_class_uid,
                    outcome.status,
                    0,
                    outcome.completed,
                    outcome.failed,
                    outcome.warning,
                );
                send_command(
                    &mut association,
                    message.presentation_context_id,
                    &final_response,
                )?;
            }
            other => return Err(anyhow!("unsupported move SCP command 0x{other:04X}")),
        }
    }

    Ok(())
}

#[derive(Debug, Clone, Copy)]
struct MoveHarnessOutcome {
    status: u16,
    completed: u32,
    failed: u32,
    warning: u32,
}

fn perform_move(
    ae_title: &str,
    files: &[PathBuf],
    destinations: &HashMap<String, Destination>,
    move_destination: &str,
    failure_mode: MoveFailureMode,
    identifier: &DefaultMemObject,
) -> anyhow::Result<MoveHarnessOutcome> {
    let files = matching_move_files(files, identifier)?;
    let attempted = files.len() as u32;
    if matches!(failure_mode, MoveFailureMode::RefuseDestination) {
        return Ok(MoveHarnessOutcome {
            status: 0xA801,
            completed: 0,
            failed: attempted,
            warning: 0,
        });
    }

    let Some(destination) = destinations.get(&normalize_ae(move_destination)) else {
        return Ok(MoveHarnessOutcome {
            status: 0xA801,
            completed: 0,
            failed: attempted,
            warning: 0,
        });
    };

    let configured_failed = match failure_mode {
        MoveFailureMode::PartialFailure { failed } => failed.min(attempted),
        MoveFailureMode::None | MoveFailureMode::RefuseDestination => 0,
    };
    let send_count = files.len().saturating_sub(configured_failed as usize);
    let files_to_send = files[..send_count].to_vec();
    let node = RemoteNode {
        id: String::new(),
        name: "move-destination".to_string(),
        ae_title: move_destination.to_string(),
        host: destination.host.clone(),
        port: destination.port,
        preferred_move_destination: None,
        notes: None,
        created_at: String::new(),
        updated_at: String::new(),
    };
    let store_scu = StoreScu::new(
        AssociationFactory::new(ae_title.to_string(), RECOMMENDED_MAX_PDU_LENGTH, true),
        StoreTransferSyntaxPreference::ExplicitVrLittleEndian,
    );

    match store_scu.send_files(&node, &files_to_send) {
        Ok(outcome) => {
            let failed = configured_failed + outcome.failed as u32;
            Ok(MoveHarnessOutcome {
                status: if failed == 0 { 0x0000 } else { 0xB000 },
                completed: outcome.sent as u32,
                failed,
                warning: 0,
            })
        }
        Err(_) => Ok(MoveHarnessOutcome {
            status: 0xA702,
            completed: 0,
            failed: attempted,
            warning: 0,
        }),
    }
}

fn matching_move_files(
    files: &[PathBuf],
    identifier: &DefaultMemObject,
) -> anyhow::Result<Vec<PathBuf>> {
    let requested = requested_move_uids(identifier);
    let mut matching = Vec::new();

    for file in files {
        let obj = dicom_object::open_file(file)
            .with_context(|| format!("reading move source file {}", file.display()))?;
        if requested.matches(
            get_str_opt(&obj, tags::STUDY_INSTANCE_UID).as_deref(),
            get_str_opt(&obj, tags::SERIES_INSTANCE_UID).as_deref(),
            get_str_opt(&obj, tags::SOP_INSTANCE_UID).as_deref(),
        ) {
            matching.push(file.clone());
        }
    }

    Ok(matching)
}

#[derive(Debug)]
struct RequestedMoveUids {
    study_instance_uid: Option<String>,
    series_instance_uid: Option<String>,
    sop_instance_uid: Option<String>,
}

fn requested_move_uids(identifier: &DefaultMemObject) -> RequestedMoveUids {
    RequestedMoveUids {
        study_instance_uid: element_string(identifier, tags::STUDY_INSTANCE_UID),
        series_instance_uid: element_string(identifier, tags::SERIES_INSTANCE_UID),
        sop_instance_uid: element_string(identifier, tags::SOP_INSTANCE_UID),
    }
}

impl RequestedMoveUids {
    fn matches(
        &self,
        study_instance_uid: Option<&str>,
        series_instance_uid: Option<&str>,
        sop_instance_uid: Option<&str>,
    ) -> bool {
        uid_matches(self.study_instance_uid.as_deref(), study_instance_uid)
            && uid_matches(self.series_instance_uid.as_deref(), series_instance_uid)
            && uid_matches(self.sop_instance_uid.as_deref(), sop_instance_uid)
    }
}

fn uid_matches(requested: Option<&str>, candidate: Option<&str>) -> bool {
    let Some(requested) = requested.map(str::trim).filter(|value| !value.is_empty()) else {
        return true;
    };

    candidate
        .map(str::trim)
        .is_some_and(|candidate| candidate == requested)
}

fn should_refuse_move(
    move_destination: &str,
    destinations: &HashMap<String, Destination>,
    failure_mode: MoveFailureMode,
) -> bool {
    matches!(failure_mode, MoveFailureMode::RefuseDestination)
        || !destinations.contains_key(&normalize_ae(move_destination))
}

fn received_move_from_identifier(
    identifier: &DefaultMemObject,
    move_destination: String,
) -> ReceivedMove {
    ReceivedMove {
        move_destination,
        level: element_string(identifier, tags::QUERY_RETRIEVE_LEVEL),
        study_instance_uid: element_string(identifier, tags::STUDY_INSTANCE_UID),
        series_instance_uid: element_string(identifier, tags::SERIES_INSTANCE_UID),
        sop_instance_uid: element_string(identifier, tags::SOP_INSTANCE_UID),
    }
}

fn move_response_command(
    message_id: u16,
    sop_class_uid: &str,
    status: u16,
    remaining: u32,
    completed: u32,
    failed: u32,
    warning: u32,
) -> DefaultMemObject {
    InMemDicomObject::command_from_element_iter([
        DataElement::new(
            tags::AFFECTED_SOP_CLASS_UID,
            VR::UI,
            PrimitiveValue::from(sop_class_uid),
        ),
        DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x8021])),
        DataElement::new(
            tags::MESSAGE_ID_BEING_RESPONDED_TO,
            VR::US,
            dicom_value!(U16, [message_id]),
        ),
        DataElement::new(
            tags::COMMAND_DATA_SET_TYPE,
            VR::US,
            dicom_value!(U16, [0x0101]),
        ),
        DataElement::new(tags::STATUS, VR::US, dicom_value!(U16, [status])),
        DataElement::new(
            tags::NUMBER_OF_REMAINING_SUBOPERATIONS,
            VR::US,
            dicom_value!(U16, [remaining.min(u16::MAX as u32) as u16]),
        ),
        DataElement::new(
            tags::NUMBER_OF_COMPLETED_SUBOPERATIONS,
            VR::US,
            dicom_value!(U16, [completed.min(u16::MAX as u32) as u16]),
        ),
        DataElement::new(
            tags::NUMBER_OF_FAILED_SUBOPERATIONS,
            VR::US,
            dicom_value!(U16, [failed.min(u16::MAX as u32) as u16]),
        ),
        DataElement::new(
            tags::NUMBER_OF_WARNING_SUBOPERATIONS,
            VR::US,
            dicom_value!(U16, [warning.min(u16::MAX as u32) as u16]),
        ),
    ])
}

fn normalize_ae(value: impl AsRef<str>) -> String {
    value.as_ref().trim().to_ascii_uppercase()
}
