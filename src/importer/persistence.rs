use std::{fs, path::Path};

use anyhow::Context;
use dicom_dictionary_std::tags;

use crate::{
    config::now_utc_string,
    dicom::{extract_local_instance, managed_file_path, DefaultFileObject},
    models::ImportReport,
};

use super::{
    staging::{replace_file, sha256_hex, FileCleanupGuard},
    Importer,
};

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
        let staged_cleanup = FileCleanupGuard::new(staged_path);
        let study_instance_uid = crate::dicom::required_str(&file_obj, tags::STUDY_INSTANCE_UID)
            .map_err(StoreDicomError::InvalidDicom)?;
        let series_instance_uid = crate::dicom::required_str(&file_obj, tags::SERIES_INSTANCE_UID)
            .map_err(StoreDicomError::InvalidDicom)?;
        let sop_instance_uid = file_obj.meta().media_storage_sop_instance_uid().to_string();

        let managed_path = managed_file_path(
            &self.paths.managed_store_dir,
            &study_instance_uid,
            &series_instance_uid,
            &sop_instance_uid,
        );

        if let Some(parent) = managed_path.parent() {
            fs::create_dir_all(parent)
                .with_context(|| format!("creating {}", parent.display()))
                .map_err(StoreDicomError::Fatal)?;
        }

        if self
            .db
            .instance_exists(&sop_instance_uid, &sha256)
            .map_err(StoreDicomError::Fatal)?
        {
            report.duplicates += 1;
            return Ok(());
        }

        replace_file(staged_cleanup.path(), &managed_path).map_err(StoreDicomError::Fatal)?;
        staged_cleanup.disarm();
        let managed_cleanup = FileCleanupGuard::new(&managed_path);

        let imported_at = now_utc_string();
        let instance = extract_local_instance(
            &file_obj,
            source_path,
            &managed_path,
            sha256,
            file_size_bytes,
            Some(imported_at),
        )
        .map_err(StoreDicomError::InvalidDicom)?;

        self.db
            .upsert_instance(&instance)
            .map_err(StoreDicomError::Fatal)?;
        managed_cleanup.disarm();
        report.accepted += 1;
        report.stored_bytes += file_size_bytes;
        Ok(())
    }

    pub(super) fn store_valid_dicom_bytes(
        &self,
        file_obj: DefaultFileObject,
        raw_bytes: Vec<u8>,
        source_path: String,
        report: &mut ImportReport,
    ) -> StoreDicomResult<()> {
        let sha256 = sha256_hex(&raw_bytes);
        let study_instance_uid = crate::dicom::required_str(&file_obj, tags::STUDY_INSTANCE_UID)
            .map_err(StoreDicomError::InvalidDicom)?;
        let series_instance_uid = crate::dicom::required_str(&file_obj, tags::SERIES_INSTANCE_UID)
            .map_err(StoreDicomError::InvalidDicom)?;
        let sop_instance_uid = file_obj.meta().media_storage_sop_instance_uid().to_string();

        if self
            .db
            .instance_exists(&sop_instance_uid, &sha256)
            .map_err(StoreDicomError::Fatal)?
        {
            report.duplicates += 1;
            return Ok(());
        }

        let managed_path = managed_file_path(
            &self.paths.managed_store_dir,
            &study_instance_uid,
            &series_instance_uid,
            &sop_instance_uid,
        );

        if let Some(parent) = managed_path.parent() {
            fs::create_dir_all(parent)
                .with_context(|| format!("creating {}", parent.display()))
                .map_err(StoreDicomError::Fatal)?;
        }

        let managed_cleanup = FileCleanupGuard::new(&managed_path);
        fs::write(&managed_path, &raw_bytes)
            .with_context(|| format!("writing {}", managed_path.display()))
            .map_err(StoreDicomError::Fatal)?;

        let imported_at = now_utc_string();
        let instance = extract_local_instance(
            &file_obj,
            source_path,
            &managed_path,
            sha256,
            raw_bytes.len() as u64,
            Some(imported_at),
        )
        .map_err(StoreDicomError::InvalidDicom)?;

        self.db
            .upsert_instance(&instance)
            .map_err(StoreDicomError::Fatal)?;
        managed_cleanup.disarm();
        report.accepted += 1;
        report.stored_bytes += raw_bytes.len() as u64;
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use std::fs;

    use crate::config::AppConfig;

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
}
