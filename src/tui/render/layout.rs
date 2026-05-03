// Expects the parent render module to expose ratatui primitives, TUI state,
// and sibling render helpers used to compose the full terminal layout.
use super::{
    active_block_style, config_pane_text, floor_char_boundary, footer_status_text,
    format_instance_row, format_node_row, format_query_result_row, format_series_row,
    format_study_row, local_instances_empty_text, local_series_empty_text,
    local_studies_empty_text, query_results_empty_text, remote_nodes_empty_text,
    render_detail_pane, render_help_modal, render_modal, status_summary_lines,
    truncate_tail_with_ellipsis, truncate_uid, Alignment, Block, Borders, Constraint, Direction,
    FocusPane, Frame, Layout, Line, List, ListItem, ListState, Modifier, Paragraph, Rect, Span,
    Style, Text, TuiView, Wrap, MIN_TERMINAL_HEIGHT, MIN_TERMINAL_WIDTH,
    TERMINAL_TOO_SMALL_MESSAGE,
};

const MAX_VISIBLE_LOGS: usize = 24;

pub(super) fn log_window_counts(total: usize) -> (usize, bool) {
    let shown = total.min(MAX_VISIBLE_LOGS);
    let capped = total > MAX_VISIBLE_LOGS;
    (shown, capped)
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(super) struct ScrollState {
    pub(super) has_above: bool,
    pub(super) has_below: bool,
}

pub(super) fn selected_position_text(selected: Option<usize>, len: usize) -> String {
    let pos = selected.and_then(|idx| (idx < len).then_some(idx + 1));
    let pos_text = pos
        .map(|p| p.to_string())
        .unwrap_or_else(|| "-".to_string());
    format!("{pos_text}/{len}")
}

pub(super) fn compute_scroll_state(
    len: usize,
    viewport_height: usize,
    top_index: usize,
) -> ScrollState {
    if len == 0 || viewport_height == 0 {
        return ScrollState {
            has_above: false,
            has_below: false,
        };
    }

    let max_top_index = len.saturating_sub(viewport_height);
    let top_index = top_index.min(max_top_index);

    ScrollState {
        has_above: top_index > 0,
        has_below: top_index + viewport_height < len,
    }
}

pub(super) fn list_top_index(
    len: usize,
    viewport_height: usize,
    selected: Option<usize>,
    current_top_index: usize,
) -> usize {
    if len == 0 || viewport_height == 0 {
        return 0;
    }

    let max_top_index = len.saturating_sub(viewport_height);
    let current_top_index = current_top_index.min(max_top_index);

    let Some(selected) = selected else {
        return current_top_index;
    };

    let selected = selected.min(len - 1);
    if selected < current_top_index {
        selected
    } else if selected >= current_top_index + viewport_height {
        selected + 1 - viewport_height
    } else {
        current_top_index
    }
    .min(max_top_index)
}

#[derive(Debug, Default)]
pub(in crate::tui) struct TuiListStates {
    nodes: ListState,
    local_studies: ListState,
    local_series: ListState,
    local_instances: ListState,
    query_results: ListState,
}

/// Renders the complete terminal UI for a given `TuiView` onto the provided frame.
///
/// This draws the full application layout (status, main body with selectable lists and detail/log panes,
/// and a footer with command input), positions the input cursor when appropriate, and overlays any active
/// modal or help view. If the terminal is smaller than the minimum dimensions, a centered “terminal too small”
/// message is rendered instead.
///
/// # Examples
///
/// ```rust
/// // Example (illustrative): obtain a Frame and a TuiView from your application context and call:
/// // let mut list_states = TuiListStates::default();
/// // draw_ui(&mut frame, &view, &mut list_states);
/// ```
pub(in crate::tui) fn draw_ui(
    frame: &mut Frame<'_>,
    view: &TuiView,
    list_states: &mut TuiListStates,
) {
    let area = frame.area();
    if area.width < MIN_TERMINAL_WIDTH || area.height < MIN_TERMINAL_HEIGHT {
        render_terminal_too_small(frame, area);
        return;
    }

    let root = Layout::default()
        .direction(Direction::Vertical)
        .constraints([
            Constraint::Length(3),
            Constraint::Min(10),
            Constraint::Length(4),
        ])
        .split(area);

    frame.render_widget(Paragraph::new(status_summary_lines(&view.status)), root[0]);

    let stack_vertically = area.width < 110;

    let body = Layout::default()
        .direction(if stack_vertically {
            Direction::Vertical
        } else {
            Direction::Horizontal
        })
        .constraints(if stack_vertically {
            [Constraint::Percentage(45), Constraint::Percentage(55)]
        } else {
            [Constraint::Percentage(35), Constraint::Percentage(65)]
        })
        .split(root[1]);

    let left = Layout::default()
        .direction(Direction::Vertical)
        .constraints([
            Constraint::Percentage(35),
            Constraint::Percentage(35),
            Constraint::Percentage(30),
        ])
        .split(body[0]);

    let right = Layout::default()
        .direction(Direction::Vertical)
        .constraints([
            Constraint::Percentage(35),
            Constraint::Percentage(40),
            Constraint::Percentage(25),
        ])
        .split(body[1]);

    render_selectable_list(
        frame,
        left[0],
        SelectableListConfig {
            title: "Remote Nodes".to_string(),
            active: view.focus == FocusPane::Nodes,
            items: &view.nodes,
            selected: view.selected_node,
            format_item: format_node_row,
            empty_text: remote_nodes_empty_text(),
        },
        &mut list_states.nodes,
    );

    if view.local_instance_drill_down {
        let series_uid = view
            .selected_local_series
            .and_then(|index| view.local_series.get(index))
            .map(|series| series.series_instance_uid.as_str())
            .unwrap_or("<unknown series>");

        render_selectable_list(
            frame,
            left[1],
            SelectableListConfig {
                title: format!("Instances for: {}", truncate_uid(series_uid, 20)),
                active: view.focus == FocusPane::Local,
                items: &view.local_instances,
                selected: view.selected_local_instance,
                format_item: format_instance_row,
                empty_text: local_instances_empty_text(),
            },
            &mut list_states.local_instances,
        );
    } else if view.local_drill_down {
        let local_title = view
            .drill_down_study_uid
            .as_deref()
            .map(|study_uid| format!("Series for: {}", truncate_uid(study_uid, 20)))
            .unwrap_or_else(|| "Series for: <unknown study>".to_string());

        render_selectable_list(
            frame,
            left[1],
            SelectableListConfig {
                title: local_title,
                active: view.focus == FocusPane::Local,
                items: &view.local_series,
                selected: view.selected_local_series,
                format_item: format_series_row,
                empty_text: local_series_empty_text(),
            },
            &mut list_states.local_series,
        );
    } else {
        render_selectable_list(
            frame,
            left[1],
            SelectableListConfig {
                title: "Local Studies".to_string(),
                active: view.focus == FocusPane::Local,
                items: &view.local_studies,
                selected: view.selected_local_study,
                format_item: format_study_row,
                empty_text: local_studies_empty_text(),
            },
            &mut list_states.local_studies,
        );
    }

    let config_lines = config_pane_text(view);
    frame.render_widget(
        Paragraph::new(config_lines).block(
            Block::default()
                .title("Config")
                .borders(Borders::ALL)
                .style(active_block_style(view.focus == FocusPane::Config)),
        ),
        left[2],
    );

    render_selectable_list(
        frame,
        right[0],
        SelectableListConfig {
            title: "Query / Retrieve Results".to_string(),
            active: view.focus == FocusPane::Query,
            items: &view.query_results,
            selected: view.selected_query_result,
            format_item: format_query_result_row,
            empty_text: query_results_empty_text(view.query_context_node_name.as_deref()),
        },
        &mut list_states.query_results,
    );

    render_detail_pane(frame, right[1], view);

    render_logs(frame, right[2], view.focus == FocusPane::Logs, &view.logs);

    // Build config lines on-demand for display in the Config pane.

    let footer = Layout::default()
        .direction(Direction::Vertical)
        .constraints([Constraint::Length(3), Constraint::Length(1)])
        .split(root[2]);

    let input_text = if view.input_content.is_empty() {
        Text::from(Line::from(Span::styled(
            "Type a command or use pane shortcuts.",
            Style::default(),
        )))
    } else {
        Text::from(Line::from(view.input_content.clone()))
    };

    let input_area = footer[0];
    frame.render_widget(
        Paragraph::new(input_text).block(
            Block::default()
                .title("Command")
                .borders(Borders::ALL)
                .style(active_block_style(view.focus == FocusPane::Input)),
        ),
        input_area,
    );
    render_input_cursor(frame, input_area, view);

    let footer_status = footer_status_text(view);

    frame.render_widget(Paragraph::new(footer_status), footer[1]);

    if let Some(modal) = &view.modal {
        render_modal(frame, frame.area(), modal);
    }

    if view.show_help && view.modal.is_none() {
        render_help_modal(frame, frame.area(), view);
    }
}

/// Positions the terminal cursor inside the command input area based on the view's input cursor.
///
/// If the input pane is focused and the area is sufficiently large, computes a character-boundary-aligned
/// cursor offset (clamped to the input interior) and sets the frame cursor to that location.
/// Does nothing when the input pane is not focused or the area is too small to contain an interior.
///
/// # Parameters
///
/// - `frame`: the drawing frame used to set the cursor position.
/// - `area`: the outer rectangle of the input pane (cursor is placed inside the pane's inner area).
/// - `view`: the current TUI view containing `input_content`, `input_cursor`, and `focus`.
///
/// # Examples
///
/// ```rust,no_run
/// // assume `frame`, `area`, and `view` are available and view.focus == FocusPane::Input
/// render_input_cursor(&mut frame, area, &view);
/// ```
pub(in crate::tui) fn render_input_cursor(frame: &mut Frame<'_>, area: Rect, view: &TuiView) {
    if view.focus != FocusPane::Input || area.width <= 2 || area.height <= 2 {
        return;
    }

    let cursor = floor_char_boundary(&view.input_content, view.input_cursor);
    let cursor_width = Line::from(&view.input_content[..cursor]).width();
    let input_width = area.width.saturating_sub(2);
    let cursor_offset = cursor_width.min(usize::from(input_width.saturating_sub(1))) as u16;

    frame.set_cursor_position((area.x + 1 + cursor_offset, area.y + 1));
}

/// Render a centered "terminal too small" message within `area`.
///
/// If `area.width` or `area.height` is zero, this function returns without rendering anything.
///
/// # Parameters
///
/// - `frame`: the drawing frame to render into (typically `frame` passed to the main draw routine).
/// - `area`: the rectangle representing the available terminal area (commonly `frame.area()`).
///
/// # Examples
///
/// ```no_run
/// // Called from a TUI draw function:
/// // render_terminal_too_small(frame, frame.area());
/// ```
pub(in crate::tui) fn render_terminal_too_small(frame: &mut Frame<'_>, area: Rect) {
    if area.width == 0 || area.height == 0 {
        return;
    }

    let message_area = Rect {
        x: area.x,
        y: area.y + (area.height / 2),
        width: area.width,
        height: 1,
    };

    frame.render_widget(
        Paragraph::new(TERMINAL_TOO_SMALL_MESSAGE)
            .alignment(Alignment::Center)
            .style(Style::default().add_modifier(Modifier::BOLD)),
        message_area,
    );
}

pub(super) struct SelectableListConfig<'a, T, F> {
    pub(super) title: String,
    pub(super) active: bool,
    pub(super) items: &'a [T],
    pub(super) selected: Option<usize>,
    pub(super) format_item: F,
    pub(super) empty_text: Text<'static>,
}

/// Render a titled, selectable list block with an optional empty-state display.
///
/// When `config.items` is empty this renders `config.empty_text` inside a bordered
/// block titled with `config.title`. Otherwise it renders each item (formatted by
/// `config.format_item`) as a selectable `List`, applying the given `selected`
/// index to the list state and using a reversed highlight with the `">> "` prefix.
/// The block's visual style reflects whether `config.active` is true.
///
/// # Examples
///
/// ```ignore
/// use tui::layout::Rect;
/// // Construct a configuration for a list of strings.
/// let cfg = SelectableListConfig {
///     title: "Names".to_string(),
///     active: true,
///     items: &["alice", "bob", "carol"],
///     selected: Some(1),
///     format_item: |s: &&str| s.to_string(),
///     empty_text: tui::text::Text::raw("No items"),
/// };
/// // `frame` and `area` would come from the calling TUI render context.
/// // render_selectable_list(&mut frame, area, cfg);
/// ```
pub(super) fn render_selectable_list<T, F>(
    frame: &mut Frame<'_>,
    area: Rect,
    config: SelectableListConfig<'_, T, F>,
    state: &mut ListState,
) -> ScrollState
where
    F: Fn(&T) -> String,
{
    let SelectableListConfig {
        title,
        active,
        items,
        selected,
        format_item,
        empty_text,
    } = config;

    let selection_index = selected.filter(|&idx| idx < items.len());
    let title_with_count = format!(
        "{} ({})",
        title,
        selected_position_text(selection_index, items.len())
    );

    let viewport_height = area.height.saturating_sub(2) as usize;

    let block = Block::default()
        .title(title_with_count)
        .borders(Borders::ALL)
        .style(active_block_style(active));

    if items.is_empty() {
        state.select(None);
        frame.render_widget(
            Paragraph::new(empty_text)
                .block(block)
                .wrap(Wrap { trim: false }),
            area,
        );
        return ScrollState {
            has_above: false,
            has_below: false,
        };
    }

    let items = items
        .iter()
        .map(|item| {
            let line = format_item(item);
            if area.width <= 2 {
                return ListItem::new(line);
            }

            let available = area.width.saturating_sub(2) as usize;
            let truncated = truncate_tail_with_ellipsis(&line, available, "…");
            ListItem::new(truncated)
        })
        .collect::<Vec<_>>();
    state.select(selection_index);
    let top_index = list_top_index(
        items.len(),
        viewport_height,
        selection_index,
        state.offset(),
    );
    *state.offset_mut() = top_index;

    let scroll_state = compute_scroll_state(items.len(), viewport_height, state.offset());
    let up_indicator = if scroll_state.has_above { "▲" } else { " " };
    let down_indicator = if scroll_state.has_below { "▼" } else { " " };

    frame.render_stateful_widget(
        List::new(items)
            .block(block)
            .highlight_style(Style::default().add_modifier(Modifier::REVERSED))
            .highlight_symbol(format!("{up_indicator}> ")),
        area,
        state,
    );

    // Bottom indicator is rendered as a separate overlay line when there are items below.
    // We keep this minimal to avoid re-layout: draw a single glyph at the bottom-left of the list.
    if scroll_state.has_below && area.height > 2 {
        let bottom = Rect {
            x: area.x + 1,
            y: area.y + area.height - 2,
            width: 1,
            height: 1,
        };
        frame.render_widget(Paragraph::new(down_indicator), bottom);
    }

    scroll_state
}

/// Renders the most recent log lines in a bordered "Logs" list.
///
/// Displays up to `MAX_VISIBLE_LOGS` most recent entries from `logs` (preserving chronological order).
/// The `active` flag controls the block style applied to the list.
///
/// # Parameters
///
/// - `frame`: the drawing surface to render into.
/// - `area`: the rectangular region in which the logs list will be drawn.
/// - `active`: when `true`, applies the active pane styling to the block.
/// - `logs`: slice of log lines; the most recent lines are shown (up to `MAX_VISIBLE_LOGS`).
///
/// # Examples
///
/// ```no_run
/// // Assuming `frame` and `area` are available from a TUI draw context:
/// let logs = vec![
///     "Started service".to_string(),
///     "Received request".to_string(),
///     "Processed request".to_string(),
/// ];
/// render_logs(&mut frame, area, true, &logs);
/// ```
pub(in crate::tui) fn render_logs(
    frame: &mut Frame<'_>,
    area: Rect,
    active: bool,
    logs: &[String],
) {
    let inner_width = area.width.saturating_sub(2) as usize;
    let (shown, capped) = log_window_counts(logs.len());
    let lines: Vec<Line> = logs
        .iter()
        .rev()
        .take(shown)
        .rev()
        .flat_map(|line| {
            if inner_width == 0 || line.len() <= inner_width {
                vec![Line::from(line.clone())]
            } else {
                line.chars()
                    .collect::<Vec<_>>()
                    .chunks(inner_width)
                    .map(|chunk| Line::from(chunk.iter().collect::<String>()))
                    .collect()
            }
        })
        .collect();

    let has_above = logs.len() > shown;
    let up_indicator = if has_above { "▲" } else { " " };

    frame.render_widget(
        Paragraph::new(lines)
            .block(
                Block::default()
                    .title(format!(
                        "Logs ({shown}/{total}{capped_suffix})",
                        total = logs.len(),
                        capped_suffix = if capped { " capped" } else { "" }
                    ))
                    .borders(Borders::ALL)
                    .style(active_block_style(active)),
            )
            .wrap(Wrap { trim: false }),
        area,
    );

    if has_above && area.height > 2 {
        let top = Rect {
            x: area.x + 1,
            y: area.y + 1,
            width: 1,
            height: 1,
        };
        frame.render_widget(Paragraph::new(up_indicator), top);
    }
}
