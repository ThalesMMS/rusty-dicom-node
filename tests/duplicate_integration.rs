mod common;

use std::{
    collections::BTreeSet,
    path::{Path, PathBuf},
    time::Duration,
};

use dicom_node_client::models::{MoveRequest, QueryLevel, QueryModel};

use common::{
    create_test_study, harness::MoveScp, run_with_timeout, write_valid_dicom_with_pixel_data,
    TestDicomSpec, TestServices,
};

#[test]
fn importing_same_file_twice_is_idempotent_and_removes_staged_temp_files() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");
        let mut spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.203.1",
            "1.2.826.0.1.3680043.10.203.1.1",
            "1.2.826.0.1.3680043.10.203.1.1.1",
        );
        spec.pixel_byte = 0x31;
        let file = write_valid_dicom_with_pixel_data(
            &services
                .temp_dir
                .path()
                .join("import-source")
                .join("one.dcm"),
            &spec,
        )
        .expect("write import file");

        let first = services
            .services
            .importer
            .import_path(&file.path)
            .expect("first import");
        let second = services
            .services
            .importer
            .import_path(&file.path)
            .expect("second import");

        assert_eq!(first.accepted, 1);
        assert_eq!(first.duplicates, 0);
        assert_eq!(second.accepted, 0);
        assert_eq!(second.duplicates, 1);
        assert_eq!(single_study_instance_count(&services), 1);
        assert_no_orphaned_temp_files(&services.services.paths.managed_store_dir);
    });
}

#[test]
fn retrieving_same_study_twice_keeps_database_and_managed_files_idempotent() {
    run_with_timeout(Duration::from_secs(20), || {
        let services = TestServices::new().expect("create test services");
        let study = create_test_study(
            &services.temp_dir.path().join("retrieve-source"),
            "1.2.826.0.1.3680043.10.204.1",
            1,
            2,
        )
        .expect("create retrieve source study");
        let file_paths = study
            .files
            .iter()
            .map(|file| file.path.clone())
            .collect::<Vec<_>>();
        let storage_scp = services
            .services
            .storage_scp
            .spawn_background()
            .expect("spawn storage scp");
        let move_scp = MoveScp::builder()
            .expect("build move scp")
            .files(file_paths)
            .destination(
                services.services.config.local_ae_title.clone(),
                storage_scp.port(),
            )
            .spawn()
            .expect("spawn move scp");
        let node = move_scp.remote_node("move-scp");

        let first = move_once(&services, &node, &study.study_instance_uid);
        let files_after_first =
            managed_dicom_files(&services.services.paths.managed_store_dir).expect("list files");
        let second = move_once(&services, &node, &study.study_instance_uid);
        let files_after_second =
            managed_dicom_files(&services.services.paths.managed_store_dir).expect("list files");
        let report = storage_scp.stop().expect("stop storage scp");

        assert_eq!(first.final_status, 0x0000);
        assert_eq!(first.completed, 2);
        assert_eq!(second.final_status, 0x0000);
        assert_eq!(second.completed, 2);
        assert_eq!(report.received, 4);
        assert_eq!(report.stored, 4);
        assert_eq!(single_study_instance_count(&services), 2);
        assert_eq!(files_after_first, files_after_second);
        assert_no_orphaned_temp_files(&services.services.paths.managed_store_dir);

        let moves = move_scp.stop().expect("stop move scp");
        assert_eq!(moves.len(), 2);
    });
}

#[test]
fn same_sop_uid_with_different_content_is_currently_treated_as_duplicate() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");
        let base_dir = services.temp_dir.path().join("same-sop");
        let mut first_spec = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.205.1",
            "1.2.826.0.1.3680043.10.205.1.1",
            "1.2.826.0.1.3680043.10.205.1.1.1",
        );
        first_spec.pixel_byte = 0x41;
        let mut second_spec = first_spec.clone();
        second_spec.pixel_byte = 0x42;

        let first = write_valid_dicom_with_pixel_data(&base_dir.join("first.dcm"), &first_spec)
            .expect("write first DICOM");
        let second = write_valid_dicom_with_pixel_data(&base_dir.join("second.dcm"), &second_spec)
            .expect("write second DICOM");

        let first_report = services
            .services
            .importer
            .import_path(&first.path)
            .expect("first import");
        let second_report = services
            .services
            .importer
            .import_path(&second.path)
            .expect("second import");

        assert_eq!(first_report.accepted, 1);
        assert_eq!(second_report.accepted, 0);
        assert_eq!(second_report.duplicates, 1);
        assert_eq!(single_study_instance_count(&services), 1);
        assert_no_orphaned_temp_files(&services.services.paths.managed_store_dir);
    });
}

fn move_once(
    services: &TestServices,
    node: &dicom_node_client::models::RemoteNode,
    study_instance_uid: &str,
) -> dicom_node_client::models::MoveOutcome {
    let request = MoveRequest {
        node_name_or_id: node.name.clone(),
        model: QueryModel::StudyRoot,
        level: QueryLevel::Study,
        study_instance_uid: study_instance_uid.to_string(),
        series_instance_uid: None,
        sop_instance_uid: None,
        move_destination: Some(services.services.config.local_ae_title.clone()),
    };
    services
        .services
        .move_scu
        .retrieve(node, &request)
        .expect("retrieve study")
}

fn single_study_instance_count(services: &TestServices) -> i64 {
    let studies = services.services.db.list_studies().expect("list studies");
    assert_eq!(studies.len(), 1);
    studies[0].instance_count
}

fn assert_no_orphaned_temp_files(root: &Path) {
    let temp_files = staged_temp_files(root).expect("list staged temp files");
    assert!(
        temp_files.is_empty(),
        "expected no orphaned temp files, found {temp_files:?}"
    );
}

fn staged_temp_files(root: &Path) -> std::io::Result<Vec<PathBuf>> {
    let mut out = Vec::new();
    collect_files(root, &mut out, |path| {
        path.extension().is_some_and(|extension| extension == "tmp")
    })?;
    Ok(out)
}

fn managed_dicom_files(root: &Path) -> std::io::Result<BTreeSet<PathBuf>> {
    let mut out = Vec::new();
    collect_files(root, &mut out, |path| {
        path.extension().is_some_and(|extension| extension == "dcm")
    })?;
    Ok(out.into_iter().collect())
}

fn collect_files(
    root: &Path,
    out: &mut Vec<PathBuf>,
    keep: impl Fn(&Path) -> bool + Copy,
) -> std::io::Result<()> {
    let entries = std::fs::read_dir(root)?;

    for entry in entries {
        let path = entry?.path();
        if path.is_dir() {
            collect_files(&path, out, keep)?;
        } else if keep(&path) {
            out.push(path);
        }
    }

    Ok(())
}
