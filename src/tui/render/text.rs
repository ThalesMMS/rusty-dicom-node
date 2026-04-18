use super::*;
use unicode_segmentation::UnicodeSegmentation;
use unicode_width::UnicodeWidthStr;

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
    let enter_line = match (view.focus, view.local_drill_down) {
        (FocusPane::Local, true) => "  Enter       No Local-pane action in series view",
        (FocusPane::Local, false) => {
            "  Enter       Open series for the selected local study, or run the command input / submit the active modal"
        }
        _ => {
            "  Enter       Run the command input, submit the active modal, or open series from Local Studies"
        }
    };
    let esc_line = if view.focus == FocusPane::Local && view.local_drill_down {
        "  Esc         Return from Local series to studies, close help/modal, or return focus to command input"
    } else {
        "  Esc         Close help/modal, return from Local series, or return focus to command input"
    };

    Text::from(vec![
        Line::from("Keybindings"),
        Line::from("  F1 or ?     Open help"),
        Line::from("  Tab / Shift-Tab  Change focused pane"),
        Line::from("  Up/Down or j/k   Move selection in list panes"),
        Line::from("  r           Refresh panes when focus is not in command input"),
        Line::from("  a/e/d/f     Add, edit, delete, or query from the selected node"),
        Line::from("  m           Retrieve from the selected query result"),
        Line::from(enter_line),
        Line::from(esc_line),
        Line::from("  q           Quit when focus is not in command input"),
        Line::from(""),
        Line::from("Common commands"),
        Line::from("  Canonical names match CLI flags without '--', using underscores."),
        Line::from("  node add name=pacs ae=PACSAE host=10.0.0.10 port=104"),
        Line::from("  import path=/data/inbox"),
        Line::from("  query node=pacs patient_name=\"DOE^JOHN\" date_from=20240101"),
        Line::from("  retrieve node=pacs study_uid=1.2.3.4.5 dest=DICOMNODECLIENT"),
        Line::from("  send-study node=archive study_uid=1.2.3.4.5"),
        Line::from(""),
        Line::from("Current configuration"),
        Line::from(format!("  AE title: {}", view.status.local_ae_title)),
        Line::from(format!("  Listener: {}", view.status.listener_addr)),
        Line::from(format!("  Receiver mode: {}", view.status.receiver_mode)),
        Line::from(format!(
            "  strict_pdu: {}",
            bool_label(view.status.strict_pdu)
        )),
        Line::from(format!("  max_pdu_length: {}", view.status.max_pdu_length)),
        Line::from(format!(
            "  allow_promiscuous_storage: {}",
            bool_label(view.status.allow_promiscuous_storage)
        )),
        Line::from(format!(
            "  preferred_store_transfer_syntax: {}",
            view.status.preferred_store_transfer_syntax
        )),
        Line::from(format!("  Config path: {}", view.status.config_path)),
        Line::from(format!("  Data dir: {}", view.status.data_dir)),
        Line::from(format!("  Log dir: {}", view.status.log_dir)),
        Line::from(""),
        Line::from("Close help with Esc, F1, or ?."),
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
    if let Some(task) = view.running_task.as_ref() {
        return running_task_status_line(task);
    }

    let mut parts = vec!["F1/? help", "Tab panes", "r refresh"];

    match view.focus {
        FocusPane::Nodes => parts.push("a/e/d/f nodes"),
        FocusPane::Query => parts.push("m retrieve"),
        FocusPane::Local if view.local_drill_down => parts.push("Esc back to studies"),
        FocusPane::Local => parts.push("Enter series"),
        FocusPane::Input => parts.push("Enter run command"),
        FocusPane::Logs => {}
    }

    if view.focus != FocusPane::Input {
        parts.push("q quit");
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
    Text::from(vec![
        Line::from("No remote nodes are saved yet."),
        Line::from(""),
        Line::from("Press 'a' in this pane to add one."),
        Line::from("Or: node add name=pacs"),
        Line::from("    ae=PACSAE host=10.0.0.10"),
        Line::from("    port=104"),
    ])
}

/// A Text block explaining that no local studies are indexed and showing an example import command.
///
/// # Examples
///
/// ```
/// let _ = local_studies_empty_text();
/// ```
pub(in crate::tui) fn local_studies_empty_text() -> Text<'static> {
    Text::from(vec![
        Line::from("No indexed studies are available yet."),
        Line::from(""),
        Line::from("Import local DICOM files first."),
        Line::from("Example: import path=/data/inbox"),
    ])
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
    Text::from(vec![
        Line::from("No indexed series are available for this study."),
        Line::from(""),
        Line::from("Press Esc to return to local studies."),
    ])
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
        Some(node_name) => format!("Last query target: {node_name}"),
        None => "No query has been run yet.".to_string(),
    };

    Text::from(vec![
        Line::from(source_line),
        Line::from(""),
        Line::from("Select a remote node and press 'f' to query."),
        Line::from("Or: query node=pacs"),
        Line::from("    patient_name=\"DOE^JOHN\""),
        Line::from("Press 'm' on a selected result to open retrieve."),
    ])
}

/// Return a text style with bold when active, otherwise the default style.
///
/// # Returns
///
/// `Style` with the `Modifier::BOLD` added if `active` is `true`, otherwise `Style::default()`.
///
/// # Examples
///
/// ```
/// use ratatui::style::{Style, Modifier};
/// let on = active_block_style(true);
/// let off = active_block_style(false);
/// assert_eq!(on, Style::default().add_modifier(Modifier::BOLD));
/// assert_eq!(off, Style::default());
/// ```
pub(in crate::tui) fn active_block_style(active: bool) -> Style {
    if active {
        Style::default().add_modifier(Modifier::BOLD)
    } else {
        Style::default()
    }
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
pub(in crate::tui) fn truncate_tail(value: &str, max_len: usize) -> String {
    let value = value.trim();
    if UnicodeWidthStr::width(value) <= max_len {
        return value.to_string();
    }

    if max_len <= 3 {
        return ".".repeat(max_len);
    }

    let suffix_len = max_len - 3;
    let suffix = suffix_by_display_width(value, suffix_len);
    format!("...{suffix}")
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
    truncate_tail(uid, max_len)
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
    truncate_tail(path, max_len)
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
    let patient_name = non_empty_text(study.patient_name.as_deref()).unwrap_or("<no name>");
    let study_date = non_empty_text(study.study_date.as_deref()).unwrap_or("-");
    let modalities = non_empty_text(study.modalities.as_deref()).unwrap_or("-");

    format!(
        "{} | {} | {} | {:>2}s/{:<3}i | {}",
        pad_or_truncate(patient_name, 20),
        pad_or_truncate(study_date, 10),
        pad_or_truncate(modalities, 8),
        study.series_count,
        study.instance_count,
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
    let context = item
        .modality
        .as_deref()
        .and_then(|value| non_empty_text(Some(value)))
        .or_else(|| non_empty_text(item.study_date.as_deref()))
        .unwrap_or("-");
    let patient_name = non_empty_text(item.patient_name.as_deref()).unwrap_or("-");
    let primary_uid = item.primary_uid().unwrap_or("-");

    format!(
        "{} | {} | {} | {} | {}",
        pad_or_truncate(&item.level.to_string(), 6),
        pad_or_truncate(patient_name, 20),
        pad_or_truncate(context, 10),
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
        "{} | {} | {:>4} inst | {}",
        pad_or_truncate(series_number, 4),
        pad_or_truncate(modality, 8),
        series.instance_count,
        pad_or_truncate(description, 28),
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
pub(in crate::tui) fn bool_label(value: bool) -> &'static str {
    if value {
        "yes"
    } else {
        "no"
    }
}
