use dicom_node_client::summary::{
    DicomAETitles, FailureDetail, NetworkPeer, OperationCounts, OperationKind, OperationStatus,
    OperationSummary,
};

#[test]
fn summary_json_is_stable() {
    let mut s = OperationSummary::new(OperationKind::RetrieveMove, 2500, OperationStatus::Warning);
    s.peer = Some(NetworkPeer {
        host: "dicom.example".to_string(),
        port: 11112,
    });
    s.ae_titles = Some(DicomAETitles {
        calling: "CALLING_AE".to_string(),
        called: "CALLED_AE".to_string(),
        move_destination: Some("DEST_AE".to_string()),
    });
    s.criteria = Some(serde_json::json!({
        "level": "study",
        "patient_id": "123",
        "study_instance_uid": "1.2.3"
    }));
    s.counts = OperationCounts {
        requested: Some(10),
        received: Some(9),
        failed: Some(1),
        ..OperationCounts::default()
    };
    s.failures.push(FailureDetail {
        message: "one instance failed".to_string(),
        code: Some("0xA700".to_string()),
    });

    let v = serde_json::to_value(&s).unwrap();

    // Machine JSON keys stay English snake_case even after UI localization.
    // Top-level fields (explicitly asserted to prevent accidental renames/removals)
    assert_eq!(v["version"], 1);
    assert_eq!(v["kind"], "retrieve_move");
    assert_eq!(v["duration_ms"], 2500);
    assert_eq!(v["status"], "warning");

    // Nested objects / optional fields presence
    assert_eq!(v["peer"]["host"], "dicom.example");
    assert_eq!(v["peer"]["port"], 11112);

    assert_eq!(v["ae_titles"]["calling"], "CALLING_AE");
    assert_eq!(v["ae_titles"]["called"], "CALLED_AE");
    assert_eq!(v["ae_titles"]["move_destination"], "DEST_AE");

    assert_eq!(v["criteria"]["level"], "study");

    // Counts should serialize only the set fields
    assert_eq!(v["counts"]["requested"], 10);
    assert_eq!(v["counts"]["received"], 9);
    assert_eq!(v["counts"]["failed"], 1);
    assert!(v["counts"].get("matched").is_none());

    // Failures array shape
    assert_eq!(v["failures"][0]["message"], "one instance failed");
    assert_eq!(v["failures"][0]["code"], "0xA700");

    // Logs default to absent (because empty vec is skipped)
    assert!(v.get("logs").is_none());
}

#[test]
fn summary_json_field_names_stay_english_machine_keys() {
    let mut s = OperationSummary::new(OperationKind::QueryFind, 10, OperationStatus::Success);
    s.peer = Some(NetworkPeer {
        host: "pacs".to_string(),
        port: 104,
    });
    s.failures.push(FailureDetail {
        message: "unused".to_string(),
        code: Some("0x0000".to_string()),
    });

    let v = serde_json::to_value(&s).unwrap();
    let top = v.as_object().expect("summary JSON object");
    for key in [
        "version",
        "kind",
        "duration_ms",
        "status",
        "peer",
        "counts",
        "failures",
    ] {
        assert!(
            top.contains_key(key),
            "machine JSON must keep English key '{key}', got {:?}",
            top.keys().collect::<Vec<_>>()
        );
    }

    let peer = v["peer"].as_object().expect("peer object");
    assert!(peer.contains_key("host"));
    assert!(peer.contains_key("port"));
    assert!(!peer.contains_key("hospedeiro"));
    assert!(!peer.contains_key("puerto"));

    let failure = v["failures"][0].as_object().expect("failure object");
    assert!(failure.contains_key("message"));
    assert!(failure.contains_key("code"));

    assert_eq!(v["kind"], "query_find");
    assert_eq!(v["status"], "success");
}
