mod common;

use std::time::Duration;

use dicom_node_client::models::{QueryCriteria, QueryLevel, QueryModel};

use common::harness::{query_scp::MalformedResponseMode, QueryScp};
use common::{run_with_timeout, TestServices};

#[test]
fn c_find_reports_transport_interruption_when_peer_closes_without_final_response() {
    run_with_timeout(Duration::from_secs(10), || {
        let query_scp = QueryScp::builder()
            .expect("build query scp")
            .hold_final_response(true)
            .spawn()
            .expect("spawn query scp");

        let services = TestServices::new().expect("create test services");
        let node = query_scp.remote_node("query-scp");
        services
            .services
            .db
            .upsert_remote_node(&node)
            .expect("save remote node");

        let err = services
            .services
            .find_scu
            .query(
                &node,
                &QueryCriteria {
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    ..QueryCriteria::default()
                },
            )
            .expect_err("query should fail");

        let message = format!("{err:#}");
        assert!(
            message.contains("Connection closed by peer"),
            "expected transport interruption error message, got: {message}"
        );

        drop(query_scp);
    });
}

#[test]
fn c_find_reports_transport_interruption_when_peer_drops_connection_mid_response() {
    run_with_timeout(Duration::from_secs(10), || {
        let query_scp = QueryScp::builder()
            .expect("build query scp")
            .matches(vec![dicom_node_client::models::QueryMatch {
                level: QueryLevel::Study,
                patient_name: None,
                patient_id: Some("TEST".to_string()),
                accession_number: None,
                study_instance_uid: None,
                series_instance_uid: None,
                sop_instance_uid: None,
                study_date: None,
                study_description: None,
                series_description: None,
                series_number: None,
                modality: None,
                instance_number: None,
            }])
            .malformed_response_mode(MalformedResponseMode::CloseAfterFirstPending)
            .spawn()
            .expect("spawn query scp");

        let services = TestServices::new().expect("create test services");
        let node = query_scp.remote_node("query-scp");
        services
            .services
            .db
            .upsert_remote_node(&node)
            .expect("save remote node");

        let err = services
            .services
            .find_scu
            .query(
                &node,
                &QueryCriteria {
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    ..QueryCriteria::default()
                },
            )
            .expect_err("query should fail");

        let message = format!("{err:#}");
        assert!(
            message.contains("Connection closed by peer"),
            "expected transport interruption error message, got: {message}"
        );

        drop(query_scp);
    });
}
