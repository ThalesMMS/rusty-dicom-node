mod common;

use std::{path::PathBuf, time::Duration};

use dicom_dictionary_std::uids::{EXPLICIT_VR_LITTLE_ENDIAN, IMPLICIT_VR_LITTLE_ENDIAN};
use dicom_node_client::dicom::managed_file_path;
use rusqlite::Connection;

use common::{
    harness::StoreScp, remote_node_fixture, run_with_timeout, write_valid_dicom_with_pixel_data,
    TestDicomSpec, TestServices,
};

#[test]
fn c_store_scu_sends_files_and_negotiates_uncompressed_transfer_syntaxes() {
    run_with_timeout(Duration::from_secs(10), || {
        let store_scp = StoreScp::builder()
            .expect("build store scp")
            .spawn()
            .expect("spawn store scp");
        let services = TestServices::new().expect("create test services");
        let node = store_scp.remote_node("store-scp");
        services
            .services
            .db
            .upsert_remote_node(&node)
            .expect("save remote node");

        let input_dir = services.temp_dir.path().join("store-input");
        let explicit = dicom_file(
            input_dir.join("explicit.dcm"),
            "1.2.826.0.1.3680043.10.201.1.1.1",
            EXPLICIT_VR_LITTLE_ENDIAN,
            0x11,
        );
        let implicit = dicom_file(
            input_dir.join("implicit.dcm"),
            "1.2.826.0.1.3680043.10.201.1.1.2",
            IMPLICIT_VR_LITTLE_ENDIAN,
            0x22,
        );

        let paths = vec![explicit.path.clone(), implicit.path.clone()];
        let outcome = services
            .services
            .store_scu
            .send_files(&node, &paths)
            .expect("send files");

        assert_eq!(outcome.attempted, 2);
        assert_eq!(outcome.sent, 2);
        assert_eq!(outcome.failed, 0);
        assert!(outcome.failures.is_empty());

        let mut received = store_scp.stop().expect("stop store scp");
        received.sort();
        assert_eq!(
            received,
            vec![
                "1.2.826.0.1.3680043.10.201.1.1.1".to_string(),
                "1.2.826.0.1.3680043.10.201.1.1.2".to_string(),
            ]
        );
    });
}

#[test]
fn storage_scp_rejects_inbound_dataset_over_configured_limit_without_artifacts() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new_with_config(|config| {
            config.max_store_object_bytes = Some(1000);
        })
        .expect("create test services");
        let max_store_object_bytes = services.services.config.max_store_object_bytes.unwrap();
        let storage_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn storage scp");
        let node = remote_node_fixture(
            "storage-scp",
            &services.services.config.local_ae_title,
            storage_scp.port(),
        );
        let study_uid = "1.2.826.0.1.3680043.10.201.2";
        let series_uid = "1.2.826.0.1.3680043.10.201.2.1";
        let sop_uid = "1.2.826.0.1.3680043.10.201.2.1.1";
        let mut spec = TestDicomSpec::new(study_uid, series_uid, sop_uid);
        spec.rows = 64;
        spec.columns = 64;

        let input_path = services.temp_dir.path().join("oversized.dcm");
        let input =
            write_valid_dicom_with_pixel_data(&input_path, &spec).expect("write oversized DICOM");
        let input_size = std::fs::metadata(&input_path)
            .expect("stat oversized DICOM")
            .len();
        assert!(
            input_size > max_store_object_bytes,
            "oversized fixture should exceed configured store limit: {input_size} <= {max_store_object_bytes}"
        );

        let outcome = services
            .services
            .store_scu
            .send_files(&node, &[input.path])
            .expect("send oversized file");
        let report = storage_scp.stop().expect("stop storage scp");

        assert_eq!(outcome.attempted, 1);
        assert_eq!(outcome.sent, 0);
        assert_eq!(outcome.failed, 1);
        assert!(outcome.failures[0].contains("0xA700"));
        assert_eq!(report.received, 1);
        assert_eq!(report.stored, 0);
        assert_eq!(report.failed, 1);
        assert!(!managed_file_path(
            &services.services.paths.managed_store_dir,
            study_uid,
            series_uid,
            sop_uid,
        )
        .exists());
        assert_eq!(database_instance_count(&services, sop_uid), 0);
    });
}

#[test]
fn storage_scp_stores_inbound_dataset_under_configured_limit() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new_with_config(|config| {
            config.max_store_object_bytes = Some(1000);
        })
        .expect("create test services");
        let max_store_object_bytes = services.services.config.max_store_object_bytes.unwrap();
        let storage_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn storage scp");
        let node = remote_node_fixture(
            "storage-scp",
            &services.services.config.local_ae_title,
            storage_scp.port(),
        );
        let study_uid = "1.2.826.0.1.3680043.10.201.3";
        let series_uid = "1.2.826.0.1.3680043.10.201.3.1";
        let sop_uid = "1.2.826.0.1.3680043.10.201.3.1.1";
        let mut spec = TestDicomSpec::new(study_uid, series_uid, sop_uid);
        spec.rows = 1;
        spec.columns = 1;

        let input_path = services.temp_dir.path().join("small.dcm");
        let input =
            write_valid_dicom_with_pixel_data(&input_path, &spec).expect("write small DICOM");
        let input_size = std::fs::metadata(&input_path)
            .expect("stat small DICOM")
            .len();
        assert!(
            input_size < max_store_object_bytes,
            "small fixture should stay below configured store limit: {input_size} >= {max_store_object_bytes}"
        );

        let outcome = services
            .services
            .store_scu
            .send_files(&node, &[input.path])
            .expect("send small file");
        let report = storage_scp.stop().expect("stop storage scp");
        let managed_path = managed_file_path(
            &services.services.paths.managed_store_dir,
            study_uid,
            series_uid,
            sop_uid,
        );

        assert_eq!(outcome.attempted, 1);
        assert_eq!(outcome.sent, 1);
        assert_eq!(outcome.failed, 0);
        assert_eq!(report.received, 1);
        assert_eq!(report.stored, 1);
        assert_eq!(report.failed, 0);
        assert!(managed_path.exists());
        assert_eq!(database_instance_count(&services, sop_uid), 1);
    });
}

fn dicom_file(
    path: PathBuf,
    sop_instance_uid: &str,
    transfer_syntax_uid: &str,
    pixel_byte: u8,
) -> common::TestDicomFile {
    let mut spec = TestDicomSpec::new(
        "1.2.826.0.1.3680043.10.201.1",
        "1.2.826.0.1.3680043.10.201.1.1",
        sop_instance_uid,
    );
    spec.transfer_syntax_uid = transfer_syntax_uid.to_string();
    spec.pixel_byte = pixel_byte;
    write_valid_dicom_with_pixel_data(&path, &spec).expect("write test DICOM")
}

fn database_instance_count(services: &TestServices, sop_instance_uid: &str) -> i64 {
    let conn = Connection::open(&services.services.paths.sqlite_db).expect("open sqlite db");
    conn.query_row(
        "SELECT COUNT(*) FROM local_instances WHERE sop_instance_uid = ?1",
        [sop_instance_uid],
        |row| row.get(0),
    )
    .expect("query instance count")
}
