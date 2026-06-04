use std::path::Path;

use crate::{
    archive::{
        ArchiveIngestError, ArchiveIngestRequest, ArchiveIngestService, ArchiveIngestStatus,
    },
    config::now_utc_string,
    db::InstanceImportStatements,
    dicom::DefaultFileObject,
    models::ImportReport,
};

use rusqlite::Connection;

use super::{staging::FileCleanupGuard, Importer};

pub(super) type StoreDicomResult<T> = std::result::Result<T, StoreDicomError>;

#[derive(Debug)]
pub(super) enum StoreDicomError {
    InvalidDicom(anyhow::Error),
    Fatal(anyhow::Error),
}

impl Importer {
    pub(super) fn store_valid_dicom_file(
        &self,
        staged_path: &Path,
        sha256: String,
        file_size_bytes: u64,
        file_obj: DefaultFileObject,
        source_path: String,
        report: &mut ImportReport,
    ) -> StoreDicomResult<()> {
        let managed_cleanup = match self.db.with_transaction(|conn| {
            let mut stmts = InstanceImportStatements::prepare(conn)?;
            Ok(self.store_valid_dicom_file_in_conn(
                conn,
                &mut stmts,
                staged_path,
                sha256,
                file_size_bytes,
                file_obj,
                source_path,
                report,
            ))
        }) {
            Ok(result) => result,
            Err(err) => Err(StoreDicomError::Fatal(err)),
        }?;
        if let Some(managed_cleanup) = managed_cleanup {
            managed_cleanup.disarm();
        }
        Ok(())
    }

    #[allow(clippy::too_many_arguments)]
    pub(super) fn store_valid_dicom_file_in_conn(
        &self,
        conn: &Connection,
        stmts: &mut InstanceImportStatements<'_>,
        staged_path: &Path,
        sha256: String,
        file_size_bytes: u64,
        file_obj: DefaultFileObject,
        source_path: String,
        report: &mut ImportReport,
    ) -> StoreDicomResult<Option<FileCleanupGuard>> {
        debug_assert!(!conn.is_autocommit());
        let service = ArchiveIngestService::new(self.paths.clone());
        let (result, managed_cleanup) = service
            .ingest_staged_part10_in_conn(
                conn,
                stmts,
                ArchiveIngestRequest {
                    staged_path: staged_path.to_path_buf(),
                    sha256,
                    file_size_bytes,
                    file_obj,
                    source_path,
                    imported_at: Some(now_utc_string()),
                },
            )
            .map_err(|err| match err {
                ArchiveIngestError::InvalidDicom(err) => StoreDicomError::InvalidDicom(err),
                ArchiveIngestError::Fatal(err) => StoreDicomError::Fatal(err),
            })?;

        match result.status {
            ArchiveIngestStatus::Created => {
                report.accepted += 1;
                report.stored_bytes += result.bytes_stored;
            }
            ArchiveIngestStatus::Duplicate { reason } => {
                match reason {
                    crate::models::DuplicateReason::SopInstanceUid => {
                        report.duplicate_by_sop_instance_uid += 1;
                    }
                    crate::models::DuplicateReason::Sha256 => {
                        report.duplicate_by_sha256 += 1;
                    }
                    crate::models::DuplicateReason::SopInstanceUidAndSha256 => {
                        report.duplicate_by_sop_instance_uid += 1;
                        report.duplicate_by_sha256 += 1;
                    }
                }
                report.duplicates += 1;
            }
        }
        Ok(managed_cleanup)
    }
}

#[cfg(test)]
mod tests {
    use std::{
        fs,
        io::Cursor,
        path::{Path, PathBuf},
    };

    use anyhow::anyhow;
    use dicom_dictionary_std::tags;
    use dicom_object::OpenFileOptions;
    use walkdir::WalkDir;

    use crate::{
        config::AppConfig, db::InstanceImportStatements, dicom::DefaultFileObject,
        models::ImportReport,
    };

    use super::super::test_support::{
        dicom_bytes_missing_required_uids, staged_files, test_importer,
        write_valid_dicom_with_pixel_data,
    };

    #[test]
    fn import_file_reports_store_validation_failures_per_file() {
        let (root, importer) = test_importer(AppConfig::default());
        let dicom_path = root.path().join("missing-required-uids.dcm");
        let dicom_bytes = dicom_bytes_missing_required_uids(&root);
        fs::write(&dicom_path, dicom_bytes).expect("write import candidate");

        let report = importer.import_path(&dicom_path).expect("import file");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 0);
        assert_eq!(report.invalid_dicom, 1);
        assert!(report.failures.iter().any(|failure| {
            failure.contains("DICOM validation failed")
                && failure.contains("required DICOM attribute missing")
        }));
        assert!(
            staged_files(&importer).is_empty(),
            "expected no staged files after validation failure"
        );
    }

    #[test]
    fn import_file_duplicate_cleans_up_staged_copy() {
        let (root, importer) = test_importer(AppConfig::default());
        let dicom_path = root.path().join("valid-with-pixel-data.dcm");
        write_valid_dicom_with_pixel_data(&dicom_path, "1.2.826.0.1.3680043.10.999.4");

        let first_report = importer.import_path(&dicom_path).expect("first import");
        assert_eq!(first_report.accepted, 1);
        assert_eq!(first_report.duplicates, 0);

        let second_report = importer.import_path(&dicom_path).expect("second import");
        assert_eq!(second_report.accepted, 0);
        assert_eq!(second_report.duplicates, 1);

        assert!(
            staged_files(&importer).is_empty(),
            "expected no staged files after duplicate import"
        );
    }

    #[test]
    fn rollback_removes_file_moved_into_managed_store() {
        let (root, importer) = test_importer(AppConfig::default());
        let staged_path = root.path().join("staged.dcm");
        write_valid_dicom_with_pixel_data(&staged_path, "1.2.826.0.1.3680043.10.999.5");
        let file_obj = OpenFileOptions::new()
            .read_until(tags::PIXEL_DATA)
            .open_file(&staged_path)
            .expect("open staged DICOM");

        importer
            .db
            .with_transaction(|conn| {
                let mut stmts = InstanceImportStatements::prepare(conn)?;
                let mut report = ImportReport::default();
                let _managed_cleanup = importer
                    .store_valid_dicom_file_in_conn(
                        conn,
                        &mut stmts,
                        &staged_path,
                        "ignored-by-store_valid_dicom_file_in_conn".to_string(),
                        fs::metadata(&staged_path).expect("staged metadata").len(),
                        file_obj,
                        staged_path.display().to_string(),
                        &mut report,
                    )
                    .expect("store DICOM")
                    .expect("accepted DICOM");

                assert_eq!(managed_files(&importer.paths.managed_store_dir).len(), 1);
                Err::<(), anyhow::Error>(anyhow!("force rollback"))
            })
            .expect_err("rollback transaction");

        assert!(
            managed_files(&importer.paths.managed_store_dir).is_empty(),
            "expected managed file to be removed when transaction rolls back"
        );
    }

    #[test]
    fn rollback_removes_file_moved_into_managed_store_for_zip_source() {
        let (root, importer) = test_importer(AppConfig::default());
        let staged_path = root.path().join("entry.dcm");
        write_valid_dicom_with_pixel_data(&staged_path, "1.2.826.0.1.3680043.10.999.6");
        let staged_bytes = fs::read(&staged_path).expect("read staged bytes");
        let file_obj =
            DefaultFileObject::from_reader(Cursor::new(&staged_bytes[..])).expect("parse DICOM");

        importer
            .db
            .with_transaction(|conn| {
                let mut stmts = InstanceImportStatements::prepare(conn)?;
                let mut report = ImportReport::default();
                let _managed_cleanup = importer
                    .store_valid_dicom_file_in_conn(
                        conn,
                        &mut stmts,
                        &staged_path,
                        "ignored-by-store_valid_dicom_file_in_conn".to_string(),
                        staged_bytes.len() as u64,
                        file_obj,
                        "zip://test.zip!entry.dcm".to_string(),
                        &mut report,
                    )
                    .expect("store DICOM")
                    .expect("accepted DICOM");

                assert_eq!(managed_files(&importer.paths.managed_store_dir).len(), 1);
                Err::<(), anyhow::Error>(anyhow!("force rollback"))
            })
            .expect_err("rollback transaction");

        assert!(
            managed_files(&importer.paths.managed_store_dir).is_empty(),
            "expected managed file to be removed when transaction rolls back"
        );
    }

    fn managed_files(managed_store_dir: &Path) -> Vec<PathBuf> {
        WalkDir::new(managed_store_dir)
            .into_iter()
            .filter_map(|entry| entry.ok())
            .filter(|entry| entry.file_type().is_file())
            .filter(|entry| !entry.file_name().to_string_lossy().ends_with(".tmp"))
            .map(|entry| entry.into_path())
            .collect()
    }
}
