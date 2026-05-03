use ratatui::{backend::TestBackend, widgets::ListState, Terminal};

use super::layout::{
    compute_scroll_state, list_top_index, log_window_counts, render_selectable_list,
    selected_position_text, SelectableListConfig,
};

#[test]
fn selected_position_text_formats_none_and_empty() {
    assert_eq!(selected_position_text(None, 0), "-/0");
    assert_eq!(selected_position_text(None, 3), "-/3");
}

#[test]
fn selected_position_text_is_one_based_and_bounds_checked() {
    assert_eq!(selected_position_text(Some(0), 3), "1/3");
    assert_eq!(selected_position_text(Some(2), 3), "3/3");
    // out of bounds selection should be treated as none
    assert_eq!(selected_position_text(Some(3), 3), "-/3");
}

#[test]
fn compute_scroll_state_handles_empty_and_zero_viewport() {
    let s = compute_scroll_state(0, 10, 0);
    assert!(!s.has_above);
    assert!(!s.has_below);

    let s = compute_scroll_state(10, 0, 0);
    assert!(!s.has_above);
    assert!(!s.has_below);
}

#[test]
fn compute_scroll_state_detects_above_and_below() {
    // viewport smaller than list, at top
    let s = compute_scroll_state(10, 3, 0);
    assert!(!s.has_above);
    assert!(s.has_below);

    // middle
    let s = compute_scroll_state(10, 3, 4);
    assert!(s.has_above);
    assert!(s.has_below);

    // bottom (top index clamped internally)
    let s = compute_scroll_state(10, 3, 100);
    assert!(s.has_above);
    assert!(!s.has_below);
}

#[test]
fn list_top_index_keeps_visible_selection_in_existing_viewport() {
    assert_eq!(list_top_index(10, 3, Some(4), 0), 2);
    assert_eq!(list_top_index(10, 3, Some(3), 2), 2);
    assert_eq!(list_top_index(10, 3, Some(2), 2), 2);
    assert_eq!(list_top_index(10, 3, Some(1), 2), 1);
    assert_eq!(list_top_index(10, 3, Some(9), 1), 7);
}

#[test]
fn render_selectable_list_derives_indicators_from_persisted_offset() {
    let items = (0..10).map(|idx| format!("item {idx}")).collect::<Vec<_>>();
    let backend = TestBackend::new(24, 5);
    let mut terminal = Terminal::new(backend).unwrap();
    let mut state = ListState::default();

    let mut render_selected = |state: &mut ListState, selected| {
        let mut scroll_state = None;
        terminal
            .draw(|frame| {
                scroll_state = Some(render_selectable_list(
                    frame,
                    frame.area(),
                    SelectableListConfig {
                        title: "Items".to_string(),
                        active: true,
                        items: &items,
                        selected,
                        format_item: |item: &String| item.clone(),
                        empty_text: "No items".into(),
                    },
                    state,
                ));
            })
            .unwrap();
        scroll_state.unwrap()
    };

    let first = render_selected(&mut state, Some(4));
    assert_eq!(state.offset(), 2);
    assert!(first.has_above);
    assert!(first.has_below);

    let stable = render_selected(&mut state, Some(3));
    assert_eq!(state.offset(), 2);
    assert!(stable.has_above);
    assert!(stable.has_below);

    let top_edge = render_selected(&mut state, Some(2));
    assert_eq!(state.offset(), 2);
    assert!(top_edge.has_above);
    assert!(top_edge.has_below);

    let above_viewport = render_selected(&mut state, Some(0));
    assert_eq!(state.offset(), 0);
    assert!(!above_viewport.has_above);
    assert!(above_viewport.has_below);

    let below_viewport = render_selected(&mut state, Some(9));
    assert_eq!(state.offset(), 7);
    assert!(below_viewport.has_above);
    assert!(!below_viewport.has_below);
}

#[test]
fn log_window_counts_respects_max_visible() {
    // MAX_VISIBLE_LOGS in layout.rs is 24
    assert_eq!(log_window_counts(0), (0, false));
    assert_eq!(log_window_counts(24), (24, false));
    assert_eq!(log_window_counts(25), (24, true));
}
