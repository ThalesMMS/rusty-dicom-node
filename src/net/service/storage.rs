use std::{
    fs,
    io::{self, BufWriter, Seek, SeekFrom, Write},
    net::TcpStream,
};

use anyhow::{Context, Result};
use dicom_dictionary_std::tags;
use dicom_object::FileMetaTableBuilder;
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::{
    association::{Association, ServerAssociation},
    pdu::{PDataValue, PDataValueType},
    Pdu,
};
use sha2::{Digest, Sha256};

use crate::{
    archive::{ArchiveIngestError, ArchiveIngestRequest, ArchiveIngestService},
    config::{now_utc_string, AppConfig, AppPaths},
    db::Database,
    dicom::{read_u16_opt_from_mem, DefaultMemObject},
    net::{
        assoc::{create_store_response, AssociationFactory},
        metrics::ServerMetrics,
        transfer::STORAGE_ABSTRACT_SYNTAXES,
    },
};

use super::{DimseServiceKind, ServiceProvider};

const STORAGE_COMMAND_FIELDS: &[u16] = &[0x0001];

#[derive(Debug, Clone)]
pub struct StorageProvider {
    config: AppConfig,
    paths: AppPaths,
    db: Database,
    metrics: ServerMetrics,
}

#[derive(Debug, Clone, Copy, Default)]
pub struct StorageProviderDescriptor;

#[derive(Debug, Clone)]
pub struct StoreCommand {
    pub message_id: u16,
    pub sop_class_uid: String,
    pub sop_instance_uid: String,
    pub presentation_context_id: u8,
}

impl StorageProvider {
    pub fn new(config: AppConfig, paths: AppPaths, db: Database) -> Self {
        Self::with_metrics(config, paths, db, ServerMetrics::default())
    }

    pub fn with_metrics(
        config: AppConfig,
        paths: AppPaths,
        db: Database,
        metrics: ServerMetrics,
    ) -> Self {
        Self {
            config,
            paths,
            db,
            metrics,
        }
    }

    pub fn descriptor() -> StorageProviderDescriptor {
        StorageProviderDescriptor
    }

    pub fn max_store_object_bytes(&self) -> Option<u64> {
        self.config.max_store_object_bytes
    }

    pub fn begin_store_command(
        &self,
        command: &DefaultMemObject,
        presentation_context_id: u8,
    ) -> Result<StoreCommand> {
        let message_id = read_u16_opt_from_mem(command, tags::MESSAGE_ID)
            .ok_or_else(|| {
                crate::net::err_with("error-net-missing-message-id", [("operation", "C-STORE")])
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

        Ok(StoreCommand {
            message_id,
            sop_class_uid,
            sop_instance_uid,
            presentation_context_id,
        })
    }

    pub fn persist_store(
        &self,
        association: &ServerAssociation<TcpStream>,
        store_command: &StoreCommand,
        dataset_path: &std::path::Path,
    ) -> Result<()> {
        let context = association
            .presentation_contexts()
            .iter()
            .find(|pc| pc.id == store_command.presentation_context_id)
            .ok_or_else(|| crate::net::err("error-net-no-presentation-context"))?;

        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| crate::net::err("error-net-unsupported-transfer-syntax"))?;

        let mut remove_dataset_on_drop = RemoveFileOnDrop::new(dataset_path);

        let mut dataset_file = fs::File::open(dataset_path)
            .with_context(|| {
                let path = dataset_path.display().to_string();
                crate::error::msg_with("error-net-opening-path", [("path", path.as_str())])
            })?;
        dataset_file
            .seek(SeekFrom::Start(0))
            .context(crate::error::msg("error-net-seeking-temp-dataset"))?;
        let obj = DefaultMemObject::read_dataset_with_ts(&mut dataset_file, transfer_syntax)
            .context(crate::error::msg("error-net-reading-incoming-dataset"))?;

        remove_dataset_on_drop.disarm();

        let meta = FileMetaTableBuilder::new()
            .media_storage_sop_class_uid(&store_command.sop_class_uid)
            .media_storage_sop_instance_uid(&store_command.sop_instance_uid)
            .transfer_syntax(&context.transfer_syntax)
            .build()
            .context(crate::error::msg("error-net-building-file-meta"))?;

        let file_obj = obj.with_exact_meta(meta);

        let staged_path = self.paths.managed_store_dir.join(format!(
            ".store-scp-{}-{}.dcm.partial",
            std::process::id(),
            uuid::Uuid::new_v4()
        ));
        let mut remove_staged_on_drop = RemoveFileOnDrop::new(&staged_path);

        fs::create_dir_all(&self.paths.managed_store_dir)
            .with_context(|| {
                let path = self.paths.managed_store_dir.display().to_string();
                crate::error::msg_with("error-net-creating-path", [("path", path.as_str())])
            })?;
        let file = fs::File::create(&staged_path).with_context(|| {
            let path = staged_path.display().to_string();
            crate::error::msg_with("error-net-creating-path", [("path", path.as_str())])
        })?;
        let writer = BufWriter::new(file);
        let mut hashing_writer = HashingWriter::new(writer);
        file_obj.write_all(&mut hashing_writer).with_context(|| {
            let path = staged_path.display().to_string();
            crate::error::msg_with("error-net-writing-path", [("path", path.as_str())])
        })?;
        hashing_writer.flush().with_context(|| {
            let path = staged_path.display().to_string();
            crate::error::msg_with("error-net-flushing-path", [("path", path.as_str())])
        })?;
        let (sha256, file_size_bytes) = hashing_writer.finalize();

        self.db.with_transaction(|conn| {
            let mut stmts = crate::db::InstanceImportStatements::prepare(conn)?;
            let service = ArchiveIngestService::new(self.paths.clone());
            let (_result, managed_cleanup) = service
                .ingest_staged_part10_in_conn(
                    conn,
                    &mut stmts,
                    ArchiveIngestRequest {
                        staged_path: staged_path.clone(),
                        sha256,
                        file_size_bytes,
                        file_obj,
                        source_path: format!(
                            "network://{}@{}",
                            association.peer_ae_title(),
                            now_utc_string()
                        ),
                        imported_at: Some(now_utc_string()),
                    },
                )
                .map_err(|err| match err {
                    ArchiveIngestError::InvalidDicom(err) => err,
                    ArchiveIngestError::Fatal(err) => err,
                })?;
            if let Some(managed_cleanup) = managed_cleanup {
                managed_cleanup.disarm();
            }
            Ok(())
        })?;
        remove_staged_on_drop.disarm();
        self.metrics.record_archive_ingest_bytes(file_size_bytes);
        Ok(())
    }

    pub fn send_store_response(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        store_command: &StoreCommand,
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
}

impl ServiceProvider for StorageProvider {
    fn kind(&self) -> DimseServiceKind {
        DimseServiceKind::Storage
    }

    fn name(&self) -> &'static str {
        "StorageProvider"
    }

    fn abstract_syntaxes(&self) -> &'static [&'static str] {
        STORAGE_ABSTRACT_SYNTAXES
    }

    fn command_fields(&self) -> &'static [u16] {
        STORAGE_COMMAND_FIELDS
    }
}

impl ServiceProvider for StorageProviderDescriptor {
    fn kind(&self) -> DimseServiceKind {
        DimseServiceKind::Storage
    }

    fn name(&self) -> &'static str {
        "StorageProvider"
    }

    fn abstract_syntaxes(&self) -> &'static [&'static str] {
        STORAGE_ABSTRACT_SYNTAXES
    }

    fn command_fields(&self) -> &'static [u16] {
        STORAGE_COMMAND_FIELDS
    }
}

struct RemoveFileOnDrop {
    path: std::path::PathBuf,
    armed: bool,
}

impl RemoveFileOnDrop {
    fn new(path: &std::path::Path) -> Self {
        Self {
            path: path.to_path_buf(),
            armed: true,
        }
    }

    fn disarm(&mut self) {
        self.armed = false;
    }
}

impl Drop for RemoveFileOnDrop {
    fn drop(&mut self) {
        if self.armed {
            let _ = std::fs::remove_file(&self.path);
        }
    }
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
