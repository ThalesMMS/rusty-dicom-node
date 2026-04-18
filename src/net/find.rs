use anyhow::{anyhow, Context};
use dicom_dictionary_std::tags;
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::pdu::{PDataValue, PDataValueType, Pdu};
use tracing::warn;

use crate::{
    dicom::{build_find_identifier, query_match_from_response, DefaultMemObject},
    error::Result,
    models::{QueryCriteria, QueryMatch, RemoteNode},
};

use super::assoc::{create_find_request_command, AssociationFactory, PDataAccumulator};

#[derive(Debug, Clone)]
pub struct FindScu {
    association_factory: AssociationFactory,
}

impl FindScu {
    pub fn new(association_factory: AssociationFactory) -> Self {
        Self {
            association_factory,
        }
    }

    pub fn query(&self, node: &RemoteNode, criteria: &QueryCriteria) -> Result<Vec<QueryMatch>> {
        let mut association = self
            .association_factory
            .establish_with_abstract_syntaxes(node, [criteria.model.find_sop_class_uid()])?;

        let context = self.association_factory.first_context(&association)?;
        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| anyhow!("unsupported negotiated transfer syntax"))?;

        let command = create_find_request_command(
            criteria.model.find_sop_class_uid(),
            self.association_factory.next_message_id(),
        );

        let identifier = build_find_identifier(criteria);
        let mut identifier_bytes = Vec::with_capacity(1024);
        identifier
            .write_dataset_with_ts(&mut identifier_bytes, transfer_syntax)
            .context("writing C-FIND identifier")?;

        AssociationFactory::send_command_and_dataset(
            &mut association,
            context.id,
            &command,
            identifier_bytes,
        )?;

        let mut matches = Vec::new();
        let mut command_accumulator = PDataAccumulator::new();

        loop {
            match association.receive()? {
                Pdu::PData { data } => {
                    if data.is_empty() {
                        continue;
                    }

                    let Some(response) =
                        process_find_response_pdata(&data, &mut command_accumulator)?
                    else {
                        continue;
                    };

                    let status = response
                        .command
                        .element(tags::STATUS)
                        .context("missing C-FIND status")?
                        .to_int::<u16>()
                        .context("invalid C-FIND status")?;

                    match status {
                        0x0000 => break,
                        0xFF00 | 0xFF01 => {
                            let mut dataset_bytes = response.dataset_bytes;

                            if dataset_bytes.is_empty() || response.needs_dataset_fallback {
                                let bytes = AssociationFactory::read_single_pdata_dataset(
                                    &mut association,
                                )?;
                                dataset_bytes.extend_from_slice(&bytes);
                            }

                            let response_obj =
                                crate::dicom::DefaultMemObject::read_dataset_with_ts(
                                    dataset_bytes.as_slice(),
                                    transfer_syntax,
                                )
                                .context("reading C-FIND response dataset")?;

                            matches.push(query_match_from_response(&response_obj, criteria.level));
                        }
                        other => {
                            warn!(
                                node = %node.name,
                                ae_title = %node.ae_title,
                                host = %node.host,
                                port = node.port,
                                status = %format_args!("0x{other:04X}"),
                                "C-FIND failed with remote status"
                            );
                            let _ = association.abort();
                            return Err(anyhow!("C-FIND failed with status 0x{other:04X}"));
                        }
                    }
                }
                Pdu::ReleaseRQ => {
                    ensure_complete_find_response(&command_accumulator)?;
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
                        "remote aborted association during C-FIND"
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
                        "unexpected PDU during C-FIND"
                    );
                    return Err(anyhow!("unexpected PDU during C-FIND: {:?}", other));
                }
            }
        }

        let _ = association.release();
        Ok(matches)
    }
}

#[derive(Debug)]
struct FindPDataResponse {
    command: DefaultMemObject,
    dataset_bytes: Vec<u8>,
    needs_dataset_fallback: bool,
}

fn process_find_response_pdata(
    data: &[PDataValue],
    command_accumulator: &mut PDataAccumulator,
) -> Result<Option<FindPDataResponse>> {
    if data.is_empty() {
        return Ok(None);
    }

    let mut dataset_bytes = Vec::new();
    let mut saw_dataset_last = false;

    for value in data {
        match value.value_type {
            PDataValueType::Command => command_accumulator.feed(value)?,
            PDataValueType::Data => {
                dataset_bytes.extend_from_slice(&value.data);
                if value.is_last {
                    saw_dataset_last = true;
                }
            }
        }
    }

    let Some(command) = command_accumulator.take_command()? else {
        if dataset_bytes.is_empty() {
            return Ok(None);
        }

        return Err(anyhow!(
            "received C-FIND dataset fragment before complete command response"
        ));
    };

    Ok(Some(FindPDataResponse {
        command,
        needs_dataset_fallback: !dataset_bytes.is_empty() && !saw_dataset_last,
        dataset_bytes,
    }))
}

fn ensure_complete_find_response(command_accumulator: &PDataAccumulator) -> Result<()> {
    if command_accumulator.is_empty() {
        Ok(())
    } else {
        Err(anyhow!("incomplete C-FIND command response"))
    }
}

#[cfg(test)]
mod tests {
    use super::{
        ensure_complete_find_response, process_find_response_pdata, AssociationFactory,
        DefaultMemObject, PDataAccumulator,
    };
    use crate::dicom::read_u16_opt_from_mem;
    use dicom_core::{dicom_value, DataElement, VR};
    use dicom_dictionary_std::tags;
    use dicom_object::mem::InMemDicomObject;
    use dicom_ul::pdu::{PDataValue, PDataValueType, Pdu};

    fn find_response_command(status: u16) -> DefaultMemObject {
        InMemDicomObject::command_from_element_iter([
            DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x8020])),
            DataElement::new(
                tags::MESSAGE_ID_BEING_RESPONDED_TO,
                VR::US,
                dicom_value!(U16, [1]),
            ),
            DataElement::new(
                tags::COMMAND_DATA_SET_TYPE,
                VR::US,
                dicom_value!(U16, [0x0000]),
            ),
            DataElement::new(tags::STATUS, VR::US, dicom_value!(U16, [status])),
        ])
    }

    fn command_bytes(status: u16) -> Vec<u8> {
        AssociationFactory::write_command_dataset(&find_response_command(status)).unwrap()
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
    ) -> crate::error::Result<Option<super::FindPDataResponse>> {
        match pdu {
            Pdu::PData { data } => process_find_response_pdata(&data, accumulator),
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

        let response = feed_pdu(pdu, &mut accumulator).unwrap().unwrap();

        assert_eq!(
            read_u16_opt_from_mem(&response.command, tags::STATUS),
            Some(0xFF00)
        );
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

        assert!(feed_pdu(first, &mut accumulator).unwrap().is_none());
        let response = feed_pdu(second, &mut accumulator).unwrap().unwrap();

        assert_eq!(
            read_u16_opt_from_mem(&response.command, tags::STATUS),
            Some(0x0000)
        );
    }

    #[test]
    fn empty_pdata_is_ignored() {
        let mut accumulator = PDataAccumulator::new();

        assert!(feed_pdu(Pdu::PData { data: Vec::new() }, &mut accumulator)
            .unwrap()
            .is_none());
    }

    #[test]
    fn incomplete_command_reports_clear_error_when_finalized() {
        let bytes = command_bytes(0xFF00);
        let mut accumulator = PDataAccumulator::new();

        assert!(feed_pdu(
            Pdu::PData {
                data: vec![command_pdata(bytes, false)]
            },
            &mut accumulator
        )
        .unwrap()
        .is_none());

        let error = ensure_complete_find_response(&accumulator)
            .unwrap_err()
            .to_string();
        assert!(error.contains("incomplete C-FIND command response"));
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
    fn dataset_before_complete_command_errors() {
        let bytes = command_bytes(0xFF00);
        let split_at = bytes.len() / 2;
        let mut accumulator = PDataAccumulator::new();

        let error = feed_pdu(
            Pdu::PData {
                data: vec![
                    command_pdata(bytes[..split_at].to_vec(), false),
                    data_pdata([1, 2, 3], true),
                ],
            },
            &mut accumulator,
        )
        .unwrap_err()
        .to_string();

        assert!(error.contains("received C-FIND dataset fragment before complete command response"));
    }

    #[test]
    fn accepts_dataset_in_same_pdu_as_command() {
        let bytes = command_bytes(0xFF00);
        let dataset = vec![10, 20, 30];
        let pdu = Pdu::PData {
            data: vec![
                command_pdata(bytes, true),
                data_pdata(dataset.clone(), true),
            ],
        };
        let mut accumulator = PDataAccumulator::new();

        let response = feed_pdu(pdu, &mut accumulator).unwrap().unwrap();

        assert_eq!(response.dataset_bytes, dataset);
        assert!(!response.needs_dataset_fallback);
    }

    #[test]
    fn command_without_inline_dataset_requests_fallback_for_separate_dataset_pdu() {
        let pdu = Pdu::PData {
            data: vec![command_pdata(command_bytes(0xFF00), true)],
        };
        let mut accumulator = PDataAccumulator::new();

        let response = feed_pdu(pdu, &mut accumulator).unwrap().unwrap();

        assert!(response.dataset_bytes.is_empty() || response.needs_dataset_fallback);
    }

    #[test]
    fn accepts_dataset_split_until_final_fragment() {
        let pdu = Pdu::PData {
            data: vec![
                command_pdata(command_bytes(0xFF00), true),
                data_pdata([1, 2], false),
                data_pdata([3, 4], true),
            ],
        };
        let mut accumulator = PDataAccumulator::new();

        let response = feed_pdu(pdu, &mut accumulator).unwrap().unwrap();

        assert_eq!(response.dataset_bytes, vec![1, 2, 3, 4]);
        assert!(!response.needs_dataset_fallback);
    }

    #[test]
    fn incomplete_inline_dataset_requests_fallback() {
        let pdu = Pdu::PData {
            data: vec![
                command_pdata(command_bytes(0xFF00), true),
                data_pdata([1, 2], false),
            ],
        };
        let mut accumulator = PDataAccumulator::new();

        let response = feed_pdu(pdu, &mut accumulator).unwrap().unwrap();

        assert_eq!(response.dataset_bytes, vec![1, 2]);
        assert!(response.needs_dataset_fallback);
    }
}
