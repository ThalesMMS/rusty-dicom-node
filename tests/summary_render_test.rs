use dicom_node_client::summary::{
    DicomAETitles, FailureDetail, NetworkPeer, OperationCounts, OperationKind, OperationStatus,
    OperationSummary,
};
use dicom_node_client::summary_render::render_human;

#[test]
fn render_human_includes_key_sections() {
    dicom_node_client::i18n::set_thread_locale(Some(
        "en-US".parse().expect("valid BCP-47 locale"),
    ));
    let mut s = OperationSummary::new(OperationKind::QueryFind, 1234, OperationStatus::Success);
    s.peer = Some(NetworkPeer {
        host: "127.0.0.1".to_string(),
        port: 104,
    });
    s.ae_titles = Some(DicomAETitles {
        calling: "CALLING".to_string(),
        called: "CALLED".to_string(),
        move_destination: None,
    });
    s.criteria = Some(serde_json::json!({"patient_id": "123"}));
    s.counts = OperationCounts {
        matched: Some(7),
        ..OperationCounts::default()
    };
    s.failures.push(FailureDetail {
        message: "some failure".to_string(),
        code: Some("E_TEST".to_string()),
    });

    let out = render_human(&s);

    assert!(out.contains("Operation summary"));
    assert!(out.contains("Kind:"));
    assert!(out.contains("Status:"));
    assert!(out.contains("Duration:"));
    assert!(out.contains("Peer:"));
    assert!(out.contains("AE:"));
    assert!(out.contains("Criteria:"));
    assert!(out.contains("Counts:"));
    assert!(out.contains("Failures:"));
}
