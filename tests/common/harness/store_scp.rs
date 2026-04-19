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
use dicom_dictionary_std::{tags, uids};
use dicom_node_client::{
    dicom::{read_u16_opt_from_mem, DefaultMemObject},
    models::RemoteNode,
    net::{
        assoc::{create_echo_response, create_store_response},
        transfer::{all_supported_transfer_syntaxes, STORAGE_ABSTRACT_SYNTAXES},
    },
};
use dicom_ul::association::ServerAssociationOptions;

use super::{
    bind_test_listener, element_string, is_preflight_probe, next_dimse_message, send_command,
};
use crate::common::services::remote_node_fixture;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ReceivedStore {
    pub sop_class_uid: String,
    pub sop_instance_uid: String,
    pub dataset_bytes: Vec<u8>,
}

#[derive(Debug)]
pub struct StoreScpBuilder {
    ae_title: String,
    port: u16,
    store_status: u16,
}

#[derive(Debug)]
pub struct StoreScp {
    ae_title: String,
    port: u16,
    stop_flag: Arc<AtomicBool>,
    received: Arc<Mutex<Vec<ReceivedStore>>>,
    join_handle: Option<JoinHandle<anyhow::Result<()>>>,
}

impl StoreScpBuilder {
    pub fn new() -> anyhow::Result<Self> {
        Ok(Self {
            ae_title: "STORESCP".to_string(),
            port: 0,
            store_status: 0x0000,
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

    pub fn store_status(mut self, status: u16) -> Self {
        self.store_status = status;
        self
    }

    pub fn spawn(self) -> anyhow::Result<StoreScp> {
        let listener = bind_test_listener(self.port)?;
        let port = listener
            .local_addr()
            .context("reading store SCP listener port")?
            .port();
        let stop_flag = Arc::new(AtomicBool::new(false));
        let received = Arc::new(Mutex::new(Vec::new()));
        let thread_stop = stop_flag.clone();
        let thread_received = received.clone();
        let ae_title = self.ae_title.clone();
        let store_status = self.store_status;

        let join_handle = std::thread::spawn(move || {
            while !thread_stop.load(Ordering::Relaxed) {
                match listener.accept() {
                    Ok((stream, _addr)) => {
                        handle_store_connection(stream, &ae_title, store_status, &thread_received)?;
                    }
                    Err(err) if err.kind() == std::io::ErrorKind::WouldBlock => {
                        std::thread::sleep(Duration::from_millis(25));
                    }
                    Err(err) => return Err(err.into()),
                }
            }
            Ok(())
        });

        Ok(StoreScp {
            ae_title: self.ae_title,
            port,
            stop_flag,
            received,
            join_handle: Some(join_handle),
        })
    }
}

impl StoreScp {
    pub fn builder() -> anyhow::Result<StoreScpBuilder> {
        StoreScpBuilder::new()
    }

    pub fn port(&self) -> u16 {
        self.port
    }

    pub fn remote_node(&self, name: &str) -> RemoteNode {
        remote_node_fixture(name, &self.ae_title, self.port)
    }

    pub fn stop(self) -> anyhow::Result<Vec<String>> {
        let instances = self.stop_with_instances()?;
        Ok(instances
            .into_iter()
            .map(|instance| instance.sop_instance_uid)
            .collect())
    }

    pub fn stop_with_instances(mut self) -> anyhow::Result<Vec<ReceivedStore>> {
        self.stop_flag.store(true, Ordering::Relaxed);
        if let Some(join_handle) = self.join_handle.take() {
            join_handle
                .join()
                .map_err(|_| anyhow!("store SCP thread panicked"))??;
        }
        let received = self
            .received
            .lock()
            .map_err(|_| anyhow!("store SCP received list lock poisoned"))?
            .clone();
        Ok(received)
    }
}

fn handle_store_connection(
    stream: TcpStream,
    ae_title: &str,
    store_status: u16,
    received: &Arc<Mutex<Vec<ReceivedStore>>>,
) -> anyhow::Result<()> {
    stream
        .set_nonblocking(false)
        .context("setting store SCP stream blocking")?;
    if is_preflight_probe(&stream)? {
        return Ok(());
    }

    let mut options = ServerAssociationOptions::new()
        .accept_called_ae_title()
        .ae_title(ae_title.to_string())
        .strict(true)
        .promiscuous(true)
        .read_timeout(Duration::from_secs(1))
        .write_timeout(Duration::from_secs(1))
        .with_abstract_syntax(uids::VERIFICATION);
    for abstract_syntax in STORAGE_ABSTRACT_SYNTAXES {
        options = options.with_abstract_syntax(*abstract_syntax);
    }
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
            0x0001 => {
                let message_id = read_u16_opt_from_mem(&message.command, tags::MESSAGE_ID)
                    .ok_or_else(|| anyhow!("missing C-STORE message id"))?;
                let sop_class_uid = element_string(&message.command, tags::AFFECTED_SOP_CLASS_UID)
                    .ok_or_else(|| anyhow!("missing affected SOP class UID"))?;
                let sop_instance_uid =
                    element_string(&message.command, tags::AFFECTED_SOP_INSTANCE_UID)
                        .ok_or_else(|| anyhow!("missing affected SOP instance UID"))?;

                received
                    .lock()
                    .map_err(|_| anyhow!("store SCP received list lock poisoned"))?
                    .push(ReceivedStore {
                        sop_class_uid: sop_class_uid.clone(),
                        sop_instance_uid: sop_instance_uid.clone(),
                        dataset_bytes: message.dataset_bytes,
                    });

                let response = create_store_response(
                    message_id,
                    &sop_class_uid,
                    &sop_instance_uid,
                    store_status,
                );
                send_command(&mut association, message.presentation_context_id, &response)?;
            }
            other => return Err(anyhow!("unsupported store SCP command 0x{other:04X}")),
        }
    }

    Ok(())
}
