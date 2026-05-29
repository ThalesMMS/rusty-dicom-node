mod common;

use std::{fs, time::Duration};

use common::{run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec, TestServices};

#[test]
fn importing_extensionless_file_is_rejected_as_invalid_dicom() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        let base_dir = services.temp_dir.path().join("extensionless-import");
        let spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.250.10",
            "1.2.826.0.1.3680043.10.250.10.1",
            "1.2.826.0.1.3680043.10.250.10.1.1",
        );

        let extensionless_path = base_dir.join("image");
        write_valid_dicom_with_pixel_data(&extensionless_path, &spec).expect("write dicom");

        let report = services
            .services
            .importer
            .import_folder(&base_dir)
            .expect("import folder");

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

#[test]
fn importing_non_dicom_file_is_rejected() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        let base_dir = services.temp_dir.path().join("non-dicom-import");
        fs::create_dir_all(&base_dir).expect("create base dir");
        let txt_path = base_dir.join("note.txt");
        fs::write(&txt_path, b"not a dicom").expect("write txt");

        let report = services
            .services
            .importer
            .import_folder(&base_dir)
            .expect("import folder");

        assert_eq!(report.scanned_files, 1);
        assert_eq!(report.accepted, 0);
        assert_eq!(report.duplicates, 0);
        assert_eq!(report.invalid_dicom, 1);
        assert_eq!(report.unreadable, 0);

        let studies = services.services.db.list_studies().expect("list studies");
        assert_eq!(studies.len(), 0);
    });
}
