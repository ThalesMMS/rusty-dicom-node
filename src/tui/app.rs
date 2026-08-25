use super::*;
use dicom_node_client::summary::OperationSummary;

impl TuiApp {
    pub(super) fn new(services: AppServices) -> Self {
        let services = Arc::new(services);
        let status = services.tui_status_snapshot(TuiReceiverMode::OnDemandForLocalRetrieve);
        let task_runner = TaskRunner::new(Arc::clone(&services));

        Self {
            services,
            task_runner,
            status: status.clone(),
            focus: FocusPane::Input,
            nodes: Vec::new(),
            selected_node: None,
            local_studies: Vec::new(),
            selected_local_study: None,
            local_series: Vec::new(),
            selected_local_series: None,
            local_instances: Vec::new(),
            selected_local_instance: None,
            local_drill_down: false,
            drill_down_study_uid: None,
            local_instance_drill_down: false,
            query_results: Vec::new(),
            selected_query_result: None,
            query_context_node: None,
            query_context_model: QueryModel::default(),
            detail_scroll: 0,
            editor: CommandEditor::default(),
            history: VecDeque::new(),
            history_index: None,
            draft: String::new(),
            logs: vec![
                tr("tui.log.welcome"),
                tr3(
                    "tui.status.configured-listener",
                    "addr",
                    &status.listener_addr,
                    "ae",
                    &status.local_ae_title,
                    "mode",
                    &status.receiver_mode,
                ),
                tr1("tui.log.logging-to", "path", &status.log_dir),
            ],
            running_task: None,
            queued_tasks: VecDeque::new(),
            task_history: VecDeque::new(),
            selected_task: None,
            selected_task_scope: TaskListScope::History,
            task_logs: VecDeque::new(),
            last_task_error: None,
            show_help: false,
            modal: None,
            should_quit: false,
        }
    }

    pub(super) fn run(&mut self) -> anyhow::Result<()> {
        let _panic_hook = PanicHookGuard::install();
        let mut terminal = TerminalGuard::new()?;

        self.refresh_all()?;

        loop {
            let view = self.view();

            terminal.draw(&view)?;

            self.tick_tasks()?;

            if self.should_quit {
                break;
            }

            if event::poll(Duration::from_millis(100))? {
                match event::read()? {
                    Event::Key(key) if key.kind == KeyEventKind::Press => {
                        self.handle_key(key)?;
                    }
                    Event::Paste(text) => self.handle_paste(&text),
                    _ => {}
                }
            }
        }

        Ok(())
    }

    // Build a lightweight frame view borrowing from `self`.
    //
    // Rendering is synchronous and only needs data for the duration of a single draw call,
    // so `TuiView` holds references/slices into app state. This avoids per-frame deep clones
    // of potentially large collections (nodes, local catalog, query results, logs, tasks).
    pub(super) fn view(&mut self) -> TuiView<'_> {
        TuiView {
            status: self.status.clone(),
            focus: self.focus,
            nodes: &self.nodes,
            selected_node: self.selected_node,
            local_studies: &self.local_studies,
            selected_local_study: self.selected_local_study,
            local_series: &self.local_series,
            selected_local_series: self.selected_local_series,
            local_instances: &self.local_instances,
            selected_local_instance: self.selected_local_instance,
            local_drill_down: self.local_drill_down,
            drill_down_study_uid: self.drill_down_study_uid.as_deref(),
            local_instance_drill_down: self.local_instance_drill_down,
            query_results: &self.query_results,
            selected_query_result: self.selected_query_result,
            query_context_node: self.query_context_node.as_ref(),
            query_context_node_name: self
                .query_context_node
                .as_ref()
                .map(|node| node.name.as_str()),
            detail_scroll: self.detail_scroll,
            input_content: self.editor.content().to_string(),
            input_cursor: self.editor.cursor_position(),
            logs: &self.logs,
            running_task: self.running_task.as_ref().map(|task| RunningTaskView {
                description: task.description.clone(),
                elapsed: task.started_at.elapsed(),
            }),
            queued_tasks: self.queued_tasks.make_contiguous(),
            task_history: self.task_history.make_contiguous(),
            selected_task: self.selected_task,
            selected_task_scope: self.selected_task_scope,
            show_help: self.show_help,
            modal: self.modal.as_ref(),
        }
    }

    pub(super) fn is_busy(&self) -> bool {
        self.running_task.is_some() || self.task_runner.has_pending_tasks()
    }

    pub(super) fn tick_tasks(&mut self) -> anyhow::Result<()> {
        while let Some(event) = self.task_runner.try_recv_event() {
            self.apply_task_event(event)?;
        }

        if let Some(event) = self.task_runner.try_recv() {
            self.apply_task_event(event)?;
        }

        if self.running_task.is_none() {
            if let Some(next) = self.task_runner.try_start_next()? {
                self.running_task = Some(next);
            }
        }

        Ok(())
    }

    pub(super) fn log_task_queued(&mut self, description: impl AsRef<str>) {
        self.log(tr1(
            "tui-status-queued-op",
            "op",
            description.as_ref().trim_end(),
        ));
    }

    pub(super) fn start_task(&mut self, task: BackgroundTask) -> anyhow::Result<()> {
        let description = task.description();

        // Queue tasks; the main loop will start the next task when idle.
        let event = self.task_runner.enqueue(task);
        self.apply_task_event(event)?;
        if self.running_task.is_none() {
            if let Some(next) = self.task_runner.try_start_next()? {
                self.running_task = Some(next);
            }
        } else {
            self.log_task_queued(description);
        }
        Ok(())
    }

    pub(super) fn cancel_active_task(&mut self) {
        let id = self.task_runner.cancel_active();
        if let Some(id) = id {
            if let Some(task) = self.queued_tasks.iter_mut().find(|task| task.id == id) {
                task.status = TaskStatus::Cancelling;
            }

            // Best-effort immediate feedback.
            self.log(tr("tui-status-cancel-requested"));
        } else {
            self.log(tr("tui-status-no-active-task"));
        }
    }

    pub(super) fn open_task_inspect_modal(&mut self) {
        let task = match self.selected_task_scope {
            TaskListScope::Queued => self
                .selected_task
                .and_then(|index| self.queued_tasks.get(index)),
            TaskListScope::History => self
                .selected_task
                .and_then(|index| self.task_history.get(index)),
        };

        let Some(task) = task else {
            return;
        };

        let mut lines: Vec<Line<'static>> = Vec::new();
        lines.push(Line::from(tr1("tui-inspect-task", "id", task.id)));
        lines.push(Line::from(tr1(
            "tui-inspect-status",
            "status",
            task.status.to_string(),
        )));
        lines.push(Line::from(tr1(
            "tui-inspect-description",
            "description",
            &task.description,
        )));
        if let Some(progress) = task.progress.as_ref() {
            let progress_text = match progress.total {
                Some(total) => format!("{}/{}", progress.current, total),
                None => progress.current.to_string(),
            };
            lines.push(Line::from(tr1(
                "tui-inspect-progress",
                "progress",
                progress_text,
            )));
        }

        if let Some(summary) = task.summary.as_ref() {
            lines.push(Line::from(""));
            lines.push(Line::from(Span::styled(
                tr("tui-inspect-summary"),
                Style::default().add_modifier(Modifier::BOLD),
            )));

            // Render the shared operation summary into a line-oriented representation.
            // We keep this in the inspect modal so users can quickly see the most important
            // diagnostics without needing to dig through raw logs.
            let rendered = dicom_node_client::summary_render::render_human(summary);
            for line in rendered.lines() {
                lines.push(Line::from(line.to_string()));
            }
        }

        lines.push(Line::from(""));
        lines.push(Line::from(Span::styled(
            "Logs:",
            Style::default().add_modifier(Modifier::BOLD),
        )));

        let mut recent_logs: Vec<String> = self
            .task_logs
            .iter()
            .rev()
            .filter(|(id, _)| *id == task.id)
            .map(|(_, line)| line.clone())
            .take(50)
            .collect();

        if recent_logs.is_empty() {
            lines.push(Line::from(tr("tui-inspect-no-logs")));
        } else {
            recent_logs.reverse();
            for line in recent_logs {
                lines.push(Line::from(line));
            }
        }

        self.modal = Some(ModalState::TaskInspect(TaskInspectState {
            title: tr("tui.pane.task-details"),
            content: Text::from(lines),
        }));
    }

    pub(super) fn refresh_local_studies(&mut self) -> anyhow::Result<()> {
        let selected_study_uid = self
            .selected_local_study()
            .map(|study| study.study_instance_uid.clone());
        let selected_series_uid = self
            .selected_local_series()
            .map(|series| series.series_instance_uid.clone());
        let selected_instance_uid = self
            .selected_local_instance()
            .map(|instance| instance.sop_instance_uid.clone());
        let drill_down_study_uid = self.drill_down_study_uid.clone();

        self.local_studies = self.services.local_studies()?;
        self.selected_local_study = selection_by_key(
            &self.local_studies,
            selected_study_uid.as_deref(),
            |study| study.study_instance_uid.as_str(),
        );

        if let Some(study_uid) = drill_down_study_uid {
            if self
                .local_studies
                .iter()
                .any(|study| study.study_instance_uid == study_uid)
            {
                self.local_series = self.services.local_series(&study_uid)?;
                self.selected_local_series = selection_by_key(
                    &self.local_series,
                    selected_series_uid.as_deref(),
                    |series| series.series_instance_uid.as_str(),
                );

                if self.local_instance_drill_down {
                    if let Some(series_uid) = self
                        .selected_local_series()
                        .map(|series| series.series_instance_uid.clone())
                    {
                        self.local_instances = self.services.local_instances(&series_uid)?;
                        self.selected_local_instance = selection_by_key(
                            &self.local_instances,
                            selected_instance_uid.as_deref(),
                            |instance| instance.sop_instance_uid.as_str(),
                        );
                    } else {
                        self.clear_local_instance_drill_down();
                        self.local_instances.clear();
                    }
                }

                self.drill_down_study_uid = Some(study_uid);
            } else {
                self.reset_local_drill_down_cache();
            }
        } else {
            self.clear_local_drill_down();
        }

        Ok(())
    }

    pub(super) fn apply_task_event(&mut self, event: TaskEvent) -> anyhow::Result<()> {
        match event {
            TaskEvent::Queued {
                id,
                description,
                at,
            } => {
                tracing::info!(task.id = id, task.event = "queued", task.description = %description);

                self.queued_tasks.push_back(TaskInfo {
                    id,
                    description,
                    status: TaskStatus::Queued,
                    created_at: at,
                    started_at: None,
                    finished_at: None,
                    progress: None,
                    outcome: None,
                    summary: None,
                });
            }
            TaskEvent::Started { id, at } => {
                tracing::info!(task.id = id, task.event = "started");

                if let Some(task) = self.queued_tasks.iter_mut().find(|t| t.id == id) {
                    task.status = TaskStatus::Running;
                    task.started_at = Some(at);
                }
            }
            TaskEvent::Log { id, line, .. } => {
                tracing::info!(task.id = id, task.event = "log", "{line}");

                self.task_logs.push_back((id, line));
                if self.task_logs.len() > 500 {
                    let overflow = self.task_logs.len() - 500;
                    self.task_logs.drain(0..overflow);
                }
            }
            TaskEvent::Progress { id, progress, .. } => {
                tracing::info!(
                    task.id = id,
                    task.event = "progress",
                    task.progress.current = progress.current,
                    task.progress.total = progress.total,
                    "task progress"
                );

                if let Some(task) = self.queued_tasks.iter_mut().find(|t| t.id == id) {
                    task.progress = Some(progress);
                }
            }
            TaskEvent::Finished { id, at, result } => {
                let (status, status_label, error) = match &result {
                    TaskResult::Query(Ok(_))
                    | TaskResult::Retrieve(Ok(_))
                    | TaskResult::Import(Ok(_))
                    | TaskResult::Send(Ok(_)) => (TaskStatus::Succeeded, "succeeded", None),
                    TaskResult::Query(Err(err))
                    | TaskResult::Retrieve(Err(err))
                    | TaskResult::Import(Err(err))
                    | TaskResult::Send(Err(err))
                    | TaskResult::InternalError(err) => (TaskStatus::Failed, "failed", Some(err)),
                };

                if let Some(error) = error {
                    tracing::error!(task.id = id, task.event = "finished", task.status = status_label, error = %error);
                } else {
                    tracing::info!(
                        task.id = id,
                        task.event = "finished",
                        task.status = status_label
                    );
                }

                if let Some(pos) = self.queued_tasks.iter().position(|t| t.id == id) {
                    let mut task = self.queued_tasks.remove(pos).expect("position existed");
                    task.status = status;
                    task.finished_at = Some(at);
                    task.outcome = Some(match status {
                        TaskStatus::Succeeded => TaskOutcome::Succeeded,
                        TaskStatus::Failed => TaskOutcome::Failed,
                        TaskStatus::Cancelled => TaskOutcome::Cancelled,
                        _ => TaskOutcome::Failed,
                    });
                    // Attach a placeholder summary for now; a richer per-operation summary
                    // will be wired in once background tasks emit it.
                    let mut summary = OperationSummary::new(
                        dicom_node_client::summary::OperationKind::Import,
                        task.started_at
                            .map(|start| at.duration_since(start).as_millis() as u64)
                            .unwrap_or(0),
                        match status {
                            TaskStatus::Succeeded => {
                                dicom_node_client::summary::OperationStatus::Success
                            }
                            TaskStatus::Failed => {
                                dicom_node_client::summary::OperationStatus::Failure
                            }
                            TaskStatus::Cancelled => {
                                dicom_node_client::summary::OperationStatus::Cancelled
                            }
                            _ => dicom_node_client::summary::OperationStatus::Failure,
                        },
                    );
                    summary.logs.push(dicom_node_client::summary::LogReference {
                        path: self.status.log_dir.clone() + "/app.log",
                        correlation_id: None,
                        line_range: None,
                    });
                    task.summary = Some(summary);
                    self.task_history.push_front(task);
                    if self.task_history.len() > 50 {
                        self.task_history.pop_back();
                    }
                }

                // Preserve existing completion behavior for now, but also store
                // the latest error so it can be surfaced in the UI.
                self.last_task_error = error.map(|err| err.to_string());
                self.handle_task_result(result)?;
            }
            TaskEvent::Cancelled { id, at, reason } => {
                if let Some(event) = self.task_runner.try_recv_real_result() {
                    self.apply_task_event(event)?;
                }
                self.task_runner.clear_active_state();
                self.running_task = None;

                if let Some(reason) = reason.as_deref() {
                    tracing::warn!(task.id = id, task.event = "cancelled", reason = reason);
                } else {
                    tracing::warn!(task.id = id, task.event = "cancelled");
                }

                // Also surface a user-visible message, consistent with other task
                // lifecycle feedback.
                match reason.as_deref() {
                    Some(reason)
                        if reason == tr("tui-status-cancel-requested")
                            || reason == tr("error-operation-cancelled") =>
                    {
                        self.log(tr("tui-status-cancel-requested"));
                    }
                    Some(other) => {
                        self.log(tr1("tui-status-task-cancelled-detail", "other", other));
                    }
                    None => {
                        self.log(tr("tui-status-task-cancelled"));
                    }
                }

                self.last_task_error = reason;
                if let Some(pos) = self.queued_tasks.iter().position(|t| t.id == id) {
                    let mut task = self.queued_tasks.remove(pos).expect("position existed");
                    task.status = TaskStatus::Cancelled;
                    task.finished_at = Some(at);
                    task.outcome = Some(TaskOutcome::Cancelled);
                    self.task_history.push_front(task);
                    if self.task_history.len() > 50 {
                        self.task_history.pop_back();
                    }
                }
            }
        }

        Ok(())
    }

    pub(super) fn handle_task_result(&mut self, result: TaskResult) -> anyhow::Result<()> {
        self.running_task = None;

        match result {
            TaskResult::Query(Ok(matches)) => {
                self.query_results = matches;
                self.selected_query_result = normalized_selection(None, self.query_results.len());
                self.focus = FocusPane::Query;
                self.log(tr_n(
                    "tui-task-query-done",
                    "count",
                    self.query_results.len() as i64,
                ));
            }
            TaskResult::Query(Err(error)) => {
                self.query_results.clear();
                self.selected_query_result = normalized_selection(None, 0);
                self.log(tr1("tui-status-query-failed", "error", error.to_string()));
            }
            TaskResult::Retrieve(Ok(outcome)) => {
                self.log(tr5(
                    "tui-status-retrieve-ok",
                    "status",
                    format!("{:04X}", outcome.final_status),
                    "completed",
                    outcome.completed,
                    "failed",
                    outcome.failed,
                    "warning",
                    outcome.warning,
                    "remaining",
                    outcome.remaining,
                ));
                self.refresh_local_studies()?;
            }
            TaskResult::Retrieve(Err(error)) => {
                self.log(tr1("tui-status-retrieve-failed", "error", error.to_string()));
            }
            TaskResult::Import(Ok(report)) => {
                self.log(tr_pairs(
                    "tui-status-import-counts",
                    &[
                        ("scanned", report.scanned_files.to_string()),
                        ("accepted", report.accepted.to_string()),
                        ("duplicates", report.duplicates.to_string()),
                        ("unreadable", report.unreadable.to_string()),
                        ("invalid", report.invalid_dicom.to_string()),
                        ("rejected", report.rejected().to_string()),
                        ("bytes", report.stored_bytes.to_string()),
                    ],
                ));
                const IMPORT_FAILURE_LOG_LIMIT: usize = 5;
                if !report.failures.is_empty() {
                    for failure in report.failures.iter().take(IMPORT_FAILURE_LOG_LIMIT) {
                        self.log(tr1("tui-status-failure", "failure", failure.to_string()));
                    }
                    if report.failures.len() > IMPORT_FAILURE_LOG_LIMIT {
                        self.log(tr_n(
                            "tui-status-more-failures",
                            "n",
                            (report.failures.len() - IMPORT_FAILURE_LOG_LIMIT) as i64,
                        ));
                    }
                }
                self.refresh_local_studies()?;
            }
            TaskResult::Import(Err(error)) => {
                self.log(tr1("tui-task-import-failed", "error", error.to_string()));
            }
            TaskResult::Send(Ok(outcome)) => {
                self.log(tr3(
                    "tui-status-send-ok",
                    "attempted",
                    outcome.attempted,
                    "sent",
                    outcome.sent,
                    "failed",
                    outcome.failed,
                ));
            }
            TaskResult::Send(Err(error)) => {
                self.log(tr1("cli-msg-send-failed", "error", error.to_string()));
            }
            TaskResult::InternalError(error) => {
                self.log(tr1("tui-task-failed-generic", "error", error.to_string()));
            }
        }

        Ok(())
    }

    pub(super) fn refresh_all(&mut self) -> anyhow::Result<()> {
        let selected_node_id = self.selected_node().map(|node| node.id.clone());

        self.status = self
            .services
            .tui_status_snapshot(TuiReceiverMode::OnDemandForLocalRetrieve);

        self.nodes = self.services.list_nodes()?;
        self.selected_node = selection_by_key(&self.nodes, selected_node_id.as_deref(), |node| {
            node.id.as_str()
        });

        self.refresh_local_studies()?;

        if let Some(current_query_node) = self.query_context_node.as_ref() {
            self.query_context_node = self
                .nodes
                .iter()
                .find(|node| node.id == current_query_node.id)
                .cloned();
        }

        self.selected_query_result =
            normalized_selection(self.selected_query_result, self.query_results.len());

        Ok(())
    }

    pub(super) fn log(&mut self, line: impl Into<String>) {
        self.logs.push(line.into());
        if self.logs.len() > 200 {
            let overflow = self.logs.len() - 200;
            self.logs.drain(0..overflow);
        }
    }
}
