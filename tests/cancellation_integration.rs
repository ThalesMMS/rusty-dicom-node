mod common;

use std::sync::atomic::{AtomicBool, Ordering};
use std::time::Duration;

use common::{
    create_test_study,
    harness::{MoveScp, QueryScp},
    run_with_timeout, TestServices,
};
use dicom_node_client::models::{MoveRequest, QueryCriteria, QueryLevel, QueryModel};

#[test]
fn c_find_cancellation_returns_promptly_and_does_not_collect_all_matches() {
    run_with_timeout(Duration::from_secs(10), || {
        let fixtures = vec![
            common::harness::query_scp::study_match("1.2.826.0.1.3680043.10.200.1"),
            common::harness::query_scp::study_match("1.2.826.0.1.3680043.10.200.2"),
            common::harness::query_scp::study_match("1.2.826.0.1.3680043.10.200.3"),
            common::harness::query_scp::study_match("1.2.826.0.1.3680043.10.200.4"),
            common::harness::query_scp::study_match("1.2.826.0.1.3680043.10.200.5"),
        ];

        let query_scp = QueryScp::builder()
            .expect("build query scp")
            .matches(fixtures)
            // A bunch of small fragments to keep receive loop busy.
            .response_dataset_fragments(vec![1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
            .spawn()
            .expect("spawn query scp");

        let services = TestServices::new().expect("create test services");
        let node = query_scp.remote_node("query-scp");
        services
            .services
            .db
            .upsert_remote_node(&node)
            .expect("save remote node");

        let cancel_flag = std::sync::Arc::new(AtomicBool::new(false));

        // Run the query on a background thread so we can cancel mid-flight.
        let handle = std::thread::spawn({
            let find_scu = services.services.find_scu.clone();
            let node = node.clone();
            let cancel_flag = cancel_flag.clone();
            move || {
                find_scu.query_cancellable(
                    &node,
                    &QueryCriteria {
                        model: QueryModel::StudyRoot,
                        level: QueryLevel::Study,
                        ..QueryCriteria::default()
                    },
                    &cancel_flag,
                )
            }
        });

        // Give it a brief moment to connect and start receiving.
        std::thread::sleep(Duration::from_millis(10));
        cancel_flag.store(true, Ordering::Relaxed);

        let err = handle
            .join()
            .expect("query thread panicked")
            .expect_err("expected query to be cancelled");
        assert!(dicom_node_client::cancel::is_cancelled_error(&err));

        // Cancellation may close the association abruptly.
        let _ = query_scp.stop();
    });
}

#[test]
fn c_move_cancellation_stops_after_partial_receive() {
    run_with_timeout(Duration::from_secs(15), || {
        let services = TestServices::new_with_config(|config| {
            config.allowed_calling_aet = vec![];
            config.allowed_peer_ips = vec![];
        })
        .expect("create test services");

        let study = create_test_study(
            &services.temp_dir.path().join("move-source"),
            "1.2.826.0.1.3680043.10.202.99",
            1,
            10,
        )
        .expect("create move source study");

        let file_paths = study
            .files
            .iter()
            .map(|file| file.path.clone())
            .collect::<Vec<_>>();

        let storage_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local storage scp");
        let storage_scp_port = storage_scp.port();

        let move_scp = MoveScp::builder()
            .expect("build move scp")
            .files(file_paths)
            .destination(
                services.services.config.local_ae_title.clone(),
                storage_scp_port,
            )
            .response_command_fragments(vec![1, 1, 1, 1])
            .spawn()
            .expect("spawn move scp");

        let node = move_scp.remote_node("move-scp");
        services
            .services
            .db
            .upsert_remote_node(&node)
            .expect("save move node");

        let request = MoveRequest {
            node_name_or_id: node.name.clone(),
            model: QueryModel::StudyRoot,
            level: QueryLevel::Study,
            study_instance_uid: study.study_instance_uid.clone(),
            series_instance_uid: None,
            sop_instance_uid: None,
            move_destination: Some(services.services.config.local_ae_title.clone()),
        };

        let cancel_flag = std::sync::Arc::new(AtomicBool::new(false));

        // Run the move on a background thread so we can cancel mid-flight.
        let handle = std::thread::spawn({
            let move_scu = services.services.move_scu.clone();
            let node = node.clone();
            let request = request.clone();
            let cancel_flag = cancel_flag.clone();
            move || move_scu.retrieve_cancellable(&node, &request, &cancel_flag)
        });

        // Give it a brief moment to start receiving.
        std::thread::sleep(Duration::from_millis(10));
        cancel_flag.store(true, Ordering::Relaxed);

        let err = handle
            .join()
            .expect("move thread panicked")
            .expect_err("expected move to be cancelled");
        assert!(dicom_node_client::cancel::is_cancelled_error(&err));

        let report = storage_scp.stop().expect("stop local storage scp");
        // We should not have received *all* instances.
        assert!(report.received < 10);

        // Cancellation may close the association abruptly.
        let _ = move_scp.stop();
    });
}
