mod common;

use common::{run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec, TestServices};

#[test]
fn import_rejects_corrupt_dicom_and_continues_batch() {
    run_with_timeout(std::time::Duration::from_secs(20), || {
        let fixture = TestServices::new().expect("create services");
        let import_dir = fixture.temp_dir.path().join("import");
        std::fs::create_dir_all(&import_dir).expect("create import dir");

        // Valid DICOM
        let valid_path = import_dir.join("valid.dcm");
        let valid_spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.999.100",
            "1.2.826.0.1.3680043.10.999.100.1",
            "1.2.826.0.1.3680043.10.999.100.1.1",
        );
        write_valid_dicom_with_pixel_data(&valid_path, &valid_spec).expect("write valid dicom");

        // Corrupt DICOM: not a DICOM file (random bytes). Name uses .dcm to ensure it's treated
        // as an import candidate.
        let corrupt_path = import_dir.join("corrupt.dcm");
        std::fs::write(&corrupt_path, b"this is not a dicom file").expect("write corrupt dicom");

        let report = fixture
            .services
            .import_path(&import_dir)
            .expect("import folder");

        assert_eq!(report.scanned_files, 2);
        assert_eq!(report.accepted, 1);
        assert_eq!(report.invalid_dicom, 1);
    });
}
