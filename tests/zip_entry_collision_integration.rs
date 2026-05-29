mod common;

use std::io::Write;
use std::time::Duration;

use common::{run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec, TestServices};
use zip::{write::SimpleFileOptions, CompressionMethod, ZipWriter};

#[test]
fn zip_entry_path_collision_is_rejected_without_overwriting() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        let mut spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.240.1",
            "1.2.826.0.1.3680043.10.240.1.1",
            "1.2.826.0.1.3680043.10.240.1.1.1",
        );
        spec.pixel_byte = 0x62;

        // Create one valid DICOM file which we will include twice under the same ZIP entry name.
        let source = write_valid_dicom_with_pixel_data(
            &services.temp_dir.path().join("zip-source").join("one.dcm"),
            &spec,
        )
        .expect("write source dicom");
        let bytes = std::fs::read(&source.path).expect("read source bytes");

        let zip_path = services
            .temp_dir
            .path()
            .join("zip-source")
            .join("collision.zip");
        std::fs::create_dir_all(zip_path.parent().unwrap()).expect("create zip parent dir");

        let zip_file = std::fs::File::create(&zip_path).expect("create zip");
        let mut zip = ZipWriter::new(zip_file);
        let options = SimpleFileOptions::default().compression_method(CompressionMethod::Stored);

        // First entry should import.
        zip.start_file("same-path.dcm", options)
            .expect("start zip entry 1");
        zip.write_all(&bytes).expect("write zip entry 1 bytes");

        // Second entry targets the same normalized path (enclosed_name()) via a different raw
        // path string. Importer should reject it and must not overwrite.
        zip.start_file("./same-path.dcm", options)
            .expect("start zip entry 2");
        zip.write_all(&bytes).expect("write zip entry 2 bytes");

        zip.finish().expect("finish zip");

        let report = services
            .services
            .importer
            .import_path(&zip_path)
            .expect("import zip");

        assert_eq!(report.scanned_files, 2);
        assert_eq!(report.accepted, 1);
        // Second entry is rejected before DICOM parsing due to path collision.
        assert_eq!(report.duplicates, 1);
        assert_eq!(report.invalid_dicom, 0);
        assert_eq!(report.unreadable, 0);

        // Ensure we only stored one instance.
        let studies = services.services.db.list_studies().expect("list studies");
        assert_eq!(studies.len(), 1);
        assert_eq!(studies[0].instance_count, 1);
    });
}
