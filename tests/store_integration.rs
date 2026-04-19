mod common;

use std::{path::PathBuf, time::Duration};

use dicom_dictionary_std::uids::{EXPLICIT_VR_LITTLE_ENDIAN, IMPLICIT_VR_LITTLE_ENDIAN};

use common::{
    harness::StoreScp, run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec,
    TestServices,
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
