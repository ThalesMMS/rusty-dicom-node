use super::*;
use ratatui::style::Color;

fn form_err_line(key: &str) -> Line<'static> {
    Line::from(Span::styled(
        format!("  {}", tr(key)),
        Style::default().fg(Color::Red),
    ))
}

fn form_err_text(text: String) -> Line<'static> {
    Line::from(Span::styled(text, Style::default().fg(Color::Red)))
}

fn form_hint_line(key: &str) -> Line<'static> {
    Line::from(Span::styled(
        format!("  {}", tr(key)),
        Style::default().fg(Color::DarkGray),
    ))
}

pub(in crate::tui) fn render_task_inspect_modal(
    frame: &mut Frame<'_>,
    area: Rect,
    state: &TaskInspectState,
) {
    let modal_area = centered_rect(
        area,
        area.width.saturating_sub(8).min(110),
        area.height.saturating_sub(6).min(32),
    );

    frame.render_widget(Clear, modal_area);
    frame.render_widget(
        Paragraph::new(state.content.clone())
            .block(
                Block::default()
                    .title(state.title.as_str())
                    .borders(Borders::ALL),
            )
            .wrap(Wrap { trim: false }),
        modal_area,
    );
}

/// Render a centered help modal showing the view's help text.
///
/// The modal is cleared and a bordered, wrapped paragraph titled "Help" is drawn
/// into a centered rectangle computed from `area`.
///
/// # Examples
///
/// ```rust,no_run
/// // Given a terminal frame `frame`, the full screen `area`, and a `view`,
/// // call to display the help modal:
/// render_help_modal(&mut frame, area, &view);
/// ```
pub(in crate::tui) fn render_help_modal(frame: &mut Frame<'_>, area: Rect, view: &TuiView) {
    let modal_area = centered_rect(
        area,
        area.width.saturating_sub(8).min(110),
        area.height.saturating_sub(6).min(32),
    );

    frame.render_widget(Clear, modal_area);
    frame.render_widget(
        Paragraph::new(help_text(view))
            .block(Block::default().title(tr("tui-pane-help")).borders(Borders::ALL))
            .wrap(Wrap { trim: false }),
        modal_area,
    );
}

/// Render a centered, bordered modal dialog for the provided `ModalState`.
///
/// This clears a centered rectangle computed from `area` and draws a wrapped
/// `Paragraph` whose title and content depend on the `modal` variant.
///
/// # Examples
///
/// ```no_run
/// use ratatui::layout::Rect;
/// use ratatui::backend::TestBackend;
/// use ratatui::Frame;
/// use crate::tui::render::modal::render_modal;
/// use crate::tui::state::ModalState;
///
/// // Construct a framebuffer and an example area (details omitted).
/// let backend = TestBackend::new(80, 24);
/// let mut terminal = ratatui::Terminal::new(backend).unwrap();
/// let area = Rect::new(0, 0, 80, 24);
///
/// terminal.draw(|f| {
///     // Example: render a modal (replace `ModalState::...` with a real variant)
///     let modal = ModalState::Query(/* ... */);
///     render_modal(f, area, &modal);
/// }).unwrap();
/// ```
pub(in crate::tui) fn render_modal(frame: &mut Frame<'_>, area: Rect, modal: &ModalState) {
    match modal {
        ModalState::TaskInspect(state) => {
            render_task_inspect_modal(frame, area, state);
        }
        ModalState::AddNode(form) | ModalState::EditNode(form) => {
            let modal_area = centered_rect(area, area.width.saturating_sub(20).min(82), 17);
            frame.render_widget(Clear, modal_area);
            frame.render_widget(
                Paragraph::new(render_node_form_text(form))
                    .block(Block::default().title(form.title()).borders(Borders::ALL))
                    .wrap(Wrap { trim: false }),
                modal_area,
            );
        }
        ModalState::ConfirmDeleteNode(confirm) => {
            let modal_area = centered_rect(area, area.width.saturating_sub(40).min(70), 8);
            frame.render_widget(Clear, modal_area);
            frame.render_widget(
                Paragraph::new(render_delete_confirm_text(confirm))
                    .block(
                        Block::default()
                            .title(tr("tui-form-delete-remote-node"))
                            .borders(Borders::ALL),
                    )
                    .wrap(Wrap { trim: false }),
                modal_area,
            );
        }
        ModalState::Query(form) => {
            let modal_area = centered_rect(area, area.width.saturating_sub(18).min(86), 18);
            frame.render_widget(Clear, modal_area);
            frame.render_widget(
                Paragraph::new(render_query_form_text(form))
                    .block(
                        Block::default()
                            .title(tr("tui-form-query-remote-node"))
                            .borders(Borders::ALL),
                    )
                    .wrap(Wrap { trim: false }),
                modal_area,
            );
        }
        ModalState::Retrieve(form) => {
            let modal_area = centered_rect(area, area.width.saturating_sub(18).min(86), 16);
            frame.render_widget(Clear, modal_area);
            frame.render_widget(
                Paragraph::new(render_retrieve_form_text(form))
                    .block(
                        Block::default()
                            .title(tr("tui-form-retrieve-matches"))
                            .borders(Borders::ALL),
                    )
                    .wrap(Wrap { trim: false }),
                modal_area,
            );
        }
        ModalState::Import(form) => {
            let modal_area = centered_rect(area, area.width.saturating_sub(18).min(86), 9);
            frame.render_widget(Clear, modal_area);
            frame.render_widget(
                Paragraph::new(render_import_form_text(form))
                    .block(
                        Block::default()
                            .title(tr("tui-form-import-local-files"))
                            .borders(Borders::ALL),
                    )
                    .wrap(Wrap { trim: false }),
                modal_area,
            );
        }
        ModalState::Send(form) => {
            let modal_area = centered_rect(area, area.width.saturating_sub(18).min(86), 11);
            frame.render_widget(Clear, modal_area);
            frame.render_widget(
                Paragraph::new(render_send_form_text(form))
                    .block(Block::default().title(form.title()).borders(Borders::ALL))
                    .wrap(Wrap { trim: false }),
                modal_area,
            );
        }
        ModalState::StorageScp(form) => {
            let modal_area = centered_rect(area, area.width.saturating_sub(18).min(90), 16);
            frame.render_widget(Clear, modal_area);
            frame.render_widget(
                Paragraph::new(render_storage_scp_form_text(form))
                    .block(
                        Block::default()
                            .title(tr("tui-form-storage-scp-settings"))
                            .borders(Borders::ALL),
                    )
                    .wrap(Wrap { trim: false }),
                modal_area,
            );
        }
    }
}

/// Build the multiline `Text` used to render the add/edit remote node form.
///
/// The returned `Text` contains a header line indicating whether the form is in
/// add or edit mode, one line per form field (`Name`, `AE title`, `Host`,
/// `Port`, `Move destination`, `Notes`) with the active field highlighted, an
/// instruction line describing controls, and an optional bolded `Error: ...`
/// line when `form.error` is present.
///
/// # Returns
///
/// The composed `Text<'static>` representing the form contents suitable for
/// rendering inside a modal `Paragraph`.
///
/// # Examples
///
/// ```
/// let form = NodeFormState {
///     mode: NodeFormMode::Add,
///     active: NodeField::Name,
///     name: "My Node".into(),
///     ae_title: "AET".into(),
///     host: "127.0.0.1".into(),
///     port: "104".into(),
///     move_destination: "".into(),
///     notes: "".into(),
///     error: None,
/// };
/// let text = render_node_form_text(&form);
/// // text now contains lines such as "Mode: create a new remote node" and "Name: My Node"
/// ```
pub(in crate::tui) fn render_node_form_text(form: &NodeFormState) -> Text<'static> {
    let required = tr("common-required");
    let optional = tr("common-optional");
    let name_label = tr("tui-form-field-name");
    let ae_label = tr("tui-form-field-ae-title");
    let host_label = tr("tui-form-field-host");
    let port_label = tr("tui-form-field-port");
    let move_label = tr("tui-form-field-move-dest");
    let notes_label = tr("tui-form-field-notes");
    let mode = match form.mode {
        NodeFormMode::Add => tr("tui-form-mode-add"),
        NodeFormMode::Edit => tr("tui-form-mode-edit"),
    };

    let mut lines = vec![
        Line::from(format!("{}: {mode}", tr("tui-status-mode"))),
        Line::from(""),
    ];

    lines.push(form_field_line(
        form.active == NodeField::Name,
        &name_label,
        display_text_field(&form.name, &required),
    ));
    if form.touched.contains(&NodeField::Name) && form.name.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            format!("  {}", tr("tui-form-err-name-required")),
            Style::default().fg(Color::Red),
        )));
    } else if form.active == NodeField::Name && form.name.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            format!("  {}", tr("tui-form-hint-name")),
            Style::default().fg(Color::DarkGray),
        )));
    }

    lines.push(form_field_line(
        form.active == NodeField::AeTitle,
        &ae_label,
        display_text_field(&form.ae_title, &required),
    ));
    if form.touched.contains(&NodeField::AeTitle) {
        let ae_title = form.ae_title.trim().to_ascii_uppercase();
        if ae_title.is_empty() {
            lines.push(Line::from(Span::styled(
                format!("  {}", tr("tui-form-err-ae-required")),
                Style::default().fg(Color::Red),
            )));
        } else if let Err(err) = crate::models::validate_ae_title(&ae_title) {
            lines.push(Line::from(Span::styled(
                format!("  ! {err}"),
                Style::default().fg(Color::Red),
            )));
        }
    } else if form.active == NodeField::AeTitle && form.ae_title.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            format!("  {}", tr("tui-form-hint-local-ae")),
            Style::default().fg(Color::DarkGray),
        )));
    }

    lines.push(form_field_line(
        form.active == NodeField::Host,
        &host_label,
        display_text_field(&form.host, &required),
    ));
    if form.touched.contains(&NodeField::Host) && form.host.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            format!("  {}", tr("tui-form-err-host-required")),
            Style::default().fg(Color::Red),
        )));
    } else if form.active == NodeField::Host && form.host.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            format!("  {}", tr("cli-arg-host")),
            Style::default().fg(Color::DarkGray),
        )));
    }

    lines.push(form_field_line(
        form.active == NodeField::Port,
        &port_label,
        display_text_field(&form.port, &required),
    ));
    if form.touched.contains(&NodeField::Port) {
        let port = form.port.trim();
        if port.is_empty() {
            lines.push(Line::from(Span::styled(
                format!("  {}", tr("tui-form-err-port-required")),
                Style::default().fg(Color::Red),
            )));
        } else if let Err(err) = crate::models::parse_port(port) {
            lines.push(Line::from(Span::styled(
                format!("  ! {err}"),
                Style::default().fg(Color::Red),
            )));
        }
    } else if form.active == NodeField::Port && form.port.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            format!("  {}", tr("cli-arg-port")),
            Style::default().fg(Color::DarkGray),
        )));
    }

    lines.push(form_field_line(
        form.active == NodeField::MoveDestination,
        &move_label,
        display_text_field(&form.move_destination, &optional),
    ));
    if form.touched.contains(&NodeField::MoveDestination) {
        let value = form.move_destination.trim().to_ascii_uppercase();
        if !value.is_empty() {
            if let Err(err) = crate::models::validate_ae_title(&value) {
                lines.push(Line::from(Span::styled(
                    format!("  {}", tr1("tui-form-err-move-dest-invalid", "err", err)),
                    Style::default().fg(Color::Red),
                )));
            }
        }
    } else if form.active == NodeField::MoveDestination && form.move_destination.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            format!("  {}", tr("tui-form-hint-move-dest")),
            Style::default().fg(Color::DarkGray),
        )));
    }

    lines.push(form_field_line(
        form.active == NodeField::Notes,
        &notes_label,
        display_text_field(&form.notes, &optional),
    ));

    lines.push(Line::from(""));
    lines.push(Line::from(tr("tui-controls-hint")));

    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            error.to_string(),
            Style::default().fg(Color::Red),
        )));
    }

    Text::from(lines)
}

/// Builds the modal body text that asks the user to confirm deletion of a remote node.
///
/// The returned `Text` contains three lines:
/// 1. A question that includes the node's name, AE title, host, and port.
/// 2. A blank line.
/// 3. An instruction line stating which keys confirm or cancel the operation.
///
/// # Examples
///
/// ```no_run
/// // Given a `confirm` value with `.node.name`, `.node.ae_title`, `.node.host`, and `.node.port`:
/// let text = render_delete_confirm_text(&confirm);
/// // `text` now contains the confirmation question, a blank line, and the key instructions.
/// ```
pub(in crate::tui) fn render_delete_confirm_text(confirm: &DeleteConfirmState) -> Text<'static> {
    Text::from(vec![
        Line::from(tr4(
            "tui-form-delete-confirm",
            "name",
            &confirm.node.name,
            "ae",
            &confirm.node.ae_title,
            "host",
            &confirm.node.host,
            "port",
            confirm.node.port,
        )),
        Line::from(""),
        Line::from(tr("tui-controls-hint")),
    ])
}

/// Render the query form as multiline TUI text for display in a modal.
///
/// The produced `Text` begins with a header line describing the remote node and then
/// a sequence of labeled field lines (Model, Level, Patient name, Patient ID, Accession number,
/// Study/Series/SOP Instance UIDs, Date from/to, Modality, Study description), followed by an
/// instruction line. If `form.error` is set, a blank line and a bold "Error: ..." line are appended.
///
/// # Returns
///
/// A `Text` containing the assembled lines ready to be rendered inside a `Paragraph`.
///
/// # Examples
///
/// ```no_run
/// // Construct a QueryFormState (fields elided) and render its text for a modal.
/// let form = QueryFormState::default(); // assume a sensible default exists in scope
/// let text = render_query_form_text(&form);
/// // `text` can now be passed to a Paragraph for rendering inside a modal.
/// ```
pub(in crate::tui) fn render_query_form_text(form: &QueryFormState) -> Text<'static> {
    let mut lines = vec![
        Line::from(tr4(
            "tui-form-remote-node-line",
            "name",
            &form.node.name,
            "ae",
            &form.node.ae_title,
            "host",
            &form.node.host,
            "port",
            form.node.port,
        )),
        Line::from(""),
    ];

    // Model
    lines.push(form_field_line(
        form.active == QueryField::Model,
        tr("tui-form-field-model"),
        form.model.to_string(),
    ));

    // Level
    lines.push(form_field_line(
        form.active == QueryField::Level,
        tr("tui-form-field-level"),
        form.level.to_string(),
    ));

    // Patient name
    lines.push(form_field_line(
        form.active == QueryField::PatientName,
        tr("tui-form-field-patient-name"),
        display_text_field(&form.patient_name, &tr("common-optional")),
    ));

    // Patient ID
    lines.push(form_field_line(
        form.active == QueryField::PatientId,
        tr("tui-form-field-patient-id"),
        display_text_field(&form.patient_id, &tr("common-optional")),
    ));

    // Accession number
    lines.push(form_field_line(
        form.active == QueryField::AccessionNumber,
        tr("tui-form-field-accession"),
        display_text_field(&form.accession_number, &tr("common-optional")),
    ));

    // Study UID
    lines.push(form_field_line(
        form.active == QueryField::StudyUid,
        tr("tui-form-field-study-uid"),
        display_text_field(
            &form.study_uid,
            &level_uid_requirement_hint(form.level, QueryUidField::Study),
        ),
    ));
    push_query_uid_help(&mut lines, form, QueryField::StudyUid, QueryUidField::Study);

    // Series UID
    lines.push(form_field_line(
        form.active == QueryField::SeriesUid,
        tr("tui-form-field-series-uid"),
        display_text_field(
            &form.series_uid,
            &level_uid_requirement_hint(form.level, QueryUidField::Series),
        ),
    ));
    push_query_uid_help(
        &mut lines,
        form,
        QueryField::SeriesUid,
        QueryUidField::Series,
    );

    // SOP Instance UID
    lines.push(form_field_line(
        form.active == QueryField::SopInstanceUid,
        tr("tui-form-field-sop-uid"),
        display_text_field(&form.sop_instance_uid, &tr("common-optional")),
    ));
    if form.touched.contains(&QueryField::SopInstanceUid) {
        let value = form.sop_instance_uid.trim();
        if !value.is_empty() {
            if let Err(err) = validate_query_uid(value) {
                lines.push(Line::from(Span::styled(
                    format!("  ! SOP Instance UID is invalid: {err}"),
                    Style::default().fg(Color::Red),
                )));
            }
        }
    } else if form.active == QueryField::SopInstanceUid && form.sop_instance_uid.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: optional; numeric dotted UID, e.g. 1.2.840.10008.5.1.4.1.1.2",
            Style::default().fg(Color::DarkGray),
        )));
    }

    // Date from/to
    lines.push(form_field_line(
        form.active == QueryField::DateFrom,
        tr("tui-form-field-date-from"),
        display_text_field(&form.date_from, "YYYYMMDD"),
    ));
    push_query_date_help(&mut lines, form);

    lines.push(form_field_line(
        form.active == QueryField::DateTo,
        tr("tui-form-field-date-to"),
        display_text_field(&form.date_to, "YYYYMMDD"),
    ));

    // Modality
    lines.push(form_field_line(
        form.active == QueryField::Modality,
        tr("tui-form-field-modality"),
        display_text_field(&form.modality, &tr("common-optional")),
    ));
    if form.touched.contains(&QueryField::Modality) {
        let value = form.modality.trim();
        if !value.is_empty() {
            let upper = value.to_ascii_uppercase();
            if let Err(err) = validate_query_modality(&upper) {
                lines.push(Line::from(Span::styled(
                    format!("  ! {err}"),
                    Style::default().fg(Color::Red),
                )));
            }
        }
    } else if form.active == QueryField::Modality && form.modality.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: optional; A-Z/0-9 (e.g., CT, MR, US)",
            Style::default().fg(Color::DarkGray),
        )));
    }

    // Study description
    lines.push(form_field_line(
        form.active == QueryField::StudyDescription,
        tr("tui-form-field-study-desc"),
        display_text_field(&form.study_description, &tr("common-optional")),
    ));

    lines.push(Line::from(""));
    lines.push(Line::from(tr("tui-controls-hint")));

    // Global submit error summary.
    // Now that we show per-field inline validation hints, keep this as a lightweight summary.
    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            error.to_string(),
            Style::default().fg(Color::Red),
        )));
    }

    Text::from(lines)
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum QueryUidField {
    Study,
    Series,
}

fn level_uid_requirement_hint(level: QueryLevel, which: QueryUidField) -> String {
    let key = match (level, which) {
        (QueryLevel::Series | QueryLevel::Image, QueryUidField::Study) => "common-required",
        (QueryLevel::Image, QueryUidField::Series) => "common-required",
        _ => "common-optional",
    };
    tr(key)
}

fn validate_query_uid(value: &str) -> anyhow::Result<()> {
    crate::tui::forms::validate_uid(value)
}

fn validate_query_dicom_date(value: &str) -> anyhow::Result<()> {
    if value.len() != 8 || !value.chars().all(|c| c.is_ascii_digit()) {
        return Err(anyhow::anyhow!("{}", tr("tui-form-submit-date-format")));
    }
    Ok(())
}

fn validate_query_modality(value: &str) -> anyhow::Result<()> {
    crate::tui::forms::validate_modality(value)
}

fn push_query_uid_help(
    lines: &mut Vec<Line<'static>>,
    form: &QueryFormState,
    field: QueryField,
    which: QueryUidField,
) {
    if form.touched.contains(&field) {
        let value = match which {
            QueryUidField::Study => form.study_uid.trim(),
            QueryUidField::Series => form.series_uid.trim(),
        };

        let required = matches!(
            (form.level, which),
            (QueryLevel::Series | QueryLevel::Image, QueryUidField::Study)
                | (QueryLevel::Image, QueryUidField::Series)
        );

        if required && value.is_empty() {
            lines.push(Line::from(Span::styled(
                match which {
                    QueryUidField::Study => "  ! study UID is required for this query level",
                    QueryUidField::Series => "  ! series UID is required for image-level queries",
                },
                Style::default().fg(Color::Red),
            )));
        } else if !value.is_empty() {
            if let Err(err) = validate_query_uid(value) {
                lines.push(Line::from(Span::styled(
                    format!(
                        "  ! {} UID is invalid: {err}",
                        match which {
                            QueryUidField::Study => "study",
                            QueryUidField::Series => "series",
                        }
                    ),
                    Style::default().fg(Color::Red),
                )));
            }
        }
    } else if form.active == field {
        let value = match which {
            QueryUidField::Study => form.study_uid.trim(),
            QueryUidField::Series => form.series_uid.trim(),
        };
        if value.is_empty() {
            lines.push(Line::from(Span::styled(
                match (form.level, which) {
                    (QueryLevel::Series | QueryLevel::Image, QueryUidField::Study) => {
                        "  hint: required for Series/Image levels; e.g. 1.2.840.113619.2.55.3.604688433.123"
                    }
                    (QueryLevel::Image, QueryUidField::Series) => {
                        "  hint: required for Image level; e.g. 1.2.840.113619.2.55.3.604688433.456"
                    }
                    _ => "  hint: optional; numeric dotted UID, e.g. 1.2.840.10008.5.1.4.1.1.2",
                },
                Style::default().fg(Color::DarkGray),
            )));
        }
    }
}

fn push_query_date_help(lines: &mut Vec<Line<'static>>, form: &QueryFormState) {
    let from = form.date_from.trim();
    let to = form.date_to.trim();

    let from_touched = form.touched.contains(&QueryField::DateFrom);
    let to_touched = form.touched.contains(&QueryField::DateTo);

    if from_touched || to_touched {
        let from_opt = if from.is_empty() { None } else { Some(from) };
        let to_opt = if to.is_empty() { None } else { Some(to) };

        if from_opt.is_some() ^ to_opt.is_some() {
            lines.push(Line::from(Span::styled(
                "  ! both date from and date to must be set, or neither",
                Style::default().fg(Color::Red),
            )));
            return;
        }

        if let (Some(from_val), Some(to_val)) = (from_opt, to_opt) {
            if let Err(err) = validate_query_dicom_date(from_val) {
                lines.push(Line::from(Span::styled(
                    format!("  ! date from is invalid: {err}"),
                    Style::default().fg(Color::Red),
                )));
            } else if let Err(err) = validate_query_dicom_date(to_val) {
                lines.push(Line::from(Span::styled(
                    format!("  ! date to is invalid: {err}"),
                    Style::default().fg(Color::Red),
                )));
            } else if from_val > to_val {
                lines.push(Line::from(Span::styled(
                    "  ! date from must be on or before date to",
                    Style::default().fg(Color::Red),
                )));
            }
        }
    } else if matches!(form.active, QueryField::DateFrom | QueryField::DateTo)
        && from.is_empty()
        && to.is_empty()
    {
        lines.push(Line::from(Span::styled(
            "  hint: set both dates (YYYYMMDD) to filter a range, e.g. 20240101 .. 20241231",
            Style::default().fg(Color::DarkGray),
        )));
    }
}

/// Render textual content for the "Retrieve Matches" modal.
///
/// Builds a multiline `Text` containing:
/// - a header with the remote node's name, AE title, host, and port;
/// - field lines for Model, Level, Study UID (required), Series UID (optional), Instance UID (optional),
///   and Move destination (with "local AE fallback" placeholder);
/// - an instruction line describing editing and how to run/cancel;
/// - an optional bold "Error: ..." line when `form.error` is present.
///
/// # Examples
///
/// ```
/// // Construct a RetrieveFormState with appropriate fields (example values).
/// let form = RetrieveFormState {
///     node: RemoteNode { name: "rem".into(), ae_title: "AE".into(), host: "127.0.0.1".into(), port: 104 },
///     model: QueryModel::Study,
///     level: QueryLevel::Study,
///     study_uid: String::from("1.2.3"),
///     series_uid: String::new(),
///     instance_uid: String::new(),
///     destination: String::new(),
///     active: RetrieveField::StudyUid,
///     error: None,
/// };
/// let text = render_retrieve_form_text(&form);
/// let s = text.lines().next().unwrap().content(); // first line contains remote node header
/// assert!(s.contains("Remote node:"));
/// ```
pub(in crate::tui) fn render_retrieve_form_text(form: &RetrieveFormState) -> Text<'static> {
    let mut lines = vec![
        Line::from(tr4(
            "tui-form-remote-node-line",
            "name",
            &form.node.name,
            "ae",
            &form.node.ae_title,
            "host",
            &form.node.host,
            "port",
            form.node.port,
        )),
        Line::from(""),
        form_field_line(
            form.active == RetrieveField::Model,
            tr("tui-form-field-model"),
            form.model.to_string(),
        ),
        form_field_line(
            form.active == RetrieveField::Level,
            tr("tui-form-field-level"),
            form.level.to_string(),
        ),
    ];

    // Study UID
    lines.push(form_field_line(
        form.active == RetrieveField::StudyUid,
        tr("tui-form-field-study-uid"),
        display_text_field(&form.study_uid, &tr("common-required")),
    ));
    if form.touched.contains(&RetrieveField::StudyUid) {
        let value = form.study_uid.trim();
        if value.is_empty() {
            lines.push(Line::from(Span::styled(
                "  ! study UID is required",
                Style::default().fg(Color::Red),
            )));
        } else if let Err(err) = crate::tui::forms::validate_uid(value) {
            lines.push(Line::from(Span::styled(
                format!("  ! study UID is invalid: {err}"),
                Style::default().fg(Color::Red),
            )));
        }
    } else if form.active == RetrieveField::StudyUid && form.study_uid.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: dotted numeric UID (e.g., 1.2.840.113619.2.55.3.604688)",
            Style::default().fg(Color::DarkGray),
        )));
    }

    // Series UID
    lines.push(form_field_line(
        form.active == RetrieveField::SeriesUid,
        tr("tui-form-field-series-uid"),
        display_text_field(
            &form.series_uid,
            match form.level {
                QueryLevel::Image | QueryLevel::Series => tr("common-required"),
                QueryLevel::Study => tr("common-optional"),
                QueryLevel::Patient => "(n/a)".to_string(),
            },
        ),
    ));
    if form.touched.contains(&RetrieveField::SeriesUid) {
        let value = form.series_uid.trim();
        match form.level {
            QueryLevel::Series | QueryLevel::Image => {
                if value.is_empty() {
                    lines.push(Line::from(Span::styled(
                        match form.level {
                            QueryLevel::Series => {
                                "  ! series UID is required for series-level retrieve"
                            }
                            QueryLevel::Image => {
                                "  ! series UID is required for image-level retrieve"
                            }
                            _ => "  ! series UID is required",
                        },
                        Style::default().fg(Color::Red),
                    )));
                } else if let Err(err) = crate::tui::forms::validate_uid(value) {
                    lines.push(Line::from(Span::styled(
                        format!("  ! series UID is invalid: {err}"),
                        Style::default().fg(Color::Red),
                    )));
                }
            }
            QueryLevel::Study | QueryLevel::Patient => {
                if !value.is_empty() {
                    if let Err(err) = crate::tui::forms::validate_uid(value) {
                        lines.push(Line::from(Span::styled(
                            format!("  ! series UID is invalid: {err}"),
                            Style::default().fg(Color::Red),
                        )));
                    }
                }
            }
        }
    } else if form.active == RetrieveField::SeriesUid && form.series_uid.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: required for series/image level (e.g., 1.2.3.4.5)",
            Style::default().fg(Color::DarkGray),
        )));
    }

    // Instance UID
    lines.push(form_field_line(
        form.active == RetrieveField::InstanceUid,
        tr("tui-form-field-instance-uid"),
        display_text_field(
            &form.instance_uid,
            match form.level {
                QueryLevel::Image => tr("common.required"),
                _ => tr("common.optional"),
            },
        ),
    ));
    if form.touched.contains(&RetrieveField::InstanceUid) {
        let value = form.instance_uid.trim();
        if matches!(form.level, QueryLevel::Image) {
            if value.is_empty() {
                lines.push(Line::from(Span::styled(
                    "  ! instance UID is required for image-level retrieve",
                    Style::default().fg(Color::Red),
                )));
            } else if let Err(err) = crate::tui::forms::validate_uid(value) {
                lines.push(Line::from(Span::styled(
                    format!("  ! instance UID is invalid: {err}"),
                    Style::default().fg(Color::Red),
                )));
            }
        } else if !value.is_empty() {
            if let Err(err) = crate::tui::forms::validate_uid(value) {
                lines.push(Line::from(Span::styled(
                    format!("  ! instance UID is invalid: {err}"),
                    Style::default().fg(Color::Red),
                )));
            }
        }
    } else if form.active == RetrieveField::InstanceUid && form.instance_uid.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: required for image level (SOP Instance UID)",
            Style::default().fg(Color::DarkGray),
        )));
    }

    // Move destination
    lines.push(form_field_line(
        form.active == RetrieveField::Destination,
        tr("tui-form-field-move-dest"),
        display_text_field(&form.destination, "local AE fallback"),
    ));
    if form.touched.contains(&RetrieveField::Destination) {
        let value = form.destination.trim();
        if !value.is_empty() {
            let ae = value.to_ascii_uppercase();
            if let Err(err) = crate::models::validate_ae_title(&ae) {
                lines.push(Line::from(Span::styled(
                    format!("  ! move destination AE title is invalid: {err}"),
                    Style::default().fg(Color::Red),
                )));
            }
        }
    } else if form.active == RetrieveField::Destination && form.destination.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: override destination AE (defaults to local AE)",
            Style::default().fg(Color::DarkGray),
        )));
    }

    lines.push(Line::from(""));
    lines.push(Line::from(
        tr("tui-controls-hint"),
    ));

    // Global submit error summary.
    // Now that we show per-field inline validation hints, keep this as a lightweight summary.
    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            error.to_string(),
            Style::default().fg(Color::Red),
        )));
    }

    Text::from(lines)
}

pub(in crate::tui) fn render_import_form_text(form: &ImportFormState) -> Text<'static> {
    let mut lines = vec![
        Line::from(tr("tui-form-import-local-files")),
        Line::from(""),
        form_field_line(
            form.active == ImportField::Path,
            tr("tui-form-field-path"),
            display_text_field(&form.path, "folder|file|zip"),
        ),
    ];

    // Inline validation + hints
    if form.touched.contains(&ImportField::Path) {
        match crate::tui::forms::build_import_path(form) {
            Ok(_) => {}
            Err(err) => {
                lines.push(Line::from(Span::styled(
                    format!("  ! {err}"),
                    Style::default().fg(Color::Red),
                )));
            }
        }
    } else if form.active == ImportField::Path && form.path.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: e.g. /path/to/study-folder or /path/to/images.zip",
            Style::default().fg(Color::DarkGray),
        )));
    }

    lines.push(Line::from(""));
    lines.push(Line::from(
        tr("tui-controls-hint"),
    ));

    // Global submit error summary.
    // Now that we show per-field inline validation hints, keep this as a lightweight summary.
    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            error.to_string(),
            Style::default().fg(Color::Red),
        )));
    }

    Text::from(lines)
}

pub(in crate::tui) fn render_send_form_text(form: &SendFormState) -> Text<'static> {
    let mut lines = vec![
        Line::from(tr("tui-form-send-study")),
        Line::from(""),
        form_field_line(
            form.active == SendField::Kind,
            tr("tui-form-field-kind"),
            match form.kind {
                SendKind::Study => "study".to_string(),
                SendKind::Series => "series".to_string(),
            },
        ),
        form_field_line(
            form.active == SendField::Uid,
            match form.kind {
                SendKind::Study => tr("tui-form-field-study-uid"),
                SendKind::Series => tr("tui-form-field-series-uid"),
            },
            display_text_field(&form.uid, tr("common-required")),
        ),
        form_field_line(
            form.active == SendField::DestinationNode,
            tr("tui-form-field-dest-node"),
            display_text_field(&form.destination_node, tr("common-required")),
        ),
    ];

    // Inline validation + hints
    if form.touched.contains(&SendField::Uid) {
        let uid = form.uid.trim();
        if uid.is_empty() {
            lines.push(Line::from(Span::styled(
                "  ! UID is required",
                Style::default().fg(Color::Red),
            )));
        } else if let Err(err) = crate::tui::forms::validate_uid(uid) {
            lines.push(Line::from(Span::styled(
                format!("  ! {err}"),
                Style::default().fg(Color::Red),
            )));
        }
    } else if form.active == SendField::Uid && form.uid.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: UID like 1.2.840.113619.2.55.3.604688433.1234.1597349123.467",
            Style::default().fg(Color::DarkGray),
        )));
    }

    if form.touched.contains(&SendField::DestinationNode) {
        if form.destination_node.trim().is_empty() {
            lines.push(Line::from(Span::styled(
                "  ! destination node is required",
                Style::default().fg(Color::Red),
            )));
        }
    } else if form.active == SendField::DestinationNode && form.destination_node.trim().is_empty() {
        lines.push(Line::from(Span::styled(
            "  hint: a configured node name (e.g. pacs1)",
            Style::default().fg(Color::DarkGray),
        )));
    }

    lines.push(Line::from(""));
    lines.push(Line::from(
        tr("tui-controls-hint"),
    ));

    // Global submit error summary.
    // Now that we show per-field inline validation hints, keep this as a lightweight summary.
    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            error.to_string(),
            Style::default().fg(Color::Red),
        )));
    }

    Text::from(lines)
}

fn scp_limit_invalid(raw: &str) -> bool {
    !raw.trim().is_empty() && raw.trim().parse::<u64>().ok().filter(|v| *v > 0).is_none()
}

fn scp_limit_count_invalid(raw: &str) -> bool {
    !raw.trim().is_empty()
        && raw
            .trim()
            .parse::<usize>()
            .ok()
            .filter(|v| *v > 0)
            .is_none()
}

pub(in crate::tui) fn render_storage_scp_form_text(form: &StorageScpFormState) -> Text<'static> {
    let required = tr("common.required");
    let unlimited = tr("tui.form.unlimited");
    let mut lines = vec![
        Line::from(tr("tui.form.storage-intro")),
        Line::from(""),
    ];

    lines.push(form_field_line(
        form.active == StorageScpField::LocalAeTitle,
        tr("tui.form.field-local-ae"),
        display_text_field(&form.local_ae_title, &required),
    ));
    if form.touched.contains(&StorageScpField::LocalAeTitle) {
        let ae_title = form.local_ae_title.trim().to_ascii_uppercase();
        if ae_title.is_empty() {
            lines.push(form_err_line("tui.form.err-local-ae-required"));
        } else if let Err(err) = crate::models::validate_ae_title(&ae_title) {
            lines.push(form_err_text(format!(
                "  {}",
                tr1("tui.form.err-local-ae-invalid", "err", err)
            )));
        }
    } else if form.active == StorageScpField::LocalAeTitle && form.local_ae_title.trim().is_empty()
    {
        lines.push(form_hint_line("tui.form.hint-local-ae"));
    }

    lines.push(form_field_line(
        form.active == StorageScpField::BindAddr,
        tr("tui.form.field-bind-addr"),
        display_text_field(&form.bind_addr, &required),
    ));
    if form.touched.contains(&StorageScpField::BindAddr) && form.bind_addr.trim().is_empty() {
        lines.push(form_err_line("tui.form.err-bind-required"));
    } else if form.active == StorageScpField::BindAddr && form.bind_addr.trim().is_empty() {
        lines.push(form_hint_line("tui.form.hint-bind"));
    }

    lines.push(form_field_line(
        form.active == StorageScpField::Port,
        tr("tui.field.port"),
        display_text_field(&form.port, &required),
    ));
    if form.touched.contains(&StorageScpField::Port) {
        let port = form.port.trim();
        if port.is_empty() {
            lines.push(form_err_line("tui.form.err-port-required"));
        } else if let Err(err) = crate::models::parse_port(port) {
            lines.push(form_err_text(format!("  ! {err}")));
        }
    } else if form.active == StorageScpField::Port && form.port.trim().is_empty() {
        lines.push(form_hint_line("tui.form.hint-port-range"));
    }

    lines.push(form_field_line(
        form.active == StorageScpField::AllowPromiscuous,
        tr("tui.field.promiscuous"),
        display_toggle_field(form.allow_promiscuous_storage, "y", "n"),
    ));
    if form.active == StorageScpField::AllowPromiscuous
        && !form.touched.contains(&StorageScpField::AllowPromiscuous)
    {
        lines.push(form_hint_line("tui.form.hint-promiscuous"));
    }

    lines.push(form_field_line(
        form.active == StorageScpField::StrictPdu,
        tr("tui.field.strict-pdu"),
        display_toggle_field(form.strict_pdu, "y", "n"),
    ));
    if form.active == StorageScpField::StrictPdu
        && !form.touched.contains(&StorageScpField::StrictPdu)
    {
        lines.push(form_hint_line("tui.form.hint-strict-pdu"));
    }

    lines.push(form_field_line(
        form.active == StorageScpField::MaxPduLength,
        tr("tui.field.max-pdu"),
        display_text_field(&form.max_pdu_length, &required),
    ));
    if form.touched.contains(&StorageScpField::MaxPduLength) {
        let value = form.max_pdu_length.trim();
        if value.is_empty() {
            lines.push(form_err_line("tui.form.err-max-pdu-required"));
        } else if value.parse::<u32>().ok().filter(|v| *v > 0).is_none() {
            lines.push(form_err_line("tui.form.err-max-pdu-gt-zero"));
        }
    } else if form.active == StorageScpField::MaxPduLength && form.max_pdu_length.trim().is_empty()
    {
        lines.push(form_hint_line("tui.form.hint-max-pdu-bytes"));
    }

    lines.push(Line::from(""));
    lines.push(Line::from(tr("tui.form.limits-heading")));

    let limit_fields = [
        (
            StorageScpField::MaxFileImportBytes,
            "tui.form.field-max-file-import",
            form.max_file_import_bytes.as_str(),
            scp_limit_invalid(&form.max_file_import_bytes),
        ),
        (
            StorageScpField::MaxZipEntryBytes,
            "tui.form.field-max-zip-entry",
            form.max_zip_entry_bytes.as_str(),
            scp_limit_invalid(&form.max_zip_entry_bytes),
        ),
        (
            StorageScpField::MaxZipTotalBytes,
            "tui.form.field-max-zip-total",
            form.max_zip_total_bytes.as_str(),
            scp_limit_invalid(&form.max_zip_total_bytes),
        ),
        (
            StorageScpField::MaxZipEntryCount,
            "tui.form.field-max-zip-count",
            form.max_zip_entry_count.as_str(),
            scp_limit_count_invalid(&form.max_zip_entry_count),
        ),
        (
            StorageScpField::MaxStoreObjectBytes,
            "tui.form.field-max-store-object",
            form.max_store_object_bytes.as_str(),
            scp_limit_invalid(&form.max_store_object_bytes),
        ),
    ];
    for (field, label_key, value, invalid) in limit_fields {
        let label = tr(label_key);
        lines.push(form_field_line(
            form.active == field,
            &label,
            display_text_field(value, &unlimited),
        ));
        if form.touched.contains(&field) && invalid {
            lines.push(form_err_text(format!(
                "  {}",
                tr1("tui.form.err-limit-gt-zero", "label", &label)
            )));
        }
    }

    lines.push(Line::from(""));
    lines.push(Line::from(tr("tui.form.controls-scp")));

    // Global submit error summary.
    // Now that we show per-field inline validation hints, keep this as a lightweight summary.
    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            error.to_string(),
            Style::default().fg(Color::Red),
        )));
    }

    Text::from(lines)
}

/// Compute a rectangle of the requested size centered inside `area`, clamping the
/// requested width and height to fit within `area` (width limited to at most
/// `area.width - 2` and at least 10; height limited to at most `area.height - 2`
/// and at least 5).
///
/// # Examples
///
/// ```
/// use ratatui::layout::Rect;
/// let area = Rect::new(0, 0, 100, 30);
/// let rect = centered_rect(area, 50, 10);
/// assert_eq!(rect, Rect::new(25, 10, 50, 10));
/// ```
pub(in crate::tui) fn centered_rect(area: Rect, width: u16, height: u16) -> Rect {
    let width = width.min(area.width.saturating_sub(2)).max(10);
    let height = height.min(area.height.saturating_sub(2)).max(5);

    let vertical = Layout::default()
        .direction(Direction::Vertical)
        .constraints([
            Constraint::Length(area.height.saturating_sub(height) / 2),
            Constraint::Length(height),
            Constraint::Min(0),
        ])
        .split(area);

    let horizontal = Layout::default()
        .direction(Direction::Horizontal)
        .constraints([
            Constraint::Length(area.width.saturating_sub(width) / 2),
            Constraint::Length(width),
            Constraint::Min(0),
        ])
        .split(vertical[1]);

    horizontal[1]
}

/// Render a single form field line with an indicator and styling for the active field.
///
/// When `active` is `true` the line is prefixed with `"> "` and styled with reversed + bold;
/// otherwise it is prefixed with two spaces and uses the default style. The produced line
/// contains the label and value formatted as `"{prefix}{label}: {value}"`.
///
/// # Examples
///
/// ```
/// use ratatui::text::Line;
/// // Create an active field line
/// let line: Line = crate::tui::render::modal::form_field_line(true, "Name", "Alice".to_string());
/// assert!(format!("{:?}", line).contains("> Name: Alice"));
/// ```
pub(in crate::tui) fn form_field_line(
    active: bool,
    label: impl AsRef<str>,
    value: String,
) -> Line<'static> {
    let label = label.as_ref();
    let style = if active {
        Style::default().add_modifier(Modifier::REVERSED | Modifier::BOLD)
    } else {
        Style::default()
    };
    let prefix = if active { "> " } else { "  " };
    Line::from(Span::styled(format!("{prefix}{label}: {value}"), style))
}

/// Display a boolean toggle as "On"/"Off" with an optional hint when unset.
///
/// `label_on`/`label_off` allow callers to choose wording (e.g. Yes/No, Enabled/Disabled).
pub(in crate::tui) fn display_toggle_field(value: bool, label_on: &str, label_off: &str) -> String {
    if value {
        label_on.to_string()
    } else {
        label_off.to_string()
    }
}

/// Formats a text field for display, showing a placeholder when the value is empty.
///
/// If `value` contains only whitespace, returns `"<{placeholder}>"`. Otherwise returns the original `value` unchanged.
///
/// # Examples
///
/// ```
/// assert_eq!(display_text_field("", "required"), "<required>");
/// assert_eq!(display_text_field("  ", "opt"), "<opt>");
/// assert_eq!(display_text_field("foo ", "x"), "foo ");
/// ```
pub(in crate::tui) fn display_text_field(value: &str, placeholder: impl AsRef<str>) -> String {
    let trimmed = value.trim();
    if trimmed.is_empty() {
        format!("<{}>", placeholder.as_ref())
    } else {
        value.to_string()
    }
}
