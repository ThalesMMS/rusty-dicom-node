mod common;

use std::time::Duration;

use common::{run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec, TestServices};

#[test]
fn importing_multiple_files_in_one_folder_reports_duplicates_and_persists_instances() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        let base_dir = services.temp_dir.path().join("batch-import");
        let mut first_spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.250.1",
            "1.2.826.0.1.3680043.10.250.1.1",
            "1.2.826.0.1.3680043.10.250.1.1.1",
        );
        first_spec.pixel_byte = 0x11;

        let mut second_spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.250.1",
            "1.2.826.0.1.3680043.10.250.1.2",
            "1.2.826.0.1.3680043.10.250.1.2.1",
        );
        second_spec.pixel_byte = 0x22;

        // Duplicate: same SOP instance UID as first, but different content.
        // Current behavior considers this a duplicate (UID match) and it should not be inserted.
        let mut dup_spec = first_spec.clone();
        dup_spec.pixel_byte = 0x33;

        write_valid_dicom_with_pixel_data(&base_dir.join("first.dcm"), &first_spec)
            .expect("write first");
        write_valid_dicom_with_pixel_data(&base_dir.join("second.dcm"), &second_spec)
            .expect("write second");
        write_valid_dicom_with_pixel_data(&base_dir.join("dup.dcm"), &dup_spec).expect("write dup");

        let report = services
            .services
            .importer
            .import_folder(&base_dir)
            .expect("import folder");

        assert_eq!(report.scanned_files, 3);
        assert_eq!(report.accepted, 2);
        assert_eq!(report.duplicates, 1);
        assert_eq!(report.invalid_dicom, 0);
        assert_eq!(report.unreadable, 0);

        let studies = services.services.db.list_studies().expect("list studies");
        assert_eq!(studies.len(), 1);
        assert_eq!(studies[0].instance_count, 2);
    });
}
