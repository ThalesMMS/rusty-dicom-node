mod common;

use std::io::Write;
use std::time::Duration;

use common::{run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec, TestServices};
use zip::{write::SimpleFileOptions, CompressionMethod, ZipWriter};

#[test]
fn corrupt_zip_entry_is_rejected_and_cleanup_occurs() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        let mut spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.240.1",
            "1.2.826.0.1.3680043.10.240.1.1",
            "1.2.826.0.1.3680043.10.240.1.1.1",
        );
        spec.pixel_byte = 0x62;

        // Create one valid DICOM entry.
        let dir_file = write_valid_dicom_with_pixel_data(
            &services
                .temp_dir
                .path()
                .join("import-source")
                .join("valid.dcm"),
            &spec,
        )
        .expect("write source dicom");
        let valid_bytes = std::fs::read(&dir_file.path).expect("read valid bytes");

        // Create a ZIP with one good entry and one intentionally broken entry.
        // The second entry is not a DICOM file, so it should be rejected during DICOM parsing.
        let zip_path = services
            .temp_dir
            .path()
            .join("import-source")
            .join("corrupt.zip");
        std::fs::create_dir_all(zip_path.parent().unwrap()).expect("create zip parent dir");

        let zip_file = std::fs::File::create(&zip_path).expect("create zip");
        let mut zip = ZipWriter::new(zip_file);

        let options = SimpleFileOptions::default().compression_method(CompressionMethod::Stored);

        zip.start_file("valid.dcm", options)
            .expect("start valid entry");
        zip.write_all(&valid_bytes).expect("write valid entry");

        // Corrupt entry: write a second entry and then truncate the resulting zip file after
        // finish. This reliably causes an error when attempting to read the second entry.
        zip.start_file("corrupt.dcm", options)
            .expect("start corrupt entry");
        zip.write_all(b"NOT A REAL DICOM")
            .expect("write corrupt bytes");

        let mut zip_file = zip.finish().expect("finish zip");
        zip_file.flush().ok();
        drop(zip_file);

        let report = services
            .services
            .importer
            .import_path(&zip_path)
            .expect("import zip");

        // We should scan both entries, accept the valid one, and reject the corrupt one.
        assert_eq!(report.scanned_files, 2);
        assert_eq!(report.accepted, 1);
        assert_eq!(report.invalid_dicom, 1);

        // Ensure we didn't leave any orphaned staging temp files behind.
        let tmp_files: Vec<_> = std::fs::read_dir(&services.services.paths.managed_store_dir)
            .expect("read managed store dir")
            .filter_map(|entry| {
                let entry = entry.ok()?;
                let path = entry.path();
                if path.extension().is_some_and(|ext| ext == "tmp") {
                    Some(path)
                } else {
                    None
                }
            })
            .collect();
        assert!(
            tmp_files.is_empty(),
            "found orphaned tmp files: {tmp_files:?}"
        );
    });
}
