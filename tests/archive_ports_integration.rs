mod common;

use std::io::Read;

use common::TestServices;
use dicom_node_client::{
    archive::{
        ArchiveCatalogRead, ArchiveCatalogWrite, ObjectLocator, ObjectReadStore, ObjectWriteStore,
        RetrieveSelector,
    },
    models::LocalInstance,
};

#[test]
fn archive_catalog_and_object_store_round_trip_retrieve_payload_by_study() {
    let fixture = TestServices::new().expect("create test services");
    let payload = b"dicom payload bytes";
    let locator = ObjectLocator::new("study-1", "series-1", "instance-1");

    let mut session = fixture
        .services
        .object_store
        .begin_write(&locator)
        .expect("start object write");
    session.write_chunk(payload).expect("write object payload");
    let stored_object = session.commit().expect("commit object");

    let instance = LocalInstance {
        study_instance_uid: "study-1".to_string(),
        series_instance_uid: "series-1".to_string(),
        sop_instance_uid: "instance-1".to_string(),
        sop_class_uid: "1.2.840.10008.5.1.4.1.1.2".to_string(),
        transfer_syntax_uid: Some("1.2.840.10008.1.2.1".to_string()),
        patient_id: Some("patient-1".to_string()),
        patient_name: Some("Patient^One".to_string()),
        accession_number: Some("accession-1".to_string()),
        study_date: Some("20260604".to_string()),
        study_description: Some("Archive ports round trip".to_string()),
        series_description: Some("Series one".to_string()),
        series_number: Some("1".to_string()),
        modality: Some("CT".to_string()),
        instance_number: Some("1".to_string()),
        file_size_bytes: stored_object.size_bytes,
        sha256: "sha256-placeholder".to_string(),
        source_path: "test://archive-ports".to_string(),
        managed_path: stored_object.path.display().to_string(),
        attributes_json: None,
        imported_at: "2026-06-04T00:00:00Z".to_string(),
    };
    fixture
        .services
        .archive_catalog
        .upsert_instance(&instance)
        .expect("index stored object");

    let resolved = fixture
        .services
        .archive_catalog
        .instances_for_retrieve(RetrieveSelector::Study {
            study_instance_uid: "study-1".to_string(),
        })
        .expect("resolve study instances");
    assert_eq!(resolved.len(), 1);
    assert_eq!(resolved[0].sop_instance_uid, "instance-1");
    assert_eq!(
        resolved[0].managed_path,
        stored_object.path.display().to_string()
    );

    let mut reader = fixture
        .services
        .object_store
        .open(&stored_object)
        .expect("open stored object");
    let mut reopened = Vec::new();
    reader.read_to_end(&mut reopened).expect("read object");

    assert_eq!(reopened, payload);
}
