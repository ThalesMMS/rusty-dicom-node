use std::{
    fs,
    io::{BufReader, Cursor, Read},
    path::Path,
    sync::atomic::AtomicBool,
};

use anyhow::{anyhow, Context};
use tracing::warn;
use walkdir::WalkDir;
use zip::ZipArchive;

use crate::{
    cancel, config::AppConfig, db::InstanceImportStatements, dicom::DefaultFileObject,
    error::Result, models::ImportReport,
};

use super::{persistence::StoreDicomError, Importer};

impl Importer {
    pub fn import_folder(&self, path: &Path) -> Result<ImportReport> {
        self.import_folder_with_cancel(path, None)
    }

    pub(super) fn import_folder_with_cancel(
        &self,
        path: &Path,
        cancel_flag: Option<&AtomicBool>,
    ) -> Result<ImportReport> {
        let (report, managed_cleanups) = self.db.with_transaction(|conn| {
            let mut stmts = InstanceImportStatements::prepare(conn)?;
            let mut report = ImportReport::default();
            let mut managed_cleanups = Vec::new();

            for entry in WalkDir::new(path).follow_links(false) {
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

                if let Some(managed_cleanup) = self.import_file_candidate_in_conn(
                    conn,
                    &mut stmts,
                    entry.path(),
                    &mut report,
                    cancel_flag,
                )? {
                    managed_cleanups.push(managed_cleanup);
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
        self.import_zip_with_cancel(path, None)
    }

    pub(super) fn import_zip_with_cancel(
        &self,
        path: &Path,
        cancel_flag: Option<&AtomicBool>,
    ) -> Result<ImportReport> {
        cancel::ensure_not_cancelled(cancel_flag)?;
        let file = fs::File::open(path)
            .with_context(|| format!("opening ZIP import file {}", path.display()))?;
        let reader = BufReader::new(file);
        let mut archive = ZipArchive::new(reader)
            .with_context(|| format!("opening ZIP archive {}", path.display()))?;

        let (report, managed_cleanups) = self.db.with_transaction(|conn| {
            let mut stmts = InstanceImportStatements::prepare(conn)?;
            let mut report = ImportReport::default();
            let mut extracted_bytes = 0_u64;
            let mut managed_cleanups = Vec::new();

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
                            format!("opening ZIP entry: {err}"),
                        );
                        continue;
                    }
                };

                if entry.is_dir() {
                    continue;
                }
                report.scanned_files += 1;

                let safe_name = match entry.enclosed_name() {
                    Some(name) => name.to_path_buf(),
                    None => {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), entry.name()),
                            "entry path escapes archive",
                        );
                        continue;
                    }
                };

                let entry_size = entry.size();
                let mut bytes = Vec::new();
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
                cancel::ensure_not_cancelled(cancel_flag)?;
                let read_result = match read_limit {
                    Some(read_limit) => entry
                        .by_ref()
                        .take(read_limit.saturating_add(1))
                        .read_to_end(&mut bytes),
                    None => entry.read_to_end(&mut bytes),
                };
                if let Err(err) = read_result {
                    record_unreadable_with_warning(
                        &mut report,
                        format!("zip://{}!{}", path.display(), safe_name.display()),
                        format!("reading ZIP entry: {err}"),
                    );
                    continue;
                }
                let actual_entry_bytes = bytes.len() as u64;
                if let Some(max_entry_bytes) = self.config.max_zip_entry_bytes {
                    if actual_entry_bytes > max_entry_bytes {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            format!(
                                "ZIP entry read {} bytes, exceeding limit {}",
                                actual_entry_bytes, max_entry_bytes
                            ),
                        );
                        continue;
                    }
                }
                if let Some(max_total_bytes) = self.config.max_zip_total_bytes {
                    let projected_total = extracted_bytes.saturating_add(actual_entry_bytes);
                    if projected_total > max_total_bytes {
                        record_unreadable_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            format!(
                                "ZIP total extracted bytes limit exceeded: current total {} plus read bytes {} exceeds limit {}",
                                extracted_bytes, actual_entry_bytes, max_total_bytes
                            ),
                        );
                        return Ok((report, managed_cleanups));
                    }
                }
                extracted_bytes = extracted_bytes.saturating_add(actual_entry_bytes);

                cancel::ensure_not_cancelled(cancel_flag)?;
                let file_obj = match DefaultFileObject::from_reader(Cursor::new(&bytes[..])) {
                    Ok(file_obj) => file_obj,
                    Err(err) => {
                        record_invalid_dicom_with_warning(
                            &mut report,
                            format!("zip://{}!{}", path.display(), safe_name.display()),
                            format!("DICOM parse failed: {err}"),
                        );
                        continue;
                    }
                };

                let source_path = format!("zip://{}!{}", path.display(), safe_name.display());
                cancel::ensure_not_cancelled(cancel_flag)?;
                match self.store_valid_dicom_bytes_in_conn(
                    conn,
                    &mut stmts,
                    file_obj,
                    bytes,
                    source_path.clone(),
                    &mut report,
                ) {
                    Ok(Some(managed_cleanup)) => managed_cleanups.push(managed_cleanup),
                    Ok(None) => {}
                    Err(err) => match err {
                        StoreDicomError::InvalidDicom(err) => {
                            record_invalid_dicom_with_warning(
                                &mut report,
                                source_path,
                                format!("DICOM validation failed: {err}"),
                            );
                            continue;
                        }
                        StoreDicomError::Fatal(err) => return Err(err),
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
        dicom_bytes_missing_required_uids, test_importer, write_zip, write_zip_with_directory,
        zip_path,
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
