use std::{
    error::Error,
    io::{Read, Write},
    net::{TcpStream, ToSocketAddrs},
    sync::{
        atomic::{AtomicBool, AtomicU16, Ordering},
        mpsc::{Receiver, SyncSender},
    },
    time::Duration,
};

use anyhow::{anyhow, Context};
use dicom_core::{dicom_value, DataElement, PrimitiveValue, VR};
use dicom_dictionary_std::tags;
use dicom_object::mem::InMemDicomObject;
use dicom_transfer_syntax_registry::entries;
use dicom_ul::{
    association::{Association, ClientAssociation, ClientAssociationOptions},
    pdu::{PDataValue, PDataValueType, Pdu},
};
use tracing::{debug, warn};

use crate::{cancel, dicom::DefaultMemObject, error::Result, models::RemoteNode};

const DEFAULT_ASSOCIATION_IO_TIMEOUT: Duration = Duration::from_secs(60);
const CANCELLABLE_ASSOCIATION_IO_TIMEOUT: Duration = Duration::from_millis(500);

const PDATA_PDV_OVERHEAD: usize = 12;
const DEFAULT_PDV_PAYLOAD: usize = 64 * 1024;

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

/// A `Write` implementation which forwards bytes to a bounded channel in chunks.
///
/// This is used to connect `dicom_object`'s dataset serializer (which writes to a
/// `Write`) to the association sender (which reads from a `Read`) without ever
/// materializing the whole dataset in memory.
pub struct ChunkedChannelWriter {
    tx: Option<SyncSender<ChannelMsg>>,
    buf: Vec<u8>,
}

pub type ChannelError = Box<dyn Error + Send + Sync + 'static>;

pub enum ChannelMsg {
    Chunk(Vec<u8>),
    End,
    Error(ChannelError),
}

impl ChunkedChannelWriter {
    pub fn new(tx: SyncSender<ChannelMsg>) -> Self {
        Self {
            tx: Some(tx),
            buf: Vec::with_capacity(64 * 1024),
        }
    }

    fn flush_buf(&mut self) -> std::io::Result<()> {
        if self.buf.is_empty() {
            return Ok(());
        }
        let tx = self
            .tx
            .as_ref()
            .ok_or_else(|| std::io::Error::new(std::io::ErrorKind::BrokenPipe, "channel closed"))?;
        let chunk = std::mem::replace(&mut self.buf, Vec::with_capacity(64 * 1024));
        let chunk = ChannelMsg::Chunk(chunk);
        tx.send(chunk)
            .map_err(|_| std::io::Error::new(std::io::ErrorKind::BrokenPipe, "receiver dropped"))
    }

    pub fn finish(mut self) -> std::io::Result<()> {
        self.flush_buf()?;
        if let Some(tx) = self.tx.take() {
            tx.send(ChannelMsg::End).map_err(|_| {
                std::io::Error::new(std::io::ErrorKind::BrokenPipe, "receiver dropped")
            })?;
        }
        Ok(())
    }

    pub fn fail_with_message(mut self, message: String) {
        self.buf.clear();
        if let Some(tx) = self.tx.take() {
            let _ = tx.send(ChannelMsg::Error(Box::new(std::io::Error::new(
                std::io::ErrorKind::Other,
                message,
            ))));
        }
    }
}

impl Write for ChunkedChannelWriter {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        // Keep chunks reasonably sized to avoid excessive allocations.
        const MAX_CHUNK: usize = 64 * 1024;
        let original_len = buf.len();
        let mut remaining = buf;

        while !remaining.is_empty() {
            if self.buf.len() == MAX_CHUNK {
                self.flush_buf()?;
            }

            let available = MAX_CHUNK - self.buf.len();
            let take = available.min(remaining.len());
            self.buf.extend_from_slice(&remaining[..take]);
            remaining = &remaining[take..];

            if self.buf.len() == MAX_CHUNK {
                self.flush_buf()?;
            }
        }

        Ok(original_len)
    }

    fn flush(&mut self) -> std::io::Result<()> {
        self.flush_buf()
    }
}

impl Drop for ChunkedChannelWriter {
    fn drop(&mut self) {}
}

/// A `Read` implementation which consumes byte chunks from a channel.
pub struct ChannelChunkReader {
    rx: Receiver<ChannelMsg>,
    current: std::io::Cursor<Vec<u8>>,
    done: bool,
}

impl ChannelChunkReader {
    pub fn new(rx: Receiver<ChannelMsg>) -> Self {
        Self {
            rx,
            current: std::io::Cursor::new(Vec::new()),
            done: false,
        }
    }
}

impl Read for ChannelChunkReader {
    fn read(&mut self, out: &mut [u8]) -> std::io::Result<usize> {
        if out.is_empty() {
            return Ok(0);
        }

        loop {
            let n = self.current.read(out)?;
            if n > 0 {
                return Ok(n);
            }
            if self.done {
                return Ok(0);
            }
            match self.rx.recv() {
                Ok(ChannelMsg::Chunk(chunk)) => {
                    self.current = std::io::Cursor::new(chunk);
                }
                Ok(ChannelMsg::End) => {
                    self.done = true;
                }
                Ok(ChannelMsg::Error(err)) => {
                    return Err(std::io::Error::new(std::io::ErrorKind::Other, err));
                }
                Err(_) => {
                    return Err(std::io::Error::new(
                        std::io::ErrorKind::UnexpectedEof,
                        "chunk channel closed before end of dataset",
                    ));
                }
            }
        }
    }
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
            .read_timeout(DEFAULT_ASSOCIATION_IO_TIMEOUT)
            .write_timeout(DEFAULT_ASSOCIATION_IO_TIMEOUT)
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
            .read_timeout(DEFAULT_ASSOCIATION_IO_TIMEOUT)
            .write_timeout(DEFAULT_ASSOCIATION_IO_TIMEOUT)
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

    pub fn establish_with_presentation_contexts_cancellable(
        &self,
        node: &RemoteNode,
        contexts: &[PresentationContextDefinition],
        cancel_flag: &AtomicBool,
    ) -> Result<ClientAssociation<TcpStream>> {
        cancel::ensure_not_cancelled(Some(cancel_flag))?;
        preflight_tcp_connect(node, CANCELLABLE_ASSOCIATION_IO_TIMEOUT)?;
        cancel::ensure_not_cancelled(Some(cancel_flag))?;

        let mut options = ClientAssociationOptions::new()
            .calling_ae_title(self.local_ae_title.clone())
            .called_ae_title(node.ae_title.clone())
            .max_pdu_length(self.max_pdu_length)
            .read_timeout(CANCELLABLE_ASSOCIATION_IO_TIMEOUT)
            .write_timeout(CANCELLABLE_ASSOCIATION_IO_TIMEOUT)
            .strict(self.strict);

        for context in contexts {
            options = options.with_presentation_context(
                context.abstract_syntax.clone(),
                context.transfer_syntaxes.clone(),
            );
        }

        let addr = format!("{}@{}:{}", node.ae_title, node.host, node.port);
        let mut association = options
            .establish_with(&addr)
            .with_context(|| format!("establishing association with {} ({})", node.name, addr))?;

        cancel::ensure_not_cancelled(Some(cancel_flag))?;
        association
            .inner_stream()
            .set_read_timeout(Some(DEFAULT_ASSOCIATION_IO_TIMEOUT))
            .context("restoring association read timeout")?;
        association
            .inner_stream()
            .set_write_timeout(Some(DEFAULT_ASSOCIATION_IO_TIMEOUT))
            .context("restoring association write timeout")?;

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

    /// Send a DIMSE command and a dataset.
    ///
    /// Compatibility note: this is the historical API used throughout the codebase
    /// and it keeps accepting an owned `Vec<u8>`.
    ///
    /// Newer call sites should prefer `send_command_and_dataset_chunked()` (or a
    /// future streaming variant) so that datasets can be fragmented/streamed
    /// without requiring a single oversized P-DATA value.
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

    /// Send a DIMSE command and a dataset, splitting the dataset across multiple
    /// P-DATA PDVs if needed.
    ///
    /// Note: this helper currently expects the full dataset in memory; it only
    /// avoids wrapping it in a single oversized PDV.
    pub fn send_command_and_dataset_chunked(
        association: &mut ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        command: &DefaultMemObject,
        dataset_bytes: &[u8],
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

        Self::send_dataset_chunked(association, presentation_context_id, dataset_bytes)
    }

    /// Send a dataset (already encoded for the negotiated transfer syntax)
    /// fragmented across multiple P-DATA PDVs according to the peer's max PDU.
    pub fn send_dataset_chunked(
        association: &mut ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        dataset_bytes: &[u8],
    ) -> Result<()> {
        Self::send_dataset_chunked_with_cancel(
            association,
            presentation_context_id,
            dataset_bytes,
            None,
        )
    }

    pub fn send_dataset_chunked_cancellable(
        association: &mut ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        dataset_bytes: &[u8],
        cancel_flag: &AtomicBool,
    ) -> Result<()> {
        Self::send_dataset_chunked_with_cancel(
            association,
            presentation_context_id,
            dataset_bytes,
            Some(cancel_flag),
        )
    }

    fn send_dataset_chunked_with_cancel(
        association: &mut ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        dataset_bytes: &[u8],
        cancel_flag: Option<&AtomicBool>,
    ) -> Result<()> {
        validate_dataset_payload(dataset_bytes.len())?;

        // Use the same PDU sizing behavior as `send_command_and_dataset`, ensuring
        // we actually fragment large datasets across multiple PDVs.
        let max_pdv_payload = max_pdv_payload(association.peer_max_pdu_length() as usize);

        let total_chunks = dataset_bytes.len().div_ceil(max_pdv_payload);
        for (i, chunk) in dataset_bytes.chunks(max_pdv_payload).enumerate() {
            let is_last = i + 1 == total_chunks;
            cancel::ensure_not_cancelled(cancel_flag)?;
            association.send(&Pdu::PData {
                data: vec![PDataValue {
                    presentation_context_id,
                    value_type: PDataValueType::Data,
                    is_last,
                    data: chunk.to_vec(),
                }],
            })?;
        }

        Ok(())
    }

    /// Send a dataset by reading bytes from `reader` and emitting one or more
    /// P-DATA PDVs.
    ///
    /// This is the building block for streaming C-STORE payloads without first
    /// materializing the full dataset in memory.
    pub fn send_dataset_chunked_from_reader<R: Read>(
        association: &mut ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        mut reader: R,
    ) -> Result<()> {
        Self::send_dataset_chunked_from_reader_with_cancel(
            association,
            presentation_context_id,
            &mut reader,
            None,
        )
    }

    pub fn send_dataset_chunked_from_reader_cancellable<R: Read>(
        association: &mut ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        mut reader: R,
        cancel_flag: &AtomicBool,
    ) -> Result<()> {
        Self::send_dataset_chunked_from_reader_with_cancel(
            association,
            presentation_context_id,
            &mut reader,
            Some(cancel_flag),
        )
    }

    fn send_dataset_chunked_from_reader_with_cancel<R: Read>(
        association: &mut ClientAssociation<TcpStream>,
        presentation_context_id: u8,
        reader: &mut R,
        cancel_flag: Option<&AtomicBool>,
    ) -> Result<()> {
        let max_pdv_payload = max_pdv_payload(association.peer_max_pdu_length() as usize);

        let mut buf = vec![0u8; max_pdv_payload];
        let mut prev: Vec<u8> = Vec::new();

        loop {
            cancel::ensure_not_cancelled(cancel_flag)?;
            let n = reader.read(&mut buf)?;
            if n == 0 {
                break;
            }

            prev.extend_from_slice(&buf[..n]);
            while prev.len() > max_pdv_payload {
                let remainder = prev.split_off(max_pdv_payload);
                let chunk = std::mem::replace(&mut prev, remainder);
                cancel::ensure_not_cancelled(cancel_flag)?;
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

        if prev.is_empty() {
            return Err(empty_dataset_error());
        }

        validate_dataset_payload(prev.len())?;

        cancel::ensure_not_cancelled(cancel_flag)?;
        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Data,
                is_last: true,
                data: prev,
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

fn validate_dataset_payload(len: usize) -> Result<()> {
    if len == 0 {
        return Err(empty_dataset_error());
    }
    if len % 2 != 0 {
        return Err(anyhow!(
            "encoded dataset ended with an odd-length trailing fragment"
        ));
    }
    Ok(())
}

fn empty_dataset_error() -> anyhow::Error {
    anyhow!("encoded dataset is empty but COMMAND_DATA_SET_TYPE indicates a dataset is required")
}

fn max_pdv_payload(peer_max_pdu_length: usize) -> usize {
    if peer_max_pdu_length == 0 {
        return DEFAULT_PDV_PAYLOAD;
    }

    let usable = peer_max_pdu_length.saturating_sub(PDATA_PDV_OVERHEAD);
    if usable == 0 {
        return DEFAULT_PDV_PAYLOAD;
    }

    (usable & !1).max(2)
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
        PresentationContextDefinition,
    };
    use crate::{dicom::read_u16_opt_from_mem, models::RemoteNode};
    use dicom_dictionary_std::tags;
    use dicom_dictionary_std::uids::{CT_IMAGE_STORAGE, EXPLICIT_VR_LITTLE_ENDIAN};
    use dicom_ul::pdu::{PDataValue, PDataValueType};
    use std::{
        io::{self, Read, Write},
        net::TcpListener,
        sync::{
            atomic::{AtomicBool, Ordering},
            mpsc, Arc, Mutex,
        },
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
    fn chunked_channel_writer_splits_single_large_write() {
        let (tx, rx) = mpsc::sync_channel(10);
        let mut writer = super::ChunkedChannelWriter::new(tx);
        let max_chunk = 64 * 1024;
        let bytes = vec![7; max_chunk * 2 + 5];

        assert_eq!(writer.write(&bytes).unwrap(), bytes.len());
        writer.finish().unwrap();

        let chunks = rx.into_iter().collect::<Vec<_>>();
        let (chunks, end_count) =
            chunks
                .into_iter()
                .fold((Vec::new(), 0), |(mut chunks, end_count), msg| match msg {
                    super::ChannelMsg::Chunk(chunk) => {
                        chunks.push(chunk);
                        (chunks, end_count)
                    }
                    super::ChannelMsg::End => (chunks, end_count + 1),
                    super::ChannelMsg::Error(err) => panic!("unexpected channel error: {err}"),
                });
        assert_eq!(
            chunks.iter().map(Vec::len).collect::<Vec<_>>(),
            vec![max_chunk, max_chunk, 5]
        );
        assert_eq!(chunks.into_iter().flatten().collect::<Vec<_>>(), bytes);
        assert_eq!(end_count, 1);
    }

    #[test]
    fn chunked_channel_writer_drop_does_not_flush_partial_chunk() {
        let (tx, rx) = mpsc::sync_channel(10);
        let mut writer = super::ChunkedChannelWriter::new(tx);

        writer.write_all(&[1, 2, 3]).unwrap();
        drop(writer);

        assert!(rx.try_recv().is_err());
    }

    #[test]
    fn max_pdv_payload_handles_unlimited_and_even_limits() {
        assert_eq!(super::max_pdv_payload(0), 64 * 1024);
        assert_eq!(super::max_pdv_payload(12), 64 * 1024);
        assert_eq!(super::max_pdv_payload(13), 2);
        assert_eq!(super::max_pdv_payload(25), 12);
        assert_eq!(super::max_pdv_payload(26), 14);
    }

    #[test]
    fn validate_dataset_payload_rejects_empty_and_odd_lengths() {
        assert!(super::validate_dataset_payload(2).is_ok());

        let empty_error = super::validate_dataset_payload(0).unwrap_err().to_string();
        assert!(empty_error.contains("COMMAND_DATA_SET_TYPE"));

        let odd_error = super::validate_dataset_payload(3).unwrap_err().to_string();
        assert!(odd_error.contains("odd-length trailing fragment"));
    }

    #[test]
    fn channel_chunk_reader_returns_immediately_for_empty_reads() {
        let (tx, rx) = mpsc::sync_channel(0);
        let (result_tx, result_rx) = mpsc::channel();

        std::thread::spawn(move || {
            let mut reader = super::ChannelChunkReader::new(rx);
            let result = reader.read(&mut []);
            result_tx.send(result).unwrap();
        });

        let result = result_rx
            .recv_timeout(Duration::from_millis(100))
            .expect("empty read should not block");
        assert_eq!(result.unwrap(), 0);
        drop(tx);
    }

    #[test]
    fn channel_chunk_reader_reports_producer_error() {
        let (tx, rx) = mpsc::sync_channel(1);
        tx.send(super::ChannelMsg::Error(Box::new(io::Error::new(
            io::ErrorKind::Other,
            "serializer failed",
        ))))
        .unwrap();

        let mut reader = super::ChannelChunkReader::new(rx);
        let err = reader.read(&mut [0_u8; 8]).unwrap_err();

        assert_eq!(err.kind(), io::ErrorKind::Other);
        assert!(err.to_string().contains("serializer failed"));
    }

    #[test]
    fn channel_chunk_reader_rejects_closed_channel_without_end() {
        let (tx, rx) = mpsc::sync_channel(1);
        drop(tx);

        let mut reader = super::ChannelChunkReader::new(rx);
        let err = reader.read(&mut [0_u8; 8]).unwrap_err();

        assert_eq!(err.kind(), io::ErrorKind::UnexpectedEof);
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

    #[test]
    fn cancellable_presentation_context_establish_stops_when_cancelled() {
        let factory = AssociationFactory::new("LOCAL".to_string(), 16_384, false);
        let node = test_node("127.0.0.1", 9);
        let cancel_flag = AtomicBool::new(true);
        let contexts = [PresentationContextDefinition {
            abstract_syntax: CT_IMAGE_STORAGE.to_string(),
            transfer_syntaxes: vec![EXPLICIT_VR_LITTLE_ENDIAN.to_string()],
        }];

        let error = factory
            .establish_with_presentation_contexts_cancellable(&node, &contexts, &cancel_flag)
            .unwrap_err();

        assert!(crate::cancel::is_cancelled_error(&error));
        assert!(cancel_flag.load(Ordering::Acquire));
    }
}
