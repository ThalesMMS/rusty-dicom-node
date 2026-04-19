use std::{
    net::TcpStream,
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
    dicom::{put_string, read_u16_opt_from_mem, DefaultMemObject},
    models::{QueryLevel, QueryMatch, RemoteNode},
    net::transfer::all_supported_transfer_syntaxes,
};
use dicom_object::mem::InMemDicomObject;
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::association::ServerAssociationOptions;

use super::{
    bind_test_listener, element_string, is_preflight_probe, negotiated_transfer_syntax,
    next_dimse_message, send_command, send_command_and_dataset,
};
use crate::common::services::remote_node_fixture;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ReceivedQuery {
    pub level: Option<String>,
    pub patient_name: Option<String>,
    pub patient_id: Option<String>,
    pub accession_number: Option<String>,
    pub study_instance_uid: Option<String>,
    pub series_instance_uid: Option<String>,
    pub sop_instance_uid: Option<String>,
    pub modality: Option<String>,
    pub study_description: Option<String>,
}

#[derive(Debug)]
pub struct QueryScpBuilder {
    ae_title: String,
    port: u16,
    matches: Vec<QueryMatch>,
}

#[derive(Debug)]
pub struct QueryScp {
    ae_title: String,
    port: u16,
    stop_flag: Arc<AtomicBool>,
    received: Arc<Mutex<Vec<ReceivedQuery>>>,
    join_handle: Option<JoinHandle<anyhow::Result<()>>>,
}

impl QueryScpBuilder {
    pub fn new() -> anyhow::Result<Self> {
        Ok(Self {
            ae_title: "QUERYSCP".to_string(),
            port: 0,
            matches: Vec::new(),
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

    pub fn matches(mut self, matches: Vec<QueryMatch>) -> Self {
        self.matches = matches;
        self
    }

    pub fn spawn(self) -> anyhow::Result<QueryScp> {
        let listener = bind_test_listener(self.port)?;
        let port = listener
            .local_addr()
            .context("reading query SCP listener port")?
            .port();
        let stop_flag = Arc::new(AtomicBool::new(false));
        let received = Arc::new(Mutex::new(Vec::new()));
        let thread_stop = stop_flag.clone();
        let thread_received = received.clone();
        let ae_title = self.ae_title.clone();
        let matches = Arc::new(self.matches);
        let thread_matches = matches.clone();

        let join_handle = std::thread::spawn(move || {
            while !thread_stop.load(Ordering::Relaxed) {
                match listener.accept() {
                    Ok((stream, _addr)) => {
                        handle_query_connection(
                            stream,
                            &ae_title,
                            thread_matches.as_ref(),
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

        Ok(QueryScp {
            ae_title: self.ae_title,
            port,
            stop_flag,
            received,
            join_handle: Some(join_handle),
        })
    }
}

impl QueryScp {
    pub fn builder() -> anyhow::Result<QueryScpBuilder> {
        QueryScpBuilder::new()
    }

    pub fn port(&self) -> u16 {
        self.port
    }

    pub fn remote_node(&self, name: &str) -> RemoteNode {
        remote_node_fixture(name, &self.ae_title, self.port)
    }

    pub fn stop(mut self) -> anyhow::Result<Vec<ReceivedQuery>> {
        self.stop_flag.store(true, Ordering::Relaxed);
        if let Some(join_handle) = self.join_handle.take() {
            join_handle
                .join()
                .map_err(|_| anyhow!("query SCP thread panicked"))??;
        }
        let received = self
            .received
            .lock()
            .map_err(|_| anyhow!("query SCP received list lock poisoned"))?
            .clone();
        Ok(received)
    }
}

fn handle_query_connection(
    stream: TcpStream,
    ae_title: &str,
    matches: &[QueryMatch],
    received: &Arc<Mutex<Vec<ReceivedQuery>>>,
) -> anyhow::Result<()> {
    stream
        .set_nonblocking(false)
        .context("setting query SCP stream blocking")?;
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
        .with_abstract_syntax(uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND)
        .with_abstract_syntax(uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND);
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
                let response =
                    dicom_node_client::net::assoc::create_echo_response(message_id, 0x0000);
                send_command(&mut association, message.presentation_context_id, &response)?;
            }
            0x0020 => {
                let transfer_syntax_uid =
                    negotiated_transfer_syntax(&association, message.presentation_context_id)?;
                let transfer_syntax = TransferSyntaxRegistry
                    .get(&transfer_syntax_uid)
                    .ok_or_else(|| anyhow!("unsupported negotiated transfer syntax"))?;
                let identifier = DefaultMemObject::read_dataset_with_ts(
                    message.dataset_bytes.as_slice(),
                    transfer_syntax,
                )
                .context("reading C-FIND identifier")?;
                received
                    .lock()
                    .map_err(|_| anyhow!("query SCP received list lock poisoned"))?
                    .push(received_query_from_identifier(&identifier));

                let message_id = read_u16_opt_from_mem(&message.command, tags::MESSAGE_ID)
                    .ok_or_else(|| anyhow!("missing C-FIND message id"))?;
                let sop_class_uid = element_string(&message.command, tags::AFFECTED_SOP_CLASS_UID)
                    .unwrap_or_else(|| {
                        uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND.to_string()
                    });

                for query_match in matches
                    .iter()
                    .filter(|query_match| query_matches_identifier(query_match, &identifier))
                {
                    let response = find_response_command(message_id, &sop_class_uid, 0xFF00, true);
                    let response_dataset = dataset_from_query_match(query_match);
                    let mut dataset_bytes = Vec::new();
                    response_dataset
                        .write_dataset_with_ts(&mut dataset_bytes, transfer_syntax)
                        .context("writing C-FIND response dataset")?;
                    send_command_and_dataset(
                        &mut association,
                        message.presentation_context_id,
                        &response,
                        dataset_bytes,
                    )?;
                }

                let final_response =
                    find_response_command(message_id, &sop_class_uid, 0x0000, false);
                send_command(
                    &mut association,
                    message.presentation_context_id,
                    &final_response,
                )?;
            }
            other => return Err(anyhow!("unsupported query SCP command 0x{other:04X}")),
        }
    }

    Ok(())
}

fn received_query_from_identifier(identifier: &DefaultMemObject) -> ReceivedQuery {
    ReceivedQuery {
        level: element_string(identifier, tags::QUERY_RETRIEVE_LEVEL),
        patient_name: element_string(identifier, tags::PATIENT_NAME),
        patient_id: element_string(identifier, tags::PATIENT_ID),
        accession_number: element_string(identifier, tags::ACCESSION_NUMBER),
        study_instance_uid: element_string(identifier, tags::STUDY_INSTANCE_UID),
        series_instance_uid: element_string(identifier, tags::SERIES_INSTANCE_UID),
        sop_instance_uid: element_string(identifier, tags::SOP_INSTANCE_UID),
        modality: element_string(identifier, tags::MODALITY),
        study_description: element_string(identifier, tags::STUDY_DESCRIPTION),
    }
}

fn query_matches_identifier(query_match: &QueryMatch, identifier: &DefaultMemObject) -> bool {
    if let Some(level) = element_string(identifier, tags::QUERY_RETRIEVE_LEVEL) {
        if level != query_match.level.as_dicom_str() {
            return false;
        }
    }

    field_matches(
        element_string(identifier, tags::PATIENT_NAME).as_deref(),
        query_match.patient_name.as_deref(),
    ) && field_matches(
        element_string(identifier, tags::PATIENT_ID).as_deref(),
        query_match.patient_id.as_deref(),
    ) && field_matches(
        element_string(identifier, tags::ACCESSION_NUMBER).as_deref(),
        query_match.accession_number.as_deref(),
    ) && field_matches(
        element_string(identifier, tags::STUDY_INSTANCE_UID).as_deref(),
        query_match.study_instance_uid.as_deref(),
    ) && field_matches(
        element_string(identifier, tags::SERIES_INSTANCE_UID).as_deref(),
        query_match.series_instance_uid.as_deref(),
    ) && field_matches(
        element_string(identifier, tags::SOP_INSTANCE_UID).as_deref(),
        query_match.sop_instance_uid.as_deref(),
    ) && field_matches(
        element_string(identifier, tags::MODALITY).as_deref(),
        query_match.modality.as_deref(),
    ) && field_matches(
        element_string(identifier, tags::STUDY_DESCRIPTION).as_deref(),
        query_match.study_description.as_deref(),
    )
}

fn field_matches(requested: Option<&str>, candidate: Option<&str>) -> bool {
    let Some(requested) = requested.map(str::trim).filter(|value| !value.is_empty()) else {
        return true;
    };

    let Some(candidate) = candidate.map(str::trim) else {
        return false;
    };

    if requested.chars().any(|value| matches!(value, '*' | '?')) {
        wildcard_matches(requested, candidate)
    } else {
        candidate == requested
    }
}

fn wildcard_matches(pattern: &str, candidate: &str) -> bool {
    let pattern = pattern.chars().collect::<Vec<_>>();
    let candidate = candidate.chars().collect::<Vec<_>>();
    let mut matches = vec![vec![false; candidate.len() + 1]; pattern.len() + 1];
    matches[0][0] = true;

    for pattern_index in 1..=pattern.len() {
        if pattern[pattern_index - 1] == '*' {
            matches[pattern_index][0] = matches[pattern_index - 1][0];
        }
    }

    for pattern_index in 1..=pattern.len() {
        for candidate_index in 1..=candidate.len() {
            matches[pattern_index][candidate_index] = match pattern[pattern_index - 1] {
                '*' => {
                    matches[pattern_index - 1][candidate_index]
                        || matches[pattern_index][candidate_index - 1]
                }
                '?' => matches[pattern_index - 1][candidate_index - 1],
                literal => {
                    literal == candidate[candidate_index - 1]
                        && matches[pattern_index - 1][candidate_index - 1]
                }
            };
        }
    }

    matches[pattern.len()][candidate.len()]
}

fn find_response_command(
    message_id: u16,
    sop_class_uid: &str,
    status: u16,
    has_dataset: bool,
) -> DefaultMemObject {
    InMemDicomObject::command_from_element_iter([
        DataElement::new(
            tags::AFFECTED_SOP_CLASS_UID,
            VR::UI,
            PrimitiveValue::from(sop_class_uid),
        ),
        DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x8020])),
        DataElement::new(
            tags::MESSAGE_ID_BEING_RESPONDED_TO,
            VR::US,
            dicom_value!(U16, [message_id]),
        ),
        DataElement::new(
            tags::COMMAND_DATA_SET_TYPE,
            VR::US,
            dicom_value!(U16, [if has_dataset { 0x0000 } else { 0x0101 }]),
        ),
        DataElement::new(tags::STATUS, VR::US, dicom_value!(U16, [status])),
    ])
}

fn dataset_from_query_match(query_match: &QueryMatch) -> DefaultMemObject {
    let mut obj = DefaultMemObject::new_empty();
    put_string(
        &mut obj,
        tags::QUERY_RETRIEVE_LEVEL,
        VR::CS,
        query_match.level.as_dicom_str(),
    );
    put_optional(
        &mut obj,
        tags::PATIENT_NAME,
        VR::PN,
        &query_match.patient_name,
    );
    put_optional(&mut obj, tags::PATIENT_ID, VR::LO, &query_match.patient_id);
    put_optional(
        &mut obj,
        tags::ACCESSION_NUMBER,
        VR::SH,
        &query_match.accession_number,
    );
    put_optional(
        &mut obj,
        tags::STUDY_INSTANCE_UID,
        VR::UI,
        &query_match.study_instance_uid,
    );
    put_optional(
        &mut obj,
        tags::SERIES_INSTANCE_UID,
        VR::UI,
        &query_match.series_instance_uid,
    );
    put_optional(
        &mut obj,
        tags::SOP_INSTANCE_UID,
        VR::UI,
        &query_match.sop_instance_uid,
    );
    put_optional(&mut obj, tags::STUDY_DATE, VR::DA, &query_match.study_date);
    put_optional(
        &mut obj,
        tags::STUDY_DESCRIPTION,
        VR::LO,
        &query_match.study_description,
    );
    put_optional(
        &mut obj,
        tags::SERIES_DESCRIPTION,
        VR::LO,
        &query_match.series_description,
    );
    put_optional(
        &mut obj,
        tags::SERIES_NUMBER,
        VR::IS,
        &query_match.series_number,
    );
    put_optional(&mut obj, tags::MODALITY, VR::CS, &query_match.modality);
    put_optional(
        &mut obj,
        tags::MODALITIES_IN_STUDY,
        VR::CS,
        &query_match.modality,
    );
    put_optional(
        &mut obj,
        tags::INSTANCE_NUMBER,
        VR::IS,
        &query_match.instance_number,
    );
    obj
}

fn put_optional(obj: &mut DefaultMemObject, tag: dicom_core::Tag, vr: VR, value: &Option<String>) {
    if let Some(value) = value.as_deref() {
        put_string(obj, tag, vr, value);
    }
}

pub fn study_match(study_instance_uid: impl Into<String>) -> QueryMatch {
    QueryMatch {
        level: QueryLevel::Study,
        patient_name: Some("TEST^PATIENT".to_string()),
        patient_id: Some("TEST-PATIENT".to_string()),
        accession_number: None,
        study_instance_uid: Some(study_instance_uid.into()),
        series_instance_uid: None,
        sop_instance_uid: None,
        study_date: Some("20260418".to_string()),
        study_description: Some("Test Study".to_string()),
        series_description: None,
        series_number: None,
        modality: Some("CT".to_string()),
        instance_number: None,
    }
}
