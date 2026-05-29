mod common;

use std::time::Duration;

use common::{
    harness::{query_scp::MalformedResponseMode, QueryScp},
    run_with_timeout, TestServices,
};
use dicom_node_client::models::{QueryCriteria, QueryLevel, QueryModel};

#[test]
fn c_find_surfaces_malformed_response_error_when_status_missing() {
    run_with_timeout(Duration::from_secs(10), || {
        let query_scp = QueryScp::builder()
            .expect("build query scp")
            .malformed_response_mode(MalformedResponseMode::MissingStatus)
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
            .expect_err("expected malformed response error");

        let message = err.to_string();
        assert!(
            message.contains("malformed") || message.contains("Malformed"),
            "unexpected error message: {message}"
        );
        assert!(
            message.contains("Status") || message.contains("status"),
            "expected status mention in error message: {message}"
        );

        // The SCU may abort the association after detecting malformed DIMSE.
        // In that case, the test harness can observe a closed connection.
        let _ = query_scp.stop();
    });
}
