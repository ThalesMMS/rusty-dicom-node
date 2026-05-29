mod common;

use std::time::Duration;

use common::{run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec, TestServices};
use zip::{write::SimpleFileOptions, CompressionMethod, ZipWriter};

use std::io::Write;

#[test]
fn importing_duplicate_content_across_zip_and_directory_is_counted_as_duplicate() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        let mut spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.240.1",
            "1.2.826.0.1.3680043.10.240.1.1",
            "1.2.826.0.1.3680043.10.240.1.1.1",
        );
        spec.pixel_byte = 0x61;

        // Write the DICOM file once into a directory, and once into a ZIP.
        let dir_file = write_valid_dicom_with_pixel_data(
            &services
                .temp_dir
                .path()
                .join("import-source")
                .join("one.dcm"),
            &spec,
        )
        .expect("write directory import file");

        let zip_path = services
            .temp_dir
            .path()
            .join("import-source")
            .join("files.zip");
        std::fs::create_dir_all(zip_path.parent().unwrap()).expect("create zip parent dir");
        let zip_file = std::fs::File::create(&zip_path).expect("create zip");
        let mut zip = ZipWriter::new(zip_file);

        let options = SimpleFileOptions::default().compression_method(CompressionMethod::Stored);
        zip.start_file("one.dcm", options).expect("start zip entry");
        let bytes = std::fs::read(&dir_file.path).expect("read source bytes");
        zip.write_all(&bytes).expect("write zip entry bytes");
        zip.finish().expect("finish zip");

        let first = services
            .services
            .importer
            .import_path(&dir_file.path)
            .expect("import directory file");
        let second = services
            .services
            .importer
            .import_path(&zip_path)
            .expect("import zip");

        assert_eq!(first.accepted, 1);
        assert_eq!(first.duplicates, 0);
        assert_eq!(second.accepted, 0);
        assert_eq!(second.duplicates, 1);
        assert!(second.duplicate_by_sop_instance_uid + second.duplicate_by_sha256 > 0);

        // Should still only have one instance stored.
        let studies = services.services.db.list_studies().expect("list studies");
        assert_eq!(studies.len(), 1);
        assert_eq!(studies[0].instance_count, 1);
    });
}
