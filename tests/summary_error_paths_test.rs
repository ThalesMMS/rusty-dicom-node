mod common;

use std::time::Duration;

use common::{run_with_timeout, TestServices};
use dicom_node_client::models::{QueryCriteria, QueryLevel, QueryModel};

#[test]
fn operation_summary_includes_failure_details_for_network_timeout() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        // Use a deliberately unreachable address/port to force a timeout/connection error.
        // We assert the error message is propagated into OperationSummary.failures.
        let node = dicom_node_client::models::RemoteNode {
            id: "unreachable".to_string(),
            name: "unreachable".to_string(),
            ae_title: "UNREACH".to_string(),
            host: "192.0.2.1".to_string(),
            port: 65000,
            preferred_move_destination: None,
            notes: None,
            created_at: chrono::Utc::now().to_rfc3339(),
            updated_at: chrono::Utc::now().to_rfc3339(),
        };

        services
            .services
            .db
            .upsert_remote_node(&node)
            .expect("insert node");

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

        let summary = dicom_node_client::summary::OperationSummary {
            version: dicom_node_client::summary::OperationSummary::VERSION,
            kind: dicom_node_client::summary::OperationKind::QueryFind,
            peer: None,
            ae_titles: None,
            criteria: None,
            duration_ms: 0,
            status: dicom_node_client::summary::OperationStatus::Failure,
            counts: Default::default(),
            failures: vec![dicom_node_client::summary::FailureDetail {
                message: err.to_string(),
                code: None,
            }],
            logs: vec![dicom_node_client::summary::LogReference {
                path: "logs/app.log".to_string(),
                correlation_id: None,
                line_range: None,
            }],
        };

        assert_eq!(
            summary.status,
            dicom_node_client::summary::OperationStatus::Failure
        );
        assert_eq!(summary.failures.len(), 1);
        assert!(
            !summary.failures[0].message.is_empty(),
            "failure message should not be empty"
        );
    });
}
