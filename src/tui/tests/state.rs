use super::prelude::*;

// ── state.rs coverage: FocusPane, selection helpers ──────────────────────────

#[test]
fn focus_pane_next_cycles_through_all_variants() {
    assert_eq!(FocusPane::Input.next(), FocusPane::Nodes);
    assert_eq!(FocusPane::Nodes.next(), FocusPane::Query);
    assert_eq!(FocusPane::Query.next(), FocusPane::Local);
    assert_eq!(FocusPane::Local.next(), FocusPane::Logs);
    assert_eq!(FocusPane::Logs.next(), FocusPane::Input);
}

#[test]
fn focus_pane_previous_cycles_backwards_through_all_variants() {
    assert_eq!(FocusPane::Input.previous(), FocusPane::Logs);
    assert_eq!(FocusPane::Logs.previous(), FocusPane::Local);
    assert_eq!(FocusPane::Local.previous(), FocusPane::Query);
    assert_eq!(FocusPane::Query.previous(), FocusPane::Nodes);
    assert_eq!(FocusPane::Nodes.previous(), FocusPane::Input);
}

#[test]
fn selection_by_key_returns_none_for_empty_items() {
    let items: Vec<String> = Vec::new();
    let result = selection_by_key(&items, Some("x"), |s| s.as_str());
    assert_eq!(result, None);
}

#[test]
fn selection_by_key_finds_matching_item() {
    let items = vec!["a".to_string(), "b".to_string(), "c".to_string()];
    let result = selection_by_key(&items, Some("b"), |s| s.as_str());
    assert_eq!(result, Some(1));
}

#[test]
fn selection_by_key_falls_back_to_zero_when_key_not_found() {
    let items = vec!["a".to_string(), "b".to_string()];
    let result = selection_by_key(&items, Some("z"), |s| s.as_str());
    assert_eq!(result, Some(0));
}

#[test]
fn selection_by_key_returns_zero_when_wanted_key_is_none() {
    let items = vec!["a".to_string(), "b".to_string()];
    let result = selection_by_key(&items, None, |s| s.as_str());
    assert_eq!(result, Some(0));
}

#[test]
fn normalized_selection_returns_none_for_empty_list() {
    assert_eq!(normalized_selection(Some(0), 0), None);
    assert_eq!(normalized_selection(None, 0), None);
}

#[test]
fn normalized_selection_clamps_out_of_bounds_index() {
    assert_eq!(normalized_selection(Some(10), 3), Some(2));
}

#[test]
fn normalized_selection_returns_zero_when_current_is_none() {
    assert_eq!(normalized_selection(None, 5), Some(0));
}

#[test]
fn normalized_selection_keeps_valid_index() {
    assert_eq!(normalized_selection(Some(2), 5), Some(2));
}

#[test]
fn move_selection_on_empty_list_returns_none() {
    assert_eq!(move_selection(None, 0, 1), None);
    assert_eq!(move_selection(Some(0), 0, 1), None);
}

#[test]
fn move_selection_increments_and_clamps_at_end() {
    assert_eq!(move_selection(Some(0), 3, 1), Some(1));
    assert_eq!(move_selection(Some(2), 3, 1), Some(2)); // clamped at 2
}

#[test]
fn move_selection_decrements_and_clamps_at_zero() {
    assert_eq!(move_selection(Some(2), 3, -1), Some(1));
    assert_eq!(move_selection(Some(0), 3, -1), Some(0)); // clamped at 0
}

#[test]
fn move_selection_starts_from_zero_when_current_is_none() {
    assert_eq!(move_selection(None, 3, 1), Some(1));
    assert_eq!(move_selection(None, 3, -1), Some(0));
}
