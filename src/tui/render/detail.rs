use super::*;

/// Renders the detail pane for the given area based on the view's current focus and selection.
///
/// The function determines an appropriate title and textual content for the detail pane (nodes,
/// local studies/series, query results, or a generic placeholder) and renders a wrapped,
/// bordered paragraph into the provided frame and area.
///
/// # Examples
///
/// ```
/// // Render the detail pane into `area` using the current `view`.
/// // (Types omitted for brevity; replace with real Frame, Rect and TuiView instances.)
/// // render_detail_pane(&mut frame, area, &view);
/// ```
pub(in crate::tui) fn render_detail_pane(frame: &mut Frame<'_>, area: Rect, view: &TuiView) {
    let (title, content) = match view.focus {
        FocusPane::Nodes => match view.selected_node.and_then(|index| view.nodes.get(index)) {
            Some(node) => ("Node Detail", format_node_detail(node)),
            None => (
                "Node Detail",
                detail_placeholder_text("Select a remote node to inspect its metadata."),
            ),
        },
        FocusPane::Local => {
            if view.local_drill_down {
                let parent_study = view
                    .drill_down_study_uid
                    .as_deref()
                    .and_then(|study_uid| {
                        view.local_studies
                            .iter()
                            .find(|study| study.study_instance_uid == study_uid)
                    })
                    .or_else(|| {
                        view.selected_local_study
                            .and_then(|index| view.local_studies.get(index))
                    });

                match (
                    view.selected_local_series
                        .and_then(|index| view.local_series.get(index)),
                    parent_study,
                ) {
                    (Some(series), Some(study)) => {
                        ("Series Detail", format_series_detail(series, study))
                    }
                    _ => (
                        "Series Detail",
                        detail_placeholder_text(
                            "Select a series to inspect it, or return to studies with Esc.",
                        ),
                    ),
                }
            } else {
                match view
                    .selected_local_study
                    .and_then(|index| view.local_studies.get(index))
                {
                    Some(study) => {
                        let series = if view.drill_down_study_uid.as_deref()
                            == Some(study.study_instance_uid.as_str())
                        {
                            view.local_series.as_slice()
                        } else {
                            &[]
                        };
                        ("Study Detail", format_study_detail(study, series))
                    }
                    None => (
                        "Study Detail",
                        detail_placeholder_text(
                            "Select a local study to inspect patient and series metadata.",
                        ),
                    ),
                }
            }
        }
        FocusPane::Query => match view
            .selected_query_result
            .and_then(|index| view.query_results.get(index))
        {
            Some(item) => (
                "Query Result Detail",
                format_query_result_detail(item, view.query_context_node.as_ref()),
            ),
            None => (
                "Query Result Detail",
                detail_placeholder_text(
                    "Select a query result to inspect metadata and retrieve context.",
                ),
            ),
        },
        FocusPane::Logs | FocusPane::Input => (
            "Detail",
            detail_placeholder_text(
                "The detail pane follows the active Remote Nodes, Local, and Query panes.",
            ),
        ),
    };

    frame.render_widget(
        Paragraph::new(content)
            .block(Block::bordered().title(title))
            .wrap(Wrap { trim: false }),
        area,
    );
}

/// Build a labeled detail view for a remote node suitable for the detail pane.
///
/// The returned `Text` contains bolded label/value lines for the node's
/// Name, AE Title, Host:Port, Move Destination, Created, and Updated fields.
/// If the node has non-empty notes, a blank line and a multiline "Notes" section
/// are inserted before the Created/Updated lines. An empty or whitespace-only
/// preferred move destination is rendered as `"-"`.
///
/// # Returns
///
/// A `Text` containing the formatted, line-oriented detail view for the given node.
pub(in crate::tui) fn format_node_detail(node: &RemoteNode) -> Text<'static> {
    let mut lines = vec![
        detail_line("Name", node.name.clone()),
        detail_line("AE Title", node.ae_title.clone()),
        detail_line("Host:Port", format!("{}:{}", node.host, node.port)),
        detail_line(
            "Move Destination",
            node.preferred_move_destination
                .as_deref()
                .filter(|value| !value.trim().is_empty())
                .unwrap_or("-")
                .to_string(),
        ),
    ];

    if let Some(notes) = non_empty_text(node.notes.as_deref()) {
        lines.push(Line::from(""));
        append_multiline_detail(&mut lines, "Notes", notes);
    }

    lines.push(Line::from(""));
    lines.push(detail_line("Created", node.created_at.clone()));
    lines.push(detail_line("Updated", node.updated_at.clone()));

    Text::from(lines)
}

/// Formats a study's metadata and a short preview list of its series for display in the detail pane.
///
/// The returned `Text` contains labeled lines for patient and study fields, counts, the study UID,
/// and a "Series:" section showing up to eight series with modality, series number, description,
/// and instance count. If more than eight series are provided, a trailing line indicates how many
/// additional series exist. When the `series` slice is empty, a message stating no series are loaded
/// is included.
///
/// # Examples
///
/// ```
/// use crate::tui::{format_study_detail, StudySummary, SeriesSummary};
///
/// let study = StudySummary {
///     patient_name: Some("Jane Doe".into()),
///     patient_id: Some("JD-001".into()),
///     study_date: Some("2026-04-01".into()),
///     study_description: Some("Chest CT".into()),
///     modalities: Some("CT".into()),
///     series_count: 2,
///     instance_count: 120,
///     study_instance_uid: "1.2.3.4".into(),
///     // other fields if present...
/// };
///
/// let series = vec![
///     SeriesSummary {
///         series_instance_uid: "1.2.3.4.1".into(),
///         modality: Some("CT".into()),
///         series_number: Some("1".into()),
///         series_description: Some("Axial".into()),
///         instance_count: 60,
///         // other fields if present...
///     },
/// ];
///
/// let text = format_study_detail(&study, &series);
/// assert!(!text.lines.is_empty());
/// ```
pub(in crate::tui) fn format_study_detail(
    study: &StudySummary,
    series: &[SeriesSummary],
) -> Text<'static> {
    const SERIES_PREVIEW_LIMIT: usize = 8;

    let mut lines = vec![
        detail_line(
            "Patient Name",
            display_optional_detail(study.patient_name.as_deref(), "-"),
        ),
        detail_line(
            "Patient ID",
            display_optional_detail(study.patient_id.as_deref(), "-"),
        ),
        detail_line(
            "Study Date",
            display_optional_detail(study.study_date.as_deref(), "-"),
        ),
        detail_line(
            "Study Description",
            display_optional_detail(study.study_description.as_deref(), "-"),
        ),
        detail_line(
            "Modalities",
            display_optional_detail(study.modalities.as_deref(), "-"),
        ),
        detail_line("Series Count", study.series_count.to_string()),
        detail_line("Instance Count", study.instance_count.to_string()),
        detail_line("Study Instance UID", study.study_instance_uid.clone()),
        Line::from(""),
        detail_section_heading("Series:"),
    ];

    if series.is_empty() {
        lines.push(Line::from("  No series loaded for this study."));
    } else {
        for entry in series.iter().take(SERIES_PREVIEW_LIMIT) {
            let modality = display_optional_detail(entry.modality.as_deref(), "-");
            let series_number = display_optional_detail(entry.series_number.as_deref(), "-");
            let description = display_optional_detail(entry.series_description.as_deref(), "-");
            lines.push(Line::from(format!(
                "  {modality} | #{series_number} | {description} | {} inst",
                entry.instance_count
            )));
        }

        if series.len() > SERIES_PREVIEW_LIMIT {
            lines.push(Line::from(format!(
                "  ... and {} more series",
                series.len() - SERIES_PREVIEW_LIMIT
            )));
        }
    }

    Text::from(lines)
}

/// Format a series and its parent study into labeled display lines for the detail pane.
///
/// The returned `Text` contains labeled lines for:
/// - Series Instance UID
/// - Modality
/// - Series Number
/// - Description
/// - Instance Count
/// - Parent Study UID
///
/// # Examples
///
/// ```
/// // Construct minimal examples of the summary types as required by your crate.
/// // The concrete field names used here must match the real `SeriesSummary` and `StudySummary`.
/// let series = SeriesSummary {
///     series_instance_uid: "1.2.3".to_string(),
///     modality: Some("CT".to_string()),
///     series_number: Some("2".to_string()),
///     series_description: Some("Abdomen".to_string()),
///     instance_count: 42,
///     ..Default::default()
/// };
/// let study = StudySummary {
///     study_instance_uid: "1.2".to_string(),
///     ..Default::default()
/// };
///
/// let text = format_series_detail(&series, &study);
/// // `text` is ready to be rendered in the detail pane.
/// assert!(!text.lines.is_empty());
/// ```
pub(in crate::tui) fn format_series_detail(
    series: &SeriesSummary,
    parent_study: &StudySummary,
) -> Text<'static> {
    Text::from(vec![
        detail_line("Series Instance UID", series.series_instance_uid.clone()),
        detail_line(
            "Modality",
            display_optional_detail(series.modality.as_deref(), "-"),
        ),
        detail_line(
            "Series Number",
            display_optional_detail(series.series_number.as_deref(), "-"),
        ),
        detail_line(
            "Description",
            display_optional_detail(series.series_description.as_deref(), "-"),
        ),
        detail_line("Instance Count", series.instance_count.to_string()),
        detail_line("Parent Study UID", parent_study.study_instance_uid.clone()),
    ])
}

/// Formats a query result into a multiline `Text` suitable for the detail pane.
///
/// Includes the query `Level`, optional `Query Node` information when `context_node` is
/// provided, and optional descriptive fields (patient, study, series, instance, modality,
/// accession). If any UID fields are present, a `UIDs:` section is appended containing the
/// available UIDs.
///
/// # Parameters
///
/// - `item`: The `QueryMatch` whose fields will be rendered.
/// - `context_node`: Optional remote node that provides the query context and will be shown
///   as a single `Query Node` line when present.
///
/// # Returns
///
/// A `Text<'static>` where each line is a labeled detail or section heading; UIDs are included
/// only when at least one UID value is present.
///
/// # Examples
///
/// ```rust,ignore
/// let text = format_query_result_detail(&query_match, Some(&remote_node));
/// // Render `text` in the detail pane; inspect lines or convert to string for tests.
/// ```
pub(in crate::tui) fn format_query_result_detail(
    item: &QueryMatch,
    context_node: Option<&RemoteNode>,
) -> Text<'static> {
    let mut lines = vec![detail_line("Level", item.level.to_string())];

    if let Some(node) = context_node {
        lines.push(detail_line(
            "Query Node",
            format!(
                "{} [{}] {}:{}",
                node.name, node.ae_title, node.host, node.port
            ),
        ));
    }

    push_optional_detail_line(&mut lines, "Patient Name", item.patient_name.as_deref());
    push_optional_detail_line(&mut lines, "Patient ID", item.patient_id.as_deref());
    push_optional_detail_line(
        &mut lines,
        "Accession Number",
        item.accession_number.as_deref(),
    );
    push_optional_detail_line(&mut lines, "Study Date", item.study_date.as_deref());
    push_optional_detail_line(
        &mut lines,
        "Study Description",
        item.study_description.as_deref(),
    );
    push_optional_detail_line(
        &mut lines,
        "Series Description",
        item.series_description.as_deref(),
    );
    push_optional_detail_line(&mut lines, "Series Number", item.series_number.as_deref());
    push_optional_detail_line(&mut lines, "Modality", item.modality.as_deref());
    push_optional_detail_line(
        &mut lines,
        "Instance Number",
        item.instance_number.as_deref(),
    );

    let has_uid = non_empty_text(item.study_instance_uid.as_deref()).is_some()
        || non_empty_text(item.series_instance_uid.as_deref()).is_some()
        || non_empty_text(item.sop_instance_uid.as_deref()).is_some();

    if has_uid {
        lines.push(Line::from(""));
        lines.push(detail_section_heading("UIDs:"));
        push_optional_detail_line(
            &mut lines,
            "Study Instance UID",
            item.study_instance_uid.as_deref(),
        );
        push_optional_detail_line(
            &mut lines,
            "Series Instance UID",
            item.series_instance_uid.as_deref(),
        );
        push_optional_detail_line(
            &mut lines,
            "SOP Instance UID",
            item.sop_instance_uid.as_deref(),
        );
    }

    Text::from(lines)
}

/// Creates a generic placeholder Text for the detail pane.
///
/// The returned `Text` contains three lines: the provided `message`, a blank line,
/// and a fixed instruction telling the user how to update the view.
///
/// # Examples
///
/// ```no_run
/// let _ = detail_placeholder_text("No selection");
/// ```
pub(in crate::tui) fn detail_placeholder_text(message: &str) -> Text<'static> {
    Text::from(vec![
        Line::from(message.to_string()),
        Line::from(""),
        Line::from("Change focus to a list pane and move the selection to update this view."),
    ])
}

/// Create a labeled detail line with a bold label followed by a plain value.
///
/// The returned `Line` contains a bold `"label: "` span then a raw span with the provided `value`.
///
/// # Examples
///
/// ```rust
/// let _line = detail_line("Name", "Alice");
/// ```
pub(in crate::tui) fn detail_line(label: &str, value: impl Into<String>) -> Line<'static> {
    Line::from(vec![
        Span::styled(
            format!("{label}: "),
            Style::default().add_modifier(Modifier::BOLD),
        ),
        Span::raw(value.into()),
    ])
}

/// Creates a bold section heading `Line` for use in detail panes.
///
/// The returned `Line` contains the given `label` styled with a bold modifier.
///
/// # Examples
///
/// ```no_run
/// let heading = detail_section_heading("UIDs:");
/// // `heading` will render the text "UIDs:" in bold within the UI.
/// ```
pub(in crate::tui) fn detail_section_heading(label: &str) -> Line<'static> {
    Line::from(Span::styled(
        label.to_string(),
        Style::default().add_modifier(Modifier::BOLD),
    ))
}

/// Appends a labeled multiline detail to `lines`, splitting `value` by line breaks.
///
/// The first line is added as `label: {first_line}` using `detail_line`; each subsequent
/// line is appended as a separate line prefixed with two spaces. If `value` is empty
/// (contains no lines), no lines are appended.
///
/// # Examples
///
/// ```
/// use tui_text::line::Line; // adjust import to actual path in your crate
///
/// let mut lines: Vec<Line<'static>> = Vec::new();
/// append_multiline_detail(&mut lines, "Notes", "First line\nSecond line\nThird");
/// // lines now contains:
/// // "Notes: First line"
/// // "  Second line"
/// // "  Third"
/// ```
pub(in crate::tui) fn append_multiline_detail(
    lines: &mut Vec<Line<'static>>,
    label: &str,
    value: &str,
) {
    let mut note_lines = value.lines();

    if let Some(first_line) = note_lines.next() {
        lines.push(detail_line(label, first_line.to_string()));
        for line in note_lines {
            lines.push(Line::from(format!("  {line}")));
        }
    }
}

/// Appends a labeled detail line when a string value is present and not empty after trimming.
///
/// If `value` is `Some` and contains non-whitespace characters, a `detail_line` with the
/// given `label` and the trimmed `value` is pushed onto `lines`. Does nothing for `None`
/// or empty/whitespace-only strings.
///
/// # Examples
///
/// ```
/// use tui::text::Line;
///
/// let mut lines: Vec<Line<'static>> = Vec::new();
/// // appends when value is non-empty
/// push_optional_detail_line(&mut lines, "Name", Some("Alice"));
/// assert_eq!(lines.len(), 1);
///
/// // does nothing for empty or None
/// push_optional_detail_line(&mut lines, "Empty", Some("   "));
/// push_optional_detail_line(&mut lines, "Missing", None);
/// assert_eq!(lines.len(), 1);
/// ```
pub(in crate::tui) fn push_optional_detail_line(
    lines: &mut Vec<Line<'static>>,
    label: &str,
    value: Option<&str>,
) {
    if let Some(value) = non_empty_text(value) {
        lines.push(detail_line(label, value.to_string()));
    }
}
