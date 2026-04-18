use std::{
    io::Read,
    net::{TcpStream, ToSocketAddrs},
    sync::atomic::{AtomicU16, Ordering},
    time::Duration,
};

use anyhow::{anyhow, Context};
use dicom_core::{dicom_value, DataElement, PrimitiveValue, VR};
use dicom_dictionary_std::tags;
use dicom_object::mem::InMemDicomObject;
use dicom_transfer_syntax_registry::entries;
use dicom_ul::{
    association::{ClientAssociation, ClientAssociationOptions},
    pdu::{PDataValue, PDataValueType, Pdu},
};
use tracing::{debug, warn};

use crate::{dicom::DefaultMemObject, error::Result, models::RemoteNode};

#[derive(Debug, Clone)]
pub struct PresentationContextDefinition {
    pub abstract_syntax: String,
    pub transfer_syntaxes: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct NegotiatedContext {
    pub id: u8,
    pub abstract_syntax: String,
    pub transfer_syntax: String,
}

#[derive(Debug, Clone, Default)]
pub struct PDataAccumulator {
    buffer: Vec<u8>,
    is_complete: bool,
}

impl PDataAccumulator {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn feed(&mut self, value: &PDataValue) -> Result<()> {
        if self.is_complete {
            return Err(anyhow!(
                "cannot feed P-DATA fragment into a complete accumulator"
            ));
        }

        self.buffer.extend_from_slice(&value.data);
        if value.is_last {
            self.is_complete = true;
        }

        Ok(())
    }

    pub fn is_complete(&self) -> bool {
        self.is_complete
    }

    pub fn is_empty(&self) -> bool {
        self.buffer.is_empty()
    }

    pub fn take(&mut self) -> Option<Vec<u8>> {
        if !self.is_complete {
            return None;
        }

        self.is_complete = false;
        Some(std::mem::take(&mut self.buffer))
    }

    pub fn take_command(&mut self) -> Result<Option<DefaultMemObject>> {
        let Some(bytes) = self.take() else {
            return Ok(None);
        };

        AssociationFactory::read_command_dataset(&bytes).map(Some)
    }
}

#[derive(Debug)]
pub struct AssociationFactory {
    local_ae_title: String,
    max_pdu_length: u32,
    strict: bool,
    message_id: AtomicU16,
}

impl Clone for AssociationFactory {
    fn clone(&self) -> Self {
        Self {
            local_ae_title: self.local_ae_title.clone(),
            max_pdu_length: self.max_pdu_length,
            strict: self.strict,
            message_id: AtomicU16::new(self.message_id.load(Ordering::Relaxed)),
        }
    }
}

impl AssociationFactory {
    pub fn new(local_ae_title: String, max_pdu_length: u32, strict: bool) -> Self {
        Self {
            local_ae_title,
            max_pdu_length,
            strict,
            message_id: AtomicU16::new(1),
        }
    }

    pub fn next_message_id(&self) -> u16 {
        self.message_id.fetch_add(1, Ordering::Relaxed)
    }

    pub fn establish_with_abstract_syntaxes(
        &self,
        node: &RemoteNode,
        syntaxes: impl IntoIterator<Item = &'static str>,
    ) -> Result<ClientAssociation<TcpStream>> {
        preflight_tcp_connect(node, Duration::from_secs(3))?;

        let mut options = ClientAssociationOptions::new()
            .calling_ae_title(self.local_ae_title.clone())
            .called_ae_title(node.ae_title.clone())
            .max_pdu_length(self.max_pdu_length)
            .read_timeout(Duration::from_secs(60))
            .write_timeout(Duration::from_secs(60))
            .strict(self.strict);

        for syntax in syntaxes {
            options = options.with_abstract_syntax(syntax);
        }

        let addr = format!("{}@{}:{}", node.ae_title, node.host, node.port);
        let association = options
            .establish_with(&addr)
            .with_context(|| format!("establishing association with {} ({})", node.name, addr))?;

        Ok(association)
    }

    pub fn establish_with_presentation_contexts(
        &self,
        node: &RemoteNode,
        contexts: &[PresentationContextDefinition],
    ) -> Result<ClientAssociation<TcpStream>> {
        preflight_tcp_connect(node, Duration::from_secs(3))?;

        let mut options = ClientAssociationOptions::new()
            .calling_ae_title(self.local_ae_title.clone())
            .called_ae_title(node.ae_title.clone())
            .max_pdu_length(self.max_pdu_length)
            .read_timeout(Duration::from_secs(60))
            .write_timeout(Duration::from_secs(60))
            .strict(self.strict);

        for context in contexts {
            options = options.with_presentation_context(
                context.abstract_syntax.clone(),
                context.transfer_syntaxes.clone(),
            );
        }

        let addr = format!("{}@{}:{}", node.ae_title, node.host, node.port);
        let association = options
            .establish_with(&addr)
            .with_context(|| format!("establishing association with {} ({})", node.name, addr))?;

        Ok(association)
    }

    pub fn negotiated_contexts(
        &self,
        association: &ClientAssociation<TcpStream>,
    ) -> Vec<NegotiatedContext> {
        association
            .presentation_contexts()
            .iter()
            .map(|pc| NegotiatedContext {
                id: pc.id,
                abstract_syntax: pc.abstract_syntax.to_string(),
                transfer_syntax: pc.transfer_syntax.to_string(),
            })
            .collect()
    }

    pub fn first_context(
        &self,
        association: &ClientAssociation<TcpStream>,
    ) -> Result<NegotiatedContext> {
        self.negotiated_contexts(association)
            .into_iter()
            .next()
            .ok_or_else(|| anyhow!("no negotiated presentation context"))
    }

    pub fn write_command_dataset(command: &DefaultMemObject) -> Result<Vec<u8>> {
        let mut out = Vec::with_capacity(256);
        command
            .write_dataset_with_ts(&mut out, &entries::IMPLICIT_VR_LITTLE_ENDIAN.erased())
            .context("writing command dataset")?;
        Ok(out)
    }

    pub fn read_command_dataset(bytes: &[u8]) -> Result<DefaultMemObject> {
        let obj = InMemDicomObject::read_dataset_with_ts(
            bytes,
            &entries::IMPLICIT_VR_LITTLE_ENDIAN.erased(),
        )
        .context("reading command dataset")?;
        Ok(obj)
    }

    pub fn send_command_and_dataset(
        association: &mut ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        command: &DefaultMemObject,
        dataset_bytes: Vec<u8>,
    ) -> Result<()> {
        let command_bytes = Self::write_command_dataset(command)?;

        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Command,
                is_last: true,
                data: command_bytes,
            }],
        })?;

        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Data,
                is_last: true,
                data: dataset_bytes,
            }],
        })?;

        Ok(())
    }

    pub fn read_single_pdata_dataset(
        association: &mut ClientAssociation<TcpStream>,
    ) -> Result<Vec<u8>> {
        let mut reader = association.receive_pdata();
        let mut bytes = Vec::new();
        reader.read_to_end(&mut bytes)?;
        Ok(bytes)
    }
}

fn preflight_tcp_connect(node: &RemoteNode, timeout: Duration) -> Result<()> {
    let addrs = match (node.host.as_str(), node.port).to_socket_addrs() {
        Ok(addrs) => addrs.collect::<Vec<_>>(),
        Err(err) => {
            warn!(
                node = %node.name,
                ae_title = %node.ae_title,
                host = %node.host,
                port = node.port,
                error = %err,
                "TCP preflight address resolution failed"
            );
            return Err(anyhow!(
                "resolving {} at {}:{}: {}",
                node.name,
                node.host,
                node.port,
                err
            ));
        }
    };

    if addrs.is_empty() {
        warn!(
            node = %node.name,
            ae_title = %node.ae_title,
            host = %node.host,
            port = node.port,
            "TCP preflight resolved no socket addresses"
        );
        return Err(anyhow!(
            "no socket addresses resolved for {} at {}:{}",
            node.name,
            node.host,
            node.port
        ));
    }

    let mut last_err = None;

    for addr in addrs {
        match TcpStream::connect_timeout(&addr, timeout) {
            Ok(_) => return Ok(()),
            Err(err) => {
                debug!(
                    node = %node.name,
                    ae_title = %node.ae_title,
                    address = %addr,
                    timeout_secs = timeout.as_secs(),
                    error = %err,
                    "TCP preflight connection attempt failed"
                );
                last_err = Some(err);
            }
        }
    }

    let Some(err) = last_err else {
        unreachable!("non-empty address resolution must attempt at least one TCP connection");
    };
    warn!(
        node = %node.name,
        ae_title = %node.ae_title,
        host = %node.host,
        port = node.port,
        timeout_secs = timeout.as_secs(),
        error = %err,
        "TCP preflight could not reach remote node"
    );
    Err(anyhow!(
        "could not reach {} [{}] at {}:{} within {}s: {}. Check host/IP, port, and network reachability",
        node.name,
        node.ae_title,
        node.host,
        node.port,
        timeout.as_secs(),
        err
    ))
}

pub fn create_find_request_command(sop_class_uid: &str, message_id: u16) -> DefaultMemObject {
    InMemDicomObject::command_from_element_iter([
        DataElement::new(
            tags::AFFECTED_SOP_CLASS_UID,
            VR::UI,
            PrimitiveValue::from(sop_class_uid),
        ),
        DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x0020])),
        DataElement::new(tags::MESSAGE_ID, VR::US, dicom_value!(U16, [message_id])),
        DataElement::new(tags::PRIORITY, VR::US, dicom_value!(U16, [0x0000])),
        DataElement::new(
            tags::COMMAND_DATA_SET_TYPE,
            VR::US,
            dicom_value!(U16, [0x0001]),
        ),
    ])
}

pub fn create_move_request_command(
    sop_class_uid: &str,
    message_id: u16,
    move_destination: &str,
) -> DefaultMemObject {
    InMemDicomObject::command_from_element_iter([
        DataElement::new(
            tags::AFFECTED_SOP_CLASS_UID,
            VR::UI,
            PrimitiveValue::from(sop_class_uid),
        ),
        DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x0021])),
        DataElement::new(tags::MESSAGE_ID, VR::US, dicom_value!(U16, [message_id])),
        DataElement::new(tags::PRIORITY, VR::US, dicom_value!(U16, [0x0000])),
        DataElement::new(
            tags::MOVE_DESTINATION,
            VR::AE,
            PrimitiveValue::from(move_destination),
        ),
        DataElement::new(
            tags::COMMAND_DATA_SET_TYPE,
            VR::US,
            dicom_value!(U16, [0x0001]),
        ),
    ])
}

pub fn create_store_request_command(
    message_id: u16,
    sop_class_uid: &str,
    sop_instance_uid: &str,
) -> DefaultMemObject {
    InMemDicomObject::command_from_element_iter([
        DataElement::new(
            tags::AFFECTED_SOP_CLASS_UID,
            VR::UI,
            PrimitiveValue::from(sop_class_uid),
        ),
        DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x0001])),
        DataElement::new(tags::MESSAGE_ID, VR::US, dicom_value!(U16, [message_id])),
        DataElement::new(tags::PRIORITY, VR::US, dicom_value!(U16, [0x0000])),
        DataElement::new(
            tags::AFFECTED_SOP_INSTANCE_UID,
            VR::UI,
            PrimitiveValue::from(sop_instance_uid),
        ),
        DataElement::new(
            tags::COMMAND_DATA_SET_TYPE,
            VR::US,
            dicom_value!(U16, [0x0001]),
        ),
    ])
}

pub fn create_store_response(
    message_id_being_responded_to: u16,
    sop_class_uid: &str,
    sop_instance_uid: &str,
    status: u16,
) -> DefaultMemObject {
    InMemDicomObject::command_from_element_iter([
        DataElement::new(
            tags::AFFECTED_SOP_CLASS_UID,
            VR::UI,
            PrimitiveValue::from(sop_class_uid),
        ),
        DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x8001])),
        DataElement::new(
            tags::MESSAGE_ID_BEING_RESPONDED_TO,
            VR::US,
            dicom_value!(U16, [message_id_being_responded_to]),
        ),
        DataElement::new(
            tags::AFFECTED_SOP_INSTANCE_UID,
            VR::UI,
            PrimitiveValue::from(sop_instance_uid),
        ),
        DataElement::new(
            tags::COMMAND_DATA_SET_TYPE,
            VR::US,
            dicom_value!(U16, [0x0101]),
        ),
        DataElement::new(tags::STATUS, VR::US, dicom_value!(U16, [status])),
    ])
}

pub fn create_echo_response(message_id_being_responded_to: u16, status: u16) -> DefaultMemObject {
    InMemDicomObject::command_from_element_iter([
        DataElement::new(tags::COMMAND_FIELD, VR::US, dicom_value!(U16, [0x8030])),
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
        DataElement::new(tags::STATUS, VR::US, dicom_value!(U16, [status])),
    ])
}

#[cfg(test)]
mod tests {
    use super::{
        create_echo_response, preflight_tcp_connect, AssociationFactory, PDataAccumulator,
    };
    use crate::{dicom::read_u16_opt_from_mem, models::RemoteNode};
    use dicom_dictionary_std::tags;
    use dicom_ul::pdu::{PDataValue, PDataValueType};
    use std::{
        io::{self, Write},
        net::TcpListener,
        sync::{Arc, Mutex},
        time::Duration,
    };
    use tracing_subscriber::fmt::MakeWriter;
    use uuid::Uuid;

    fn command_pdata(data: impl Into<Vec<u8>>, is_last: bool) -> PDataValue {
        PDataValue {
            presentation_context_id: 1,
            value_type: PDataValueType::Command,
            is_last,
            data: data.into(),
        }
    }

    fn test_node(host: &str, port: u16) -> RemoteNode {
        RemoteNode {
            id: Uuid::new_v4().to_string(),
            name: "TestNode".to_string(),
            ae_title: "TEST_AE".to_string(),
            host: host.to_string(),
            port,
            preferred_move_destination: None,
            notes: None,
            created_at: String::new(),
            updated_at: String::new(),
        }
    }

    #[derive(Clone)]
    struct SharedLogBuffer(Arc<Mutex<Vec<u8>>>);

    struct SharedLogWriter(Arc<Mutex<Vec<u8>>>);

    impl Write for SharedLogWriter {
        fn write(&mut self, buf: &[u8]) -> io::Result<usize> {
            self.0
                .lock()
                .expect("lock log buffer")
                .extend_from_slice(buf);
            Ok(buf.len())
        }

        fn flush(&mut self) -> io::Result<()> {
            Ok(())
        }
    }

    impl<'a> MakeWriter<'a> for SharedLogBuffer {
        type Writer = SharedLogWriter;

        fn make_writer(&'a self) -> Self::Writer {
            SharedLogWriter(self.0.clone())
        }
    }

    #[test]
    fn pdata_accumulator_takes_single_complete_fragment() {
        let mut accumulator = PDataAccumulator::new();

        accumulator.feed(&command_pdata([1, 2, 3], true)).unwrap();

        assert!(accumulator.is_complete());
        assert_eq!(accumulator.take(), Some(vec![1, 2, 3]));
        assert!(!accumulator.is_complete());
    }

    #[test]
    fn pdata_accumulator_concatenates_multiple_fragments() {
        let mut accumulator = PDataAccumulator::new();

        accumulator.feed(&command_pdata([1, 2], false)).unwrap();
        accumulator.feed(&command_pdata([3, 4], false)).unwrap();
        assert!(!accumulator.is_complete());

        accumulator.feed(&command_pdata([5], true)).unwrap();

        assert!(accumulator.is_complete());
        assert_eq!(accumulator.take(), Some(vec![1, 2, 3, 4, 5]));
    }

    #[test]
    fn pdata_accumulator_does_not_take_incomplete_payload() {
        let mut accumulator = PDataAccumulator::new();

        accumulator.feed(&command_pdata([1, 2, 3], false)).unwrap();

        assert!(!accumulator.is_complete());
        assert_eq!(accumulator.take(), None);
    }

    #[test]
    fn pdata_accumulator_can_be_reused_after_take() {
        let mut accumulator = PDataAccumulator::new();

        accumulator.feed(&command_pdata([1, 2], true)).unwrap();
        assert_eq!(accumulator.take(), Some(vec![1, 2]));

        accumulator.feed(&command_pdata([3], false)).unwrap();
        accumulator.feed(&command_pdata([4], true)).unwrap();

        assert!(accumulator.is_complete());
        assert_eq!(accumulator.take(), Some(vec![3, 4]));
    }

    #[test]
    fn pdata_accumulator_take_command_parses_complete_payload() {
        let command = create_echo_response(7, 0x0000);
        let command_bytes = AssociationFactory::write_command_dataset(&command).unwrap();
        let split_at = command_bytes.len() / 2;
        let mut accumulator = PDataAccumulator::new();

        accumulator
            .feed(&command_pdata(command_bytes[..split_at].to_vec(), false))
            .unwrap();
        accumulator
            .feed(&command_pdata(command_bytes[split_at..].to_vec(), true))
            .unwrap();

        let parsed = accumulator.take_command().unwrap().unwrap();

        assert_eq!(
            read_u16_opt_from_mem(&parsed, tags::COMMAND_FIELD),
            Some(0x8030)
        );
        assert_eq!(read_u16_opt_from_mem(&parsed, tags::STATUS), Some(0x0000));
    }

    #[test]
    fn pdata_accumulator_rejects_feed_after_complete_fragment() {
        let mut accumulator = PDataAccumulator::new();

        accumulator.feed(&command_pdata([1, 2], true)).unwrap();
        let error = accumulator
            .feed(&command_pdata([3, 4], true))
            .unwrap_err()
            .to_string();

        assert!(error.contains("cannot feed P-DATA fragment into a complete accumulator"));
    }

    #[test]
    fn preflight_tcp_connect_succeeds_for_reachable_listener() {
        let listener = TcpListener::bind("127.0.0.1:0").unwrap();
        let port = listener.local_addr().unwrap().port();
        let node = test_node("127.0.0.1", port);

        preflight_tcp_connect(&node, Duration::from_secs(1)).unwrap();
    }

    #[test]
    fn preflight_tcp_connect_reports_unreachable_endpoint() {
        let node = test_node("127.0.0.1", 9);
        let error = preflight_tcp_connect(&node, Duration::from_secs(1))
            .unwrap_err()
            .to_string();

        assert!(error.contains("could not reach"));
        assert!(error.contains("Check host/IP, port, and network reachability"));
    }

    #[test]
    fn preflight_tcp_connect_reports_address_resolution_failure() {
        let log_buffer = Arc::new(Mutex::new(Vec::new()));
        let subscriber = tracing_subscriber::fmt()
            .with_writer(SharedLogBuffer(log_buffer.clone()))
            .with_ansi(false)
            .with_max_level(tracing::Level::WARN)
            .finish();
        let node = test_node("invalid host name", 104);

        let error = tracing::subscriber::with_default(subscriber, || {
            preflight_tcp_connect(&node, Duration::from_secs(1))
                .unwrap_err()
                .to_string()
        });

        assert!(error.contains("resolving TestNode at invalid host name:104:"));
        let logs = String::from_utf8(log_buffer.lock().expect("lock log buffer").clone()).unwrap();
        assert!(logs.contains("TCP preflight address resolution failed"));
        assert!(logs.contains("node=TestNode"));
        assert!(logs.contains("ae_title=TEST_AE"));
        assert!(logs.contains("invalid host name"));
        assert!(logs.contains("port=104"));
    }
}
