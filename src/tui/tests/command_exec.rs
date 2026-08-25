use super::prelude::*;

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

    assert_eq!(app.logs.last().cloned(), Some(tr("tui-log-refreshed")));
}

#[test]
fn execute_command_cancel_logs_when_no_active_task() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.execute_command("cancel").unwrap();

    assert_eq!(
        app.logs.last().cloned(),
        Some(tr("tui-status-no-active-task"))
    );
}

#[test]
fn execute_command_stop_alias_routes_to_cancel() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.execute_command("stop").unwrap();

    assert_eq!(
        app.logs.last().cloned(),
        Some(tr("tui-status-no-active-task"))
    );
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
fn local_studies_logs_rows() {
    let services = test_services();

    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.3",
            series_uid: "1.2.3.4",
            sop_uid: "1.2.3.4.5",
            series_number: Some("1"),
            modality: Some("MR"),
            patient_name: Some("Doe^John"),
            study_date: Some("20260101"),
            study_description: Some("Head MRI"),
            series_description: Some("Axial T1"),
        },
    );

    let mut app = TuiApp::new(services.services.clone());

    let before = app.logs.len();
    app.execute_command("local studies patient_name=Doe")
        .unwrap();

    let new_logs = &app.logs[before..];
    assert!(
        new_logs.iter().any(|line| line.contains("1.2.3")),
        "expected a study row containing the study uid; logs were: {new_logs:?}"
    );
}

#[test]
fn local_series_calls_service_and_updates_state() {
    let services = test_services();

    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.3",
            series_uid: "1.2.3.4",
            sop_uid: "1.2.3.4.5",
            series_number: Some("7"),
            modality: Some("CT"),
            patient_name: None,
            study_date: None,
            study_description: None,
            series_description: Some("Local Series"),
        },
    );

    let mut app = TuiApp::new(services.services.clone());

    app.execute_command("local series study_uid=1.2.3").unwrap();

    assert_eq!(app.focus, FocusPane::Local, "expected Local pane focused");
    assert_eq!(app.drill_down_study_uid.as_deref(), Some("1.2.3"));
    assert!(app.local_drill_down, "expected local drill down enabled");
    assert!(
        !app.local_series.is_empty(),
        "expected local series populated"
    );
}

#[test]
fn local_instances_calls_service_and_updates_state() {
    let services = test_services();

    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.3",
            series_uid: "1.2.3.4",
            sop_uid: "1.2.3.4.5",
            series_number: None,
            modality: None,
            patient_name: None,
            study_date: None,
            study_description: None,
            series_description: None,
        },
    );

    let mut app = TuiApp::new(services.services.clone());

    app.execute_command("local instances series_uid=1.2.3.4")
        .unwrap();

    assert_eq!(app.focus, FocusPane::Local, "expected Local pane focused");
    assert!(
        app.selected_local_instance.is_some(),
        "expected selected local instance set"
    );
    assert!(
        !app.local_instances.is_empty(),
        "expected local instances populated"
    );
}
