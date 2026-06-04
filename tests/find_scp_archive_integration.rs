mod common;

use std::time::Duration;

use common::{remote_node_fixture, run_with_timeout, TestServices};
use dicom_node_client::{
    archive::ArchiveCatalogWrite,
    models::{LocalInstance, QueryCriteria, QueryLevel, QueryModel},
};

fn instance(
    study_uid: &str,
    series_uid: &str,
    sop_uid: &str,
    patient_id: &str,
    patient_name: &str,
    study_date: &str,
    modality: &str,
) -> LocalInstance {
    LocalInstance {
        study_instance_uid: study_uid.to_string(),
        series_instance_uid: series_uid.to_string(),
        sop_instance_uid: sop_uid.to_string(),
        sop_class_uid: "1.2.840.10008.5.1.4.1.1.2".to_string(),
        transfer_syntax_uid: Some("1.2.840.10008.1.2.1".to_string()),
        patient_id: Some(patient_id.to_string()),
        patient_name: Some(patient_name.to_string()),
        accession_number: Some(format!("ACC-{patient_id}")),
        study_date: Some(study_date.to_string()),
        study_description: Some(format!("Study {study_uid}")),
        series_description: Some(format!("Series {series_uid}")),
        series_number: Some(series_uid.rsplit('.').next().unwrap_or("1").to_string()),
        modality: Some(modality.to_string()),
        instance_number: Some(sop_uid.rsplit('.').next().unwrap_or("1").to_string()),
        file_size_bytes: 128,
        sha256: format!("sha256-{sop_uid}"),
        source_path: format!("test://{sop_uid}"),
        managed_path: format!("/tmp/{sop_uid}.dcm"),
        attributes_json: None,
        imported_at: "2026-06-04T00:00:00Z".to_string(),
    }
}

#[test]
fn local_archive_c_find_scp_returns_study_level_matches() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create services");
        for item in [
            instance(
                "1.2.826.0.1.3680043.10.820.1",
                "1.2.826.0.1.3680043.10.820.1.1",
                "1.2.826.0.1.3680043.10.820.1.1.1",
                "PAT-82",
                "FIND^ONE",
                "20260110",
                "CT",
            ),
            instance(
                "1.2.826.0.1.3680043.10.820.2",
                "1.2.826.0.1.3680043.10.820.2.1",
                "1.2.826.0.1.3680043.10.820.2.1.1",
                "PAT-82",
                "FIND^ONE",
                "20260120",
                "MR",
            ),
            instance(
                "1.2.826.0.1.3680043.10.820.3",
                "1.2.826.0.1.3680043.10.820.3.1",
                "1.2.826.0.1.3680043.10.820.3.1.1",
                "PAT-OTHER",
                "FIND^TWO",
                "20260115",
                "CT",
            ),
        ] {
            services
                .services
                .archive_catalog
                .upsert_instance(&item)
                .expect("seed local archive");
        }

        let scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn local archive SCP");
        let node = remote_node_fixture(
            "local-archive-scp",
            &services.services.config.local_ae_title,
            scp.port(),
        );

        let matches = services
            .services
            .find_scu
            .query(
                &node,
                &QueryCriteria {
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    patient_id: Some("PAT-82".to_string()),
                    study_date_from: Some("20260101".to_string()),
                    study_date_to: Some("20260131".to_string()),
                    ..QueryCriteria::default()
                },
            )
            .expect("query local archive SCP");

        let mut study_uids = matches
            .iter()
            .filter_map(|query_match| query_match.study_instance_uid.clone())
            .collect::<Vec<_>>();
        study_uids.sort();
        assert_eq!(
            study_uids,
            vec![
                "1.2.826.0.1.3680043.10.820.1".to_string(),
                "1.2.826.0.1.3680043.10.820.2".to_string(),
            ]
        );
        assert!(matches.iter().all(|query_match| {
            query_match.patient_id.as_deref() == Some("PAT-82")
                && query_match.study_date.as_deref().is_some()
                && query_match.modality.as_deref().is_some()
        }));

        let report = scp.stop().expect("stop local archive SCP");
        let metrics = services.services.storage_scp.metrics_snapshot();
        assert_eq!(report.failed, 0);
        assert_eq!(metrics.c_find_requests_total, 1);
        assert_eq!(metrics.c_find_matches_total, 2);
    });
}
