use std::{
    fs,
    io::{BufReader, Read},
    path::Path,
    sync::atomic::AtomicBool,
};

use anyhow::{anyhow, Context};
use tracing::warn;
use walkdir::WalkDir;
use zip::ZipArchive;

use crate::{
    cancel,
    config::AppConfig,
    db::InstanceImportStatements,
    dicom::DefaultFileObject,
    error::{ImportRejectionReason, Result},
    models::ImportReport,
};

use super::{staging::stage_reader_with_sha256, Importer};

impl Importer {
    pub fn import_folder(&self, path: &Path) -> Result<ImportReport> {
        self.import_folder_with_cancel(path, None, None)
    }

    pub(super) fn import_folder_with_cancel<'a>(
        &self,
        path: &Path,
        cancel_flag: Option<&AtomicBool>,
        mut progress: Option<&'a mut dyn FnMut(u64, Option<u64>)>,
    ) -> Result<ImportReport> {
        let (report, managed_cleanups) = self.db.with_transaction(|conn| {
            let mut stmts = InstanceImportStatements::prepare(conn)?;
            let mut report = ImportReport::default();
            let mut managed_cleanups = Vec::new();

            let max_total_files = self.config.max_import_total_files;
            let max_depth = self.config.max_import_directory_depth;
            let max_path_len = self.config.max_import_path_length;

            let walker = WalkDir::new(path)
                .follow_links(false)
                .max_depth(max_depth.unwrap_or(usize::MAX));

            for entry in walker {
                cancel::ensure_not_cancelled(cancel_flag)?;
                let entry = match entry {
                    Ok(entry) => entry,
                    Err(err) => {
                        let source = err
                            .path()
                            .map(|path| path.display().to_string())
                            .unwrap_or_else(|| path.display().to_string());
                        record_unreadable_with_warning(&mut report, source, err);
                        continue;
                    }
                };

                if entry.file_type().is_dir() {
                    continue;
                }

                if let Some(max_path_len) = max_path_len {
                    let path_str = entry.path().to_string_lossy();
                    if path_str.len() > max_path_len {
                        record_unreadable_with_warning(
                            &mut report,
                            entry.path().display(),
                            ImportRejectionReason::LimitExceeded {
                                limit: "max_import_path_length",
                                details: format!("{} > {}", path_str.len(), max_path_len),
                            },
                        );
                        continue;
                    }
                }

                if let Some(max_total_files) = max_total_files {
                    if report.scanned_files >= max_total_files {
                        record_unreadable_with_warning(
                            &mut report,
                            path.display(),
                            ImportRejectionReason::LimitExceeded {
                                limit: "max_import_total_files",
                                details: format!("limit is {max_total_files}"),
                            },
                        );
                        return Ok((report, managed_cleanups));
                    }
                }

                if let Some(managed_cleanup) = self.import_file_candidate_in_conn(
                    conn,
                    &mut stmts,
                    entry.path(),
                    &mut report,
                    cancel_flag,
                )? {
                    managed_cleanups.push(managed_cleanup);
                }

                if let Some(progress) = progress.as_deref_mut() {
                    progress(
                        report.scanned_files as u64,
                        max_total_files.map(|v| v as u64),
                    );
                }
            }

            Ok((report, managed_cleanups))
        })?;
        for managed_cleanup in managed_cleanups {
            managed_cleanup.disarm();
        }
        Ok(report)
    }

    pub fn import_zip(&self, path: &Path) -> Result<ImportReport> {
        self.import_zip_with_cancel(path, None, None)
    }

    pub(super) fn import_zip_with_cancel<'a>(
        &self,
        path: &Path,
        cancel_flag: Option<&AtomicBool>,
        mut progress: Option<&'a mut dyn FnMut(u64, Option<u64>)>,
    ) -> Result<ImportReport> {
        cancel::ensure_not_cancelled(cancel_flag)?;
        let file = fs::File::open(path)
            .with_context(|| format!("opening ZIP import file {}", path.display()))?;
        let reader = BufReader::new(file);
        let mut archive = ZipArchive::new(reader)
            .with_context(|| format!("opening ZIP archive {}", path.display()))?;

        let (report, managed_cleanups) = self.db.with_transaction(|conn| {
            // Track entry-path collisions within this ZIP so we never overwrite a previously-staged
            // temp file for a prior entry.
            let mut seen_entry_paths: std::collections::HashSet<std::path::PathBuf> =
                std::collections::HashSet::new();
            let mut stmts = InstanceImportStatements::prepare(conn)?;
            let mut report = ImportReport::default();
            let mut extracted_bytes = 0_u64;
            let mut managed_cleanups: Vec<super::staging::FileCleanupGuard> = Vec::new();

            let total_entries = archive.len() as u64;
            for i in 0..archive.len() {
                cancel::ensure_not_cancelled(cancel_flag)?;
                if let Some(max_entries) = self.config.max_zip_entry_count {
                    if i >= max_entries {
                        record_unreadable_with_warning(
                            &mut report,
                            path.display(),
                            format!(
                                "ZIP entry count limit exceeded: archive has {} entries, limit is {}",
                                archive.len(),
                                max_entries
                            ),
                        );
                        return Ok((report, managed_cleanups));
                    }
                }

                let mut entry = match archive.by_index(i) {
                    Ok(entry) => entry,
                    Err(err) => {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}#{}", path.display(), i),
                            ImportRejectionReason::CorruptZip(format!("opening ZIP entry: {err}")),
                        );
                        continue;
                    }
                };

                if entry.is_dir() {
                    continue;
                }
                report.scanned_files += 1;
                if let Some(progress) = progress.as_deref_mut() {
                    progress(report.scanned_files as u64, Some(total_entries));
                }

                let safe_name = match entry.enclosed_name() {
                    Some(name) => name.to_path_buf(),
                    None => {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), entry.name()),
                            ImportRejectionReason::UnsafeZipPath(
                                "entry path escapes archive".to_string(),
                            ),
                        );
                        continue;
                    }
                };

                if !seen_entry_paths.insert(safe_name.clone()) {
                    record_unreadable_with_warning(
                        &mut report,
                        format!("zip://{}!{}", path.display(), safe_name.display()),
                        ImportRejectionReason::DuplicateZipPath(format!(
                            "ZIP contains multiple entries targeting '{}'",
                            safe_name.display()
                        )),
                    );
                    continue;
                }

                if let Some(max_path_len) = self.config.max_import_path_length {
                    let safe_name_str = safe_name.to_string_lossy();
                    if safe_name_str.len() > max_path_len {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            ImportRejectionReason::LimitExceeded {
                                limit: "max_import_path_length",
                                details: format!("{} > {}", safe_name_str.len(), max_path_len),
                            },
                        );
                        continue;
                    }
                }

                let entry_size = entry.size();
                let read_limit = zip_entry_read_limit(&self.config, extracted_bytes);
                if let Some(max_entry_bytes) = self.config.max_zip_entry_bytes {
                    if entry_size > max_entry_bytes {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            format!(
                                "ZIP entry size {} exceeds limit {}",
                                entry_size, max_entry_bytes
                            ),
                        );
                        continue;
                    }
                }
                if let Some(max_total_bytes) = self.config.max_zip_total_bytes {
                    let projected_total = extracted_bytes.saturating_add(entry_size);
                    if projected_total > max_total_bytes {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            format!(
                                "ZIP total extracted bytes limit exceeded: current total {} plus entry size {} exceeds limit {}",
                                extracted_bytes, entry_size, max_total_bytes
                            ),
                        );
                        return Ok((report, managed_cleanups));
                    }
                }

                // Stream the ZIP entry into a staged temp file in bounded chunks (64 KiB buffers
                // inside stage_reader_with_sha256) instead of buffering the full entry in memory.
                cancel::ensure_not_cancelled(cancel_flag)?;
                let staged_result = match read_limit {
                    Some(read_limit) => stage_reader_with_sha256(
                        entry.by_ref().take(read_limit.saturating_add(1)),
                        &self.paths.managed_store_dir,
                        &safe_name,
                        self.config.max_zip_entry_bytes,
                        cancel_flag,
                    ),
                    None => stage_reader_with_sha256(
                        entry.by_ref(),
                        &self.paths.managed_store_dir,
                        &safe_name,
                        self.config.max_zip_entry_bytes,
                        cancel_flag,
                    ),
                };

                let (staged_path, sha256_hex, actual_entry_bytes) = match staged_result {
                    Ok(result) => result,
                    Err(err) => {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            ImportRejectionReason::CorruptZip(format!("reading ZIP entry: {err}")),
                        );
                        continue;
                    }
                };

                if let Some(max_entry_bytes) = self.config.max_zip_entry_bytes {
                    if actual_entry_bytes > max_entry_bytes {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            ImportRejectionReason::LimitExceeded {
                                limit: "max_zip_entry_bytes",
                                details: format!("{} > {}", actual_entry_bytes, max_entry_bytes),
                            },
                        );
                        let _ = fs::remove_file(&staged_path);
                        continue;
                    }
                }
                if let Some(max_total_bytes) = self.config.max_zip_total_bytes {
                    let projected_total = extracted_bytes.saturating_add(actual_entry_bytes);
                    if projected_total > max_total_bytes {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            ImportRejectionReason::LimitExceeded {
                                limit: "max_zip_total_bytes",
                                details: format!(
                                    "current total {} + read bytes {} > {}",
                                    extracted_bytes, actual_entry_bytes, max_total_bytes
                                ),
                            },
                        );
                        let _ = fs::remove_file(&staged_path);
                        return Ok((report, managed_cleanups));
                    }
                }
                extracted_bytes = extracted_bytes.saturating_add(actual_entry_bytes);

                let source_path = format!("zip://{}!{}", path.display(), safe_name.display());
                cancel::ensure_not_cancelled(cancel_flag)?;
                let staged_file = match fs::File::open(&staged_path) {
                    Ok(file) => file,
                    Err(err) => {
                        record_unreadable_with_warning(
                            &mut report,
                            source_path,
                            ImportRejectionReason::Unreadable(format!("opening staged file: {err}")),
                        );
                        continue;
                    }
                };

                cancel::ensure_not_cancelled(cancel_flag)?;
                let file_obj = match DefaultFileObject::from_reader(staged_file) {
                    Ok(file_obj) => file_obj,
                    Err(err) => {
                        record_invalid_dicom_with_warning(
                            &mut report,
                            source_path.clone(),
                            ImportRejectionReason::InvalidDicom(format!("DICOM parse failed: {err}")),
                        );
                        let _ = fs::remove_file(&staged_path);
                        continue;
                    }
                };

                let store_result = self.store_valid_dicom_file_in_conn(
                    conn,
                    &mut stmts,
                    staged_path.as_path(),
                    sha256_hex,
                    actual_entry_bytes,
                    file_obj,
                    source_path.clone(),
                    &mut report,
                );

                match store_result {
                    Ok(Some(managed_cleanup)) => managed_cleanups.push(managed_cleanup),
                    Ok(None) => {
                        // Either duplicate (staged file moved into place) or validation failure.
                        // In the duplicate case, store_valid_dicom_file_in_conn will have moved the
                        // staged file into the managed store, so no staged temp remains.
                        // In the validation failure case, it won't have moved the staged file, so
                        // clean it up.
                        let _ = fs::remove_file(&staged_path);
                    }
                    Err(err) => match err {
                        super::persistence::StoreDicomError::InvalidDicom(err) => {
                            record_invalid_dicom_with_warning(
                                &mut report,
                                source_path,
                                ImportRejectionReason::InvalidDicom(format!(
                                    "DICOM validation failed: {err}"
                                )),
                            );
                            let _ = fs::remove_file(&staged_path);
                        }
                        super::persistence::StoreDicomError::Fatal(err) => return Err(err),
                    },
                }
            }

            Ok((report, managed_cleanups))
        })?;
        for managed_cleanup in managed_cleanups {
            managed_cleanup.disarm();
        }
        Ok(report)
    }
}

pub(super) fn is_zip_path(path: &Path) -> bool {
    path.extension()
        .and_then(|ext| ext.to_str())
        .map(|ext| ext.eq_ignore_ascii_case("zip"))
        .unwrap_or(false)
}

pub(super) fn record_unreadable_with_warning(
    report: &mut ImportReport,
    source: impl std::fmt::Display,
    reason: impl std::fmt::Display,
) {
    warn!(
        source = %source,
        reason = %reason,
        "rejecting import candidate as unreadable"
    );
    report.record_unreadable(source, reason);
}

pub(super) fn record_invalid_dicom_with_warning(
    report: &mut ImportReport,
    source: impl std::fmt::Display,
    reason: impl std::fmt::Display,
) {
    warn!(
        source = %source,
        reason = %reason,
        "rejecting import candidate as invalid DICOM"
    );
    report.record_invalid_dicom(source, reason);
}

#[cfg(test)]
mod rejection_reason_tests {
    use crate::error::ImportRejectionReason;

    #[test]
    fn import_rejection_reason_renders_limit_exceeded() {
        let reason = ImportRejectionReason::LimitExceeded {
            limit: "max_zip_total_bytes",
            details: "1 > 0".to_string(),
        };
        assert_eq!(reason.to_string(), "max_zip_total_bytes exceeded: 1 > 0");
    }
}

pub(super) fn validate_readable_dir(path: &Path) -> Result<()> {
    fs::read_dir(path)
        .with_context(|| format!("reading import directory {}", path.display()))
        .map(|_| ())
}

pub(super) fn validate_readable_file(path: &Path, kind: &str) -> Result<()> {
    regular_file_metadata(path)
        .with_context(|| format!("reading metadata for {kind} {}", path.display()))?;
    fs::File::open(path)
        .with_context(|| format!("opening {kind} {}", path.display()))
        .map(|_| ())
}

pub(super) fn regular_file_metadata(path: &Path) -> Result<fs::Metadata> {
    let metadata = fs::metadata(path)
        .with_context(|| format!("reading file metadata for {}", path.display()))?;
    if !metadata.file_type().is_file() {
        return Err(anyhow!("not a regular file"));
    }
    Ok(metadata)
}

fn zip_entry_read_limit(config: &AppConfig, extracted_bytes: u64) -> Option<u64> {
    let total_remaining = config
        .max_zip_total_bytes
        .map(|max_total_bytes| max_total_bytes.saturating_sub(extracted_bytes));

    match (config.max_zip_entry_bytes, total_remaining) {
        (Some(entry_limit), Some(total_remaining)) => Some(entry_limit.min(total_remaining)),
        (Some(entry_limit), None) => Some(entry_limit),
        (None, Some(total_remaining)) => Some(total_remaining),
        (None, None) => None,
    }
}

#[cfg(test)]
mod tests {
    use crate::config::AppConfig;

    use super::super::test_support::{
        dicom_bytes_missing_required_uids, staged_files, test_importer, write_zip,
        write_zip_with_directory, zip_path,
    };

    #[test]
    fn import_zip_skips_entries_over_entry_size_limit() {
        let config = AppConfig {
            max_zip_entry_bytes: Some(3),
            max_zip_total_bytes: None,
            max_zip_entry_count: None,
            ..AppConfig::default()
        };
        let (root, importer) = test_importer(config);
        let zip_path = zip_path(&root);
        write_zip(&zip_path, &[("large.dcm", b"abcd")]);

        let report = importer.import_path(&zip_path).expect("import zip");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.unreadable, 1);
        assert_eq!(report.invalid_dicom, 0);
        assert_eq!(report.rejected(), 1);
        assert!(report
            .failures
            .iter()
            .any(|failure| failure.contains("ZIP entry size 4 exceeds limit 3")));
    }

    #[test]
    fn import_zip_stops_when_total_size_limit_would_be_exceeded() {
        let config = AppConfig {
            max_zip_entry_bytes: None,
            max_zip_total_bytes: Some(3),
            max_zip_entry_count: None,
            ..AppConfig::default()
        };
        let (root, importer) = test_importer(config);
        let zip_path = zip_path(&root);
        write_zip(&zip_path, &[("first.dcm", b"ab"), ("second.dcm", b"cd")]);

        let report = importer.import_path(&zip_path).expect("import zip");

        assert_eq!(report.scanned_files, 2);
        assert_eq!(report.unreadable, 1);
        assert_eq!(report.invalid_dicom, 1);
        assert_eq!(report.rejected(), 2);
        assert!(report
            .failures
            .iter()
            .any(|failure| failure.contains("ZIP total extracted bytes limit exceeded")));
    }

    #[test]
    fn import_zip_stops_when_entry_count_limit_is_exceeded() {
        let config = AppConfig {
            max_zip_entry_bytes: None,
            max_zip_total_bytes: None,
            max_zip_entry_count: Some(1),
            ..AppConfig::default()
        };
        let (root, importer) = test_importer(config);
        let zip_path = zip_path(&root);
        write_zip(&zip_path, &[("first.dcm", b"ab"), ("second.dcm", b"cd")]);

        let report = importer.import_path(&zip_path).expect("import zip");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.unreadable, 1);
        assert_eq!(report.invalid_dicom, 1);
        assert_eq!(report.rejected(), 2);
        assert!(report
            .failures
            .iter()
            .any(|failure| failure.contains("ZIP entry count limit exceeded")));
    }

    #[test]
    fn import_zip_does_not_count_directories_as_scanned_files() {
        let (root, importer) = test_importer(AppConfig::default());
        let zip_path = zip_path(&root);
        write_zip_with_directory(
            &zip_path,
            "nested/",
            &[("nested/not-dicom.dcm", b"not dicom")],
        );

        let report = importer.import_path(&zip_path).expect("import zip");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.invalid_dicom, 1);
        assert_eq!(report.rejected(), 1);
    }

    #[test]
    fn import_zip_reports_store_validation_failures_per_entry() {
        let (root, importer) = test_importer(AppConfig::default());
        let zip_path = zip_path(&root);
        let dicom_bytes = dicom_bytes_missing_required_uids(&root);
        write_zip(&zip_path, &[("missing-required-uids.dcm", &dicom_bytes)]);

        let report = importer.import_path(&zip_path).expect("import zip");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 0);
        assert_eq!(report.invalid_dicom, 1);
        assert!(report.failures.iter().any(|failure| {
            failure.contains("DICOM validation failed")
                && failure.contains("required DICOM attribute missing")
        }));
        assert!(
            staged_files(&importer).is_empty(),
            "expected no staged files after store validation failure"
        );
    }

    #[test]
    fn import_zip_imports_valid_dicom_entry_and_persists_sha256() {
        use sha2::{Digest, Sha256};

        let (root, importer) = test_importer(AppConfig::default());

        let sop_instance_uid = "1.2.826.0.1.3680043.10.999.123";
        let dicom_path = root.path().join("entry.dcm");
        super::super::test_support::write_valid_dicom_with_pixel_data(
            &dicom_path,
            sop_instance_uid,
        );
        let dicom_bytes = std::fs::read(&dicom_path).expect("read test dicom");

        let mut hasher = Sha256::new();
        hasher.update(&dicom_bytes);
        let expected_sha256 = format!("{:x}", hasher.finalize());

        let zip_path = zip_path(&root);
        write_zip(&zip_path, &[("entry.dcm", &dicom_bytes)]);

        let report = importer.import_path(&zip_path).expect("import zip");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 1);
        assert_eq!(report.invalid_dicom, 0);

        let exists = importer
            .db
            .instance_exists(sop_instance_uid, &expected_sha256)
            .expect("db instance_exists");
        assert!(
            exists,
            "expected imported instance to exist with matching SHA-256"
        );
    }

    #[test]
    fn import_zip_large_entry_does_not_trip_entry_read_limit() {
        // Regression test for avoiding full ZIP entry buffering.
        // If ZIP import were still reading entries into memory, large entries would either
        // (a) blow memory or (b) hit per-entry limits early. With streaming staging,
        // a large entry under the configured limit should import successfully.

        let config = AppConfig {
            // Large enough to require multiple read iterations (stage_reader_with_sha256 uses 64KiB).
            max_zip_entry_bytes: Some(200_000),
            max_zip_total_bytes: None,
            max_zip_entry_count: None,
            ..AppConfig::default()
        };
        let (root, importer) = test_importer(config);

        let sop_instance_uid = "1.2.826.0.1.3680043.10.999.124";
        let dicom_path = root.path().join("large-entry.dcm");
        super::super::test_support::write_valid_dicom_with_pixel_data(
            &dicom_path,
            sop_instance_uid,
        );

        // Pad the file with extra Pixel Data so it's large but remains valid DICOM.
        // This forces the import pipeline to stream multiple 64KiB chunks.
        {
            use dicom_core::{DataElement, PrimitiveValue, VR};
            use dicom_dictionary_std::tags;
            use dicom_object::open_file;

            let mut obj = open_file(&dicom_path).expect("open generated DICOM");
            obj.put(DataElement::new(
                tags::PIXEL_DATA,
                VR::OB,
                PrimitiveValue::from(vec![0x55_u8; 150_000]),
            ));
            obj.write_to_file(&dicom_path)
                .expect("rewrite padded DICOM");
        }

        let dicom_bytes = std::fs::read(&dicom_path).expect("read test dicom");
        assert!(
            dicom_bytes.len() > 128 * 1024,
            "expected > 128KiB test entry"
        );
        assert!(
            dicom_bytes.len() <= 200_000,
            "expected test entry within configured limit"
        );

        let zip_path = zip_path(&root);
        write_zip(&zip_path, &[("large-entry.dcm", &dicom_bytes)]);

        let report = importer.import_path(&zip_path).expect("import zip");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 1);
        assert_eq!(report.rejected(), 0);
    }
}

#[cfg(test)]
mod perf_harness {
    use std::time::Instant;

    use crate::config::AppConfig;

    use super::super::test_support::{test_importer, write_valid_dicom_with_pixel_data};

    #[test]
    fn perf_harness_import_folder_timing_smoke() {
        // Crude before/after timing harness for import optimizations (e.g., DB transaction batching).
        // Not a strict performance test; only asserts functional correctness.

        let (root, importer) = test_importer(AppConfig::default());

        let import_dir = root.path().join("import");
        std::fs::create_dir_all(&import_dir).expect("create import dir");

        let file_count = 200;
        for i in 0..file_count {
            let path = import_dir.join(format!("{i}.dcm"));
            let uid = format!("1.2.826.0.1.3680043.10.999.1000.{i}");
            write_valid_dicom_with_pixel_data(&path, &uid);
        }

        let started = Instant::now();
        let report = importer.import_folder(&import_dir).expect("import folder");
        let elapsed = started.elapsed();

        eprintln!("imported {file_count} files in {elapsed:?}");

        assert_eq!(report.scanned_files, file_count);
        assert_eq!(report.accepted, file_count);
        assert_eq!(report.invalid_dicom, 0);
        assert_eq!(report.unreadable, 0);
    }
}
