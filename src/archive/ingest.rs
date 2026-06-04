use std::path::PathBuf;

use anyhow::Context;
use dicom_dictionary_std::tags;

use crate::{
    config::{now_utc_string, AppPaths},
    db::{Database, InstanceImportStatements},
    dicom::{extract_local_instance, managed_file_path, required_str, DefaultFileObject},
    importer::staging::{replace_file, FileCleanupGuard},
};

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ArchiveIngestStatus {
    Created,
    Duplicate {
        reason: crate::models::DuplicateReason,
    },
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ArchiveIngestResult {
    pub status: ArchiveIngestStatus,
    pub bytes_stored: u64,
    pub study_instance_uid: String,
    pub series_instance_uid: String,
    pub sop_instance_uid: String,
    pub managed_path: PathBuf,
}

#[derive(Debug)]
pub struct ArchiveIngestRequest {
    pub staged_path: PathBuf,
    pub sha256: String,
    pub file_size_bytes: u64,
    pub file_obj: DefaultFileObject,
    pub source_path: String,
    pub imported_at: Option<String>,
}

#[derive(Debug)]
pub enum ArchiveIngestError {
    InvalidDicom(anyhow::Error),
    Fatal(anyhow::Error),
}

pub type ArchiveIngestOutcome<T> = std::result::Result<T, ArchiveIngestError>;

#[derive(Debug, Clone)]
pub struct ArchiveIngestService {
    paths: AppPaths,
}

impl ArchiveIngestService {
    pub fn new(paths: AppPaths) -> Self {
        Self { paths }
    }

    pub(crate) fn ingest_staged_part10_in_conn(
        &self,
        conn: &rusqlite::Connection,
        stmts: &mut InstanceImportStatements<'_>,
        request: ArchiveIngestRequest,
    ) -> ArchiveIngestOutcome<(ArchiveIngestResult, Option<FileCleanupGuard>)> {
        debug_assert!(!conn.is_autocommit());

        let staged_cleanup = FileCleanupGuard::new(&request.staged_path);
        let study_instance_uid = required_str(&request.file_obj, tags::STUDY_INSTANCE_UID)
            .map_err(ArchiveIngestError::InvalidDicom)?;
        let series_instance_uid = required_str(&request.file_obj, tags::SERIES_INSTANCE_UID)
            .map_err(ArchiveIngestError::InvalidDicom)?;
        let sop_instance_uid = request
            .file_obj
            .meta()
            .media_storage_sop_instance_uid()
            .to_string();
        let managed_path = managed_file_path(
            &self.paths.managed_store_dir,
            &study_instance_uid,
            &series_instance_uid,
            &sop_instance_uid,
        );

        if let Some(parent) = managed_path.parent() {
            std::fs::create_dir_all(parent)
                .with_context(|| format!("creating {}", parent.display()))
                .map_err(ArchiveIngestError::Fatal)?;
        }

        if let Some(reason) = Database::instance_duplicate_reason_with_statements(
            stmts,
            &sop_instance_uid,
            &request.sha256,
        )
        .map_err(ArchiveIngestError::Fatal)?
        {
            return Ok((
                ArchiveIngestResult {
                    status: ArchiveIngestStatus::Duplicate { reason },
                    bytes_stored: 0,
                    study_instance_uid,
                    series_instance_uid,
                    sop_instance_uid,
                    managed_path,
                },
                None,
            ));
        }

        replace_file(staged_cleanup.path(), &managed_path).map_err(ArchiveIngestError::Fatal)?;
        staged_cleanup.disarm();
        let managed_cleanup = FileCleanupGuard::new(&managed_path);
        let imported_at = request.imported_at.unwrap_or_else(now_utc_string);
        let instance = extract_local_instance(
            &request.file_obj,
            request.source_path,
            &managed_path,
            request.sha256,
            request.file_size_bytes,
            Some(imported_at),
        )
        .map_err(ArchiveIngestError::InvalidDicom)?;

        Database::upsert_instance_with_statements(stmts, &instance)
            .map_err(ArchiveIngestError::Fatal)?;

        Ok((
            ArchiveIngestResult {
                status: ArchiveIngestStatus::Created,
                bytes_stored: request.file_size_bytes,
                study_instance_uid,
                series_instance_uid,
                sop_instance_uid,
                managed_path,
            },
            Some(managed_cleanup),
        ))
    }
}

#[cfg(test)]
mod tests {
    use std::{fs, path::Path};

    use dicom_dictionary_std::tags;
    use dicom_object::OpenFileOptions;
    use walkdir::WalkDir;

    use crate::{
        config::AppPaths, db::Database, importer::test_support::write_valid_dicom_with_pixel_data,
    };

    use super::{ArchiveIngestRequest, ArchiveIngestService};

    fn temp_paths(root: &Path) -> AppPaths {
        let base_dir = root.join("app");
        AppPaths {
            base_dir: base_dir.clone(),
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("rusty-dicom-node.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
            active_log_file: base_dir.join("logs").join("app.log"),
        }
    }

    #[test]
    fn catalog_failure_after_final_write_removes_final_object() {
        let root = tempfile::tempdir().expect("tempdir");
        let paths = temp_paths(root.path());
        paths.ensure().expect("create app paths");
        let db = Database::open(&paths.sqlite_db).expect("open db");
        let staged_path = root.path().join("staged.dcm");
        write_valid_dicom_with_pixel_data(&staged_path, "1.2.826.0.1.3680043.10.999.80");
        let file_size_bytes = fs::metadata(&staged_path).expect("metadata").len();
        let file_obj = OpenFileOptions::new()
            .read_until(tags::PIXEL_DATA)
            .open_file(&staged_path)
            .expect("open staged DICOM");
        let service = ArchiveIngestService::new(paths.clone());

        db.with_transaction(|conn| {
            conn.execute("DROP TABLE instances", [])
                .expect("force catalog failure");
            let mut stmts = crate::db::InstanceImportStatements::prepare(conn)?;
            service
                .ingest_staged_part10_in_conn(
                    conn,
                    &mut stmts,
                    ArchiveIngestRequest {
                        staged_path: staged_path.clone(),
                        sha256: "sha256-forced".to_string(),
                        file_size_bytes,
                        file_obj,
                        source_path: staged_path.display().to_string(),
                        imported_at: Some("2026-06-04T00:00:00Z".to_string()),
                    },
                )
                .expect_err("catalog failure should propagate");
            Ok(())
        })
        .expect("transaction completes after handled failure");

        assert!(
            managed_files(&paths.managed_store_dir).is_empty(),
            "expected no managed files after catalog failure"
        );
        assert!(
            !staged_path.exists(),
            "expected staged input to be removed after catalog failure"
        );
    }

    fn managed_files(managed_store_dir: &Path) -> Vec<std::path::PathBuf> {
        WalkDir::new(managed_store_dir)
            .into_iter()
            .filter_map(|entry| entry.ok())
            .filter(|entry| entry.file_type().is_file())
            .map(|entry| entry.into_path())
            .collect()
    }
}
