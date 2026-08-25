use super::*;

use crate::models::LocalInstance;

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
            Some(node) => (tr("tui-pane-node-detail"), format_node_detail(node)),
            None => (
                tr("tui-pane-node-detail"),
                detail_placeholder_text(&tr("tui-detail-select-node")),
            ),
        },
        FocusPane::Local => {
            if view.local_instance_drill_down {
                match view
                    .selected_local_instance
                    .and_then(|index| view.local_instances.get(index))
                {
                    Some(instance) => (tr("tui-pane-instance-detail"), format_instance_detail(instance)),
                    None => (
                        tr("tui-pane-instance-detail"),
                        detail_placeholder_text(&tr("tui-empty-detail-instance")),
                    ),
                }
            } else if view.local_drill_down {
                let parent_study = view
                    .drill_down_study_uid
                    .as_ref()
                    .and_then(|study_uid| {
                        view.local_studies
                            .iter()
                            .find(|study| &study.study_instance_uid == study_uid)
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
                        (tr("tui-pane-series-detail"), format_series_detail(series, study))
                    }
                    _ => (
                        tr("tui-pane-series-detail"),
                        detail_placeholder_text(&tr("tui-empty-detail-series")),
                    ),
                }
            } else {
                match view
                    .selected_local_study
                    .and_then(|index| view.local_studies.get(index))
                {
                    Some(study) => {
                        let series = if view.drill_down_study_uid
                            == Some(study.study_instance_uid.as_str())
                        {
                            view.local_series
                        } else {
                            &[]
                        };
                        (tr("tui-pane-study-detail"), format_study_detail(study, series))
                    }
                    None => (
                        tr("tui-pane-study-detail"),
                        detail_placeholder_text(&tr("tui-empty-detail-study")),
                    ),
                }
            }
        }
        FocusPane::Query => match view
            .selected_query_result
            .and_then(|index| view.query_results.get(index))
        {
            Some(item) => (
                tr("tui-pane-query-result-detail"),
                format_query_result_detail(item, view.query_context_node),
            ),
            None => (
                tr("tui-pane-query-result-detail"),
                detail_placeholder_text(&tr("tui-empty-detail-query")),
            ),
        },
        FocusPane::Config | FocusPane::Logs | FocusPane::Tasks | FocusPane::Input => (
            tr("tui-pane-detail"),
            detail_placeholder_text(&tr("tui-detail-placeholder-followup")),
        ),
    };

    let block = Block::bordered().title_top(pane_title_text(
        &tr1("tui-pane-detail-hint", "title", &title),
        matches!(
            view.focus,
            FocusPane::Nodes | FocusPane::Local | FocusPane::Query
        ),
    ));

    let content_len = content.lines.len();

    frame.render_widget(
        Paragraph::new(content)
            .block(block)
            .wrap(Wrap { trim: false })
            .scroll((view.detail_scroll, 0)),
        area,
    );

    let (has_above, has_below) = detail_scroll_indicators(area, content_len, view.detail_scroll);

    // Scroll overflow indicators: render subtle chevrons inside the border when content overflows.
    let indicator_style = Style::default().add_modifier(Modifier::DIM);

    if has_above {
        let top = Rect {
            x: area.x + 1,
            y: area.y + 1,
            width: 1,
            height: 1,
        };
        frame.render_widget(
            Paragraph::new(Line::from(Span::styled("▲", indicator_style))),
            top,
        );
    }

    if has_below && area.height > 2 {
        let bottom = Rect {
            x: area.x + 1,
            y: area.y + area.height - 2,
            width: 1,
            height: 1,
        };
        frame.render_widget(
            Paragraph::new(Line::from(Span::styled("▼", indicator_style))),
            bottom,
        );
    }
}

fn detail_scroll_indicators(area: Rect, content_len: usize, detail_scroll: u16) -> (bool, bool) {
    // Ratatui Paragraph scroll is a virtual offset, so we derive overflow from total line count
    // vs the available viewport height.
    let viewport_height = area.height.saturating_sub(2) as usize;
    if viewport_height == 0 {
        return (false, false);
    }

    // Ratatui Paragraph scroll is a u16; clamp into the derived max range so indicator logic
    // matches what the user actually sees.
    let max_scroll = content_len.saturating_sub(viewport_height) as u16;
    let scroll = detail_scroll.min(max_scroll);

    let has_above = scroll > 0;
    let has_below = max_scroll > 0 && scroll < max_scroll;

    (has_above, has_below)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn detail_scroll_indicators_are_hidden_when_content_fits() {
        let area = Rect {
            x: 0,
            y: 0,
            width: 20,
            height: 6,
        };

        let (above, below) = detail_scroll_indicators(area, 2, 0);
        assert!(!above);
        assert!(!below);
    }

    #[test]
    fn detail_scroll_indicators_show_below_at_top_when_overflowing() {
        let area = Rect {
            x: 0,
            y: 0,
            width: 20,
            height: 8,
        };

        let (above, below) = detail_scroll_indicators(area, 50, 0);
        assert!(!above);
        assert!(below);
    }

    #[test]
    fn detail_scroll_indicators_show_above_when_scrolled_down() {
        let area = Rect {
            x: 0,
            y: 0,
            width: 20,
            height: 8,
        };

        let (above, below) = detail_scroll_indicators(area, 50, 10);
        assert!(above);
        assert!(below);
    }
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
    let host_port_label = format!("{}:{}", tr("tui-field-host"), tr("tui-field-port"));
    let mut lines = vec![
        detail_line(&tr("tui-detail-name"), node.name.clone()),
        detail_line(&tr("tui-detail-ae-title"), node.ae_title.clone()),
        detail_line(
            &host_port_label,
            format!("{}:{}", node.host, node.port),
        ),
        detail_line(
            &tr("tui-field-move-destination"),
            node.preferred_move_destination
                .as_deref()
                .filter(|value| !value.trim().is_empty())
                .unwrap_or("-")
                .to_string(),
        ),
    ];

    if let Some(notes) = non_empty_text(node.notes.as_deref()) {
        lines.push(Line::from(""));
        append_multiline_detail(&mut lines, &tr("tui-field-notes"), notes);
    }

    lines.push(Line::from(""));
    lines.push(detail_line(&tr("tui.detail.created"), node.created_at.clone()));
    lines.push(detail_line(&tr("desktop.table.updated"), node.updated_at.clone()));

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
            &tr("tui.field.patient-name"),
            display_optional_detail(study.patient_name.as_deref(), "-"),
        ),
        detail_line(
            &tr("tui.field.patient-id"),
            display_optional_detail(study.patient_id.as_deref(), "-"),
        ),
        detail_line(
            &tr("desktop.table.date"),
            display_optional_detail(
                study
                    .study_date
                    .as_deref()
                    .map(crate::i18n::format_operator_date)
                    .as_deref(),
                "-",
            ),
        ),
        detail_line(
            &tr("tui.field.study-description"),
            display_optional_detail(study.study_description.as_deref(), "-"),
        ),
        detail_line(
            &tr("desktop.table.modalities"),
            display_optional_detail(study.modalities.as_deref(), "-"),
        ),
        detail_line(&tr("desktop.table.series"), tr_n("count-series", "n", study.series_count)),
        detail_line(
            &tr("desktop.table.instances"),
            tr_n("count-instances", "n", study.instance_count),
        ),
        detail_line(&tr("tui.form.field-study-uid"), study.study_instance_uid.clone()),
        Line::from(""),
        detail_section_heading(&format!("{}:", tr("common.series"))),
    ];

    if series.is_empty() {
        lines.push(Line::from(format!("  {}", tr("tui.empty.local-series"))));
    } else {
        for entry in series.iter().take(SERIES_PREVIEW_LIMIT) {
            let modality = display_optional_detail(entry.modality.as_deref(), "-");
            let series_number = display_optional_detail(entry.series_number.as_deref(), "-");
            let description = display_optional_detail(entry.series_description.as_deref(), "-");
            lines.push(Line::from(format!(
                "  {modality} | #{series_number} | {description} | {}",
                tr_n("tui-row-instance-count", "n", entry.instance_count),
            )));
        }

        if series.len() > SERIES_PREVIEW_LIMIT {
            lines.push(Line::from(format!(
                "  {}",
                tr_n(
                    "tui-detail-more-series",
                    "n",
                    (series.len() - SERIES_PREVIEW_LIMIT) as i64,
                )
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
        detail_line(&tr("tui.form.field-series-uid"), series.series_instance_uid.clone()),
        detail_line(
            &tr("tui.field.modality"),
            display_optional_detail(series.modality.as_deref(), "-"),
        ),
        detail_line(
            &tr("common.series"),
            display_optional_detail(series.series_number.as_deref(), "-"),
        ),
        detail_line(
            &tr("common.description"),
            display_optional_detail(series.series_description.as_deref(), "-"),
        ),
        detail_line(
            &tr("desktop.table.instances"),
            tr_n("count-instances", "n", series.instance_count),
        ),
        detail_line(&tr("tui.form.field-study-uid"), parent_study.study_instance_uid.clone()),
    ])
}

pub(in crate::tui) fn format_instance_detail(instance: &LocalInstance) -> Text<'static> {
    let mut lines = vec![
        detail_line(&tr("tui.form.field-sop-uid"), instance.sop_instance_uid.clone()),
        detail_line(&tr("tui-field-sop-class-uid"), instance.sop_class_uid.clone()),
        detail_line(
            &tr("tui-field-transfer-syntax-uid"),
            display_optional_detail(instance.transfer_syntax_uid.as_deref(), "-"),
        ),
        detail_line(
            &tr("tui.field.modality"),
            display_optional_detail(instance.modality.as_deref(), "-"),
        ),
        detail_line(
            &tr("common.instance"),
            display_optional_detail(instance.instance_number.as_deref(), "-"),
        ),
        detail_line(
            &tr("common.series"),
            display_optional_detail(instance.series_number.as_deref(), "-"),
        ),
        detail_line(
            &tr("common.description"),
            display_optional_detail(instance.series_description.as_deref(), "-"),
        ),
        detail_line(
            &tr("tui.field.study-description"),
            display_optional_detail(instance.study_description.as_deref(), "-"),
        ),
    ];

    lines.push(Line::from(""));
    lines.push(detail_section_heading(&tr("common.path")));
    lines.push(detail_line(&tr("tui.field.path"), instance.managed_path.clone()));
    lines.push(detail_line(&tr("tui.field.path"), instance.source_path.clone()));
    lines.push(detail_line(
        &tr("common.bytes"),
        instance.file_size_bytes.to_string(),
    ));
    lines.push(detail_line(&tr("tui-field-sha256"), instance.sha256.clone()));
    lines.push(detail_line(
        &tr("desktop.table.date"),
        crate::i18n::format_operator_date(&instance.imported_at),
    ));

    Text::from(lines)
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
    let mut lines = vec![detail_line(&tr("tui.field.level"), item.level.to_string())];

    if let Some(node) = context_node {
        lines.push(detail_line(
            &tr("tui.pane.query-node"),
            format!(
                "{} [{}] {}:{}",
                node.name, node.ae_title, node.host, node.port
            ),
        ));
    }

    push_optional_detail_line(&mut lines, tr("tui.field.patient-name"), item.patient_name.as_deref());
    push_optional_detail_line(&mut lines, tr("tui.field.patient-id"), item.patient_id.as_deref());
    push_optional_detail_line(
        &mut lines,
        tr("tui.field.accession"),
        item.accession_number.as_deref(),
    );
    push_optional_detail_line(
        &mut lines,
        tr("desktop.table.date"),
        item.study_date
            .as_deref()
            .map(crate::i18n::format_operator_date)
            .as_deref(),
    );
    push_optional_detail_line(
        &mut lines,
        tr("tui.field.study-description"),
        item.study_description.as_deref(),
    );
    push_optional_detail_line(
        &mut lines,
        tr("common.description"),
        item.series_description.as_deref(),
    );
    push_optional_detail_line(&mut lines, tr("common.series"), item.series_number.as_deref());
    push_optional_detail_line(&mut lines, tr("tui.field.modality"), item.modality.as_deref());
    push_optional_detail_line(
        &mut lines,
        tr("common.instance"),
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
            tr("tui.form.field-study-uid"),
            item.study_instance_uid.as_deref(),
        );
        push_optional_detail_line(
            &mut lines,
            tr("tui.form.field-series-uid"),
            item.series_instance_uid.as_deref(),
        );
        push_optional_detail_line(
            &mut lines,
            tr("tui.form.field-sop-uid"),
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
        Line::from(tr("tui-detail-placeholder-followup")),
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
    // Add a small indentation before the value so wrapped lines align visually under the value
    // rather than restarting at column 0.
    Line::from(vec![
        Span::styled(
            format!("{label}: "),
            Style::default().add_modifier(Modifier::BOLD),
        ),
        Span::raw(value.into()),
        // Trailing spaces are preserved by ratatui's text wrapping; these encourage subsequent
        // wrapped lines to align under the value portion for a simple "hanging indent" effect.
        Span::raw("  "),
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
pub(in crate::tui) fn detail_section_heading(label: impl AsRef<str>) -> Line<'static> {
    Line::from(Span::styled(
        label.as_ref().to_string(),
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
    label: impl AsRef<str>,
    value: Option<&str>,
) {
    if let Some(value) = non_empty_text(value) {
        lines.push(detail_line(label.as_ref(), value.to_string()));
    }
}
