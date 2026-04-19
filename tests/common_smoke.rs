mod common;

#[test]
fn test_services_uses_temp_app_paths() {
    let test_services = common::TestServices::new().expect("create test services");

    assert!(test_services.services.paths.base_dir.exists());
    assert!(test_services.services.paths.sqlite_db.exists());
    assert!(test_services.temp_dir.path().exists());
}

#[test]
fn create_test_study_writes_expected_files() {
    let root = tempfile::tempdir().expect("create temp dir");
    let study = common::create_test_study(root.path(), "1.2.826.0.1.3680043.10.999.10", 2, 2)
        .expect("create test study");

    assert_eq!(study.files.len(), 4);
    assert!(study.files.iter().all(|file| file.path.exists()));
}

#[test]
fn remote_node_fixture_points_to_localhost() {
    let port = 104;
    let node = common::remote_node_fixture("Harness", "storescp", port);

    assert_eq!(node.name, "harness");
    assert_eq!(node.ae_title, "STORESCP");
    assert_eq!(node.host, "127.0.0.1");
    assert_eq!(node.port, port);
}
