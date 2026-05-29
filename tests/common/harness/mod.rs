pub mod move_scp;
pub mod query_scp;
pub mod store_scp;

use std::{
    net::{TcpListener, TcpStream},
    time::Duration,
};

use anyhow::{anyhow, Context};
use dicom_dictionary_std::tags;
use dicom_node_client::{
    dicom::{read_u16_opt_from_mem, DefaultMemObject},
    net::assoc::{AssociationFactory, PDataAccumulator},
};
use dicom_ul::{
    association::ServerAssociation,
    pdu::{PDataValue, PDataValueType, Pdu},
};

pub use move_scp::{MoveFailureMode, MoveScp, MoveScpBuilder, ReceivedMove};
pub use query_scp::{QueryScp, QueryScpBuilder, ReceivedQuery};
pub use store_scp::{ReceivedStore, StoreScp, StoreScpBuilder};

pub fn send_dataset_fragments_for_test(
    association: &mut TestAssociation,
    presentation_context_id: u8,
    dataset_bytes: Vec<u8>,
    fragment_sizes: &[usize],
) -> anyhow::Result<()> {
    let mut sizes = fragment_sizes.to_vec();
    sizes.push(usize::MAX);
    send_dataset_fragments(
        association,
        presentation_context_id,
        dataset_bytes,
        Some(&sizes),
    )
}

pub fn send_command_fragments_for_test(
    association: &mut TestAssociation,
    presentation_context_id: u8,
    command_bytes: Vec<u8>,
    fragment_sizes: &[usize],
) -> anyhow::Result<()> {
    let mut sizes = fragment_sizes.to_vec();
    sizes.push(usize::MAX);

    let mut offset = 0usize;
    for (i, size) in sizes.iter().enumerate() {
        let end = offset.saturating_add(*size).min(command_bytes.len());
        let chunk = command_bytes[offset..end].to_vec();
        offset = end;

        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Command,
                is_last: i == sizes.len() - 1,
                data: chunk,
            }],
        })?;

        if offset >= command_bytes.len() {
            break;
        }
    }

    Ok(())
}

type TestAssociation = ServerAssociation<TcpStream>;

#[derive(Debug)]
struct IncomingDimse {
    command: DefaultMemObject,
    dataset_bytes: Vec<u8>,
    presentation_context_id: u8,
    dataset_pdv_count: usize,
}

fn bind_test_listener(port: u16) -> anyhow::Result<TcpListener> {
    let listener = TcpListener::bind(("127.0.0.1", port))
        .with_context(|| format!("binding test SCP at 127.0.0.1:{port}"))?;
    listener
        .set_nonblocking(true)
        .context("setting test SCP listener nonblocking")?;
    Ok(listener)
}

fn is_preflight_probe(stream: &TcpStream) -> anyhow::Result<bool> {
    stream.set_read_timeout(Some(Duration::from_millis(100)))?;
    let mut probe = [0_u8; 1];

    match stream.peek(&mut probe) {
        Ok(0) => Ok(true),
        Ok(_) => Ok(false),
        Err(err)
            if matches!(
                err.kind(),
                std::io::ErrorKind::ConnectionReset
                    | std::io::ErrorKind::UnexpectedEof
                    | std::io::ErrorKind::BrokenPipe
            ) =>
        {
            Ok(true)
        }
        Err(err)
            if matches!(
                err.kind(),
                std::io::ErrorKind::WouldBlock | std::io::ErrorKind::TimedOut
            ) =>
        {
            Ok(false)
        }
        Err(err) => Err(err.into()),
    }
}

fn next_dimse_message(association: &mut TestAssociation) -> anyhow::Result<Option<IncomingDimse>> {
    let mut command_accumulator = PDataAccumulator::new();
    let mut dataset_accumulator = PDataAccumulator::new();
    let mut command: Option<(DefaultMemObject, u8)> = None;
    let mut dataset_pdv_count: usize = 0;

    loop {
        match association.receive()? {
            Pdu::PData { data } => {
                for value in data {
                    match value.value_type {
                        PDataValueType::Command => {
                            let presentation_context_id = value.presentation_context_id;
                            dataset_pdv_count = 0;
                            command_accumulator.feed(&value)?;
                            if command_accumulator.is_complete() {
                                let command_obj = command_accumulator
                                    .take_command()?
                                    .ok_or_else(|| anyhow!("missing complete command payload"))?;
                                command = Some((command_obj, presentation_context_id));
                            }
                        }
                        PDataValueType::Data => {
                            dataset_pdv_count += 1;
                            dataset_accumulator.feed(&value)?;
                        }
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
                            dataset_bytes: Vec::new(),
                            presentation_context_id,
                            dataset_pdv_count: 0,
                        }));
                    }
                    if dataset_accumulator.is_complete() {
                        let dataset_bytes = dataset_accumulator.take().unwrap_or_default();
                        let (command, presentation_context_id) = command.take().unwrap();
                        return Ok(Some(IncomingDimse {
                            command,
                            dataset_bytes,
                            presentation_context_id,
                            dataset_pdv_count,
                        }));
                    }
                }
            }
            Pdu::ReleaseRQ => {
                association.send(&Pdu::ReleaseRP)?;
                return Ok(None);
            }
            Pdu::AbortRQ { source } => {
                return Err(anyhow!("peer aborted test association: {:?}", source));
            }
            other => return Err(anyhow!("unexpected PDU in test SCP: {:?}", other)),
        }
    }
}

fn send_command(
    association: &mut TestAssociation,
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

fn send_command_and_dataset(
    association: &mut TestAssociation,
    presentation_context_id: u8,
    command: &DefaultMemObject,
    dataset_bytes: Vec<u8>,
) -> anyhow::Result<()> {
    send_command(association, presentation_context_id, command)?;
    send_dataset_fragments(association, presentation_context_id, dataset_bytes, None)
}

fn send_dataset_fragments(
    association: &mut TestAssociation,
    presentation_context_id: u8,
    dataset_bytes: Vec<u8>,
    fragment_sizes: Option<&[usize]>,
) -> anyhow::Result<()> {
    let sizes: Vec<usize> = match fragment_sizes {
        Some(sizes) if !sizes.is_empty() => sizes.to_vec(),
        _ => vec![dataset_bytes.len()],
    };

    let mut offset = 0usize;
    for (i, size) in sizes.iter().enumerate() {
        let end = offset.saturating_add(*size).min(dataset_bytes.len());
        let chunk = dataset_bytes[offset..end].to_vec();
        offset = end;

        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Data,
                is_last: i == sizes.len() - 1,
                data: chunk,
            }],
        })?;

        if offset >= dataset_bytes.len() {
            break;
        }
    }

    Ok(())
}

fn negotiated_transfer_syntax(
    association: &TestAssociation,
    presentation_context_id: u8,
) -> anyhow::Result<String> {
    association
        .presentation_contexts()
        .iter()
        .find(|context| context.id == presentation_context_id)
        .map(|context| context.transfer_syntax.clone())
        .ok_or_else(|| anyhow!("missing negotiated presentation context {presentation_context_id}"))
}

fn clean_dicom_text(value: &str) -> String {
    value.trim_end_matches('\0').trim().to_string()
}

fn element_string(obj: &DefaultMemObject, tag: dicom_core::Tag) -> Option<String> {
    obj.element(tag)
        .ok()
        .and_then(|element| element.to_str().ok())
        .as_deref()
        .map(clean_dicom_text)
        .filter(|value| !value.is_empty())
}
