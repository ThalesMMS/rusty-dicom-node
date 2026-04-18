// Expects the parent render module to expose ratatui primitives, TUI state,
// and sibling render helpers used to compose the full terminal layout.
use super::{
    active_block_style, floor_char_boundary, footer_status_text, format_node_row,
    format_query_result_row, format_series_row, format_study_row, local_series_empty_text,
    local_studies_empty_text, query_results_empty_text, remote_nodes_empty_text,
    render_detail_pane, render_help_modal, render_modal, truncate_uid, Alignment, Block, Borders,
    Constraint, Direction, FocusPane, Frame, Layout, Line, List, ListItem, ListState, Modifier,
    Paragraph, Rect, Span, Style, Text, TuiView, Wrap, MIN_TERMINAL_HEIGHT, MIN_TERMINAL_WIDTH,
    TERMINAL_TOO_SMALL_MESSAGE,
};

const MAX_VISIBLE_LOGS: usize = 24;

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
/// // draw_ui(&mut frame, &view);
/// ```
pub(in crate::tui) fn draw_ui(frame: &mut Frame<'_>, view: &TuiView) {
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

    frame.render_widget(
        Paragraph::new(view.status.summary_lines()),
        root[0],
    );

    let body = Layout::default()
        .direction(Direction::Horizontal)
        .constraints([Constraint::Percentage(35), Constraint::Percentage(65)])
        .split(root[1]);

    let left = Layout::default()
        .direction(Direction::Vertical)
        .constraints([Constraint::Percentage(35), Constraint::Percentage(65)])
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
    );

    if view.local_drill_down {
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
        );
    }

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
    );

    render_detail_pane(frame, right[1], view);
    render_logs(frame, right[2], view.focus == FocusPane::Logs, &view.logs);

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

pub(in crate::tui) struct SelectableListConfig<'a, T, F> {
    title: String,
    active: bool,
    items: &'a [T],
    selected: Option<usize>,
    format_item: F,
    empty_text: Text<'static>,
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
pub(in crate::tui) fn render_selectable_list<T, F>(
    frame: &mut Frame<'_>,
    area: Rect,
    config: SelectableListConfig<'_, T, F>,
) where
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

    let block = Block::default()
        .title(title)
        .borders(Borders::ALL)
        .style(active_block_style(active));

    if items.is_empty() {
        frame.render_widget(
            Paragraph::new(empty_text)
                .block(block)
                .wrap(Wrap { trim: false }),
            area,
        );
        return;
    }

    let items = items
        .iter()
        .map(|item| ListItem::new(format_item(item)))
        .collect::<Vec<_>>();
    let mut state = ListState::default();
    state.select(selected);

    frame.render_stateful_widget(
        List::new(items)
            .block(block)
            .highlight_style(Style::default().add_modifier(Modifier::REVERSED))
            .highlight_symbol(">> "),
        area,
        &mut state,
    );
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
    let lines: Vec<Line> = logs
        .iter()
        .rev()
        .take(MAX_VISIBLE_LOGS)
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

    frame.render_widget(
        Paragraph::new(lines)
            .block(
                Block::default()
                    .title("Logs")
                    .borders(Borders::ALL)
                    .style(active_block_style(active)),
            )
            .wrap(Wrap { trim: false }),
        area,
    );
}
