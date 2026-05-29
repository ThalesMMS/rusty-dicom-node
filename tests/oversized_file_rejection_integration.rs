mod common;

use std::{fs, time::Duration};

use common::{run_with_timeout, TestServices};

#[test]
fn oversized_files_are_rejected_via_metadata_size_check() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new_with_config(|config| {
            // Keep the limit tiny so we can exceed it without large allocations.
            config.max_file_import_bytes = Some(16);
        })
        .expect("create test services");

        let base_dir = services.temp_dir.path().join("oversized-import");
        fs::create_dir_all(&base_dir).expect("create base dir");

        // Write a small file which exceeds the configured limit.
        // This should be rejected before attempting DICOM parsing.
        let oversized_path = base_dir.join("too-big.dcm");
        fs::write(&oversized_path, vec![0_u8; 17]).expect("write oversized file");

        let report = services
            .services
            .importer
            .import_folder(&base_dir)
            .expect("import folder");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 0);
        assert_eq!(report.duplicates, 0);
        assert_eq!(report.invalid_dicom, 0);
        assert_eq!(report.unreadable, 1);

        // Ensure nothing was stored.
        let studies = services.services.db.list_studies().expect("list studies");
        assert_eq!(studies.len(), 0);
    });
}
