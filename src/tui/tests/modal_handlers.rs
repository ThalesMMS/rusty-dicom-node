use super::prelude::*;

#[test]
fn busy_guard_keeps_query_modal_open() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let node = services.get_node("pacs").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Sending study 1.2.3...".to_string(),
        started_at: Instant::now(),
    });
    let mut form = QueryFormState::new(node);

    let keep_modal = app
        .handle_query_form_key(&mut form, key(KeyCode::Enter))
        .unwrap();

    assert!(keep_modal);
    assert!(app.running_task.is_some());
    assert!(app
        .logs
        .last()
        .expect("busy log")
        .contains("Please wait for the current operation to complete"));
}

#[test]
fn handle_modal_key_restores_modal_when_handler_errors() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let node = services.get_node("pacs").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::edit(&node);
    form.target = None;
    app.modal = Some(ModalState::EditNode(form));

    let error = app.handle_modal_key(key(KeyCode::Enter)).unwrap_err();

    assert!(error.to_string().contains("edit form lost its target node"));
    assert!(matches!(app.modal, Some(ModalState::EditNode(_))));
}

// ── modal_handlers.rs coverage ───────────────────────────────────────────────

#[test]
fn handle_node_form_key_tab_cycles_field_forward() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::add();
    assert_eq!(form.active, NodeField::Name);

    app.handle_node_form_key(&mut form, key(KeyCode::Tab))
        .unwrap();

    assert_eq!(form.active, NodeField::AeTitle);
}

#[test]
fn handle_node_form_key_backtab_cycles_field_backward() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::add();
    form.active = NodeField::AeTitle;

    app.handle_node_form_key(&mut form, key(KeyCode::BackTab))
        .unwrap();

    assert_eq!(form.active, NodeField::Name);
}

#[test]
fn handle_node_form_key_char_appends_to_active_field() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::add();
    // active is Name by default

    app.handle_node_form_key(&mut form, key(KeyCode::Char('m')))
        .unwrap();
    app.handle_node_form_key(&mut form, key(KeyCode::Char('y')))
        .unwrap();

    assert_eq!(form.name, "my");
    assert_eq!(form.error, None);
}

#[test]
fn handle_node_form_key_backspace_removes_last_char() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::add();
    form.name = "abc".to_string();

    app.handle_node_form_key(&mut form, key(KeyCode::Backspace))
        .unwrap();

    assert_eq!(form.name, "ab");
}

#[test]
fn handle_node_form_key_esc_returns_false_closes_modal() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::add();

    let keep = app
        .handle_node_form_key(&mut form, key(KeyCode::Esc))
        .unwrap();

    assert!(!keep);
}

#[test]
fn handle_node_form_key_down_cycles_forward() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::add();
    assert_eq!(form.active, NodeField::Name);

    app.handle_node_form_key(&mut form, key(KeyCode::Down))
        .unwrap();

    assert_eq!(form.active, NodeField::AeTitle);
}

#[test]
fn handle_node_form_key_up_cycles_backward() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::add();
    form.active = NodeField::Host;

    app.handle_node_form_key(&mut form, key(KeyCode::Up))
        .unwrap();

    assert_eq!(form.active, NodeField::AeTitle);
}

#[test]
fn handle_delete_confirm_key_esc_closes_modal() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let node = services.get_node("pacs").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    let confirm = DeleteConfirmState { node };

    let keep = app
        .handle_delete_confirm_key(&confirm, key(KeyCode::Esc))
        .unwrap();

    assert!(!keep);
    // Node should still exist
    assert!(services.get_node("pacs").is_ok());
}

#[test]
fn handle_delete_confirm_key_n_closes_modal_without_deleting() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let node = services.get_node("pacs").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    let confirm = DeleteConfirmState { node };

    let keep = app
        .handle_delete_confirm_key(&confirm, key(KeyCode::Char('n')))
        .unwrap();

    assert!(!keep);
    assert!(services.get_node("pacs").is_ok());
}

#[test]
fn handle_delete_confirm_key_y_deletes_node() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let node = services.get_node("pacs").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    let confirm = DeleteConfirmState { node };

    let keep = app
        .handle_delete_confirm_key(&confirm, key(KeyCode::Char('y')))
        .unwrap();

    assert!(!keep);
    assert!(services.get_node("pacs").is_err());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("removed"));
    assert!(last_log.contains("pacs"));
}

#[test]
fn handle_delete_confirm_key_enter_deletes_node() {
    let services = test_services();
    add_test_node(&services, "pacs2", "PACSAE2");
    let node = services.get_node("pacs2").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    let confirm = DeleteConfirmState { node };

    let keep = app
        .handle_delete_confirm_key(&confirm, key(KeyCode::Enter))
        .unwrap();

    assert!(!keep);
    assert!(services.get_node("pacs2").is_err());
}

#[test]
fn handle_delete_confirm_key_other_key_keeps_modal() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let node = services.get_node("pacs").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    let confirm = DeleteConfirmState { node };

    let keep = app
        .handle_delete_confirm_key(&confirm, key(KeyCode::Char('x')))
        .unwrap();

    assert!(keep);
}

#[test]
fn open_edit_node_modal_without_selection_logs_error() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    // No nodes, no selection

    app.open_edit_node_modal();

    assert!(app.modal.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("select a remote node first"));
}

#[test]
fn open_edit_node_modal_with_selection_opens_modal() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();

    app.open_edit_node_modal();

    assert!(matches!(app.modal, Some(ModalState::EditNode(_))));
}

#[test]
fn open_delete_node_modal_without_selection_logs_error() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.open_delete_node_modal();

    assert!(app.modal.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("select a remote node first"));
}

#[test]
fn open_delete_node_modal_with_selection_opens_modal() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();

    app.open_delete_node_modal();

    assert!(matches!(app.modal, Some(ModalState::ConfirmDeleteNode(_))));
}

#[test]
fn open_query_modal_without_selection_logs_error() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.open_query_modal();

    assert!(app.modal.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("select a remote node first"));
}

#[test]
fn open_query_modal_with_selection_opens_modal() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();

    app.open_query_modal();

    assert!(matches!(app.modal, Some(ModalState::Query(_))));
}

#[test]
fn open_retrieve_modal_without_query_results_logs_error() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.open_retrieve_modal();

    assert!(app.modal.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("select a query result first"));
}

#[test]
fn open_retrieve_modal_without_context_node_logs_error() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    // Add a query result but no context node and no selected node
    app.query_results = vec![QueryMatch {
        level: QueryLevel::Study,
        patient_name: Some("DOE^JANE".to_string()),
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
    }];
    app.selected_query_result = Some(0);
    app.query_context_node = None;
    // No selected node either

    app.open_retrieve_modal();

    assert!(app.modal.is_none());
    let last_log = app.logs.last().expect("log line");
    assert!(last_log.contains("query a remote node first"));
}
