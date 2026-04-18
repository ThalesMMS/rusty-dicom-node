use super::prelude::*;

#[test]
fn focus_cycle_wraps_forward_and_backward() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    assert_eq!(app.focus, FocusPane::Input);

    app.handle_key(key(KeyCode::Tab)).unwrap();
    assert_eq!(app.focus, FocusPane::Nodes);

    app.handle_key(key(KeyCode::BackTab)).unwrap();
    assert_eq!(app.focus, FocusPane::Input);
}

#[test]
fn command_input_keys_edit_at_cursor() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.handle_key(key(KeyCode::Char('a'))).unwrap();
    app.handle_key(key(KeyCode::Char('c'))).unwrap();
    app.handle_key(key(KeyCode::Left)).unwrap();
    app.handle_key(key(KeyCode::Char('b'))).unwrap();

    assert_eq!(app.editor.content(), "abc");
    assert_eq!(app.editor.cursor_position(), "ab".len());

    app.handle_key(key(KeyCode::Delete)).unwrap();
    assert_eq!(app.editor.content(), "ab");

    app.handle_key(key(KeyCode::Backspace)).unwrap();
    assert_eq!(app.editor.content(), "a");
    assert_eq!(app.editor.cursor_position(), "a".len());

    app.handle_key(key(KeyCode::Home)).unwrap();
    app.handle_key(key(KeyCode::Char('>'))).unwrap();
    app.handle_key(key(KeyCode::End)).unwrap();
    app.handle_key(key(KeyCode::Char('!'))).unwrap();

    assert_eq!(app.editor.content(), ">a!");
    assert_eq!(app.editor.cursor_position(), ">a!".len());
}

#[test]
fn command_input_handles_ctrl_word_operations_and_paste() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.handle_paste("alpha beta");
    app.handle_key(key_with_modifiers(KeyCode::Left, KeyModifiers::CONTROL))
        .unwrap();
    assert_eq!(app.editor.cursor_position(), "alpha ".len());

    app.handle_key(key_with_modifiers(
        KeyCode::Backspace,
        KeyModifiers::CONTROL,
    ))
    .unwrap();
    assert_eq!(app.editor.content(), "beta");
    assert_eq!(app.editor.cursor_position(), 0);

    app.handle_key(key_with_modifiers(KeyCode::Delete, KeyModifiers::CONTROL))
        .unwrap();
    assert_eq!(app.editor.content(), "");
}

#[test]
fn command_history_records_non_empty_commands_without_consecutive_duplicates() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.editor.set_content("help");
    app.handle_key(key(KeyCode::Enter)).unwrap();
    app.editor.set_content("help");
    app.handle_key(key(KeyCode::Enter)).unwrap();
    app.editor.set_content("   ");
    app.handle_key(key(KeyCode::Enter)).unwrap();

    assert_eq!(
        app.history.iter().map(String::as_str).collect::<Vec<_>>(),
        vec!["help"]
    );
    assert_eq!(app.history_index, None);
    assert_eq!(app.draft, "");
    assert_eq!(app.editor.content(), "");
}

#[test]
fn command_history_caps_at_limit() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    for index in 0..(COMMAND_HISTORY_LIMIT + 5) {
        app.push_history(format!("cmd-{index}"));
    }

    assert_eq!(app.history.len(), COMMAND_HISTORY_LIMIT);
    assert_eq!(app.history.front().map(String::as_str), Some("cmd-5"));
    assert_eq!(app.history.back().map(String::as_str), Some("cmd-104"));
}

#[test]
fn command_history_up_down_restores_draft() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.history = ["first", "second"]
        .into_iter()
        .map(str::to_string)
        .collect();
    app.editor.set_content("draft");

    app.handle_key(key(KeyCode::Up)).unwrap();
    assert_eq!(app.editor.content(), "second");
    assert_eq!(app.history_index, Some(1));
    assert_eq!(app.draft, "draft");

    app.handle_key(key(KeyCode::Up)).unwrap();
    assert_eq!(app.editor.content(), "first");
    assert_eq!(app.history_index, Some(0));

    app.handle_key(key(KeyCode::Up)).unwrap();
    assert_eq!(app.editor.content(), "first");
    assert_eq!(app.history_index, Some(0));

    app.handle_key(key(KeyCode::Down)).unwrap();
    assert_eq!(app.editor.content(), "second");
    assert_eq!(app.history_index, Some(1));

    app.handle_key(key(KeyCode::Down)).unwrap();
    assert_eq!(app.editor.content(), "draft");
    assert_eq!(app.history_index, None);
    assert_eq!(app.draft, "");
}

#[test]
fn command_history_edit_detaches_from_recalled_entry() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.history = ["first", "second"]
        .into_iter()
        .map(str::to_string)
        .collect();
    app.editor.set_content("draft");

    app.handle_key(key(KeyCode::Up)).unwrap();
    app.handle_key(key(KeyCode::Char('!'))).unwrap();

    assert_eq!(app.editor.content(), "second!");
    assert_eq!(app.history_index, None);
    assert_eq!(app.draft, "");

    app.handle_key(key(KeyCode::Up)).unwrap();
    assert_eq!(app.editor.content(), "second");
    assert_eq!(app.draft, "second!");

    app.handle_key(key(KeyCode::Down)).unwrap();
    assert_eq!(app.editor.content(), "second!");
    assert_eq!(app.history_index, None);
}

#[test]
fn help_opens_and_closes_from_keyboard() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.handle_key(key(KeyCode::Char('?'))).unwrap();
    assert!(app.show_help);

    app.handle_key(key(KeyCode::Esc)).unwrap();
    assert!(!app.show_help);
}

#[test]
fn pane_shortcut_opens_add_node_modal() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Nodes;

    app.handle_key(key(KeyCode::Char('a'))).unwrap();

    assert!(matches!(app.modal, Some(ModalState::AddNode(_))));
}

// ── input.rs coverage ─────────────────────────────────────────────────────────

#[test]
fn handle_key_f1_opens_help() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    assert!(!app.show_help);

    app.handle_key(key(KeyCode::F(1))).unwrap();

    assert!(app.show_help);
}

#[test]
fn handle_key_question_mark_does_not_open_help_when_input_not_empty() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.editor.insert_str("hello");

    app.handle_key(key(KeyCode::Char('?'))).unwrap();

    assert!(!app.show_help);
    assert_eq!(app.editor.content(), "hello?");
}

#[test]
fn handle_key_q_in_non_input_pane_sets_should_quit() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Nodes;

    app.handle_key(key(KeyCode::Char('q'))).unwrap();

    assert!(app.should_quit);
}

#[test]
fn handle_key_q_in_input_pane_types_character() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    // focus is Input by default

    app.handle_key(key(KeyCode::Char('q'))).unwrap();

    assert!(!app.should_quit);
    assert_eq!(app.editor.content(), "q");
}

#[test]
fn handle_key_r_in_non_input_pane_refreshes_and_logs() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Nodes;
    let before_count = app.logs.len();

    app.handle_key(key(KeyCode::Char('r'))).unwrap();

    assert_eq!(app.logs.last().map(String::as_str), Some("refreshed"));
    assert_eq!(app.logs.len(), before_count + 1);
}

#[test]
fn handle_key_j_k_vim_navigation_in_nodes_pane() {
    let services = test_services();
    add_test_node(&services, "alpha", "ALPHAAE");
    add_test_node(&services, "beta", "BETAAE");

    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.focus = FocusPane::Nodes;
    assert_eq!(app.selected_node, Some(0));

    app.handle_key(key(KeyCode::Char('j'))).unwrap();
    assert_eq!(app.selected_node, Some(1));

    app.handle_key(key(KeyCode::Char('k'))).unwrap();
    assert_eq!(app.selected_node, Some(0));
}

#[test]
fn handle_key_while_show_help_f1_closes_help() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.show_help = true;

    app.handle_key(key(KeyCode::F(1))).unwrap();

    assert!(!app.show_help);
}

#[test]
fn handle_key_while_show_help_question_mark_when_input_empty_closes_help() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.show_help = true;
    // editor is empty by default

    app.handle_key(key(KeyCode::Char('?'))).unwrap();

    assert!(!app.show_help);
}

#[test]
fn handle_key_while_show_help_other_keys_are_ignored() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.show_help = true;

    app.handle_key(key(KeyCode::Char('x'))).unwrap();

    assert!(app.show_help);
    assert_eq!(app.editor.content(), "");
}

#[test]
fn handle_paste_ignored_when_show_help_is_true() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.show_help = true;

    app.handle_paste("hello");

    assert_eq!(app.editor.content(), "");
}

#[test]
fn handle_paste_ignored_when_modal_is_present() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.modal = Some(ModalState::AddNode(NodeFormState::add()));

    app.handle_paste("hello");

    assert_eq!(app.editor.content(), "");
}

#[test]
fn handle_paste_ignored_when_focus_is_not_input() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Nodes;

    app.handle_paste("hello");

    assert_eq!(app.editor.content(), "");
}

#[test]
fn handle_paste_ignored_when_text_is_empty() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.handle_paste("");

    assert_eq!(app.editor.content(), "");
}

#[test]
fn push_history_does_not_add_consecutive_duplicate() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.push_history("cmd1".to_string());
    app.push_history("cmd1".to_string());

    assert_eq!(app.history.len(), 1);
    assert_eq!(app.history.back().map(String::as_str), Some("cmd1"));
}

#[test]
fn push_history_adds_non_consecutive_duplicate() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    app.push_history("cmd1".to_string());
    app.push_history("cmd2".to_string());
    app.push_history("cmd1".to_string());

    assert_eq!(app.history.len(), 3);
}

#[test]
fn previous_history_entry_on_empty_history_does_nothing() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.editor.insert_str("draft");

    app.previous_history_entry();

    assert_eq!(app.editor.content(), "draft");
    assert_eq!(app.history_index, None);
}

#[test]
fn next_history_entry_when_no_history_index_does_nothing() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.history = ["cmd1".to_string()].into_iter().collect();
    app.editor.insert_str("current");
    assert_eq!(app.history_index, None);

    app.next_history_entry();

    assert_eq!(app.editor.content(), "current");
    assert_eq!(app.history_index, None);
}

#[test]
fn detach_history_navigation_when_no_index_does_not_clear_draft() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.draft = "my draft".to_string();
    assert_eq!(app.history_index, None);

    app.detach_history_navigation();

    assert_eq!(app.draft, "my draft");
}

#[test]
fn reset_history_navigation_clears_index_and_draft() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.history_index = Some(2);
    app.draft = "something".to_string();

    app.reset_history_navigation();

    assert_eq!(app.history_index, None);
    assert_eq!(app.draft, "");
}

// ── input.rs: handle_key pane shortcuts ───────────────────────────────────────

#[test]
fn pane_shortcut_e_opens_edit_node_modal() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.focus = FocusPane::Nodes;

    app.handle_key(key(KeyCode::Char('e'))).unwrap();

    assert!(matches!(app.modal, Some(ModalState::EditNode(_))));
}

#[test]
fn pane_shortcut_d_opens_delete_node_modal() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.focus = FocusPane::Nodes;

    app.handle_key(key(KeyCode::Char('d'))).unwrap();

    assert!(matches!(app.modal, Some(ModalState::ConfirmDeleteNode(_))));
}

#[test]
fn pane_shortcut_f_opens_query_modal() {
    let services = test_services();
    add_test_node(&services, "pacs", "PACSAE");
    let mut app = TuiApp::new(services.services.clone());
    app.refresh_all().unwrap();
    app.focus = FocusPane::Nodes;

    app.handle_key(key(KeyCode::Char('f'))).unwrap();

    assert!(matches!(app.modal, Some(ModalState::Query(_))));
}

#[test]
fn esc_from_non_drill_down_returns_focus_to_input() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Nodes;

    app.handle_key(key(KeyCode::Esc)).unwrap();

    assert_eq!(app.focus, FocusPane::Input);
}
