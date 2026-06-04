mod common;

use std::time::Duration;

use common::{
    create_test_study, harness::StoreScp, remote_node_fixture, run_with_timeout, TestServices,
    TestStudy,
};
use dicom_node_client::{
    archive::{ArchiveCatalogRead, RetrieveSelector},
    models::{MoveRequest, QueryLevel, QueryModel},
};

#[test]
fn local_archive_c_move_scp_sends_study_to_configured_destination() {
    run_with_timeout(Duration::from_secs(20), || {
        let services = TestServices::new().expect("create services");
        let study = import_source_study(&services, "1.2.826.0.1.3680043.10.840.1");

        let destination_scp = StoreScp::builder()
            .expect("build destination storage SCP")
            .ae_title("MOVEDEST")
            .spawn()
            .expect("spawn destination storage SCP");
        let destination_node = destination_scp.remote_node("move-dest");
        services
            .services
            .db
            .upsert_remote_node(&destination_node)
            .expect("save move destination node");

        let source_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local archive C-MOVE SCP");
        let source_node = remote_node_fixture(
            "local-archive-source",
            &services.services.config.local_ae_title,
            source_scp.port(),
        );

        let outcome = services
            .services
            .move_scu
            .retrieve(
                &source_node,
                &MoveRequest {
                    node_name_or_id: source_node.name.clone(),
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    study_instance_uid: study.study_instance_uid.clone(),
                    series_instance_uid: None,
                    sop_instance_uid: None,
                    move_destination: Some(destination_node.ae_title.clone()),
                },
            )
            .expect("retrieve study from local archive C-MOVE SCP");

        assert_eq!(outcome.final_status, 0x0000);
        assert_eq!(outcome.completed, study.files.len() as u32);
        assert_eq!(outcome.failed, 0);
        assert_eq!(outcome.warning, 0);

        source_scp.stop().expect("stop local archive C-MOVE SCP");
        let metrics = services.services.storage_scp.metrics_snapshot();
        let received = destination_scp
            .stop_with_instances()
            .expect("stop destination storage SCP");
        assert_eq!(metrics.c_move_requests_total, 1);
        assert_eq!(
            metrics.c_move_suboperations_completed_total,
            study.files.len() as u64
        );
        assert_eq!(metrics.c_move_suboperations_failed_total, 0);
        assert_eq!(received.len(), study.files.len());
        let mut received_uids = received
            .iter()
            .map(|store| store.sop_instance_uid.clone())
            .collect::<Vec<_>>();
        received_uids.sort();
        let mut expected_uids = study
            .files
            .iter()
            .map(|file| file.sop_instance_uid.clone())
            .collect::<Vec<_>>();
        expected_uids.sort();
        assert_eq!(received_uids, expected_uids);
    });
}

#[test]
fn local_archive_c_move_scp_reports_unknown_destination() {
    run_with_timeout(Duration::from_secs(20), || {
        let services = TestServices::new().expect("create services");
        let study = import_source_study(&services, "1.2.826.0.1.3680043.10.840.2");
        let source_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local archive C-MOVE SCP");
        let source_node = remote_node_fixture(
            "local-archive-source",
            &services.services.config.local_ae_title,
            source_scp.port(),
        );

        let outcome = services
            .services
            .move_scu
            .retrieve(
                &source_node,
                &MoveRequest {
                    node_name_or_id: source_node.name.clone(),
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    study_instance_uid: study.study_instance_uid.clone(),
                    series_instance_uid: None,
                    sop_instance_uid: None,
                    move_destination: Some("UNKNOWNDEST".to_string()),
                },
            )
            .expect("retrieve with unknown destination returns DIMSE failure outcome");

        assert_eq!(outcome.final_status, 0xA801);
        assert_eq!(outcome.completed, 0);
        assert_eq!(outcome.failed, study.files.len() as u32);
        source_scp.stop().expect("stop local archive C-MOVE SCP");
    });
}

#[test]
fn local_archive_c_move_scp_reports_partial_suboperation_failure() {
    run_with_timeout(Duration::from_secs(20), || {
        let services = TestServices::new().expect("create services");
        let study = import_source_study(&services, "1.2.826.0.1.3680043.10.840.3");
        let instances = services
            .services
            .archive_catalog
            .instances_for_retrieve(RetrieveSelector::Study {
                study_instance_uid: study.study_instance_uid.clone(),
            })
            .expect("resolve imported instances");
        std::fs::remove_file(&instances[0].managed_path).expect("remove one managed file");

        let destination_scp = StoreScp::builder()
            .expect("build destination storage SCP")
            .ae_title("MOVEPART")
            .spawn()
            .expect("spawn destination storage SCP");
        let destination_node = destination_scp.remote_node("move-partial");
        services
            .services
            .db
            .upsert_remote_node(&destination_node)
            .expect("save move destination node");

        let source_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local archive C-MOVE SCP");
        let source_node = remote_node_fixture(
            "local-archive-source",
            &services.services.config.local_ae_title,
            source_scp.port(),
        );

        let outcome = services
            .services
            .move_scu
            .retrieve(
                &source_node,
                &MoveRequest {
                    node_name_or_id: source_node.name.clone(),
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    study_instance_uid: study.study_instance_uid.clone(),
                    series_instance_uid: None,
                    sop_instance_uid: None,
                    move_destination: Some(destination_node.ae_title.clone()),
                },
            )
            .expect("retrieve with one missing local file returns warning outcome");

        assert_eq!(outcome.final_status, 0xB000);
        assert_eq!(outcome.completed, study.files.len() as u32 - 1);
        assert_eq!(outcome.failed, 1);

        source_scp.stop().expect("stop local archive C-MOVE SCP");
        let metrics = services.services.storage_scp.metrics_snapshot();
        let received = destination_scp
            .stop_with_instances()
            .expect("stop destination storage SCP");
        assert_eq!(metrics.c_move_requests_total, 1);
        assert_eq!(metrics.c_move_suboperations_failed_total, 1);
        assert_eq!(received.len(), study.files.len() - 1);
    });
}

fn import_source_study(services: &TestServices, study_uid: &str) -> TestStudy {
    let source_dir = services
        .temp_dir
        .path()
        .join(format!("move-scp-source-{}", study_uid.replace('.', "-")));
    let study = create_test_study(&source_dir, study_uid, 2, 2).expect("create source study");
    services
        .services
        .import_path(&source_dir)
        .expect("import source study into local archive");
    study
}
