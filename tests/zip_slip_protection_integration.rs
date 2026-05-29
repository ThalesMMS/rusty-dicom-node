mod common;

use std::io::Write;
use std::time::Duration;

use common::{run_with_timeout, TestServices};
use zip::{write::SimpleFileOptions, CompressionMethod, ZipWriter};

#[test]
fn importing_zip_with_zip_slip_paths_rejects_unsafe_entries_and_does_not_write_outside_staging() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        let zip_path = services
            .temp_dir
            .path()
            .join("import-source")
            .join("slip.zip");
        std::fs::create_dir_all(zip_path.parent().unwrap()).expect("create zip parent dir");

        let zip_file = std::fs::File::create(&zip_path).expect("create zip");
        let mut zip = ZipWriter::new(zip_file);

        let options = SimpleFileOptions::default().compression_method(CompressionMethod::Stored);

        // Create entries with unsafe names. The importer should refuse to extract them.
        zip.start_file("../escape.dcm", options)
            .expect("start relative escape entry");
        zip.write_all(b"not-a-dicom").expect("write escape bytes");

        zip.start_file("/absolute.dcm", options)
            .expect("start absolute path entry");
        zip.write_all(b"not-a-dicom").expect("write absolute bytes");

        zip.finish().expect("finish zip");

        let report = services
            .services
            .importer
            .import_path(&zip_path)
            .expect("import zip");

        assert_eq!(report.accepted, 0);
        assert_eq!(report.duplicates, 0);
        assert_eq!(report.invalid_dicom, 0);

        // Both entries should be rejected as unreadable/unsafe.
        assert_eq!(report.unreadable, 2);

        // Ensure nothing was written outside the temp dir.
        let escaped = services.temp_dir.path().join("escape.dcm");
        let absolute = services.temp_dir.path().join("absolute.dcm");
        assert!(!escaped.exists(), "zip-slip should not write escape.dcm");
        assert!(!absolute.exists(), "zip-slip should not write absolute.dcm");
    });
}
