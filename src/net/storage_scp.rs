use std::{
    fs,
    io::{self, BufWriter, Write},
    net::{TcpListener, TcpStream},
    sync::{
        atomic::{AtomicBool, AtomicU32, Ordering},
        Arc,
    },
    time::Duration,
};

use anyhow::{anyhow, Context};
use dicom_dictionary_std::tags;
use dicom_object::{FileMetaTableBuilder, OpenFileOptions};
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::{
    association::{Association, ServerAssociationOptions},
    pdu::{PDataValue, PDataValueType},
    Pdu,
};
use sha2::{Digest, Sha256};
use tracing::{error, info, warn};

use crate::{
    config::{now_utc_string, AppConfig, AppPaths},
    db::Database,
    dicom::{extract_local_instance, managed_file_path, read_u16_opt_from_mem, DefaultMemObject},
    error::Result,
    models::ScpSessionReport,
};

use super::{
    assoc::{create_echo_response, create_store_response, AssociationFactory},
    transfer::{all_supported_transfer_syntaxes, STORAGE_ABSTRACT_SYNTAXES},
};

#[derive(Debug, Clone)]
pub struct StorageScpServer {
    config: AppConfig,
    paths: AppPaths,
    db: Database,
}

#[derive(Debug)]
pub struct BackgroundStorageScp {
    stop_flag: Arc<AtomicBool>,
    received: Arc<AtomicU32>,
    stored: Arc<AtomicU32>,
    failed: Arc<AtomicU32>,
    port: u16,
    join_handle: Option<std::thread::JoinHandle<Result<()>>>,
}

#[derive(Debug, Clone)]
struct CurrentStoreCommand {
    message_id: u16,
    sop_class_uid: String,
    sop_instance_uid: String,
    presentation_context_id: u8,
}

impl StorageScpServer {
    pub fn new(config: AppConfig, paths: AppPaths, db: Database) -> Self {
        Self { config, paths, db }
    }

    pub fn run_forever(&self) -> Result<()> {
        let stop = Arc::new(AtomicBool::new(false));
        let received = Arc::new(AtomicU32::new(0));
        let stored = Arc::new(AtomicU32::new(0));
        let failed = Arc::new(AtomicU32::new(0));
        let listener = self.bind_listener()?;
        self.run_until_stop(listener, stop, received, stored, failed)
    }

    pub fn spawn_background(&self) -> Result<BackgroundStorageScp> {
        let stop_flag = Arc::new(AtomicBool::new(false));
        let received = Arc::new(AtomicU32::new(0));
        let stored = Arc::new(AtomicU32::new(0));
        let failed = Arc::new(AtomicU32::new(0));
        let listener = self.bind_listener()?;
        let port = listener
            .local_addr()
            .context("reading storage SCP listener port")?
            .port();
        let server = self.clone();
        let thread_stop = stop_flag.clone();
        let thread_received = received.clone();
        let thread_stored = stored.clone();
        let thread_failed = failed.clone();
        let join_handle = std::thread::spawn(move || {
            server.run_until_stop(
                listener,
                thread_stop,
                thread_received,
                thread_stored,
                thread_failed,
            )
        });
        Ok(BackgroundStorageScp {
            stop_flag,
            received,
            stored,
            failed,
            port,
            join_handle: Some(join_handle),
        })
    }

    fn bind_listener(&self) -> Result<TcpListener> {
        let addr = self.config.storage_socket_addr();
        let listener = TcpListener::bind(&addr).with_context(|| {
            format!(
                "binding storage SCP at {} for AE {}. Another local DICOM receiver may already be using that port. Update storage_scp_port in {} or stop the conflicting listener",
                addr,
                self.config.local_ae_title,
                self.paths.config_json.display()
            )
        })?;
        listener
            .set_nonblocking(true)
            .context("setting listener nonblocking mode")?;
        Ok(listener)
    }

    fn run_until_stop(
        &self,
        listener: TcpListener,
        stop_flag: Arc<AtomicBool>,
        received: Arc<AtomicU32>,
        stored: Arc<AtomicU32>,
        failed: Arc<AtomicU32>,
    ) -> Result<()> {
        while !stop_flag.load(Ordering::Relaxed) {
            match listener.accept() {
                Ok((stream, _addr)) => {
                    stream
                        .set_nonblocking(false)
                        .context("setting accepted storage socket to blocking mode")?;
                    let server = self.clone();
                    let connection_received = received.clone();
                    let connection_stored = stored.clone();
                    let connection_failed = failed.clone();
                    std::thread::spawn(move || {
                        if let Err(err) = server.handle_connection(
                            stream,
                            connection_received,
                            connection_stored,
                            connection_failed,
                        ) {
                            error!("storage SCP connection failed: {err:#}");
                        }
                    });
                }
                Err(err) if err.kind() == std::io::ErrorKind::WouldBlock => {
                    std::thread::sleep(Duration::from_millis(100));
                }
                Err(err) => return Err(err.into()),
            }
        }

        Ok(())
    }

    fn handle_connection(
        &self,
        stream: TcpStream,
        received: Arc<AtomicU32>,
        stored: Arc<AtomicU32>,
        failed: Arc<AtomicU32>,
    ) -> Result<()> {
        let mut options = ServerAssociationOptions::new()
            .accept_called_ae_title()
            .ae_title(self.config.local_ae_title.clone())
            .strict(self.config.strict_pdu)
            .max_pdu_length(self.config.max_pdu_length)
            .promiscuous(self.config.allow_promiscuous_storage)
            .read_timeout(Duration::from_secs(60))
            .write_timeout(Duration::from_secs(60));

        for ts in all_supported_transfer_syntaxes() {
            options = options.with_transfer_syntax(ts);
        }
        for abstract_syntax in STORAGE_ABSTRACT_SYNTAXES {
            options = options.with_abstract_syntax(*abstract_syntax);
        }

        let mut association = options
            .establish(stream)
            .context("establishing storage SCP association")?;
        let peer_ae_title = association.peer_ae_title().to_string();
        info!(
            "accepted storage association from {} with {} negotiated presentation contexts",
            peer_ae_title,
            association.presentation_contexts().len()
        );

        let mut command_buffer = Vec::new();
        let mut dataset_buffer = Vec::new();
        let mut accumulated_bytes: u64 = 0;
        let mut current_store: Option<CurrentStoreCommand> = None;

        loop {
            match association.receive() {
                Ok(Pdu::PData { data }) => {
                    for value in data {
                        match value.value_type {
                            PDataValueType::Command => {
                                command_buffer.extend_from_slice(&value.data);
                                if value.is_last {
                                    let command =
                                        AssociationFactory::read_command_dataset(&command_buffer)?;
                                    command_buffer.clear();

                                    let command_field =
                                        read_u16_opt_from_mem(&command, tags::COMMAND_FIELD)
                                            .ok_or_else(|| anyhow!("missing command field"))?;

                                    match command_field {
                                        0x0030 => {
                                            let message_id =
                                                read_u16_opt_from_mem(&command, tags::MESSAGE_ID)
                                                    .ok_or_else(|| {
                                                    anyhow!("missing C-ECHO message id")
                                                })?;
                                            let response = create_echo_response(message_id, 0x0000);
                                            let response_bytes =
                                                AssociationFactory::write_command_dataset(
                                                    &response,
                                                )?;
                                            association.send(&Pdu::PData {
                                                data: vec![PDataValue {
                                                    presentation_context_id: value
                                                        .presentation_context_id,
                                                    value_type: PDataValueType::Command,
                                                    is_last: true,
                                                    data: response_bytes,
                                                }],
                                            })?;
                                        }
                                        0x0001 => {
                                            let message_id =
                                                read_u16_opt_from_mem(&command, tags::MESSAGE_ID)
                                                    .ok_or_else(|| {
                                                    anyhow!("missing C-STORE message id")
                                                })?;
                                            let sop_class_uid = command
                                                .element(tags::AFFECTED_SOP_CLASS_UID)?
                                                .to_str()?
                                                .trim_end_matches('\0')
                                                .to_string();
                                            let sop_instance_uid = command
                                                .element(tags::AFFECTED_SOP_INSTANCE_UID)?
                                                .to_str()?
                                                .trim_end_matches('\0')
                                                .to_string();

                                            current_store = Some(CurrentStoreCommand {
                                                message_id,
                                                sop_class_uid,
                                                sop_instance_uid,
                                                presentation_context_id: value
                                                    .presentation_context_id,
                                            });
                                            dataset_buffer.clear();
                                            accumulated_bytes = 0;
                                        }
                                        other => {
                                            warn!("unsupported DIMSE command 0x{other:04X}");
                                        }
                                    }
                                }
                            }
                            PDataValueType::Data => {
                                let projected_bytes =
                                    accumulated_bytes.saturating_add(value.data.len() as u64);
                                let max_store_object_bytes = self.config.max_store_object_bytes;

                                if let Some(max_store_object_bytes) = max_store_object_bytes {
                                    if projected_bytes > max_store_object_bytes {
                                        warn!(
                                            "incoming C-STORE dataset exceeded configured limit: {projected_bytes} > {max_store_object_bytes} bytes"
                                        );
                                        if let Some(store_command) = current_store.take() {
                                            received.fetch_add(1, Ordering::Relaxed);
                                            failed.fetch_add(1, Ordering::Relaxed);
                                            error!(
                                                accumulated_bytes,
                                                projected_bytes,
                                                max_store_object_bytes,
                                                "failed to persist incoming object: C-STORE dataset exceeded configured size limit"
                                            );
                                            send_store_response(
                                                &mut association,
                                                &store_command,
                                                0xA700,
                                            )?;
                                        }
                                        dataset_buffer.clear();
                                        return Ok(());
                                    }
                                }

                                accumulated_bytes = projected_bytes;
                                dataset_buffer.extend_from_slice(&value.data);

                                if value.is_last {
                                    if let Some(store_command) = current_store.take() {
                                        received.fetch_add(1, Ordering::Relaxed);
                                        let status = match self.persist_store(
                                            &association,
                                            &store_command,
                                            &dataset_buffer,
                                        ) {
                                            Ok(()) => {
                                                stored.fetch_add(1, Ordering::Relaxed);
                                                0x0000
                                            }
                                            Err(err) => {
                                                failed.fetch_add(1, Ordering::Relaxed);
                                                error!(
                                                    "failed to persist incoming object: {err:#}"
                                                );
                                                0xA700
                                            }
                                        };

                                        dataset_buffer.clear();
                                        accumulated_bytes = 0;

                                        send_store_response(
                                            &mut association,
                                            &store_command,
                                            status,
                                        )?;
                                    } else {
                                        dataset_buffer.clear();
                                        accumulated_bytes = 0;
                                    }
                                }
                            }
                        }
                    }
                }
                Ok(Pdu::ReleaseRQ) => {
                    association.send(&Pdu::ReleaseRP)?;
                    break;
                }
                Ok(Pdu::AbortRQ { source }) => {
                    warn!(
                        "peer {} aborted storage association: {:?}",
                        peer_ae_title, source
                    );
                    break;
                }
                Ok(Pdu::ReleaseRP) => break,
                Ok(_) => {}
                Err(err) => {
                    warn!("storage association error from {}: {err:#}", peer_ae_title);
                    break;
                }
            }
        }

        Ok(())
    }

    fn persist_store(
        &self,
        association: &dicom_ul::association::ServerAssociation<TcpStream>,
        store_command: &CurrentStoreCommand,
        dataset_bytes: &[u8],
    ) -> Result<()> {
        let context = association
            .presentation_contexts()
            .iter()
            .find(|pc| pc.id == store_command.presentation_context_id)
            .ok_or_else(|| anyhow!("missing negotiated presentation context"))?;

        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| anyhow!("unsupported negotiated transfer syntax"))?;

        let obj = DefaultMemObject::read_dataset_with_ts(dataset_bytes, transfer_syntax)
            .context("reading incoming C-STORE dataset")?;

        let study_uid = obj
            .element(tags::STUDY_INSTANCE_UID)?
            .to_str()?
            .trim_end_matches('\0')
            .to_string();
        let series_uid = obj
            .element(tags::SERIES_INSTANCE_UID)?
            .to_str()?
            .trim_end_matches('\0')
            .to_string();

        let managed_path = managed_file_path(
            &self.paths.managed_store_dir,
            &study_uid,
            &series_uid,
            &store_command.sop_instance_uid,
        );

        if let Some(parent) = managed_path.parent() {
            fs::create_dir_all(parent).with_context(|| format!("creating {}", parent.display()))?;
        }

        let meta = FileMetaTableBuilder::new()
            .media_storage_sop_class_uid(&store_command.sop_class_uid)
            .media_storage_sop_instance_uid(&store_command.sop_instance_uid)
            .transfer_syntax(&context.transfer_syntax)
            .build()
            .context("building file meta table")?;

        let file_obj = obj.with_exact_meta(meta);
        let file = fs::File::create(&managed_path)
            .with_context(|| format!("creating {}", managed_path.display()))?;
        let writer = BufWriter::new(file);
        let mut hashing_writer = HashingWriter::new(writer);
        file_obj
            .write_all(&mut hashing_writer)
            .with_context(|| format!("writing {}", managed_path.display()))?;
        hashing_writer
            .flush()
            .with_context(|| format!("flushing {}", managed_path.display()))?;
        let (sha256, file_size_bytes) = hashing_writer.finalize();

        let indexed_obj = OpenFileOptions::new()
            .read_until(tags::PIXEL_DATA)
            .open_file(&managed_path)
            .with_context(|| format!("opening {}", managed_path.display()))?;

        let instance = extract_local_instance(
            &indexed_obj,
            format!(
                "network://{}@{}",
                association.peer_ae_title(),
                now_utc_string()
            ),
            &managed_path,
            sha256,
            file_size_bytes,
            Some(now_utc_string()),
        )?;

        self.db.upsert_instance(&instance)?;
        Ok(())
    }
}

fn send_store_response(
    association: &mut dicom_ul::association::ServerAssociation<TcpStream>,
    store_command: &CurrentStoreCommand,
    status: u16,
) -> Result<()> {
    let response = create_store_response(
        store_command.message_id,
        &store_command.sop_class_uid,
        &store_command.sop_instance_uid,
        status,
    );
    let response_bytes = AssociationFactory::write_command_dataset(&response)?;
    association.send(&Pdu::PData {
        data: vec![PDataValue {
            presentation_context_id: store_command.presentation_context_id,
            value_type: PDataValueType::Command,
            is_last: true,
            data: response_bytes,
        }],
    })?;
    Ok(())
}

struct HashingWriter<W> {
    inner: W,
    hasher: Sha256,
    bytes_written: u64,
}

impl<W> HashingWriter<W> {
    fn new(inner: W) -> Self {
        Self {
            inner,
            hasher: Sha256::new(),
            bytes_written: 0,
        }
    }
}

impl<W: Write> HashingWriter<W> {
    fn finalize(self) -> (String, u64) {
        (format!("{:x}", self.hasher.finalize()), self.bytes_written)
    }
}

impl<W: Write> Write for HashingWriter<W> {
    fn write(&mut self, buf: &[u8]) -> io::Result<usize> {
        let bytes_written = self.inner.write(buf)?;
        self.hasher.update(&buf[..bytes_written]);
        self.bytes_written = self.bytes_written.saturating_add(bytes_written as u64);
        Ok(bytes_written)
    }

    fn flush(&mut self) -> io::Result<()> {
        self.inner.flush()
    }
}

impl BackgroundStorageScp {
    pub fn port(&self) -> u16 {
        self.port
    }

    pub fn stop(mut self) -> Result<ScpSessionReport> {
        self.stop_flag.store(true, Ordering::Relaxed);
        if let Some(join_handle) = self.join_handle.take() {
            match join_handle.join() {
                Ok(result) => result?,
                Err(_) => return Err(anyhow!("storage SCP thread panicked")),
            }
        }
        Ok(ScpSessionReport {
            received: self.received.load(Ordering::Relaxed),
            stored: self.stored.load(Ordering::Relaxed),
            failed: self.failed.load(Ordering::Relaxed),
        })
    }
}

#[cfg(test)]
mod tests {
    use super::StorageScpServer;
    use crate::{
        config::{AppConfig, AppPaths, RECOMMENDED_MAX_PDU_LENGTH},
        db::Database,
    };
    use std::{
        fs,
        net::TcpListener,
        process,
        time::{SystemTime, UNIX_EPOCH},
    };

    fn temp_paths() -> AppPaths {
        let unique = format!(
            "dicom-node-client-test-{}-{}",
            process::id(),
            SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .expect("system clock before unix epoch")
                .as_nanos()
        );
        let base_dir = std::env::temp_dir().join(unique);
        AppPaths {
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("app.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
            base_dir,
        }
    }

    #[test]
    fn spawn_background_fails_when_port_is_in_use() {
        let occupied = TcpListener::bind("127.0.0.1:0").expect("bind test port");
        let port = occupied
            .local_addr()
            .expect("read occupied listener addr")
            .port();

        let paths = temp_paths();
        paths.ensure().expect("create temp paths");
        let db = Database::open(&paths.sqlite_db).expect("open temp db");
        let config = AppConfig {
            local_ae_title: "TESTAE".to_string(),
            storage_bind_addr: "127.0.0.1".to_string(),
            storage_scp_port: port,
            max_pdu_length: RECOMMENDED_MAX_PDU_LENGTH,
            strict_pdu: true,
            allow_promiscuous_storage: false,
            preferred_store_transfer_syntax: crate::config::StoreTransferSyntaxPreference::default(
            ),
            ..AppConfig::default()
        };
        let server = StorageScpServer::new(config, paths.clone(), db);

        let err = server.spawn_background().unwrap_err();
        assert!(err
            .to_string()
            .contains(&format!("binding storage SCP at 127.0.0.1:{port}")));

        let _ = fs::remove_dir_all(paths.base_dir);
    }
}
