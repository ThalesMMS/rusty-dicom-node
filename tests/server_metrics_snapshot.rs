use dicom_node_client::net::ServerMetrics;

#[test]
fn default_operational_metrics_snapshot_does_not_include_phi_fields() {
    let metrics = ServerMetrics::default();
    metrics.record_c_find_matches(2);

    let json = serde_json::to_string(&metrics.snapshot()).expect("serialize metrics snapshot");

    assert!(!json.contains("PatientName"));
    assert!(!json.contains("PatientID"));
    assert!(!json.contains("PAT-"));
}
