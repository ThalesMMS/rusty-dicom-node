mod common;

use std::{collections::BTreeSet, path::Path, time::Duration};

use dicom_node_client::models::{MoveRequest, QueryLevel, QueryModel};

use common::{create_test_study, harness::MoveScp, run_with_timeout, TestServices};

#[test]
fn c_move_retrieves_instances_into_local_storage_scp_and_database() {
    run_with_timeout(Duration::from_secs(15), || {
        let services = TestServices::new().expect("create test services");
        let study = create_test_study(
            &services.temp_dir.path().join("move-source"),
            "1.2.826.0.1.3680043.10.202.1",
            2,
            2,
        )
        .expect("create move source study");
        let requested_series_uid = study.files[0].series_instance_uid.clone();
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
            level: QueryLevel::Series,
            study_instance_uid: study.study_instance_uid.clone(),
            series_instance_uid: Some(requested_series_uid.clone()),
            sop_instance_uid: None,
            move_destination: Some(services.services.config.local_ae_title.clone()),
        };
        let outcome = services
            .services
            .move_scu
            .retrieve(&node, &request)
            .expect("retrieve study");
        let report = storage_scp.stop().expect("stop local storage scp");

        assert_eq!(outcome.final_status, 0x0000);
        assert_eq!(outcome.completed, 2);
        assert_eq!(outcome.failed, 0);
        assert_eq!(report.received, 2);
        assert_eq!(report.stored, 2);

        let studies = services.services.db.list_studies().expect("list studies");
        assert_eq!(studies.len(), 1);
        assert_eq!(studies[0].study_instance_uid, study.study_instance_uid);
        assert_eq!(studies[0].series_count, 1);
        assert_eq!(studies[0].instance_count, 2);

        let stored_files = managed_dicom_files(&services.services.paths.managed_store_dir)
            .expect("list managed DICOM files");
        assert_eq!(stored_files.len(), 2);
        assert!(stored_files.iter().all(|path| path.exists()));

        let moves = move_scp.stop().expect("stop move scp");
        assert_eq!(moves.len(), 1);
        assert_eq!(
            moves[0].move_destination,
            services.services.config.local_ae_title
        );
        assert_eq!(
            moves[0].study_instance_uid.as_deref(),
            Some(study.study_instance_uid.as_str())
        );
        assert_eq!(
            moves[0].series_instance_uid.as_deref(),
            Some(requested_series_uid.as_str())
        );
    });
}

fn managed_dicom_files(root: &Path) -> std::io::Result<BTreeSet<std::path::PathBuf>> {
    let mut out = BTreeSet::new();
    collect_dicom_files(root, &mut out)?;
    Ok(out)
}

fn collect_dicom_files(root: &Path, out: &mut BTreeSet<std::path::PathBuf>) -> std::io::Result<()> {
    let entries = std::fs::read_dir(root)?;

    for entry in entries {
        let entry = entry?;
        let path = entry.path();
        if path.is_dir() {
            collect_dicom_files(&path, out)?;
        } else if path.extension().is_some_and(|extension| extension == "dcm") {
            out.insert(path);
        }
    }

    Ok(())
}
