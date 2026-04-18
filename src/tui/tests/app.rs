use super::prelude::*;

#[test]
fn view_exposes_running_task_snapshot() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Querying pacs...".to_string(),
        started_at: Instant::now() - Duration::from_secs(3),
    });

    let view = app.view();
    let running_task = view.running_task.expect("running task snapshot");

    assert_eq!(running_task.description, "Querying pacs...");
    assert!(running_task.elapsed >= Duration::from_secs(3));
}

#[test]
fn handle_task_result_updates_query_state_and_clears_running_task() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Querying pacs...".to_string(),
        started_at: Instant::now(),
    });

    app.handle_task_result(TaskResult::Query(Ok(vec![QueryMatch {
        level: QueryLevel::Study,
        patient_name: Some("DOE^JANE".to_string()),
        patient_id: None,
        accession_number: None,
        study_instance_uid: Some("1.2.3".to_string()),
        series_instance_uid: None,
        sop_instance_uid: None,
        study_date: Some("20240101".to_string()),
        study_description: Some("Head CT".to_string()),
        series_description: None,
        series_number: None,
        modality: Some("CT".to_string()),
        instance_number: None,
    }])))
    .unwrap();

    assert!(app.running_task.is_none());
    assert_eq!(app.query_results.len(), 1);
    assert_eq!(app.selected_query_result, Some(0));
    assert_eq!(app.focus, FocusPane::Query);
    assert!(app
        .logs
        .last()
        .expect("log line")
        .contains("query returned 1 matches"));
}

#[test]
fn handle_task_result_clears_stale_query_results_on_query_failure() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.query_results = vec![QueryMatch {
        level: QueryLevel::Study,
        patient_name: Some("DOE^JANE".to_string()),
        patient_id: None,
        accession_number: None,
        study_instance_uid: Some("1.2.3".to_string()),
        series_instance_uid: None,
        sop_instance_uid: None,
        study_date: Some("20240101".to_string()),
        study_description: Some("Head CT".to_string()),
        series_description: None,
        series_number: None,
        modality: Some("CT".to_string()),
        instance_number: None,
    }];
    app.selected_query_result = Some(0);
    app.running_task = Some(RunningTask {
        description: "Querying pacs...".to_string(),
        started_at: Instant::now(),
    });

    app.handle_task_result(TaskResult::Query(Err(anyhow::anyhow!("boom"))))
        .unwrap();

    assert!(app.running_task.is_none());
    assert!(app.query_results.is_empty());
    assert_eq!(app.selected_query_result, None);
    assert!(app
        .logs
        .last()
        .expect("log line")
        .contains("query failed: boom"));
}

#[test]
fn refresh_local_studies_preserves_series_selection_by_uid_while_drilled_down() {
    let services = test_services();
    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.840.2",
            series_uid: "1.2.840.2.1",
            sop_uid: "1.2.840.2.1.1",
            series_number: Some("1"),
            modality: Some("CT"),
            patient_name: Some("DOE^JANE"),
            study_date: Some("20240101"),
            study_description: Some("Chest CT"),
            series_description: Some("Scout"),
        },
    );
    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.840.2",
            series_uid: "1.2.840.2.2",
            sop_uid: "1.2.840.2.2.1",
            series_number: Some("2"),
            modality: Some("CT"),
            patient_name: Some("DOE^JANE"),
            study_date: Some("20240101"),
            study_description: Some("Chest CT"),
            series_description: Some("Axial"),
        },
    );

    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.focus = FocusPane::Local;
    app.handle_key(key(KeyCode::Enter)).unwrap();
    app.handle_key(key(KeyCode::Down)).unwrap();

    let selected_uid = app
        .selected_local_series()
        .expect("selected series")
        .series_instance_uid
        .clone();
    assert_eq!(selected_uid, "1.2.840.2.2");
    assert_eq!(app.selected_local_series, Some(1));

    add_test_local_instance(
        &app.services,
        TestInstanceMeta {
            study_uid: "1.2.840.2",
            series_uid: "1.2.840.2.1",
            sop_uid: "1.2.840.2.1.1",
            series_number: Some("9"),
            modality: Some("CT"),
            patient_name: Some("DOE^JANE"),
            study_date: Some("20240101"),
            study_description: Some("Chest CT"),
            series_description: Some("Scout"),
        },
    );
    add_test_local_instance(
        &app.services,
        TestInstanceMeta {
            study_uid: "1.2.840.2",
            series_uid: "1.2.840.2.2",
            sop_uid: "1.2.840.2.2.1",
            series_number: Some("1"),
            modality: Some("CT"),
            patient_name: Some("DOE^JANE"),
            study_date: Some("20240101"),
            study_description: Some("Chest CT"),
            series_description: Some("Axial"),
        },
    );

    app.refresh_local_studies().unwrap();

    let selected_after_refresh = app
        .selected_local_series()
        .expect("selected series after refresh");
    assert_eq!(selected_after_refresh.series_instance_uid, selected_uid);
    assert_eq!(app.selected_local_series, Some(0));
    assert_eq!(app.local_series[0].series_instance_uid, selected_uid);
    assert_eq!(app.drill_down_study_uid.as_deref(), Some("1.2.840.2"));
}

// ── app.rs: handle_task_result coverage ───────────────────────────────────────

#[test]
fn handle_task_result_retrieve_ok_logs_outcome_and_refreshes() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Retrieving...".to_string(),
        started_at: Instant::now(),
    });

    let outcome = crate::models::MoveOutcome {
        final_status: 0xFF00,
        completed: 3,
        failed: 1,
        warning: 0,
        remaining: 0,
        ..Default::default()
    };
    app.handle_task_result(TaskResult::Retrieve(Ok(outcome)))
        .unwrap();

    assert!(app.running_task.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("retrieve status=0xFF00"));
    assert!(last_log.contains("completed=3"));
    assert!(last_log.contains("failed=1"));
}

#[test]
fn handle_task_result_retrieve_err_logs_failure() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Retrieving...".to_string(),
        started_at: Instant::now(),
    });

    app.handle_task_result(TaskResult::Retrieve(Err(anyhow::anyhow!(
        "connection refused"
    ))))
    .unwrap();

    assert!(app.running_task.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("retrieve failed: connection refused"));
}

#[test]
fn handle_task_result_import_ok_logs_report_fields() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Importing...".to_string(),
        started_at: Instant::now(),
    });

    let report = crate::models::ImportReport {
        scanned_files: 10,
        accepted: 8,
        duplicates: 1,
        unreadable: 0,
        invalid_dicom: 1,
        failures: Vec::new(),
        stored_bytes: 4096,
    };
    app.handle_task_result(TaskResult::Import(Ok(report)))
        .unwrap();

    assert!(app.running_task.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("scanned=10"));
    assert!(last_log.contains("accepted=8"));
    assert!(last_log.contains("duplicates=1"));
    assert!(last_log.contains("stored_bytes=4096"));
}

#[test]
fn handle_task_result_import_ok_logs_failures_and_truncates_at_five() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Importing...".to_string(),
        started_at: Instant::now(),
    });

    let failures: Vec<String> = (0..7).map(|i| format!("bad-file-{i}.dcm")).collect();
    let report = crate::models::ImportReport {
        scanned_files: 7,
        accepted: 0,
        duplicates: 0,
        unreadable: 7,
        invalid_dicom: 0,
        failures,
        stored_bytes: 0,
    };
    app.handle_task_result(TaskResult::Import(Ok(report)))
        .unwrap();

    let failure_logs: Vec<_> = app
        .logs
        .iter()
        .filter(|l| l.starts_with("failure:"))
        .collect();
    assert_eq!(
        failure_logs.len(),
        5,
        "should log at most 5 individual failures"
    );

    let omitted_log = app
        .logs
        .iter()
        .find(|l| l.contains("more failures omitted"))
        .expect("omitted count log");
    assert!(omitted_log.contains("2 more failures omitted"));
}

#[test]
fn handle_task_result_import_err_logs_failure() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Importing...".to_string(),
        started_at: Instant::now(),
    });

    app.handle_task_result(TaskResult::Import(Err(anyhow::anyhow!("disk full"))))
        .unwrap();

    assert!(app.running_task.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("import failed: disk full"));
}

#[test]
fn handle_task_result_send_ok_logs_outcome() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Sending...".to_string(),
        started_at: Instant::now(),
    });

    let outcome = crate::models::SendOutcome {
        attempted: 5,
        sent: 4,
        failed: 1,
        failures: Vec::new(),
    };
    app.handle_task_result(TaskResult::Send(Ok(outcome)))
        .unwrap();

    assert!(app.running_task.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("send attempted=5"));
    assert!(last_log.contains("sent=4"));
    assert!(last_log.contains("failed=1"));
}

#[test]
fn handle_task_result_send_err_logs_failure() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Sending...".to_string(),
        started_at: Instant::now(),
    });

    app.handle_task_result(TaskResult::Send(Err(anyhow::anyhow!("node unreachable"))))
        .unwrap();

    assert!(app.running_task.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("send failed: node unreachable"));
}

#[test]
fn handle_task_result_internal_error_logs_message() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Something...".to_string(),
        started_at: Instant::now(),
    });

    app.handle_task_result(TaskResult::InternalError(anyhow::anyhow!(
        "unexpected panic"
    )))
    .unwrap();

    assert!(app.running_task.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("background task internal error: unexpected panic"));
}

#[test]
fn log_caps_at_200_entries_dropping_oldest() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    for i in 0..250 {
        app.log(format!("line-{i}"));
    }

    assert_eq!(app.logs.len(), 200);
    assert!(app.logs.first().expect("first log").contains("line-50"));
    assert!(app.logs.last().expect("last log").contains("line-249"));
}

#[test]
fn is_busy_reflects_running_task_presence() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    assert!(!app.is_busy());

    app.running_task = Some(RunningTask {
        description: "Working...".to_string(),
        started_at: Instant::now(),
    });

    assert!(app.is_busy());
}

#[test]
fn view_has_no_running_task_when_idle() {
    let services = test_services();
    let app = TuiApp::new(services.services.clone());

    let view = app.view();
    assert!(view.running_task.is_none());
}

#[test]
fn refresh_all_preserves_selected_node_by_id() {
    let services = test_services();
    add_test_node(&services, "alpha", "ALPHAAE");
    add_test_node(&services, "beta", "BETAAE");

    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    // Select "beta" (index 1)
    app.selected_node = Some(1);

    // Refresh should still point to "beta" by id
    app.refresh_all().unwrap();

    let selected = app.selected_node().expect("node still selected");
    assert_eq!(selected.name, "beta");
}

#[test]
fn refresh_local_studies_resets_drill_down_when_study_disappears() {
    let services = test_services();
    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.3",
            series_uid: "1.2.3.1",
            sop_uid: "1.2.3.1.1",
            series_number: Some("1"),
            modality: Some("CT"),
            patient_name: None,
            study_date: None,
            study_description: None,
            series_description: None,
        },
    );

    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.focus = FocusPane::Local;
    app.handle_key(key(KeyCode::Enter)).unwrap();
    assert!(app.local_drill_down);
    assert_eq!(app.drill_down_study_uid.as_deref(), Some("1.2.3"));

    // Simulate study disappearing by pointing drill-down to a nonexistent UID
    app.drill_down_study_uid = Some("9.9.9.9".to_string());
    app.refresh_local_studies().unwrap();

    assert!(!app.local_drill_down);
    assert!(app.local_series.is_empty());
    assert_eq!(app.drill_down_study_uid, None);
}
