use super::*;

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
            .block(Block::default().title("Help").borders(Borders::ALL))
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
                            .title("Delete Remote Node")
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
                            .title("Query Remote Node")
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
                            .title("Retrieve Matches")
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
    let mut lines = vec![
        Line::from(format!(
            "Mode: {}",
            match form.mode {
                NodeFormMode::Add => "create a new remote node",
                NodeFormMode::Edit => "update the selected remote node",
            }
        )),
        Line::from(""),
        form_field_line(
            form.active == NodeField::Name,
            "Name",
            display_text_field(&form.name, "required"),
        ),
        form_field_line(
            form.active == NodeField::AeTitle,
            "AE title",
            display_text_field(&form.ae_title, "required"),
        ),
        form_field_line(
            form.active == NodeField::Host,
            "Host",
            display_text_field(&form.host, "required"),
        ),
        form_field_line(
            form.active == NodeField::Port,
            "Port",
            display_text_field(&form.port, "required"),
        ),
        form_field_line(
            form.active == NodeField::MoveDestination,
            "Move destination",
            display_text_field(&form.move_destination, "optional"),
        ),
        form_field_line(
            form.active == NodeField::Notes,
            "Notes",
            display_text_field(&form.notes, "optional"),
        ),
        Line::from(""),
        Line::from("Type to edit. Tab/Shift-Tab or Up/Down move fields. Enter saves. Esc cancels."),
    ];

    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            format!("Error: {error}"),
            Style::default().add_modifier(Modifier::BOLD),
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
        Line::from(format!(
            "Delete remote node {} [{}] at {}:{}?",
            confirm.node.name, confirm.node.ae_title, confirm.node.host, confirm.node.port
        )),
        Line::from(""),
        Line::from("Press Enter or y to confirm. Press Esc or n to cancel."),
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
        Line::from(format!(
            "Remote node: {} [{}] {}:{}",
            form.node.name, form.node.ae_title, form.node.host, form.node.port
        )),
        Line::from(""),
        form_field_line(form.active == QueryField::Model, "Model", form.model.to_string()),
        form_field_line(form.active == QueryField::Level, "Level", form.level.to_string()),
        form_field_line(
            form.active == QueryField::PatientName,
            "Patient name",
            display_text_field(&form.patient_name, "optional"),
        ),
        form_field_line(
            form.active == QueryField::PatientId,
            "Patient ID",
            display_text_field(&form.patient_id, "optional"),
        ),
        form_field_line(
            form.active == QueryField::AccessionNumber,
            "Accession number",
            display_text_field(&form.accession_number, "optional"),
        ),
        form_field_line(
            form.active == QueryField::StudyUid,
            "Study UID",
            display_text_field(&form.study_uid, "optional"),
        ),
        form_field_line(
            form.active == QueryField::SeriesUid,
            "Series UID",
            display_text_field(&form.series_uid, "optional"),
        ),
        form_field_line(
            form.active == QueryField::SopInstanceUid,
            "SOP Instance UID",
            display_text_field(&form.sop_instance_uid, "optional"),
        ),
        form_field_line(
            form.active == QueryField::DateFrom,
            "Date from",
            display_text_field(&form.date_from, "YYYYMMDD"),
        ),
        form_field_line(
            form.active == QueryField::DateTo,
            "Date to",
            display_text_field(&form.date_to, "YYYYMMDD"),
        ),
        form_field_line(
            form.active == QueryField::Modality,
            "Modality",
            display_text_field(&form.modality, "optional"),
        ),
        form_field_line(
            form.active == QueryField::StudyDescription,
            "Study description",
            display_text_field(&form.study_description, "optional"),
        ),
        Line::from(""),
        Line::from(
            "Type to edit text. Left/Right/Space cycle model or level. Enter runs the query. Esc cancels.",
        ),
    ];

    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            format!("Error: {error}"),
            Style::default().add_modifier(Modifier::BOLD),
        )));
    }

    Text::from(lines)
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
        Line::from(format!(
            "Remote node: {} [{}] {}:{}",
            form.node.name, form.node.ae_title, form.node.host, form.node.port
        )),
        Line::from(""),
        form_field_line(
            form.active == RetrieveField::Model,
            "Model",
            form.model.to_string(),
        ),
        form_field_line(
            form.active == RetrieveField::Level,
            "Level",
            form.level.to_string(),
        ),
        form_field_line(
            form.active == RetrieveField::StudyUid,
            "Study UID",
            display_text_field(&form.study_uid, "required"),
        ),
        form_field_line(
            form.active == RetrieveField::SeriesUid,
            "Series UID",
            display_text_field(&form.series_uid, "optional"),
        ),
        form_field_line(
            form.active == RetrieveField::InstanceUid,
            "Instance UID",
            display_text_field(&form.instance_uid, "optional"),
        ),
        form_field_line(
            form.active == RetrieveField::Destination,
            "Move destination",
            display_text_field(&form.destination, "local AE fallback"),
        ),
        Line::from(""),
        Line::from(
            "Type to edit text. Left/Right/Space cycle model or level. Enter runs retrieve. Esc cancels.",
        ),
    ];

    if let Some(error) = &form.error {
        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            format!("Error: {error}"),
            Style::default().add_modifier(Modifier::BOLD),
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
pub(in crate::tui) fn form_field_line(active: bool, label: &str, value: String) -> Line<'static> {
    let style = if active {
        Style::default().add_modifier(Modifier::REVERSED | Modifier::BOLD)
    } else {
        Style::default()
    };
    let prefix = if active { "> " } else { "  " };
    Line::from(Span::styled(format!("{prefix}{label}: {value}"), style))
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
pub(in crate::tui) fn display_text_field(value: &str, placeholder: &str) -> String {
    let trimmed = value.trim();
    if trimmed.is_empty() {
        format!("<{placeholder}>")
    } else {
        value.to_string()
    }
}
