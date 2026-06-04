mod common;

use common::TestServices;
use dicom_dictionary_std::tags;
use dicom_node_client::{
    archive::{
        ArchiveCatalogRead, ArchiveCatalogWrite, ArchiveQuery, AttributePath, MatchingRule,
        QueryPredicate, SqliteArchiveCatalog,
    },
    models::{LocalInstance, QueryLevel, QueryModel},
};

fn instance(
    study_uid: &str,
    series_uid: &str,
    sop_uid: &str,
    patient_id: &str,
    patient_name: &str,
    study_date: &str,
    modality: &str,
    accession_number: Option<&str>,
    attributes_json: Option<&str>,
) -> LocalInstance {
    LocalInstance {
        study_instance_uid: study_uid.to_string(),
        series_instance_uid: series_uid.to_string(),
        sop_instance_uid: sop_uid.to_string(),
        sop_class_uid: "1.2.840.10008.5.1.4.1.1.2".to_string(),
        transfer_syntax_uid: Some("1.2.840.10008.1.2.1".to_string()),
        patient_id: Some(patient_id.to_string()),
        patient_name: Some(patient_name.to_string()),
        accession_number: accession_number.map(str::to_string),
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
        attributes_json: attributes_json.map(str::to_string),
        imported_at: "2026-06-04T00:00:00Z".to_string(),
    }
}

fn seed_catalog(catalog: &SqliteArchiveCatalog) {
    for item in [
        instance(
            "1.2.840.100.1",
            "1.2.840.100.1.1",
            "1.2.840.100.1.1.1",
            "PAT-1",
            "DOE^JOHN",
            "20260115",
            "CT",
            Some("ACC-1"),
            Some(r#"{"Manufacturer":"ACME Scanner"}"#),
        ),
        instance(
            "1.2.840.100.1",
            "1.2.840.100.1.2",
            "1.2.840.100.1.2.1",
            "PAT-1",
            "DOE^JOHN",
            "20260115",
            "MR",
            Some("ACC-1"),
            Some(r#"{"Manufacturer":"ACME Scanner"}"#),
        ),
        instance(
            "1.2.840.100.2",
            "1.2.840.100.2.1",
            "1.2.840.100.2.1.1",
            "PAT-2",
            "DOE^JANE",
            "20260201",
            "CT",
            Some("ACC-2"),
            None,
        ),
        instance(
            "1.2.840.100.3",
            "1.2.840.100.3.1",
            "1.2.840.100.3.1.1",
            "PAT-3",
            "EMPTY^ACCESSION",
            "20260301",
            "US",
            None,
            None,
        ),
    ] {
        catalog.upsert_instance(&item).expect("seed catalog");
    }
}

#[test]
fn get_study_counts_instances_once_across_series() {
    let fixture = TestServices::new().expect("create services");
    let catalog = &fixture.services.archive_catalog;
    seed_catalog(catalog);

    let study = catalog
        .get_study("1.2.840.100.1")
        .expect("get study")
        .expect("study exists");

    assert_eq!(study.series_count, 2);
    assert_eq!(study.instance_count, 2);
}

#[test]
fn study_root_matching_rules_are_parameterized_and_distinct_by_study() {
    let fixture = TestServices::new().expect("create services");
    let catalog = &fixture.services.archive_catalog;
    seed_catalog(catalog);

    let query = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Study)
        .with_predicate(QueryPredicate::new(
            tags::PATIENT_NAME,
            MatchingRule::Wildcard("DOE^JO*".to_string()),
        ))
        .with_predicate(QueryPredicate::new(
            tags::STUDY_DATE,
            MatchingRule::Range {
                start: Some("20260101".to_string()),
                end: Some("20260131".to_string()),
            },
        ))
        .with_predicate(QueryPredicate::new(
            tags::STUDY_INSTANCE_UID,
            MatchingRule::UidList(vec![
                "1.2.840.100.1".to_string(),
                "1.2.840.100.2".to_string(),
            ]),
        ))
        .with_return_key(tags::STUDY_INSTANCE_UID)
        .with_return_key(tags::PATIENT_NAME);

    let compiled = query.compile().expect("compile query");
    assert!(!compiled.sql.contains("DOE^JO"));
    assert_eq!(compiled.params[0], "DOE^JO%");

    let entries = catalog.query_dicom(&query).expect("query catalog");
    assert_eq!(entries.len(), 1);
    assert_eq!(
        entries[0]
            .object
            .element(tags::STUDY_INSTANCE_UID)
            .expect("study uid return key")
            .to_str()
            .expect("study uid string")
            .trim_end_matches('\0'),
        "1.2.840.100.1"
    );

    let empty_query = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Study)
        .with_predicate(QueryPredicate::new(
            tags::ACCESSION_NUMBER,
            MatchingRule::EmptyValue,
        ))
        .with_return_key(tags::STUDY_INSTANCE_UID);
    let empty_entries = catalog
        .query_dicom(&empty_query)
        .expect("query empty value");
    assert_eq!(empty_entries.len(), 1);
    assert_eq!(
        empty_entries[0]
            .object
            .element(tags::STUDY_INSTANCE_UID)
            .expect("study uid return key")
            .to_str()
            .expect("study uid string")
            .trim_end_matches('\0'),
        "1.2.840.100.3"
    );
}

#[test]
fn study_root_query_returns_series_and_image_levels() {
    let fixture = TestServices::new().expect("create services");
    let catalog = &fixture.services.archive_catalog;
    seed_catalog(catalog);

    let series_query = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Series)
        .with_predicate(QueryPredicate::new(
            tags::STUDY_INSTANCE_UID,
            MatchingRule::SingleValue("1.2.840.100.1".to_string()),
        ))
        .with_predicate(QueryPredicate::new(
            tags::MODALITY,
            MatchingRule::SingleValue("MR".to_string()),
        ))
        .with_return_key(tags::SERIES_INSTANCE_UID)
        .with_return_key(tags::MODALITY);
    let series_entries = catalog.query_dicom(&series_query).expect("query series");
    assert_eq!(series_entries.len(), 1);
    assert_eq!(
        series_entries[0]
            .object
            .element(tags::SERIES_INSTANCE_UID)
            .expect("series uid return key")
            .to_str()
            .expect("series uid string")
            .trim_end_matches('\0'),
        "1.2.840.100.1.2"
    );

    let image_query = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Image)
        .with_predicate(QueryPredicate::new(
            tags::SERIES_INSTANCE_UID,
            MatchingRule::UidList(vec!["1.2.840.100.1.1".to_string()]),
        ))
        .with_return_key(tags::SOP_INSTANCE_UID)
        .with_return_key(tags::INSTANCE_NUMBER);
    let image_entries = catalog.query_dicom(&image_query).expect("query image");
    assert_eq!(image_entries.len(), 1);
    assert_eq!(
        image_entries[0]
            .object
            .element(tags::SOP_INSTANCE_UID)
            .expect("sop uid return key")
            .to_str()
            .expect("sop uid string")
            .trim_end_matches('\0'),
        "1.2.840.100.1.1.1"
    );
}

#[test]
fn patient_root_levels_are_supported_and_study_root_rejects_patient_level() {
    let fixture = TestServices::new().expect("create services");
    let catalog = &fixture.services.archive_catalog;
    seed_catalog(catalog);

    let patient_query = ArchiveQuery::new(QueryModel::PatientRoot, QueryLevel::Patient)
        .with_predicate(QueryPredicate::new(
            tags::PATIENT_NAME,
            MatchingRule::Wildcard("DOE^J*".to_string()),
        ))
        .with_return_key(tags::PATIENT_ID)
        .with_return_key(tags::PATIENT_NAME);
    let patient_entries = catalog
        .query_dicom(&patient_query)
        .expect("query patient root patient level");
    assert_eq!(patient_entries.len(), 2);

    let patient_study_query = ArchiveQuery::new(QueryModel::PatientRoot, QueryLevel::Study)
        .with_predicate(QueryPredicate::new(
            tags::PATIENT_ID,
            MatchingRule::SingleValue("PAT-2".to_string()),
        ))
        .with_return_key(tags::STUDY_INSTANCE_UID);
    let study_entries = catalog
        .query_dicom(&patient_study_query)
        .expect("query patient root study level");
    assert_eq!(study_entries.len(), 1);

    let rejected = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Patient)
        .with_return_key(tags::PATIENT_ID)
        .compile()
        .expect_err("study root must reject patient level");
    assert!(rejected.to_string().contains("Study Root"));
}

#[test]
fn return_key_falls_back_to_attributes_json_when_not_column_mapped() {
    let fixture = TestServices::new().expect("create services");
    let catalog = &fixture.services.archive_catalog;
    seed_catalog(catalog);

    let query = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Image)
        .with_predicate(QueryPredicate::new(
            tags::SOP_INSTANCE_UID,
            MatchingRule::SingleValue("1.2.840.100.1.1.1".to_string()),
        ))
        .with_return_key(tags::SOP_INSTANCE_UID)
        .with_return_path(AttributePath::tag(tags::MANUFACTURER));

    let entries = catalog.query_dicom(&query).expect("query image");
    assert_eq!(entries.len(), 1);
    assert_eq!(
        entries[0]
            .object
            .element(tags::MANUFACTURER)
            .expect("manufacturer return key")
            .to_str()
            .expect("manufacturer string")
            .trim_end_matches('\0'),
        "ACME Scanner"
    );
}

#[test]
fn study_and_series_return_keys_include_related_counts() {
    let fixture = TestServices::new().expect("create services");
    let catalog = &fixture.services.archive_catalog;
    seed_catalog(catalog);

    let study_query = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Study)
        .with_predicate(QueryPredicate::new(
            tags::STUDY_INSTANCE_UID,
            MatchingRule::SingleValue("1.2.840.100.1".to_string()),
        ))
        .with_return_key(tags::NUMBER_OF_STUDY_RELATED_SERIES)
        .with_return_key(tags::NUMBER_OF_STUDY_RELATED_INSTANCES);
    let study_entries = catalog
        .query_dicom(&study_query)
        .expect("query study counts");
    assert_eq!(study_entries.len(), 1);
    assert_eq!(
        study_entries[0]
            .object
            .element(tags::NUMBER_OF_STUDY_RELATED_SERIES)
            .expect("study series count")
            .to_str()
            .expect("study series count string")
            .trim_end_matches('\0'),
        "2"
    );
    assert_eq!(
        study_entries[0]
            .object
            .element(tags::NUMBER_OF_STUDY_RELATED_INSTANCES)
            .expect("study instance count")
            .to_str()
            .expect("study instance count string")
            .trim_end_matches('\0'),
        "2"
    );

    let series_query = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Series)
        .with_predicate(QueryPredicate::new(
            tags::SERIES_INSTANCE_UID,
            MatchingRule::SingleValue("1.2.840.100.1.1".to_string()),
        ))
        .with_return_key(tags::NUMBER_OF_SERIES_RELATED_INSTANCES);
    let series_entries = catalog
        .query_dicom(&series_query)
        .expect("query series counts");
    assert_eq!(series_entries.len(), 1);
    assert_eq!(
        series_entries[0]
            .object
            .element(tags::NUMBER_OF_SERIES_RELATED_INSTANCES)
            .expect("series instance count")
            .to_str()
            .expect("series instance count string")
            .trim_end_matches('\0'),
        "1"
    );
}
