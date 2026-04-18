mod persistence;
mod staging;
mod traversal;

use std::{fs, path::Path};

use anyhow::anyhow;
use dicom_dictionary_std::tags;
use dicom_object::OpenFileOptions;

use crate::{
    config::{AppConfig, AppPaths},
    db::Database,
    error::Result,
    models::ImportReport,
};

use persistence::StoreDicomError;
use staging::{remove_file_if_exists, stage_reader_with_sha256};
use traversal::{
    is_zip_path, record_invalid_dicom_with_warning, record_unreadable_with_warning,
    regular_file_metadata, validate_readable_dir, validate_readable_file,
};

#[derive(Debug, Clone)]
pub struct Importer {
    pub paths: AppPaths,
    pub config: AppConfig,
    pub db: Database,
}

impl Importer {
    pub fn new(paths: AppPaths, config: AppConfig, db: Database) -> Self {
        Self { paths, config, db }
    }

    pub fn import_path(&self, path: &Path) -> Result<ImportReport> {
        if !path.exists() {
            return Err(anyhow!("Import path does not exist: {}", path.display()));
        }

        if path.is_dir() {
            validate_readable_dir(path)?;
            self.import_folder(path)
        } else if is_zip_path(path) {
            validate_readable_file(path, "ZIP import file")?;
            self.import_zip(path)
        } else {
            validate_readable_file(path, "import file")?;
            let mut report = ImportReport::default();
            self.import_file_candidate(path, &mut report)?;
            Ok(report)
        }
    }

    fn import_file_candidate(&self, path: &Path, report: &mut ImportReport) -> Result<()> {
        report.scanned_files += 1;

        let metadata = match regular_file_metadata(path) {
            Ok(metadata) => metadata,
            Err(err) => {
                record_unreadable_with_warning(report, path.display(), err);
                return Ok(());
            }
        };
        let file_size = metadata.len();
        if let Some(max_file_import_bytes) = self.config.max_file_import_bytes {
            if file_size > max_file_import_bytes {
                record_unreadable_with_warning(
                    report,
                    path.display(),
                    format!("file too large: {file_size} > {max_file_import_bytes}"),
                );
                return Ok(());
            }
        }

        let file = match fs::File::open(path) {
            Ok(file) => file,
            Err(err) => {
                record_unreadable_with_warning(
                    report,
                    path.display(),
                    format!("opening file: {err}"),
                );
                return Ok(());
            }
        };

        // Snapshot the source first so validation and payload persistence operate on the
        // exact same bytes even if the original file changes during import.
        let (staged_path, sha256, file_size_bytes) = match stage_reader_with_sha256(
            file,
            &self.paths.managed_store_dir,
            path,
            self.config.max_file_import_bytes,
        ) {
            Ok(staged) => staged,
            Err(err) => {
                record_unreadable_with_warning(
                    report,
                    path.display(),
                    format!("reading file: {err}"),
                );
                return Ok(());
            }
        };

        let file_obj = match OpenFileOptions::new()
            .read_until(tags::PIXEL_DATA)
            .open_file(&staged_path)
        {
            Ok(file_obj) => file_obj,
            Err(err) => {
                let _ = remove_file_if_exists(&staged_path);
                record_invalid_dicom_with_warning(
                    report,
                    path.display(),
                    format!("DICOM parse failed: {err}"),
                );
                return Ok(());
            }
        };
        let source_path = path.to_string_lossy().to_string();
        if let Err(err) = self.store_valid_dicom_file(
            staged_path.as_path(),
            sha256,
            file_size_bytes,
            file_obj,
            source_path.clone(),
            report,
        ) {
            match err {
                StoreDicomError::InvalidDicom(err) => {
                    record_invalid_dicom_with_warning(
                        report,
                        source_path,
                        format!("DICOM validation failed: {err}"),
                    );
                    return Ok(());
                }
                StoreDicomError::Fatal(err) => return Err(err),
            }
        }
        Ok(())
    }
}

#[cfg(test)]
mod test_support {
    use dicom_core::{DataElement, PrimitiveValue, VR};
    use dicom_dictionary_std::{
        tags,
        uids::{CT_IMAGE_STORAGE, EXPLICIT_VR_LITTLE_ENDIAN},
    };
    use dicom_object::{mem::InMemDicomObject, FileMetaTableBuilder};
    use std::{
        fs::{self, File},
        io::Write,
        path::{Path, PathBuf},
    };

    use tempfile::{tempdir, TempDir};
    use walkdir::WalkDir;
    use zip::{write::SimpleFileOptions, ZipWriter};

    use super::Importer;
    use crate::{config::AppConfig, config::AppPaths, db::Database};

    pub(super) fn test_paths(root: &TempDir) -> AppPaths {
        let base_dir = root.path().join("app");
        AppPaths {
            base_dir: base_dir.clone(),
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("app.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
        }
    }

    pub(super) fn test_importer(config: AppConfig) -> (TempDir, Importer) {
        let root = tempdir().expect("create temp dir");
        let paths = test_paths(&root);
        paths.ensure().expect("create app paths");
        let db = Database::open(&paths.sqlite_db).expect("open temp db");
        db.init().expect("init temp db");
        let importer = Importer::new(paths, config, db);
        (root, importer)
    }

    pub(super) fn write_zip(path: &Path, entries: &[(&str, &[u8])]) {
        let file = File::create(path).expect("create test zip");
        let mut zip = ZipWriter::new(file);
        let options = SimpleFileOptions::default();
        for (name, bytes) in entries {
            zip.start_file(name, options).expect("start zip entry");
            zip.write_all(bytes).expect("write zip entry");
        }
        zip.finish().expect("finish zip");
    }

    pub(super) fn write_zip_with_directory(
        path: &Path,
        directory: &str,
        entries: &[(&str, &[u8])],
    ) {
        let file = File::create(path).expect("create test zip");
        let mut zip = ZipWriter::new(file);
        let options = SimpleFileOptions::default();
        zip.add_directory(directory, options)
            .expect("add zip directory");
        for (name, bytes) in entries {
            zip.start_file(name, options).expect("start zip entry");
            zip.write_all(bytes).expect("write zip entry");
        }
        zip.finish().expect("finish zip");
    }

    pub(super) fn zip_path(root: &TempDir) -> PathBuf {
        root.path().join("import.zip")
    }

    pub(super) fn dicom_bytes_missing_required_uids(root: &TempDir) -> Vec<u8> {
        let obj = InMemDicomObject::from_element_iter([DataElement::new(
            tags::PATIENT_NAME,
            VR::PN,
            PrimitiveValue::from("TEST^PATIENT"),
        )]);
        let meta = FileMetaTableBuilder::new()
            .media_storage_sop_class_uid(CT_IMAGE_STORAGE)
            .media_storage_sop_instance_uid("1.2.826.0.1.3680043.10.999.1")
            .transfer_syntax(EXPLICIT_VR_LITTLE_ENDIAN)
            .build()
            .expect("build file meta");
        let path = root.path().join("missing-required-uids.dcm");

        obj.with_exact_meta(meta)
            .write_to_file(&path)
            .expect("write test DICOM");
        fs::read(path).expect("read test DICOM")
    }

    pub(super) fn write_valid_dicom_with_pixel_data(path: &Path, sop_instance_uid: &str) {
        let obj = InMemDicomObject::from_element_iter([
            DataElement::new(
                tags::PATIENT_NAME,
                VR::PN,
                PrimitiveValue::from("TEST^PATIENT"),
            ),
            DataElement::new(
                tags::STUDY_INSTANCE_UID,
                VR::UI,
                PrimitiveValue::from("1.2.826.0.1.3680043.10.999.2"),
            ),
            DataElement::new(
                tags::SERIES_INSTANCE_UID,
                VR::UI,
                PrimitiveValue::from("1.2.826.0.1.3680043.10.999.3"),
            ),
            DataElement::new(tags::MODALITY, VR::CS, PrimitiveValue::from("CT")),
            DataElement::new(
                tags::PIXEL_DATA,
                VR::OB,
                PrimitiveValue::from(vec![0x55_u8; 128]),
            ),
        ]);
        let meta = FileMetaTableBuilder::new()
            .media_storage_sop_class_uid(CT_IMAGE_STORAGE)
            .media_storage_sop_instance_uid(sop_instance_uid)
            .transfer_syntax(EXPLICIT_VR_LITTLE_ENDIAN)
            .build()
            .expect("build file meta");

        obj.with_exact_meta(meta)
            .write_to_file(path)
            .expect("write valid test DICOM");
    }

    pub(super) fn staged_files(importer: &Importer) -> Vec<PathBuf> {
        WalkDir::new(&importer.paths.managed_store_dir)
            .into_iter()
            .filter_map(|entry| entry.ok())
            .filter(|entry| entry.file_type().is_file())
            .filter(|entry| entry.file_name().to_string_lossy().ends_with(".tmp"))
            .map(|entry| entry.into_path())
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use std::fs;

    use crate::config::AppConfig;

    use super::test_support::{staged_files, test_importer};

    #[test]
    fn import_file_skips_candidates_over_size_limit() {
        let config = AppConfig {
            max_file_import_bytes: Some(3),
            ..AppConfig::default()
        };
        let (root, importer) = test_importer(config);
        let file_path = root.path().join("large.bin");
        fs::write(&file_path, b"abcd").expect("write oversized candidate");

        let report = importer.import_path(&file_path).expect("import file");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 0);
        assert_eq!(report.unreadable, 1);
        assert_eq!(report.invalid_dicom, 0);
        assert!(report
            .failures
            .iter()
            .any(|failure| failure.contains("file too large: 4 > 3")));
    }

    #[test]
    fn import_file_parse_failure_cleans_up_staged_copy() {
        let (root, importer) = test_importer(AppConfig::default());
        let file_path = root.path().join("not-dicom.bin");
        fs::write(&file_path, b"not dicom").expect("write invalid import candidate");

        let report = importer.import_path(&file_path).expect("import file");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 0);
        assert_eq!(report.invalid_dicom, 1);
        assert!(
            staged_files(&importer).is_empty(),
            "expected no staged files after parse failure"
        );
    }
}
