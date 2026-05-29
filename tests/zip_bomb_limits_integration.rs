mod common;

use std::{fs::File, io::Write, time::Duration};

use common::{run_with_timeout, TestServices};
use dicom_node_client::config::DEFAULT_MAX_ZIP_ENTRY_BYTES;
use zip::{write::SimpleFileOptions, CompressionMethod, ZipWriter};

#[test]
fn zip_entry_count_limit_is_enforced_for_many_entries() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new_with_config(|config| {
            config.max_zip_entry_count = Some(2);
            config.max_zip_entry_bytes = Some(DEFAULT_MAX_ZIP_ENTRY_BYTES);
            config.max_zip_total_bytes = None;
        })
        .expect("create test services");

        let zip_path = services.temp_dir.path().join("many.zip");
        let file = File::create(&zip_path).expect("create zip");
        let mut zip = ZipWriter::new(file);
        let options = SimpleFileOptions::default().compression_method(CompressionMethod::Stored);

        for i in 0..3 {
            zip.start_file(format!("{i}.txt"), options)
                .expect("start file");
            zip.write_all(b"hi").expect("write bytes");
        }

        zip.finish().expect("finish zip");

        let report = services
            .services
            .importer
            .import_path(&zip_path)
            .expect("import zip");

        assert_eq!(report.scanned_files, 2);
        assert_eq!(report.unreadable, 1);
        assert!(report
            .failures
            .iter()
            .any(|failure| failure.contains("ZIP entry count limit exceeded")));
    });
}

#[test]
fn zip_total_uncompressed_bytes_limit_is_enforced() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new_with_config(|config| {
            config.max_zip_entry_bytes = None;
            config.max_zip_total_bytes = Some(5);
            config.max_zip_entry_count = None;
        })
        .expect("create test services");

        let zip_path = services.temp_dir.path().join("total_limit.zip");
        let file = File::create(&zip_path).expect("create zip");
        let mut zip = ZipWriter::new(file);
        let options = SimpleFileOptions::default().compression_method(CompressionMethod::Stored);

        zip.start_file("first.txt", options).expect("start file");
        zip.write_all(b"abcd").expect("write bytes");
        zip.start_file("second.txt", options).expect("start file");
        zip.write_all(b"efgh").expect("write bytes");

        zip.finish().expect("finish zip");

        let report = services
            .services
            .importer
            .import_path(&zip_path)
            .expect("import zip");

        assert_eq!(report.scanned_files, 2);
        assert_eq!(report.unreadable, 1);
        assert!(report
            .failures
            .iter()
            .any(|failure| failure.contains("ZIP total extracted bytes limit exceeded")));
    });
}
