use super::prelude::*;

#[test]
fn handle_query_form_key_q_appends_to_text_field() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let node = services.get_node("pacs").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = QueryFormState::new(node);
    form.active = QueryField::PatientName;

    let keep = app
        .handle_query_form_key(&mut form, key(KeyCode::Char('q')))
        .unwrap();

    assert!(keep);
    assert_eq!(form.patient_name, "q");
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
fn handle_node_form_key_q_appends_to_active_field() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    let mut form = NodeFormState::add();

    let keep = app
        .handle_node_form_key(&mut form, key(KeyCode::Char('q')))
        .unwrap();

    assert!(keep);
    assert_eq!(form.name, "q");
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
    assert_eq!(
        last_log,
        &tr("tui-status-query-before-retrieve")
    );
}

#[test]
fn handle_retrieve_form_key_q_appends_to_text_field() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let node = services.get_node("pacs").unwrap();
    let mut app = TuiApp::new(services.services.clone());
    let result = QueryMatch {
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
    };
    let mut form =
        RetrieveFormState::from_result(node, QueryModel::PatientRoot, &result, "LOCALAE").unwrap();
    form.active = RetrieveField::Destination;
    form.destination.clear();

    let keep = app
        .handle_retrieve_form_key(&mut form, key(KeyCode::Char('q')))
        .unwrap();

    assert!(keep);
    assert_eq!(form.destination, "q");
}

#[test]
fn invalid_query_form_shows_error_and_preserves_input() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();

    let mut form = QueryFormState::new(services.get_node("pacs").unwrap());
    form.patient_id = "PAT123".to_string();
    form.date_from = "20250102".to_string();
    form.date_to = "20250101".to_string();

    let keep = app
        .handle_query_form_key(&mut form, key(KeyCode::Enter))
        .unwrap();

    assert!(keep);
    assert!(form.error.as_deref().unwrap_or("").contains("date"));
    assert_eq!(form.patient_id, "PAT123");
    assert_eq!(form.date_from, "20250102");
    assert_eq!(form.date_to, "20250101");
}

#[test]
fn invalid_import_form_shows_error_and_preserves_input() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    let mut form = ImportFormState::new();
    form.path = "/this/does/not/exist".to_string();

    let keep = app
        .handle_import_form_key(&mut form, key(KeyCode::Enter))
        .unwrap();

    assert!(keep);
    assert!(form.error.is_some());
    assert_eq!(form.path, "/this/does/not/exist");
}

#[test]
fn invalid_send_form_shows_error_and_preserves_input() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());

    let mut form = SendFormState::new();
    form.destination_node = "".to_string();
    form.uid = "not-a-uid".to_string();

    let keep = app
        .handle_send_form_key(&mut form, key(KeyCode::Enter))
        .unwrap();

    assert!(keep);
    assert!(form.error.as_deref().unwrap_or("").contains("UID"));
    assert_eq!(form.uid, "not-a-uid");
}

#[test]
fn invalid_storage_scp_form_shows_error_and_preserves_input() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    let mut form = StorageScpFormState::from_config(&services.services.config);
    form.port = "99999".to_string();
    form.local_ae_title = "bad ae".to_string();

    let keep = app
        .handle_storage_scp_form_key(&mut form, key(KeyCode::Enter))
        .unwrap();

    assert!(keep);
    assert!(form.error.is_some());
    assert_eq!(form.port, "99999");
    assert_eq!(form.local_ae_title, "bad ae");
}

#[test]
fn storage_scp_form_save_persists_limit_keys_in_config_json() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    // Edit values and save
    let mut form = StorageScpFormState::from_config(&services.services.config);
    form.max_file_import_bytes = "123".to_string();
    form.max_zip_entry_bytes = "234".to_string();
    form.max_zip_total_bytes = "345".to_string();
    form.max_zip_entry_count = "4".to_string();
    form.max_store_object_bytes = "456".to_string();

    let keep = app
        .handle_storage_scp_form_key(&mut form, key(KeyCode::Enter))
        .unwrap();
    assert!(!keep);

    // Ensure values were written with the correct keys
    let raw =
        std::fs::read_to_string(&services.services.paths.config_json).expect("read config.json");
    let json: serde_json::Value = serde_json::from_str(&raw).expect("parse config.json");

    assert_eq!(json["max_file_import_bytes"], 123);
    assert_eq!(json["max_zip_entry_bytes"], 234);
    assert_eq!(json["max_zip_total_bytes"], 345);
    assert_eq!(json["max_zip_entry_count"], 4);
    assert_eq!(json["max_store_object_bytes"], 456);
}

#[test]
fn storage_scp_form_save_persists_unlimited_as_null_in_config_json() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    let mut form = StorageScpFormState::from_config(&services.services.config);
    form.max_file_import_bytes = "none".to_string();
    form.max_zip_entry_bytes = "".to_string();
    form.max_zip_total_bytes = "NONE".to_string();
    form.max_zip_entry_count = "  none  ".to_string();
    form.max_store_object_bytes = "\t".to_string();

    let keep = app
        .handle_storage_scp_form_key(&mut form, key(KeyCode::Enter))
        .unwrap();
    assert!(!keep);

    let raw =
        std::fs::read_to_string(&services.services.paths.config_json).expect("read config.json");
    let json: serde_json::Value = serde_json::from_str(&raw).expect("parse config.json");

    assert!(json.get("max_file_import_bytes").is_some());
    assert!(json["max_file_import_bytes"].is_null());

    assert!(json.get("max_zip_entry_bytes").is_some());
    assert!(json["max_zip_entry_bytes"].is_null());

    assert!(json.get("max_zip_total_bytes").is_some());
    assert!(json["max_zip_total_bytes"].is_null());

    assert!(json.get("max_zip_entry_count").is_some());
    assert!(json["max_zip_entry_count"].is_null());

    assert!(json.get("max_store_object_bytes").is_some());
    assert!(json["max_store_object_bytes"].is_null());
}
