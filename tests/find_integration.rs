mod common;

use std::time::Duration;

use dicom_node_client::models::{QueryCriteria, QueryLevel, QueryMatch, QueryModel};

use common::{
    harness::{query_scp::study_match, QueryScp},
    run_with_timeout, TestServices,
};

#[test]
fn c_find_returns_filtered_study_and_series_matches() {
    run_with_timeout(Duration::from_secs(10), || {
        let fixtures = query_fixtures();
        let query_scp = QueryScp::builder()
            .expect("build query scp")
            .matches(fixtures.clone())
            .spawn()
            .expect("spawn query scp");
        let services = TestServices::new().expect("create test services");
        let node = query_scp.remote_node("query-scp");
        services
            .services
            .db
            .upsert_remote_node(&node)
            .expect("save remote node");

        let ct_studies = services
            .services
            .find_scu
            .query(
                &node,
                &QueryCriteria {
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    modality: Some("CT".to_string()),
                    ..QueryCriteria::default()
                },
            )
            .expect("query CT studies");
        assert_eq!(
            study_uids(&ct_studies),
            vec![
                "1.2.826.0.1.3680043.10.200.1".to_string(),
                "1.2.826.0.1.3680043.10.200.3".to_string(),
            ]
        );

        let patient_study = services
            .services
            .find_scu
            .query(
                &node,
                &QueryCriteria {
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    patient_id: Some("MRN-002".to_string()),
                    ..QueryCriteria::default()
                },
            )
            .expect("query by patient id");
        assert_eq!(
            study_uids(&patient_study),
            vec!["1.2.826.0.1.3680043.10.200.2".to_string()]
        );

        let wildcard_study = services
            .services
            .find_scu
            .query(
                &node,
                &QueryCriteria {
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    patient_name: Some("ALPHA*ON?".to_string()),
                    ..QueryCriteria::default()
                },
            )
            .expect("query by wildcard patient name");
        assert_eq!(
            study_uids(&wildcard_study),
            vec!["1.2.826.0.1.3680043.10.200.1".to_string()]
        );

        let series = services
            .services
            .find_scu
            .query(
                &node,
                &QueryCriteria {
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Series,
                    study_instance_uid: Some("1.2.826.0.1.3680043.10.200.1".to_string()),
                    ..QueryCriteria::default()
                },
            )
            .expect("query study series");
        assert_eq!(
            series_uids(&series),
            vec![
                "1.2.826.0.1.3680043.10.200.1.1".to_string(),
                "1.2.826.0.1.3680043.10.200.1.2".to_string(),
            ]
        );

        let empty = services
            .services
            .find_scu
            .query(
                &node,
                &QueryCriteria {
                    model: QueryModel::StudyRoot,
                    level: QueryLevel::Study,
                    accession_number: Some("NO-SUCH-ACCESSION".to_string()),
                    ..QueryCriteria::default()
                },
            )
            .expect("query no-match accession");
        assert!(empty.is_empty());

        let received = query_scp.stop().expect("stop query scp");
        assert_eq!(received.len(), 5);
        assert_eq!(
            received
                .iter()
                .filter(|query| query.level.as_deref() == Some("STUDY"))
                .count(),
            4
        );
        assert_eq!(
            received
                .iter()
                .filter(|query| query.level.as_deref() == Some("SERIES"))
                .count(),
            1
        );
    });
}

fn query_fixtures() -> Vec<QueryMatch> {
    let mut study_1 = study_match("1.2.826.0.1.3680043.10.200.1");
    study_1.patient_name = Some("ALPHA^ONE".to_string());
    study_1.patient_id = Some("MRN-001".to_string());
    study_1.accession_number = Some("ACC-001".to_string());
    study_1.study_description = Some("CT HEAD".to_string());
    study_1.modality = Some("CT".to_string());

    let mut study_2 = study_match("1.2.826.0.1.3680043.10.200.2");
    study_2.patient_name = Some("BETA^TWO".to_string());
    study_2.patient_id = Some("MRN-002".to_string());
    study_2.accession_number = Some("ACC-002".to_string());
    study_2.study_description = Some("MR KNEE".to_string());
    study_2.modality = Some("MR".to_string());

    let mut study_3 = study_match("1.2.826.0.1.3680043.10.200.3");
    study_3.patient_name = Some("GAMMA^THREE".to_string());
    study_3.patient_id = Some("MRN-003".to_string());
    study_3.accession_number = Some("ACC-003".to_string());
    study_3.study_description = Some("CT CHEST".to_string());
    study_3.modality = Some("CT".to_string());

    let mut series_1 = study_1.clone();
    series_1.level = QueryLevel::Series;
    series_1.series_instance_uid = Some("1.2.826.0.1.3680043.10.200.1.1".to_string());
    series_1.series_number = Some("1".to_string());
    series_1.series_description = Some("AXIAL".to_string());

    let mut series_2 = study_1.clone();
    series_2.level = QueryLevel::Series;
    series_2.series_instance_uid = Some("1.2.826.0.1.3680043.10.200.1.2".to_string());
    series_2.series_number = Some("2".to_string());
    series_2.series_description = Some("CORONAL".to_string());

    vec![study_1, study_2, study_3, series_1, series_2]
}

fn study_uids(matches: &[QueryMatch]) -> Vec<String> {
    matches
        .iter()
        .filter_map(|query_match| query_match.study_instance_uid.clone())
        .collect()
}

fn series_uids(matches: &[QueryMatch]) -> Vec<String> {
    matches
        .iter()
        .filter_map(|query_match| query_match.series_instance_uid.clone())
        .collect()
}
