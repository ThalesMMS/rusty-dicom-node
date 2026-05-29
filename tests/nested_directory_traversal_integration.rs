mod common;

use std::time::Duration;

use common::{run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec, TestServices};

#[test]
fn importing_nested_directory_honors_max_directory_depth() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new_with_config(|config| {
            // Only scan base_dir itself (depth 1); do not descend into subdirectories.
            config.max_import_directory_depth = Some(1);
        })
        .expect("create test services");

        let base_dir = services.temp_dir.path().join("nested-import");
        let nested_dir = base_dir.join("level1").join("level2");
        std::fs::create_dir_all(&nested_dir).expect("create nested dirs");

        let mut spec_root = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.250.10",
            "1.2.826.0.1.3680043.10.250.10.1",
            "1.2.826.0.1.3680043.10.250.10.1.1",
        );
        spec_root.pixel_byte = 0x11;

        let mut spec_nested = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.250.10",
            "1.2.826.0.1.3680043.10.250.10.2",
            "1.2.826.0.1.3680043.10.250.10.2.1",
        );
        spec_nested.pixel_byte = 0x22;

        write_valid_dicom_with_pixel_data(&base_dir.join("root.dcm"), &spec_root)
            .expect("write root dicom");
        write_valid_dicom_with_pixel_data(&nested_dir.join("nested.dcm"), &spec_nested)
            .expect("write nested dicom");

        let report = services
            .services
            .importer
            .import_folder(&base_dir)
            .expect("import folder");

        // With max depth 1, we should only see the file directly under base_dir.
        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 1);
        assert_eq!(report.duplicates, 0);
        assert_eq!(report.invalid_dicom, 0);
        assert_eq!(report.unreadable, 0);

        let studies = services.services.db.list_studies().expect("list studies");
        assert_eq!(studies.len(), 1);
        assert_eq!(studies[0].instance_count, 1);
    });
}
