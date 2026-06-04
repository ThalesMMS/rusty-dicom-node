use std::{
    fs,
    net::TcpListener,
    sync::{atomic::AtomicBool, Arc},
    time::Duration,
};

use dicom_node_client::{
    config::{AppConfig, AppPaths, LocalAeConfig, LocalAeService},
    db::Database,
    net::{DicomServerRuntime, ServerRuntimeOptions, StorageScpServer},
};

fn temp_paths() -> AppPaths {
    let base_dir = std::env::temp_dir().join(format!(
        "dicom-node-client-server-runtime-test-{}",
        uuid::Uuid::new_v4()
    ));
    AppPaths {
        config_json: base_dir.join("config.json"),
        sqlite_db: base_dir.join("app.sqlite3"),
        managed_store_dir: base_dir.join("store"),
        logs_dir: base_dir.join("logs"),
        active_log_file: base_dir.join("logs").join("app.log"),
        base_dir,
    }
}

fn runtime_options() -> ServerRuntimeOptions {
    ServerRuntimeOptions {
        global_max_concurrent_associations: 2,
        association_slot_wait_timeout: Duration::from_millis(10),
        shutdown_timeout: Duration::from_millis(50),
    }
}

#[test]
fn runtime_cancelled_before_accept_returns_zero_report() {
    let paths = temp_paths();
    paths.ensure().expect("create temp paths");
    let db = Database::open(&paths.sqlite_db).expect("open temp db");
    db.init().expect("init temp db");
    let config = AppConfig {
        local_aes: vec![LocalAeConfig {
            title: "RUNTIMEAE".to_string(),
            bind_addr: "127.0.0.1:0".to_string(),
            services: vec![LocalAeService::Verification, LocalAeService::Storage],
            max_concurrent_associations: 2,
            allowed_calling_aet: vec![],
            allowed_peer_ips: vec![],
        }],
        ..AppConfig::default()
    };
    let storage_scp = StorageScpServer::new(config, paths.clone(), db);
    let runtime = DicomServerRuntime::new(storage_scp, runtime_options());
    let cancel_flag = Arc::new(AtomicBool::new(true));

    let report = runtime
        .run_until_cancelled(cancel_flag)
        .expect("cancelled runtime should shut down cleanly");

    assert_eq!(report.received, 0);
    assert_eq!(report.stored, 0);
    assert_eq!(report.failed, 0);
    let _ = fs::remove_dir_all(paths.base_dir);
}

#[test]
fn runtime_reports_bind_error_for_unavailable_port() {
    let occupied = TcpListener::bind("127.0.0.1:0").expect("bind occupied port");
    let port = occupied.local_addr().expect("occupied local addr").port();

    let paths = temp_paths();
    paths.ensure().expect("create temp paths");
    let db = Database::open(&paths.sqlite_db).expect("open temp db");
    db.init().expect("init temp db");
    let config = AppConfig {
        local_aes: vec![LocalAeConfig {
            title: "RUNTIMEAE".to_string(),
            bind_addr: format!("127.0.0.1:{port}"),
            services: vec![LocalAeService::Verification],
            max_concurrent_associations: 1,
            allowed_calling_aet: vec![],
            allowed_peer_ips: vec![],
        }],
        ..AppConfig::default()
    };
    let storage_scp = StorageScpServer::new(config, paths.clone(), db);
    let runtime = DicomServerRuntime::new(storage_scp, runtime_options());
    let cancel_flag = Arc::new(AtomicBool::new(false));

    let err = runtime
        .run_until_cancelled(cancel_flag)
        .expect_err("occupied listener port should fail startup");

    assert!(err
        .to_string()
        .contains(&format!("binding storage SCP at 127.0.0.1:{port}")));
    let _ = fs::remove_dir_all(paths.base_dir);
}
