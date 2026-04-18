use super::prelude::*;

#[test]
fn draw_ui_sets_command_cursor_from_display_width() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.editor.insert_str("a日b");
    app.editor.move_left();
    let view = app.view();

    let backend = ratatui::backend::TestBackend::new(80, 20);
    let mut terminal = Terminal::new(backend).unwrap();
    terminal.draw(|frame| draw_ui(frame, &view)).unwrap();

    terminal.backend_mut().assert_cursor_position((4, 17));
}

#[test]
fn draw_ui_does_not_render_help_over_active_modal() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.modal = Some(ModalState::AddNode(NodeFormState::add()));
    app.show_help = true;
    let view = app.view();

    let backend = ratatui::backend::TestBackend::new(80, 24);
    let mut terminal = Terminal::new(backend).unwrap();
    terminal.draw(|frame| draw_ui(frame, &view)).unwrap();

    let rendered = terminal
        .backend()
        .buffer()
        .content()
        .iter()
        .map(|cell| cell.symbol())
        .collect::<String>();

    assert!(rendered.contains("Add Remote Node"));
    assert!(!rendered.contains("Keybindings"));
}

#[test]
fn formatting_helpers_compact_rows_and_status_lines() {
    assert_eq!(truncate_uid("1234567890", 6), "...890");
    assert_eq!(pad_or_truncate("CT", 4), "CT  ");
    assert_eq!(pad_or_truncate("PATIENT-NAME", 7), "PATIENT");

    let services = test_services();
    let status = services.tui_status_snapshot(TuiReceiverMode::OnDemandForLocalRetrieve);
    let summary = status.summary_lines();

    assert_eq!(summary.lines.len(), 3);

    let lines = summary
        .lines
        .iter()
        .map(line_plain_text)
        .collect::<Vec<_>>();

    assert!(lines[0].contains("Local AE: "));
    assert!(lines[0].contains(&status.local_ae_title));
    assert!(lines[0].contains("Mode: on-demand"));
    assert!(lines[1].contains("PDU: "));
    assert!(lines[1].contains("TS Pref: "));
    assert!(lines[2].contains("Config: "));
    assert!(lines[2].contains("Data: "));
}

#[test]
fn footer_and_help_text_reflect_local_drill_down_state() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Local;

    let normal_view = app.view();
    assert!(footer_status_text(&normal_view).contains("Enter series"));

    let help_lines = help_text(&normal_view)
        .lines
        .iter()
        .map(line_plain_text)
        .collect::<Vec<_>>();
    assert!(help_lines
        .iter()
        .any(|line| line.contains("Open series for the selected local study")));

    app.local_drill_down = true;
    app.drill_down_study_uid = Some("1.2.3".to_string());
    let drilled_view = app.view();
    assert!(footer_status_text(&drilled_view).contains("Esc back to studies"));

    let drilled_help_lines = help_text(&drilled_view)
        .lines
        .iter()
        .map(line_plain_text)
        .collect::<Vec<_>>();
    assert!(drilled_help_lines
        .iter()
        .any(|line| line.contains("Return from Local series to studies")));

    app.focus = FocusPane::Input;
    let input_view = app.view();
    assert!(!footer_status_text(&input_view).contains("q quit"));
}

// ── render/text.rs coverage ──────────────────────────────────────────────────

#[test]
fn non_empty_text_returns_none_for_none_input() {
    assert_eq!(non_empty_text(None), None);
}

#[test]
fn non_empty_text_returns_none_for_empty_string() {
    assert_eq!(non_empty_text(Some("")), None);
}

#[test]
fn non_empty_text_returns_none_for_whitespace_only() {
    assert_eq!(non_empty_text(Some("   ")), None);
}

#[test]
fn non_empty_text_returns_trimmed_value() {
    assert_eq!(non_empty_text(Some("  hello  ")), Some("hello"));
}

#[test]
fn display_optional_detail_returns_value_when_present() {
    assert_eq!(
        display_optional_detail(Some("my-value"), "fallback"),
        "my-value"
    );
}

#[test]
fn display_optional_detail_returns_fallback_when_none() {
    assert_eq!(display_optional_detail(None, "fallback"), "fallback");
}

#[test]
fn display_optional_detail_returns_fallback_when_empty() {
    assert_eq!(display_optional_detail(Some(""), "fallback"), "fallback");
}

#[test]
fn truncate_uid_short_string_unchanged() {
    assert_eq!(truncate_uid("1.2.3", 10), "1.2.3");
}

#[test]
fn truncate_uid_exact_length_unchanged() {
    assert_eq!(truncate_uid("123456", 6), "123456");
}

#[test]
fn truncate_uid_longer_than_max_truncates_with_ellipsis() {
    assert_eq!(truncate_uid("1234567890", 7), "...7890");
}

#[test]
fn truncate_uid_max_len_zero_returns_empty() {
    assert_eq!(truncate_uid("1234567890", 0), "");
}

#[test]
fn truncate_uid_max_len_three_returns_dots_at_boundary() {
    assert_eq!(truncate_uid("1234567890", 3), "...");
}

#[test]
fn truncate_uid_max_len_two_returns_two_dots() {
    assert_eq!(truncate_uid("1234567890", 2), "..");
}

#[test]
fn truncate_tail_uses_display_width_and_grapheme_boundaries() {
    assert_eq!(truncate_tail("日本語テキスト", 5), "...ト");
    assert_eq!(truncate_tail("abcde\u{301}", 4), "...e\u{301}");
}

#[test]
fn pad_or_truncate_zero_width_returns_empty() {
    assert_eq!(pad_or_truncate("abc", 0), "");
}

#[test]
fn pad_or_truncate_pads_short_value_with_spaces() {
    let result = pad_or_truncate("hi", 5);
    assert_eq!(result, "hi   ");
    assert_eq!(result.len(), 5);
}

#[test]
fn pad_or_truncate_trims_leading_trailing_whitespace() {
    let result = pad_or_truncate("  hi  ", 4);
    assert_eq!(result, "hi  ");
}

#[test]
fn pad_or_truncate_uses_display_width_and_grapheme_boundaries() {
    assert_eq!(pad_or_truncate("日ab", 3), "日a");
    assert_eq!(pad_or_truncate("e\u{301}fg", 2), "e\u{301}f");
}

#[test]
fn bool_label_true_returns_yes() {
    assert_eq!(bool_label(true), "yes");
}

#[test]
fn bool_label_false_returns_no() {
    assert_eq!(bool_label(false), "no");
}

#[test]
fn format_node_row_contains_ae_title_and_host_port_and_name() {
    use crate::models::RemoteNode;

    let node = RemoteNode {
        id: "node-1".to_string(),
        name: "TestPACS".to_string(),
        ae_title: "PACSAE".to_string(),
        host: "10.0.0.1".to_string(),
        port: 104,
        preferred_move_destination: Some("DEST".to_string()),
        notes: None,
        created_at: "2024-01-01T00:00:00Z".to_string(),
        updated_at: "2024-01-01T00:00:00Z".to_string(),
    };

    let row = format_node_row(&node);
    assert!(row.contains("PACSAE"));
    assert!(row.contains("10.0.0.1:104"));
    assert!(row.contains("TestPACS"));
    assert!(row.contains("DEST"));
}

#[test]
fn format_node_row_shows_dash_when_no_move_destination() {
    use crate::models::RemoteNode;

    let node = RemoteNode {
        id: "node-1".to_string(),
        name: "TestPACS".to_string(),
        ae_title: "PACSAE".to_string(),
        host: "10.0.0.1".to_string(),
        port: 104,
        preferred_move_destination: None,
        notes: None,
        created_at: "2024-01-01T00:00:00Z".to_string(),
        updated_at: "2024-01-01T00:00:00Z".to_string(),
    };

    let row = format_node_row(&node);
    assert!(row.contains(" - ") || row.ends_with('-') || row.contains("| -"));
}

#[test]
fn format_study_row_contains_key_fields() {
    use crate::models::StudySummary;

    let study = StudySummary {
        study_instance_uid: "1.2.840.10008.5.1.9999".to_string(),
        patient_name: Some("DOE^JANE".to_string()),
        patient_id: Some("MRN-1".to_string()),
        study_date: Some("20240101".to_string()),
        study_description: Some("Head CT".to_string()),
        modalities: Some("CT".to_string()),
        series_count: 2,
        instance_count: 5,
    };

    let row = format_study_row(&study);
    assert!(row.contains("DOE^JANE"));
    assert!(row.contains("20240101"));
    assert!(row.contains("CT"));
    // series_count and instance_count appear in the row formatted as " 2s/5  i"
    assert!(row.contains("2s/"));
    assert!(row.contains("5"));
}

#[test]
fn format_query_result_row_contains_level_and_patient_name() {
    let item = QueryMatch {
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
    };

    let row = format_query_result_row(&item);
    assert!(row.contains("study"));
    assert!(row.contains("DOE^JANE"));
    assert!(row.contains("CT"));
    assert!(row.contains("Head CT"));
}

#[test]
fn format_series_row_contains_series_number_and_modality() {
    use crate::models::SeriesSummary;

    let series = SeriesSummary {
        study_instance_uid: "1.2.840.1".to_string(),
        series_instance_uid: "1.2.840.1.1".to_string(),
        modality: Some("MR".to_string()),
        series_number: Some("3".to_string()),
        series_description: Some("Axial T1".to_string()),
        instance_count: 20,
    };

    let row = format_series_row(&series);
    assert!(row.contains("MR"));
    assert!(row.contains("3"));
    assert!(row.contains("Axial T1"));
    assert!(row.contains("20 inst"));
}

#[test]
fn query_results_empty_text_shows_no_query_message_when_no_context() {
    let text = query_results_empty_text(None);
    let plain = text
        .lines
        .iter()
        .map(line_plain_text)
        .collect::<Vec<_>>()
        .join(" ");
    assert!(plain.contains("No query has been run yet."));
}

#[test]
fn query_results_empty_text_shows_last_query_target_when_context_provided() {
    let text = query_results_empty_text(Some("my-pacs-node"));
    let plain = text
        .lines
        .iter()
        .map(line_plain_text)
        .collect::<Vec<_>>()
        .join(" ");
    assert!(plain.contains("my-pacs-node"));
}

#[test]
fn footer_status_text_shows_running_task_description() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.running_task = Some(RunningTask {
        description: "Querying pacs...".to_string(),
        started_at: Instant::now(),
    });

    let view = app.view();
    let footer = footer_status_text(&view);

    assert!(footer.contains("Querying pacs..."));
}

#[test]
fn footer_status_text_shows_nodes_shortcuts_in_nodes_pane() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Nodes;

    let view = app.view();
    let footer = footer_status_text(&view);

    assert!(footer.contains("a/e/d/f nodes"));
    assert!(footer.contains("q quit"));
}

#[test]
fn footer_status_text_shows_retrieve_hint_in_query_pane() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());
    app.focus = FocusPane::Query;

    let view = app.view();
    let footer = footer_status_text(&view);

    assert!(footer.contains("m retrieve"));
}

#[test]
fn footer_status_text_shows_run_command_hint_in_input_pane() {
    let services = test_services();
    let app = TuiApp::new(services.services.clone());
    // default focus is Input

    let view = app.view();
    let footer = footer_status_text(&view);

    assert!(footer.contains("Enter run command"));
    assert!(!footer.contains("q quit"));
}
