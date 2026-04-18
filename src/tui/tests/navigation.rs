use super::prelude::*;

#[test]
fn selection_movement_clamps_in_nodes_pane() {
    let services = test_services();
    add_test_node(&services, "Alpha", "ALPHAAE");
    add_test_node(&services, "Beta", "BETAAE");

    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.focus = FocusPane::Nodes;

    assert_eq!(app.selected_node, Some(0));

    app.handle_key(key(KeyCode::Down)).unwrap();
    assert_eq!(app.selected_node, Some(1));

    app.handle_key(key(KeyCode::Down)).unwrap();
    assert_eq!(app.selected_node, Some(1));

    app.handle_key(key(KeyCode::Up)).unwrap();
    assert_eq!(app.selected_node, Some(0));
}

#[test]
fn local_pane_enter_drills_down_and_escape_returns_to_studies() {
    let services = test_services();
    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.840.1",
            series_uid: "1.2.840.1.1",
            sop_uid: "1.2.840.1.1.1",
            series_number: Some("1"),
            modality: Some("CT"),
            patient_name: Some("DOE^JANE"),
            study_date: Some("20240101"),
            study_description: Some("Head CT"),
            series_description: Some("Scout"),
        },
    );
    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.840.1",
            series_uid: "1.2.840.1.2",
            sop_uid: "1.2.840.1.2.1",
            series_number: Some("2"),
            modality: Some("MR"),
            patient_name: Some("DOE^JANE"),
            study_date: Some("20240101"),
            study_description: Some("Head CT"),
            series_description: Some("Axial T1"),
        },
    );

    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.focus = FocusPane::Local;

    assert_eq!(app.selected_local_study, Some(0));
    assert_eq!(app.local_studies.len(), 1);

    app.handle_key(key(KeyCode::Enter)).unwrap();

    assert!(app.local_drill_down);
    assert_eq!(app.drill_down_study_uid.as_deref(), Some("1.2.840.1"));
    assert_eq!(app.local_series.len(), 2);
    assert_eq!(app.selected_local_series, Some(0));
    assert_eq!(app.local_series[0].series_instance_uid, "1.2.840.1.1");

    app.handle_key(key(KeyCode::Down)).unwrap();
    assert_eq!(app.selected_local_series, Some(1));

    app.handle_key(key(KeyCode::Esc)).unwrap();

    assert!(!app.local_drill_down);
    assert_eq!(app.drill_down_study_uid.as_deref(), Some("1.2.840.1"));
    assert_eq!(app.local_series.len(), 2);
    assert_eq!(app.selected_local_series, None);
    assert_eq!(app.focus, FocusPane::Local);
    assert_eq!(app.selected_local_study, Some(0));

    app.refresh_local_studies().unwrap();
    assert_eq!(app.local_series.len(), 2);
    assert_eq!(app.drill_down_study_uid.as_deref(), Some("1.2.840.1"));
}

// ── navigation.rs coverage ────────────────────────────────────────────────────

#[test]
fn move_current_selection_in_query_pane() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Query;
    app.query_results = vec![
        QueryMatch {
            level: QueryLevel::Study,
            patient_name: None,
            patient_id: None,
            accession_number: None,
            study_instance_uid: Some("1.2.3".to_string()),
            series_instance_uid: None,
            sop_instance_uid: None,
            study_date: None,
            study_description: None,
            series_description: None,
            series_number: None,
            modality: None,
            instance_number: None,
        },
        QueryMatch {
            level: QueryLevel::Study,
            patient_name: None,
            patient_id: None,
            accession_number: None,
            study_instance_uid: Some("1.2.4".to_string()),
            series_instance_uid: None,
            sop_instance_uid: None,
            study_date: None,
            study_description: None,
            series_description: None,
            series_number: None,
            modality: None,
            instance_number: None,
        },
    ];
    app.selected_query_result = Some(0);

    app.move_current_selection(1);
    assert_eq!(app.selected_query_result, Some(1));

    app.move_current_selection(-1);
    assert_eq!(app.selected_query_result, Some(0));

    // Clamp at bottom
    app.move_current_selection(-1);
    assert_eq!(app.selected_query_result, Some(0));
}

#[test]
fn move_current_selection_in_local_pane_drill_down_moves_series() {
    let services = test_services();
    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.840.1",
            series_uid: "1.2.840.1.1",
            sop_uid: "1.2.840.1.1.1",
            series_number: Some("1"),
            modality: Some("CT"),
            patient_name: None,
            study_date: None,
            study_description: None,
            series_description: None,
        },
    );
    add_test_local_instance(
        &services,
        TestInstanceMeta {
            study_uid: "1.2.840.1",
            series_uid: "1.2.840.1.2",
            sop_uid: "1.2.840.1.2.1",
            series_number: Some("2"),
            modality: Some("MR"),
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
    assert_eq!(app.selected_local_series, Some(0));

    app.move_current_selection(1);
    assert_eq!(app.selected_local_series, Some(1));

    // Studies unchanged while in drill-down
    assert_eq!(app.selected_local_study, Some(0));
}

#[test]
fn move_current_selection_in_logs_pane_is_noop() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Logs;
    // Nothing to assert other than it doesn't panic or change other state

    app.move_current_selection(1);
    app.move_current_selection(-1);
    // No crash is the test
}

#[test]
fn move_current_selection_in_input_pane_is_noop() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Input;
    let content_before = app.editor.content().to_string();

    app.move_current_selection(1);

    assert_eq!(app.editor.content(), content_before);
}

#[test]
fn clear_local_drill_down_resets_drill_down_flag_and_series_selection() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.local_drill_down = true;
    app.selected_local_series = Some(2);
    app.drill_down_study_uid = Some("1.2.3".to_string());
    app.local_series = vec![]; // content doesn't matter

    app.clear_local_drill_down();

    assert!(!app.local_drill_down);
    assert_eq!(app.selected_local_series, None);
    // drill_down_study_uid is NOT cleared by clear_local_drill_down
    assert_eq!(app.drill_down_study_uid, Some("1.2.3".to_string()));
}

#[test]
fn reset_local_drill_down_cache_clears_all_drill_down_state() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.local_drill_down = true;
    app.selected_local_series = Some(1);
    app.drill_down_study_uid = Some("1.2.3".to_string());
    app.local_series = vec![];

    app.reset_local_drill_down_cache();

    assert!(!app.local_drill_down);
    assert_eq!(app.selected_local_series, None);
    assert_eq!(app.drill_down_study_uid, None);
    assert!(app.local_series.is_empty());
}

#[test]
fn select_node_by_id_finds_existing_node() {
    let services = test_services();
    add_test_node(&services, "alpha", "ALPHAAE");
    add_test_node(&services, "beta", "BETAAE");

    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();

    let beta_id = app.nodes[1].id.clone();
    app.select_node_by_id(&beta_id);

    assert_eq!(app.selected_node, Some(1));
    let selected = app.selected_node().expect("selected node");
    assert_eq!(selected.name, "beta");
}

#[test]
fn select_node_by_id_falls_back_to_first_when_not_found() {
    let services = test_services();
    add_test_node(&services, "alpha", "ALPHAAE");

    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.selected_node = None;

    app.select_node_by_id("nonexistent-id");

    assert_eq!(app.selected_node, Some(0));
}

#[test]
fn enter_local_drill_down_with_no_selected_study_does_nothing() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    // No local studies loaded, selected_local_study is None

    app.enter_local_drill_down().unwrap();

    assert!(!app.local_drill_down);
    assert_eq!(app.drill_down_study_uid, None);
}
