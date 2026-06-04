mod common;

use std::{net::TcpStream, time::Duration};

use anyhow::{anyhow, Context};
use common::{create_test_study, remote_node_fixture, run_with_timeout, TestServices};
use dicom_core::{dicom_value, DataElement, VR};
use dicom_dictionary_std::{tags, uids};
use dicom_node_client::{
    config::RECOMMENDED_MAX_PDU_LENGTH,
    dicom::{
        build_move_identifier, read_u16_opt_from_mem, read_u32_opt_from_mem, DefaultMemObject,
    },
    models::{MoveRequest, QueryLevel, QueryModel, RemoteNode},
    net::{
        assoc::{
            create_get_request_command, create_store_response, AssociationFactory,
            PDataAccumulator, PresentationContextDefinition,
        },
        transfer::all_supported_transfer_syntaxes,
    },
};
use dicom_object::mem::InMemDicomObject;
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::{
    association::ClientAssociation,
    pdu::{PDataValue, PDataValueType, Pdu},
};

#[derive(Debug, Default)]
struct GetOutcome {
    final_status: u16,
    remaining: u32,
    completed: u32,
    failed: u32,
    warning: u32,
    received_sop_instance_uids: Vec<String>,
}

#[derive(Debug)]
struct IncomingDimse {
    command: DefaultMemObject,
    _dataset_bytes: Vec<u8>,
    presentation_context_id: u8,
}

#[test]
fn local_archive_c_get_scp_sends_study_instances_on_same_association() {
    run_with_timeout(Duration::from_secs(20), || {
        let services = TestServices::new().expect("create services");
        let source_dir = services.temp_dir.path().join("get-scp-source");
        let study = create_test_study(&source_dir, "1.2.826.0.1.3680043.10.850.1", 2, 2)
            .expect("create source study");
        services
            .services
            .import_path(&source_dir)
            .expect("import source study into local archive");

        let source_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local archive C-GET SCP");
        let source_node = remote_node_fixture(
            "local-archive-get",
            &services.services.config.local_ae_title,
            source_scp.port(),
        );

        let outcome = c_get_study(&source_node, &study.study_instance_uid, true, 0x0000, false)
            .expect("C-GET study");

        assert_eq!(outcome.final_status, 0x0000);
        assert_eq!(outcome.remaining, 0);
        assert_eq!(outcome.completed, study.files.len() as u32);
        assert_eq!(outcome.failed, 0);
        assert_eq!(outcome.warning, 0);
        assert_eq!(outcome.received_sop_instance_uids.len(), study.files.len());

        source_scp.stop().expect("stop local archive C-GET SCP");
        let metrics = services.services.storage_scp.metrics_snapshot();
        assert_eq!(metrics.c_get_requests_total, 1);
    });
}

#[test]
fn local_archive_c_get_scp_reports_missing_storage_presentation_context() {
    run_with_timeout(Duration::from_secs(20), || {
        let services = TestServices::new().expect("create services");
        let source_dir = services.temp_dir.path().join("get-scp-no-storage-context");
        let study = create_test_study(&source_dir, "1.2.826.0.1.3680043.10.850.2", 1, 1)
            .expect("create source study");
        services
            .services
            .import_path(&source_dir)
            .expect("import source study into local archive");

        let source_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local archive C-GET SCP");
        let source_node = remote_node_fixture(
            "local-archive-get",
            &services.services.config.local_ae_title,
            source_scp.port(),
        );

        let outcome = c_get_study(
            &source_node,
            &study.study_instance_uid,
            false,
            0x0000,
            false,
        )
        .expect("C-GET study without storage context");

        assert_eq!(outcome.final_status, 0xA702);
        assert_eq!(outcome.completed, 0);
        assert_eq!(outcome.failed, study.files.len() as u32);
        assert!(outcome.received_sop_instance_uids.is_empty());

        source_scp.stop().expect("stop local archive C-GET SCP");
    });
}

#[test]
fn local_archive_c_get_scp_accepts_series_and_image_identifiers() {
    run_with_timeout(Duration::from_secs(20), || {
        let services = TestServices::new().expect("create services");
        let source_dir = services.temp_dir.path().join("get-scp-levels");
        let study = create_test_study(&source_dir, "1.2.826.0.1.3680043.10.850.4", 2, 2)
            .expect("create source study");
        services
            .services
            .import_path(&source_dir)
            .expect("import source study into local archive");

        let source_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local archive C-GET SCP");
        let source_node = remote_node_fixture(
            "local-archive-get",
            &services.services.config.local_ae_title,
            source_scp.port(),
        );

        let series_uid = study.files[0].series_instance_uid.clone();
        let series_outcome = c_get(
            &source_node,
            MoveRequest {
                node_name_or_id: source_node.name.clone(),
                model: QueryModel::StudyRoot,
                level: QueryLevel::Series,
                study_instance_uid: study.study_instance_uid.clone(),
                series_instance_uid: Some(series_uid.clone()),
                sop_instance_uid: None,
                move_destination: None,
            },
            true,
            0x0000,
            false,
        )
        .expect("C-GET series");
        assert_eq!(series_outcome.final_status, 0x0000);
        assert_eq!(series_outcome.completed, 2);
        assert!(series_outcome
            .received_sop_instance_uids
            .iter()
            .all(|uid| study.files.iter().any(|file| {
                file.series_instance_uid == series_uid && file.sop_instance_uid == *uid
            })));

        let image = study.files[3].clone();
        let image_outcome = c_get(
            &source_node,
            MoveRequest {
                node_name_or_id: source_node.name.clone(),
                model: QueryModel::StudyRoot,
                level: QueryLevel::Image,
                study_instance_uid: study.study_instance_uid.clone(),
                series_instance_uid: Some(image.series_instance_uid.clone()),
                sop_instance_uid: Some(image.sop_instance_uid.clone()),
                move_destination: None,
            },
            true,
            0x0000,
            false,
        )
        .expect("C-GET image");
        assert_eq!(image_outcome.final_status, 0x0000);
        assert_eq!(image_outcome.completed, 1);
        assert_eq!(
            image_outcome.received_sop_instance_uids,
            vec![image.sop_instance_uid]
        );

        source_scp.stop().expect("stop local archive C-GET SCP");
    });
}

#[test]
fn local_archive_c_get_scp_honors_requester_cancel() {
    run_with_timeout(Duration::from_secs(20), || {
        let services = TestServices::new().expect("create services");
        let source_dir = services.temp_dir.path().join("get-scp-cancel");
        let study = create_test_study(&source_dir, "1.2.826.0.1.3680043.10.850.3", 2, 2)
            .expect("create source study");
        services
            .services
            .import_path(&source_dir)
            .expect("import source study into local archive");

        let source_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local archive C-GET SCP");
        let source_node = remote_node_fixture(
            "local-archive-get",
            &services.services.config.local_ae_title,
            source_scp.port(),
        );

        let outcome = c_get_study(&source_node, &study.study_instance_uid, true, 0x0000, true)
            .expect("C-GET study with requester cancel");

        assert_eq!(outcome.final_status, 0xFE00);
        assert_eq!(outcome.completed, 0);
        assert_eq!(outcome.received_sop_instance_uids.len(), 1);
        assert!(outcome.remaining >= 1);

        source_scp.stop().expect("stop local archive C-GET SCP");
    });
}

fn c_get_study(
    source_node: &RemoteNode,
    study_instance_uid: &str,
    include_storage_context: bool,
    store_status: u16,
    cancel_on_first_store: bool,
) -> anyhow::Result<GetOutcome> {
    c_get(
        source_node,
        MoveRequest {
            node_name_or_id: source_node.name.clone(),
            model: QueryModel::StudyRoot,
            level: QueryLevel::Study,
            study_instance_uid: study_instance_uid.to_string(),
            series_instance_uid: None,
            sop_instance_uid: None,
            move_destination: None,
        },
        include_storage_context,
        store_status,
        cancel_on_first_store,
    )
}

fn c_get(
    source_node: &RemoteNode,
    request: MoveRequest,
    include_storage_context: bool,
    store_status: u16,
    cancel_on_first_store: bool,
) -> anyhow::Result<GetOutcome> {
    let association_factory =
        AssociationFactory::new("GETSCU".to_string(), RECOMMENDED_MAX_PDU_LENGTH, true);
    let mut contexts = vec![PresentationContextDefinition {
        abstract_syntax: uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_GET.to_string(),
        transfer_syntaxes: all_supported_transfer_syntaxes(),
    }];
    if include_storage_context {
        contexts.push(PresentationContextDefinition {
            abstract_syntax: uids::CT_IMAGE_STORAGE.to_string(),
            transfer_syntaxes: vec![uids::EXPLICIT_VR_LITTLE_ENDIAN.to_string()],
        });
    }
    let mut association = association_factory
        .establish_with_presentation_contexts(source_node, &contexts)
        .context("establish C-GET association")?;
    let get_context = association
        .presentation_contexts()
        .iter()
        .find(|context| {
            context.abstract_syntax == uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_GET
        })
        .ok_or_else(|| anyhow!("missing negotiated C-GET presentation context"))?;
    let transfer_syntax = TransferSyntaxRegistry
        .get(&get_context.transfer_syntax)
        .ok_or_else(|| anyhow!("unsupported C-GET transfer syntax"))?;
    let get_context_id = get_context.id;

    let get_message_id = association_factory.next_message_id();
    let command = create_get_request_command(
        uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_GET,
        get_message_id,
    );
    let identifier = build_move_identifier(&request);
    let mut identifier_bytes = Vec::with_capacity(256);
    identifier
        .write_dataset_with_ts(&mut identifier_bytes, transfer_syntax)
        .context("write C-GET identifier")?;

    AssociationFactory::send_command_and_dataset(
        &mut association,
        get_context_id,
        &command,
        identifier_bytes,
    )?;

    let mut outcome = GetOutcome::default();
    let mut cancel_sent = false;
    while let Some(message) = next_dimse_message(&mut association)? {
        let command_field = read_u16_opt_from_mem(&message.command, tags::COMMAND_FIELD)
            .ok_or_else(|| anyhow!("missing command field"))?;
        match command_field {
            0x0001 => {
                let message_id = read_u16_opt_from_mem(&message.command, tags::MESSAGE_ID)
                    .ok_or_else(|| anyhow!("missing C-STORE message id"))?;
                let sop_class_uid = command_string(&message.command, tags::AFFECTED_SOP_CLASS_UID)
                    .ok_or_else(|| anyhow!("missing C-STORE SOP Class UID"))?;
                let sop_instance_uid =
                    command_string(&message.command, tags::AFFECTED_SOP_INSTANCE_UID)
                        .ok_or_else(|| anyhow!("missing C-STORE SOP Instance UID"))?;
                outcome
                    .received_sop_instance_uids
                    .push(sop_instance_uid.clone());
                if cancel_on_first_store && !cancel_sent {
                    cancel_sent = true;
                    let cancel = create_cancel_request_command(get_message_id);
                    send_command(&mut association, get_context_id, &cancel)?;
                    continue;
                }
                let response = create_store_response(
                    message_id,
                    &sop_class_uid,
                    &sop_instance_uid,
                    store_status,
                );
                send_command(&mut association, message.presentation_context_id, &response)?;
            }
            0x8010 => {
                let status = read_u16_opt_from_mem(&message.command, tags::STATUS)
                    .ok_or_else(|| anyhow!("missing C-GET status"))?;
                outcome.final_status = status;
                outcome.remaining = read_u32_opt_from_mem(
                    &message.command,
                    tags::NUMBER_OF_REMAINING_SUBOPERATIONS,
                )
                .unwrap_or(outcome.remaining);
                outcome.completed = read_u32_opt_from_mem(
                    &message.command,
                    tags::NUMBER_OF_COMPLETED_SUBOPERATIONS,
                )
                .unwrap_or(outcome.completed);
                outcome.failed =
                    read_u32_opt_from_mem(&message.command, tags::NUMBER_OF_FAILED_SUBOPERATIONS)
                        .unwrap_or(outcome.failed);
                outcome.warning =
                    read_u32_opt_from_mem(&message.command, tags::NUMBER_OF_WARNING_SUBOPERATIONS)
                        .unwrap_or(outcome.warning);
                if status != 0xFF00 && status != 0xFF01 {
                    let _ = association.release();
                    return Ok(outcome);
                }
            }
            other => return Err(anyhow!("unexpected DIMSE command 0x{other:04X}")),
        }
    }

    Ok(outcome)
}

fn create_cancel_request_command(message_id_being_responded_to: u16) -> DefaultMemObject {
    InMemDicomObject::command_from_element_iter([
        DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x0FFF])),
        DataElement::new(
            tags::MESSAGE_ID_BEING_RESPONDED_TO,
            VR::US,
            dicom_value!(U16, [message_id_being_responded_to]),
        ),
        DataElement::new(
            tags::COMMAND_DATA_SET_TYPE,
            VR::US,
            dicom_value!(U16, [0x0101]),
        ),
    ])
}

fn next_dimse_message(
    association: &mut ClientAssociation<TcpStream>,
) -> anyhow::Result<Option<IncomingDimse>> {
    let mut command_accumulator = PDataAccumulator::new();
    let mut dataset_accumulator = PDataAccumulator::new();
    let mut command: Option<(DefaultMemObject, u8)> = None;

    loop {
        match association.receive()? {
            Pdu::PData { data } => {
                for value in data {
                    match value.value_type {
                        PDataValueType::Command => {
                            let presentation_context_id = value.presentation_context_id;
                            command_accumulator.feed(&value)?;
                            if command_accumulator.is_complete() {
                                let command_obj = command_accumulator
                                    .take_command()?
                                    .ok_or_else(|| anyhow!("missing command payload"))?;
                                command = Some((command_obj, presentation_context_id));
                            }
                        }
                        PDataValueType::Data => dataset_accumulator.feed(&value)?,
                    }
                }

                if let Some((command_obj, _presentation_context_id)) = &command {
                    let data_set_type =
                        read_u16_opt_from_mem(command_obj, tags::COMMAND_DATA_SET_TYPE)
                            .unwrap_or(0x0101);
                    if data_set_type == 0x0101 {
                        let (command, presentation_context_id) = command.take().unwrap();
                        return Ok(Some(IncomingDimse {
                            command,
                            _dataset_bytes: Vec::new(),
                            presentation_context_id,
                        }));
                    }
                    if dataset_accumulator.is_complete() {
                        let dataset_bytes = dataset_accumulator.take().unwrap_or_default();
                        let (command, presentation_context_id) = command.take().unwrap();
                        return Ok(Some(IncomingDimse {
                            command,
                            _dataset_bytes: dataset_bytes,
                            presentation_context_id,
                        }));
                    }
                }
            }
            Pdu::ReleaseRQ => {
                association.send(&Pdu::ReleaseRP)?;
                return Ok(None);
            }
            Pdu::AbortRQ { source } => return Err(anyhow!("peer aborted: {:?}", source)),
            other => return Err(anyhow!("unexpected PDU: {:?}", other)),
        }
    }
}

fn send_command(
    association: &mut ClientAssociation<TcpStream>,
    presentation_context_id: u8,
    command: &DefaultMemObject,
) -> anyhow::Result<()> {
    let command_bytes = AssociationFactory::write_command_dataset(command)?;
    association.send(&Pdu::PData {
        data: vec![PDataValue {
            presentation_context_id,
            value_type: PDataValueType::Command,
            is_last: true,
            data: command_bytes,
        }],
    })?;
    Ok(())
}

fn command_string(command: &DefaultMemObject, tag: dicom_core::Tag) -> Option<String> {
    command
        .element(tag)
        .ok()
        .and_then(|element| element.to_str().ok())
        .as_deref()
        .map(|value| value.trim_end_matches('\0').trim().to_string())
        .filter(|value| !value.is_empty())
}
