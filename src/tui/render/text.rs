use super::*;
use unicode_segmentation::UnicodeSegmentation;
use unicode_width::UnicodeWidthStr;

use crate::{
    models::LocalInstance,
    tui::suggestions::{resolve_top_suggestion, SuggestionContext},
};

pub(in crate::tui) const FOCUSED_PANE_MARKER: &str = "▶ ";

pub(in crate::tui) fn pane_title_text(title: &str, focused: bool) -> String {
    if focused {
        format!("{FOCUSED_PANE_MARKER}{title}")
    } else {
        title.to_string()
    }
}

/// Produce a trimmed string slice when the input contains non-whitespace characters.
///
/// Trims surrounding whitespace from the provided `&str` and yields `Some(&str)` if the
/// trimmed result is not empty; returns `None` if the input is `None` or the trimmed
/// string is empty.
///
/// # Returns
///
/// `Some(&str)` with the trimmed content if it contains at least one character after trimming, `None` otherwise.
///
/// # Examples
///
/// ```
/// assert_eq!(non_empty_text(Some("  hello ")), Some("hello"));
/// assert_eq!(non_empty_text(Some("   ")), None);
/// assert_eq!(non_empty_text(None), None);
/// ```
pub(in crate::tui) fn non_empty_text(value: Option<&str>) -> Option<&str> {
    value.map(str::trim).filter(|value| !value.is_empty())
}

/// Selects a trimmed, non-empty string from `value`, falling back to `fallback` when none is available.
///
/// Returns the trimmed `&str` from `value` if it contains non-whitespace characters; otherwise returns `fallback` as an owned `String`.
///
/// # Examples
///
/// ```
/// assert_eq!(display_optional_detail(Some("  foo  "), "-"), "foo".to_string());
/// assert_eq!(display_optional_detail(Some("   "), "-"), "-".to_string());
/// assert_eq!(display_optional_detail(None, "<none>"), "<none>".to_string());
/// ```
pub(in crate::tui) fn display_optional_detail(value: Option<&str>, fallback: &str) -> String {
    non_empty_text(value).unwrap_or(fallback).to_string()
}

/// Construct the help Text shown in the TUI, tailoring wording and status lines to the current view.
///
/// This produces a multi-line Text block containing keybindings, common CLI command examples,
/// and a "Current configuration" section populated from `view.status`. The wording for the
/// Enter and Esc help lines adapts to `view.focus` and `view.local_drill_down` to reflect
/// whether the Local pane is focused and whether it is drilled down into a series.
///
/// # Examples
///
/// ```
/// # use crate::tui::render::text::help_text;
/// # use crate::tui::TuiView;
/// # // Construct a minimal TuiView for demonstration (the real type lives in the crate).
/// let view = TuiView::default();
/// let text = help_text(&view);
/// // The returned Text always contains at least one line describing keybindings.
/// assert!(text.iter().next().is_some());
/// ```
pub(in crate::tui) fn help_text(view: &TuiView) -> Text<'static> {
    let enter_line = match (view.focus, view.local_drill_down, view.local_instance_drill_down) {
        (FocusPane::Local, _, true) => tr("tui-help-enter-instance"),
        (FocusPane::Local, true, false) => tr("tui-help-enter-series"),
        (FocusPane::Local, false, false) => tr("tui-help-enter-study"),
        _ => tr("tui-help-enter-default"),
    };
    let esc_line = if view.focus == FocusPane::Local && view.local_instance_drill_down {
        tr("tui-help-esc-instances")
    } else if view.focus == FocusPane::Local && view.local_drill_down {
        tr("tui-help-esc-series")
    } else {
        tr("tui-help-esc-default")
    };

    Text::from(vec![
        Line::from(tr("tui-help-title")),
        Line::from(tr("tui-help-open")),
        Line::from(tr("tui-help-tab")),
        Line::from(tr("tui-help-move")),
        Line::from(tr("tui-help-refresh")),
        Line::from(tr("tui-help-nodes")),
        Line::from(tr("tui-help-retrieve")),
        Line::from(tr("tui-help-import-send")),
        Line::from(tr("tui-help-config")),
        Line::from(enter_line),
        Line::from(esc_line),
        Line::from(tr("tui-help-quit")),
        Line::from(""),
        Line::from(tr("tui-help-common-commands")),
        Line::from(tr("tui-help-canonical-names")),
        Line::from("  node add name=pacs ae=PACSAE host=10.0.0.10 port=104"),
        Line::from("  import path=/data/inbox"),
        Line::from("  query node=pacs patient_name=\"DOE^JOHN\" date_from=20240101"),
        Line::from("  retrieve node=pacs study_uid=1.2.3.4.5 dest=DICOMNODECLIENT"),
        Line::from("  send-study node=archive study_uid=1.2.3.4.5"),
        Line::from(""),
        Line::from(tr("tui-help-current-config")),
        Line::from(tr1("tui-help-ae-title", "value", &view.status.local_ae_title)),
        Line::from(tr1("tui-help-listener", "value", &view.status.listener_addr)),
        Line::from(tr1(
            "tui-help-receiver-mode",
            "value",
            view.status.receiver_mode.to_string(),
        )),
        Line::from(tr1(
            "tui-help-strict-pdu",
            "value",
            bool_label(view.status.strict_pdu),
        )),
        Line::from(tr1(
            "tui-help-max-pdu",
            "value",
            view.status.max_pdu_length.to_string(),
        )),
        Line::from(tr1(
            "tui-help-promiscuous",
            "value",
            bool_label(view.status.allow_promiscuous_storage),
        )),
        Line::from(tr1(
            "tui-help-ts-pref",
            "value",
            &view.status.preferred_store_transfer_syntax,
        )),
        Line::from(tr1(
            "tui-help-config-path",
            "value",
            &view.status.config_path,
        )),
        Line::from(tr1("tui-help-data-dir", "value", &view.status.data_dir)),
        Line::from(tr1("tui-help-log-dir", "value", &view.status.log_dir)),
        Line::from(""),
        Line::from(tr("tui-help-close")),
    ])
}

/// Build the footer status line for the TUI based on current view state.
///
/// The returned string is a single line composed of command segments separated by
/// " | ". If a running task is present in the view, the line describes that task;
/// otherwise it lists common footer commands and adds focus-specific segments
/// (and a "q quit" segment unless the input pane has focus).
///
/// # Returns
///
/// The composed footer status line as an owned `String`.
///
pub(in crate::tui) fn footer_status_text(view: &TuiView) -> String {
    let queued_count = view
        .queued_tasks
        .iter()
        .filter(|task| task.status == TaskStatus::Queued)
        .count();

    if let Some(task) = view.running_task.as_ref() {
        let mut text = running_task_status_line(task);
        if queued_count > 0 {
            text.push_str(" | ");
            text.push_str(&tr_n("tui-footer-queued", "n", queued_count as i64));
        }
        return text;
    }

    let mut parts: Vec<String> = vec![
        tr("tui-footer-help"),
        tr("tui-footer-panes"),
        tr("tui-footer-refresh"),
    ];

    if queued_count > 0 {
        parts.push(tr_n("tui-footer-queued", "n", queued_count as i64));
    }

    match view.focus {
        FocusPane::Nodes => parts.push(tr("tui-footer-nodes")),
        FocusPane::Query => parts.push(tr("tui-footer-retrieve")),
        FocusPane::Local if view.local_instance_drill_down => {
            parts.push(tr("tui-footer-back-series"))
        }
        FocusPane::Local if view.local_drill_down => parts.push(tr("tui-footer-back-studies")),
        FocusPane::Local => parts.push(tr("tui-footer-enter-series")),
        FocusPane::Config => parts.push(tr("tui-footer-edit-config")),
        FocusPane::Input => parts.push(tr("tui-footer-run-command")),
        FocusPane::Logs => {}
        FocusPane::Tasks => {
            parts.push(tr("tui-footer-inspect"));
            parts.push(tr("tui-footer-cancel-task"));
            parts.push(tr("tui-footer-task-scope"));
        }
    }

    let mut suggestion_ctx = SuggestionContext::new(view.focus);
    suggestion_ctx.show_help = view.show_help;
    suggestion_ctx.has_selected_node = view.selected_node.is_some();
    suggestion_ctx.has_query_results = !view.query_results.is_empty();
    suggestion_ctx.has_selected_query_result = view.selected_query_result.is_some();
    suggestion_ctx.local_drill_down = view.local_drill_down;
    suggestion_ctx.local_instance_drill_down = view.local_instance_drill_down;
    suggestion_ctx.has_selected_local_study = view.selected_local_study.is_some();
    suggestion_ctx.has_selected_local_series = view.selected_local_series.is_some();
    suggestion_ctx.has_selected_local_instance = view.selected_local_instance.is_some();
    suggestion_ctx.has_queued_tasks = queued_count > 0;

    // Suggestion segment: a non-interactive hint about the next likely action.
    // NOTE: Do not truncate here unconditionally; the footer is width-limited at render time.
    let suggestion = resolve_top_suggestion(suggestion_ctx);
    let next_segment = tr1("tui-footer-next", "text", &suggestion.text);
    parts.push(next_segment);

    // No telemetry/logging: suggestions are derived deterministically per-render and
    // should not generate logs in normal operation.

    if view.focus != FocusPane::Input {
        parts.push(tr("tui-footer-quit"));
    }
    parts.join(" | ")
}

/// Produces the help text shown when there are no configured remote nodes.
///
/// # Examples
///
/// ```
/// let txt = remote_nodes_empty_text(); // Text block describing how to add a remote node
/// assert!(true); // example usage; inspect `txt` in the TUI environment
/// ```
pub(in crate::tui) fn remote_nodes_empty_text() -> Text<'static> {
    text_from_ftl("tui-empty-remote-nodes")
}

/// A Text block explaining that no local studies are indexed and showing an example import command.
///
/// # Examples
///
/// ```
/// let _ = local_studies_empty_text();
/// ```
pub(in crate::tui) fn local_studies_empty_text() -> Text<'static> {
    text_from_ftl("tui-empty-local-studies")
}

/// Creates a Text block indicating there are no indexed series for the current study.
///
/// The returned text contains a primary message, a blank line, and an instruction to press Esc
/// to return to local studies.
///
/// # Examples
///
/// ```
/// let txt = local_series_empty_text();
/// assert!(format!("{:?}", txt).contains("No indexed series are available for this study."));
/// ```
pub(in crate::tui) fn local_series_empty_text() -> Text<'static> {
    text_from_ftl("tui-empty-local-series")
}

pub(in crate::tui) fn local_instances_empty_text() -> Text<'static> {
    text_from_ftl("tui-empty-local-instances")
}

/// Generates the help text shown when there are no query results.
///
/// The first line indicates the last query target when available, otherwise notes that no
/// query has been run. The returned `Text` includes instructions for running a query and
/// retrieving results.
///
/// # Examples
///
/// ```rust
/// let _ = crate::tui::render::text::query_results_empty_text(Some("pacs"));
/// ```
pub(in crate::tui) fn query_results_empty_text(
    query_context_node_name: Option<&str>,
) -> Text<'static> {
    let source_line = match query_context_node_name {
        Some(node_name) => tr1("tui-empty-query-last-target", "name", node_name),
        None => tr("tui-empty-query-none"),
    };

    let mut lines = vec![Line::from(source_line), Line::from("")];
    lines.extend(text_from_ftl("tui-empty-query-body").lines);
    Text::from(lines)
}

/// Return a style used for pane borders/titles when the pane is focused.
///
/// This intentionally does **not** rely on bold alone: focused panes are additionally colored
/// (cyan) so focus remains visible across terminal themes.
///
/// # Returns
///
/// When `active` is `true`, returns a cyan, bold style. Otherwise returns `Style::default()`.
///
/// # Examples
///
/// ```
/// use ratatui::style::{Style, Color, Modifier};
/// let on = active_block_style(true);
/// let off = active_block_style(false);
/// assert_eq!(on, Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD));
/// assert_eq!(off, Style::default());
/// ```
pub(in crate::tui) fn active_block_style(active: bool) -> Style {
    if active {
        Style::default()
            .fg(Color::Cyan)
            .add_modifier(Modifier::BOLD)
    } else {
        Style::default()
    }
}

pub(in crate::tui) fn config_pane_text(view: &TuiView) -> Text<'static> {
    Text::from(vec![
        Line::from(tr1("tui-config-ae-title", "value", &view.status.local_ae_title)),
        Line::from(tr1("tui-config-listener", "value", &view.status.listener_addr)),
        Line::from(tr1(
            "tui-config-strict-pdu",
            "value",
            bool_label(view.status.strict_pdu),
        )),
        Line::from(tr1(
            "tui-config-promiscuous",
            "value",
            bool_label(view.status.allow_promiscuous_storage),
        )),
        Line::from(tr1(
            "tui-config-max-pdu",
            "value",
            view.status.max_pdu_length.to_string(),
        )),
        Line::from(tr1(
            "tui-config-ts-pref",
            "value",
            &view.status.preferred_store_transfer_syntax,
        )),
        Line::from(""),
        Line::from(tr("tui-config-hint")),
    ])
}

/// Truncates a string to a maximum display-cell width by keeping the tail and
/// prefixing an ellipsis when truncation is required.
///
/// The input is trimmed before measuring. If the trimmed width is less than or
/// equal to `max_len`, the trimmed string is returned unchanged. If
/// `max_len` is less than or equal to 3, the function returns a string of
/// `max_len` periods (e.g., `".", "..", "..."`). Otherwise the result is
/// `"..."` followed by the last grapheme clusters that fit in `max_len - 3`
/// display cells from the
/// trimmed input.
///
/// # Examples
///
/// ```
/// assert_eq!(truncate_tail("  hello world  ", 8), "...world");
/// assert_eq!(truncate_tail("short", 10), "short");
/// assert_eq!(truncate_tail("日本語テキスト", 5), "...ト");
/// assert_eq!(truncate_tail("abc", 2), "..");
/// ```
#[allow(
    dead_code,
    reason = "kept for callers that require ASCII ellipsis; current layout uses the configurable form"
)]
pub(in crate::tui) fn truncate_tail(value: &str, max_len: usize) -> String {
    truncate_tail_with_ellipsis(value, max_len, "...")
}

/// Like [`truncate_tail`] but allows customizing the ellipsis string.
///
/// This is useful when table-like layouts want a single-cell ellipsis (`"…"`) to
/// preserve more of the suffix content.
pub(in crate::tui) fn truncate_tail_with_ellipsis(
    value: &str,
    max_len: usize,
    ellipsis: &str,
) -> String {
    let value = value.trim();

    if max_len == 0 {
        return String::new();
    }

    if UnicodeWidthStr::width(value) <= max_len {
        return value.to_string();
    }

    let ellipsis_width = UnicodeWidthStr::width(ellipsis);

    // Keep existing truncate_tail behavior for very small widths: show dot-runs
    // up to 3 cells.
    if max_len <= 3 {
        return ".".repeat(max_len);
    }

    // If the requested ellipsis itself can't fit, fall back to dot-runs.
    if max_len <= ellipsis_width {
        return ".".repeat(max_len);
    }

    let suffix_len = max_len - ellipsis_width;
    let suffix = suffix_by_display_width(value, suffix_len);
    format!("{ellipsis}{suffix}")
}

/// Truncates a UID to at most `max_len` display cells, preserving the end of the UID and
/// inserting an ellipsis when truncation is necessary.
///
/// The function trims surrounding whitespace before measuring width. If the trimmed UID
/// fits within `max_len`, it is returned unchanged. If `max_len` is less than or equal
/// to 3, the result is a string of `max_len` dots. Otherwise the returned string begins
/// with `"..."` followed by the last grapheme clusters of the UID so the total width is at most
/// `max_len`.
///
/// # Examples
///
/// ```
/// assert_eq!(truncate_uid("  1.2.840.113619.2.55.3  ", 10), "...3.2.55.3");
/// assert_eq!(truncate_uid("short", 10), "short");
/// assert_eq!(truncate_uid("abcdef", 3), "...");
/// ```
pub(in crate::tui) fn truncate_uid(uid: &str, max_len: usize) -> String {
    // UIDs benefit from keeping the suffix, so use a single-cell ellipsis to
    // retain a bit more of the tail in tight columns.
    truncate_tail_with_ellipsis(uid, max_len, "…")
}

/// Truncates a path-like string to at most `max_len` display cells, preserving the tail and
/// prefixing an ellipsis when the original needs shortening.
///
/// If the trimmed path fits within `max_len`, the trimmed path is returned unchanged.
/// When truncation is required and `max_len > 3`, the result is `"..."` followed by the
/// last grapheme clusters that fit in `max_len - 3` display cells. When `max_len <= 3`, the function
/// returns a string of `max_len` period characters (e.g., `".."` for `max_len == 2`).
///
/// # Examples
///
/// ```
/// let s = "/very/long/path/to/file.dcm";
/// assert_eq!(truncate_path(s, 10), "...o/file.dcm");
/// assert_eq!(truncate_path(s, 100), "/very/long/path/to/file.dcm");
/// assert_eq!(truncate_path(s, 3), "...");
/// assert_eq!(truncate_path("  short  ", 6), "short");
/// ```
pub(in crate::tui) fn truncate_path(path: &str, max_len: usize) -> String {
    truncate_tail_with_ellipsis(path, max_len, "…")
}

/// Produce a fixed-width string by trimming the input and then truncating or padding it
/// to exactly `width` terminal display cells.
///
/// - If `width` is zero, returns an empty `String`.
/// - Trims whitespace from both ends of `value`.
/// - If the trimmed string has at least `width` display cells, it is truncated on a grapheme boundary.
/// - If it has fewer than `width` display cells, spaces are appended on the right until the width equals `width`.
///
/// # Examples
///
/// ```
/// // padding
/// assert_eq!(pad_or_truncate("  hi  ", 5), "hi   ");
///
/// // truncation (counts terminal display cells)
/// assert_eq!(pad_or_truncate("héllo", 3), "hél");
///
/// // width zero yields empty string
/// assert_eq!(pad_or_truncate("something", 0), "");
/// ```
pub(in crate::tui) fn pad_or_truncate(value: &str, width: usize) -> String {
    if width == 0 {
        return String::new();
    }

    let value = value.trim();
    let mut out = String::with_capacity(value.len().max(width));
    let mut display_width = 0;

    for grapheme in value.graphemes(true) {
        let grapheme_width = UnicodeWidthStr::width(grapheme);
        if display_width + grapheme_width > width {
            break;
        }

        out.push_str(grapheme);
        display_width += grapheme_width;
        if display_width == width {
            break;
        }
    }

    out.extend(std::iter::repeat_n(' ', width - display_width));
    out
}

fn suffix_by_display_width(value: &str, max_width: usize) -> String {
    let mut suffix = Vec::new();
    let mut display_width = 0;

    for grapheme in value.graphemes(true).rev() {
        let grapheme_width = UnicodeWidthStr::width(grapheme);
        if display_width + grapheme_width > max_width {
            break;
        }

        suffix.push(grapheme);
        display_width += grapheme_width;
        if display_width == max_width {
            break;
        }
    }

    suffix.reverse();
    suffix.concat()
}

/// Format a remote node as a single table row with four fixed-width columns:
/// AE title, host:port, node name, and preferred move destination.
///
/// Each column is padded or truncated by character count to widths 16, 22, 18, and 14,
/// respectively; empty preferred move destinations are shown as "-".
///
/// # Examples
///
/// ```
/// // Example output shape (columns separated by " | "):
/// // "AE_TITLE         | host.example.com:104   | node-name        | DEST       "
/// ```
pub(in crate::tui) fn format_node_row(node: &RemoteNode) -> String {
    let host_port = format!("{}:{}", node.host, node.port);
    let move_destination =
        non_empty_text(node.preferred_move_destination.as_deref()).unwrap_or("-");

    format!(
        "{} | {} | {} | {}",
        pad_or_truncate(&node.ae_title, 16),
        pad_or_truncate(&host_port, 22),
        pad_or_truncate(&node.name, 18),
        pad_or_truncate(move_destination, 14),
    )
}

/// Format a study summary into a single fixed-width row for list display.
///
/// The returned string contains five pipe-separated columns:
/// - patient name (trimmed, padded/truncated to 20 characters),
/// - study date (trimmed, padded/truncated to 10 characters),
/// - modalities (trimmed, padded/truncated to 8 characters),
/// - series and instance counts formatted as `<series_count>s/<instance_count>i` with series right-aligned to 2 and instances left-aligned to 3,
/// - study instance UID truncated to 20 characters.
///
/// # Examples
///
/// ```no_run
/// // Given a StudySummary `study`, produce a single-line row for display:
/// let row = format_study_row(&study);
/// // Example output: "John Doe            | 2024-01-01 | CT      |  3s/12i | 1.2.840.113619..."
/// println!("{}", row);
/// ```
pub(in crate::tui) fn format_study_row(study: &StudySummary) -> String {
    let missing_name = tr("tui-empty-no-name");
    let patient_name = non_empty_text(study.patient_name.as_deref()).unwrap_or(missing_name.as_str());
    let formatted_date = non_empty_text(study.study_date.as_deref())
        .map(crate::i18n::format_operator_date);
    let study_date = formatted_date.as_deref().unwrap_or("-");
    let modalities = non_empty_text(study.modalities.as_deref()).unwrap_or("-");
    let mut count_args = HashMap::new();
    count_args.insert("series".into(), FluentValue::from(study.series_count));
    count_args.insert("instances".into(), FluentValue::from(study.instance_count));
    let counts = crate::i18n::t_with("tui-row-study-counts", &count_args);

    format!(
        "{} | {} | {} | {} | {}",
        pad_or_truncate(patient_name, 20),
        pad_or_truncate(study_date, 10),
        pad_or_truncate(modalities, 8),
        counts,
        truncate_uid(&study.study_instance_uid, 20),
    )
}

/// Format a single query result row for display in the UI.
///
/// Produces a five-column, pipe-separated line containing:
/// - query `level` (padded/truncated to 6),
/// - patient name (trimmed, `"-"` if empty, width 20),
/// - context (modality or study date, `"-"` if none, width 10),
/// - description (series description, study description, or `"-"`, width 24),
/// - primary UID truncated to 20 characters.
///
/// Empty or whitespace-only fields are replaced with `"-"`; long fields are truncated or padded to fixed widths.
///
/// # Returns
///
/// A formatted `String` representing the row.
pub(in crate::tui) fn format_query_result_row(item: &QueryMatch) -> String {
    let description = item
        .series_description
        .as_deref()
        .and_then(|value| non_empty_text(Some(value)))
        .or_else(|| non_empty_text(item.study_description.as_deref()))
        .unwrap_or("-");
    let formatted_date = non_empty_text(item.study_date.as_deref())
        .map(crate::i18n::format_operator_date);
    let context = item
        .modality
        .as_deref()
        .and_then(|value| non_empty_text(Some(value)))
        .map(str::to_string)
        .or(formatted_date)
        .unwrap_or_else(|| "-".to_string());
    let patient_name = non_empty_text(item.patient_name.as_deref()).unwrap_or("-");
    let primary_uid = item.primary_uid().unwrap_or("-");

    format!(
        "{} | {} | {} | {} | {}",
        pad_or_truncate(&item.level.to_string(), 6),
        pad_or_truncate(patient_name, 20),
        pad_or_truncate(&context, 10),
        pad_or_truncate(description, 24),
        truncate_uid(primary_uid, 20),
    )
}

/// Format a series summary into a single fixed-width table row for display.
///
/// The row contains four columns separated by " | ":
/// - series number, padded or truncated to 4 characters (fallback `"-"` when empty),
/// - modality, padded or truncated to 8 characters (fallback `"-"` when empty),
/// - instance count rendered right-aligned into a 4-character field followed by `" inst"`,
/// - series description, padded or truncated to 28 characters (fallback `"-"` when empty).
///
/// Empty or whitespace-only optional fields are treated as absent and replaced with `"-"`.
///
/// # Examples
///
/// ```
/// use crate::tui::render::text::format_series_row;
/// use crate::tui::render::text::SeriesSummary;
///
/// let series = SeriesSummary {
///     series_number: Some("12".to_string()),
///     modality: Some("CT".to_string()),
///     series_description: Some("Head without contrast".to_string()),
///     instance_count: 42,
/// };
///
/// let row = format_series_row(&series);
/// assert!(row.contains("12"));
/// assert!(row.contains("CT"));
/// assert!(row.contains("42 inst"));
/// assert!(row.contains("Head without contrast") || row.contains("Head without cont"));
/// ```
pub(in crate::tui) fn format_series_row(series: &SeriesSummary) -> String {
    let series_number = non_empty_text(series.series_number.as_deref()).unwrap_or("-");
    let modality = non_empty_text(series.modality.as_deref()).unwrap_or("-");
    let description = non_empty_text(series.series_description.as_deref()).unwrap_or("-");

    format!(
        "{} | {} | {} | {}",
        pad_or_truncate(series_number, 4),
        pad_or_truncate(modality, 8),
        tr_n("tui-row-instance-count", "n", series.instance_count),
        pad_or_truncate(description, 28),
    )
}

pub(in crate::tui) fn format_instance_row(instance: &LocalInstance) -> String {
    let modality = non_empty_text(instance.modality.as_deref()).unwrap_or("-");
    let instance_number = non_empty_text(instance.instance_number.as_deref()).unwrap_or("-");
    let description = non_empty_text(instance.series_description.as_deref()).unwrap_or("-");

    format!(
        "{} | {} | {}",
        pad_or_truncate(modality, 8),
        pad_or_truncate(instance_number, 8),
        pad_or_truncate(description, 40),
    )
}

/// Map a boolean to the literal labels `yes` or `no`.
///
/// # Examples
///
/// ```
/// assert_eq!(crate::tui::render::text::bool_label(true), "yes");
/// assert_eq!(crate::tui::render::text::bool_label(false), "no");
/// ```
pub(in crate::tui) fn bool_label(value: bool) -> String {
    if value {
        tr("tui-bool-yes")
    } else {
        tr("tui-bool-no")
    }
}
