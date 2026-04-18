use super::prelude::*;

#[test]
fn busy_guard_blocks_command_dispatch_before_argument_validation() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Importing inbox...".to_string(),
        started_at: Instant::now(),
    });

    app.exec_import(&[]).unwrap();

    assert!(app
        .logs
        .last()
        .expect("busy log")
        .contains("Please wait for the current operation to complete"));
}

#[test]
fn import_command_rejects_missing_path_before_starting_task() {
    let services = test_services();
    let missing_path = services.paths.base_dir.join("missing");
    let mut app = TuiApp::new(services.services.clone());

    let error = app
        .exec_import(&[format!("path={}", missing_path.display())])
        .unwrap_err();

    assert!(format!("{error:#}").contains("accessing import path"));
    assert!(app.running_task.is_none());
}

#[test]
fn node_add_command_accepts_short_and_canonical_ae_forms() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.execute_command("node add name=pacs-short ae=PACSAE host=10.0.0.10 port=104 dest=LOCAL_AE")
        .unwrap();
    app.execute_command(
        "node add name=pacs-canonical ae_title=ARCHIVEAE host=10.0.0.11 port=11112 move_destination=STORE_AE",
    )
    .unwrap();

    let short = app.services.get_node("pacs-short").unwrap();
    assert_eq!(short.ae_title, "PACSAE");
    assert_eq!(
        short.preferred_move_destination.as_deref(),
        Some("LOCAL_AE")
    );

    let canonical = app.services.get_node("pacs-canonical").unwrap();
    assert_eq!(canonical.ae_title, "ARCHIVEAE");
    assert_eq!(
        canonical.preferred_move_destination.as_deref(),
        Some("STORE_AE")
    );
}

#[test]
fn node_edit_command_updates_targeted_node_with_patch_fields() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());

    app.execute_command(
        "node edit target=pacs name=archive ae_title=ARCHIVEAE host=10.0.0.11 port=11112 dest=LOCAL_AE notes=\"Primary archive\"",
    )
    .unwrap();

    let updated = app.services.get_node("archive").unwrap();
    assert_eq!(updated.name, "archive");
    assert_eq!(updated.ae_title, "ARCHIVEAE");
    assert_eq!(updated.host, "10.0.0.11");
    assert_eq!(updated.port, 11112);
    assert_eq!(
        updated.preferred_move_destination.as_deref(),
        Some("LOCAL_AE")
    );
    assert_eq!(updated.notes.as_deref(), Some("Primary archive"));
}

#[test]
fn execute_command_rejects_malformed_key_value_syntax() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    let error = app
        .execute_command("query node=pacs malformed")
        .unwrap_err()
        .to_string();

    assert_eq!(error, "expected key=value argument, got malformed");
}

// ── command_exec.rs coverage ──────────────────────────────────────────────────

#[test]
fn execute_command_empty_string_returns_ok() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let initial_log_count = app.logs.len();

    app.execute_command("").unwrap();
    app.execute_command("   ").unwrap();

    assert_eq!(app.logs.len(), initial_log_count);
}

#[test]
fn execute_command_quit_sets_should_quit() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.execute_command("quit").unwrap();
    assert!(app.should_quit);
}

#[test]
fn execute_command_exit_sets_should_quit() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.execute_command("exit").unwrap();
    assert!(app.should_quit);
}

#[test]
fn execute_command_help_logs_help_lines() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let before_count = app.logs.len();

    app.execute_command("help").unwrap();

    assert!(app.logs.len() > before_count);
}

#[test]
fn execute_command_refresh_logs_refreshed() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.execute_command("refresh").unwrap();

    assert_eq!(app.logs.last().map(String::as_str), Some("refreshed"));
}

#[test]
fn execute_command_unknown_returns_error() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    let error = app.execute_command("foobar").unwrap_err().to_string();
    assert!(error.contains("unknown command: foobar"));
}

#[test]
fn exec_node_missing_subcommand_returns_error() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    let error = app.exec_node(&[]).unwrap_err().to_string();
    assert!(error.contains("node subcommand required"));
}

#[test]
fn exec_node_delete_removes_node_and_logs() {
    let services = test_services();
    add_test_node(&services, "removeme", "REMAE");
    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();

    app.exec_node(&args(&["delete", "name=removeme"])).unwrap();

    assert!(app.services.get_node("removeme").is_err());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("removed"));
}

#[test]
fn exec_node_unsupported_subcommand_returns_error() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    let error = app
        .exec_node(&args(&["frobnicate"]))
        .unwrap_err()
        .to_string();
    assert!(error.contains("unsupported node subcommand: frobnicate"));
}

#[test]
fn exec_query_busy_guard_logs_and_returns_ok() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Working...".to_string(),
        started_at: Instant::now(),
    });

    app.exec_query(&[]).unwrap();

    assert!(app
        .logs
        .last()
        .expect("log")
        .contains("Please wait for the current operation to complete"));
}

#[test]
fn exec_retrieve_busy_guard_logs_and_returns_ok() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Working...".to_string(),
        started_at: Instant::now(),
    });

    app.exec_retrieve(&[]).unwrap();

    assert!(app
        .logs
        .last()
        .expect("log")
        .contains("Please wait for the current operation to complete"));
}

#[test]
fn exec_send_study_busy_guard_logs_and_returns_ok() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Working...".to_string(),
        started_at: Instant::now(),
    });

    app.exec_send_study(&[]).unwrap();

    assert!(app
        .logs
        .last()
        .expect("log")
        .contains("Please wait for the current operation to complete"));
}

#[test]
fn exec_send_series_busy_guard_logs_and_returns_ok() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Working...".to_string(),
        started_at: Instant::now(),
    });

    app.exec_send_series(&[]).unwrap();

    assert!(app
        .logs
        .last()
        .expect("log")
        .contains("Please wait for the current operation to complete"));
}
