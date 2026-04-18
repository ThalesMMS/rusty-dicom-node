use anyhow::{anyhow, Context};
use dicom_dictionary_std::tags;
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::pdu::{PDataValue, PDataValueType, Pdu};
use tracing::warn;

use crate::{
    config::now_utc_string,
    dicom::{
        build_move_identifier, ensure_study_for_series_or_image, read_u32_opt_from_mem,
        DefaultMemObject,
    },
    error::Result,
    models::{MoveOutcome, MoveRequest, RemoteNode},
};

use super::assoc::{create_move_request_command, AssociationFactory, PDataAccumulator};

#[derive(Debug, Clone)]
pub struct MoveScu {
    association_factory: AssociationFactory,
}

impl MoveScu {
    pub fn new(association_factory: AssociationFactory) -> Self {
        Self {
            association_factory,
        }
    }

    pub fn retrieve(&self, node: &RemoteNode, request: &MoveRequest) -> Result<MoveOutcome> {
        ensure_study_for_series_or_image(request)?;

        let mut association = self
            .association_factory
            .establish_with_abstract_syntaxes(node, [request.model.move_sop_class_uid()])?;

        let context = self.association_factory.first_context(&association)?;
        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| anyhow!("unsupported negotiated transfer syntax"))?;

        let destination = request
            .move_destination
            .as_deref()
            .ok_or_else(|| anyhow!("move_destination was not resolved"))?;

        let command = create_move_request_command(
            request.model.move_sop_class_uid(),
            self.association_factory.next_message_id(),
            destination,
        );

        let identifier = build_move_identifier(request);
        let mut identifier_bytes = Vec::with_capacity(256);
        identifier
            .write_dataset_with_ts(&mut identifier_bytes, transfer_syntax)
            .context("writing C-MOVE identifier")?;

        let mut outcome = MoveOutcome {
            started_at: now_utc_string(),
            ..MoveOutcome::default()
        };

        AssociationFactory::send_command_and_dataset(
            &mut association,
            context.id,
            &command,
            identifier_bytes,
        )?;

        let mut command_accumulator = PDataAccumulator::new();
        let mut dataset_accumulator = PDataAccumulator::new();
        let mut awaiting_identifier_status = None;

        loop {
            match association.receive()? {
                Pdu::PData { data } => {
                    if data.is_empty() {
                        continue;
                    }

                    let Some(status) = process_move_response_pdata(
                        &data,
                        &mut command_accumulator,
                        &mut dataset_accumulator,
                        &mut outcome,
                    )?
                    else {
                        if let Some(status) = awaiting_identifier_status {
                            if dataset_accumulator.is_complete() {
                                parse_move_response_identifier(
                                    &mut dataset_accumulator,
                                    transfer_syntax,
                                )?;
                                outcome.final_status = status;
                                break;
                            }
                        }
                        continue;
                    };

                    match status {
                        0xFF00 | 0xFF01 => continue,
                        0x0000 => break,
                        _ if move_status_may_have_identifier(status)
                            && dataset_accumulator.is_complete() =>
                        {
                            parse_move_response_identifier(
                                &mut dataset_accumulator,
                                transfer_syntax,
                            )?;
                            break;
                        }
                        _ if move_status_may_have_identifier(status)
                            && !dataset_accumulator.is_empty() =>
                        {
                            awaiting_identifier_status = Some(status);
                            continue;
                        }
                        _ => break,
                    }
                }
                Pdu::ReleaseRQ => {
                    ensure_complete_move_response(&command_accumulator)?;
                    ensure_complete_move_identifier(&dataset_accumulator)?;
                    if dataset_accumulator.is_complete() {
                        parse_move_response_identifier(&mut dataset_accumulator, transfer_syntax)?;
                    }
                    association.send(&Pdu::ReleaseRP)?;
                    break;
                }
                Pdu::AbortRQ { source } => {
                    warn!(
                        node = %node.name,
                        ae_title = %node.ae_title,
                        host = %node.host,
                        port = node.port,
                        source = ?source,
                        "remote aborted association during C-MOVE"
                    );
                    return Err(anyhow!("remote aborted association: {:?}", source));
                }
                other => {
                    warn!(
                        node = %node.name,
                        ae_title = %node.ae_title,
                        host = %node.host,
                        port = node.port,
                        pdu = ?other,
                        "unexpected PDU during C-MOVE"
                    );
                    return Err(anyhow!("unexpected PDU during C-MOVE: {:?}", other));
                }
            }
        }

        outcome.finished_at = now_utc_string();
        let _ = association.release();
        Ok(outcome)
    }
}

fn process_move_response_pdata(
    data: &[PDataValue],
    command_accumulator: &mut PDataAccumulator,
    dataset_accumulator: &mut PDataAccumulator,
    outcome: &mut MoveOutcome,
) -> Result<Option<u16>> {
    if data.is_empty() {
        return Ok(None);
    }

    for value in data {
        match value.value_type {
            PDataValueType::Command => command_accumulator.feed(value)?,
            PDataValueType::Data => dataset_accumulator.feed(value)?,
        }
    }

    let Some(command_obj) = command_accumulator.take_command()? else {
        return Ok(None);
    };

    let status = command_obj
        .element(tags::STATUS)
        .context("missing C-MOVE status")?
        .to_int::<u16>()
        .context("invalid C-MOVE status")?;

    outcome.final_status = status;
    outcome.remaining =
        read_u32_opt_from_mem(&command_obj, tags::NUMBER_OF_REMAINING_SUBOPERATIONS)
            .unwrap_or(outcome.remaining);
    outcome.completed =
        read_u32_opt_from_mem(&command_obj, tags::NUMBER_OF_COMPLETED_SUBOPERATIONS)
            .unwrap_or(outcome.completed);
    outcome.failed = read_u32_opt_from_mem(&command_obj, tags::NUMBER_OF_FAILED_SUBOPERATIONS)
        .unwrap_or(outcome.failed);
    outcome.warning = read_u32_opt_from_mem(&command_obj, tags::NUMBER_OF_WARNING_SUBOPERATIONS)
        .unwrap_or(outcome.warning);

    Ok(Some(status))
}

fn move_status_may_have_identifier(status: u16) -> bool {
    !matches!(status, 0x0000 | 0xFF00 | 0xFF01)
}

fn parse_move_response_identifier(
    dataset_accumulator: &mut PDataAccumulator,
    transfer_syntax: &dicom_transfer_syntax_registry::TransferSyntax,
) -> Result<Option<DefaultMemObject>> {
    let Some(identifier_bytes) = dataset_accumulator.take() else {
        return Ok(None);
    };

    let identifier =
        DefaultMemObject::read_dataset_with_ts(identifier_bytes.as_slice(), transfer_syntax)
            .context("reading C-MOVE response identifier")?;
    Ok(Some(identifier))
}

fn ensure_complete_move_response(command_accumulator: &PDataAccumulator) -> Result<()> {
    if command_accumulator.is_empty() {
        Ok(())
    } else {
        Err(anyhow!("incomplete C-MOVE command response"))
    }
}

fn ensure_complete_move_identifier(dataset_accumulator: &PDataAccumulator) -> Result<()> {
    if dataset_accumulator.is_empty() || dataset_accumulator.is_complete() {
        Ok(())
    } else {
        Err(anyhow!("incomplete C-MOVE response identifier"))
    }
}

#[cfg(test)]
mod tests {
    use super::{
        ensure_complete_move_identifier, ensure_complete_move_response,
        process_move_response_pdata, AssociationFactory, PDataAccumulator,
    };
    use crate::{dicom::DefaultMemObject, models::MoveOutcome};
    use dicom_core::{dicom_value, DataElement, VR};
    use dicom_dictionary_std::tags;
    use dicom_object::mem::InMemDicomObject;
    use dicom_ul::pdu::{PDataValue, PDataValueType, Pdu};

    fn move_response_command(status: u16) -> DefaultMemObject {
        InMemDicomObject::command_from_element_iter([
            DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x8021])),
            DataElement::new(
                tags::MESSAGE_ID_BEING_RESPONDED_TO,
                VR::US,
                dicom_value!(U16, [1]),
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
                dicom_value!(U16, [2]),
            ),
        ])
    }

    fn command_bytes(status: u16) -> Vec<u8> {
        AssociationFactory::write_command_dataset(&move_response_command(status)).unwrap()
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

    fn feed_pdu(
        pdu: Pdu,
        accumulator: &mut PDataAccumulator,
        dataset_accumulator: &mut PDataAccumulator,
        outcome: &mut MoveOutcome,
    ) -> crate::error::Result<Option<u16>> {
        match pdu {
            Pdu::PData { data } => {
                process_move_response_pdata(&data, accumulator, dataset_accumulator, outcome)
            }
            other => panic!("unexpected test PDU: {other:?}"),
        }
    }

    #[test]
    fn parses_command_split_within_same_pdu() {
        let bytes = command_bytes(0xFF00);
        let split_at = bytes.len() / 2;
        let pdu = Pdu::PData {
            data: vec![
                command_pdata(bytes[..split_at].to_vec(), false),
                command_pdata(bytes[split_at..].to_vec(), true),
            ],
        };
        let mut accumulator = PDataAccumulator::new();
        let mut dataset_accumulator = PDataAccumulator::new();
        let mut outcome = MoveOutcome::default();

        let status = feed_pdu(
            pdu,
            &mut accumulator,
            &mut dataset_accumulator,
            &mut outcome,
        )
        .unwrap();

        assert_eq!(status, Some(0xFF00));
        assert_eq!(outcome.final_status, 0xFF00);
        assert_eq!(outcome.remaining, 2);
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
        let mut dataset_accumulator = PDataAccumulator::new();
        let mut outcome = MoveOutcome::default();

        assert_eq!(
            feed_pdu(
                first,
                &mut accumulator,
                &mut dataset_accumulator,
                &mut outcome
            )
            .unwrap(),
            None
        );
        assert_eq!(
            feed_pdu(
                second,
                &mut accumulator,
                &mut dataset_accumulator,
                &mut outcome
            )
            .unwrap(),
            Some(0x0000)
        );
        assert_eq!(outcome.final_status, 0x0000);
    }

    #[test]
    fn empty_pdata_is_ignored() {
        let mut accumulator = PDataAccumulator::new();
        let mut dataset_accumulator = PDataAccumulator::new();
        let mut outcome = MoveOutcome::default();

        let status = feed_pdu(
            Pdu::PData { data: Vec::new() },
            &mut accumulator,
            &mut dataset_accumulator,
            &mut outcome,
        )
        .unwrap();

        assert_eq!(status, None);
    }

    #[test]
    fn incomplete_command_reports_clear_error_when_finalized() {
        let bytes = command_bytes(0x0000);
        let mut accumulator = PDataAccumulator::new();
        let mut dataset_accumulator = PDataAccumulator::new();
        let mut outcome = MoveOutcome::default();

        assert_eq!(
            feed_pdu(
                Pdu::PData {
                    data: vec![command_pdata(bytes, false)]
                },
                &mut accumulator,
                &mut dataset_accumulator,
                &mut outcome
            )
            .unwrap(),
            None
        );

        let error = ensure_complete_move_response(&accumulator)
            .unwrap_err()
            .to_string();
        assert!(error.contains("incomplete C-MOVE command response"));
    }

    #[test]
    fn unparseable_command_keeps_command_dataset_context() {
        let mut accumulator = PDataAccumulator::new();
        let mut dataset_accumulator = PDataAccumulator::new();
        let mut outcome = MoveOutcome::default();

        let error = feed_pdu(
            Pdu::PData {
                data: vec![command_pdata([0, 1, 2, 3], true)],
            },
            &mut accumulator,
            &mut dataset_accumulator,
            &mut outcome,
        )
        .unwrap_err();

        assert!(format!("{error:#}").contains("reading command dataset"));
    }

    #[test]
    fn accumulates_identifier_dataset_fragment() {
        let mut accumulator = PDataAccumulator::new();
        let mut dataset_accumulator = PDataAccumulator::new();
        let mut outcome = MoveOutcome::default();
        let identifier_bytes = vec![1, 2, 3];

        let status = feed_pdu(
            Pdu::PData {
                data: vec![
                    command_pdata(command_bytes(0xB000), true),
                    data_pdata(identifier_bytes.clone(), true),
                ],
            },
            &mut accumulator,
            &mut dataset_accumulator,
            &mut outcome,
        )
        .unwrap();

        assert_eq!(status, Some(0xB000));
        assert_eq!(dataset_accumulator.take(), Some(identifier_bytes));
    }

    #[test]
    fn accumulates_identifier_dataset_across_pdu_receives() {
        let mut accumulator = PDataAccumulator::new();
        let mut dataset_accumulator = PDataAccumulator::new();
        let mut outcome = MoveOutcome::default();

        let first_status = feed_pdu(
            Pdu::PData {
                data: vec![
                    command_pdata(command_bytes(0xB000), true),
                    data_pdata([1, 2], false),
                ],
            },
            &mut accumulator,
            &mut dataset_accumulator,
            &mut outcome,
        )
        .unwrap();

        let second_status = feed_pdu(
            Pdu::PData {
                data: vec![data_pdata([3, 4], true)],
            },
            &mut accumulator,
            &mut dataset_accumulator,
            &mut outcome,
        )
        .unwrap();

        assert_eq!(first_status, Some(0xB000));
        assert_eq!(second_status, None);
        assert_eq!(dataset_accumulator.take(), Some(vec![1, 2, 3, 4]));
    }

    #[test]
    fn incomplete_identifier_reports_clear_error_when_finalized() {
        let mut dataset_accumulator = PDataAccumulator::new();

        dataset_accumulator
            .feed(&data_pdata([1, 2, 3], false))
            .unwrap();

        let error = ensure_complete_move_identifier(&dataset_accumulator)
            .unwrap_err()
            .to_string();

        assert!(error.contains("incomplete C-MOVE response identifier"));
    }
}
