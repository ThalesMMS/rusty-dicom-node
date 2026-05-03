use super::*;

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
                "Press F1 or ? for help. Focus Remote nodes and press 'a' to add one.".to_string(),
                format!(
                    "Configured listener {} as AE {} ({})",
                    status.listener_addr, status.local_ae_title, status.receiver_mode
                ),
                format!("Logging to {}", status.log_dir),
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

    // This clones render-facing state into TuiView each frame so drawing stays decoupled
    // from mutable app state. That is acceptable for human-scale TUI data, but very large
    // nodes, local_studies, query_results, logs, or similar collections could make this
    // allocation-heavy; if profiling shows overhead, consider Arc/Rc, Cow, streaming views,
    // or converting a specific heavy collection such as nodes or logs to shared immutable data.
    pub(super) fn view(&self) -> TuiView {
        TuiView {
            status: self.status.clone(),
            focus: self.focus,
            nodes: self.nodes.clone(),
            selected_node: self.selected_node,
            local_studies: self.local_studies.clone(),
            selected_local_study: self.selected_local_study,
            local_series: self.local_series.clone(),
            selected_local_series: self.selected_local_series,
            local_instances: self.local_instances.clone(),
            selected_local_instance: self.selected_local_instance,
            local_drill_down: self.local_drill_down,
            drill_down_study_uid: self.drill_down_study_uid.clone(),
            local_instance_drill_down: self.local_instance_drill_down,
            query_results: self.query_results.clone(),
            selected_query_result: self.selected_query_result,
            query_context_node: self.query_context_node.clone(),
            query_context_node_name: self
                .query_context_node
                .as_ref()
                .map(|node| node.name.clone()),
            detail_scroll: self.detail_scroll,
            input_content: self.editor.content().to_string(),
            input_cursor: self.editor.cursor_position(),
            logs: self.logs.clone(),
            running_task: self.running_task.as_ref().map(|task| RunningTaskView {
                description: task.description.clone(),
                elapsed: task.started_at.elapsed(),
            }),
            queued_tasks: self.queued_tasks.iter().cloned().collect(),
            task_history: self.task_history.iter().cloned().collect(),
            selected_task: self.selected_task,
            selected_task_scope: self.selected_task_scope,
            show_help: self.show_help,
            modal: self.modal.clone(),
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

    pub(super) fn ensure_not_busy(&mut self) -> bool {
        if self.is_busy() {
            self.log("Please wait for the current operation to complete");
            false
        } else {
            true
        }
    }

    pub(super) fn start_task(&mut self, task: BackgroundTask) -> anyhow::Result<()> {
        // Queue tasks; the main loop will start the next task when idle.
        let event = self.task_runner.enqueue(task);
        self.apply_task_event(event)?;
        if self.running_task.is_none() {
            if let Some(next) = self.task_runner.try_start_next()? {
                self.running_task = Some(next);
            }
        }
        Ok(())
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
        lines.push(Line::from(vec![
            Span::styled("Task ", Style::default().add_modifier(Modifier::BOLD)),
            Span::raw(format!("#{}", task.id)),
        ]));
        lines.push(Line::from(format!("Status: {}", task.status)));
        lines.push(Line::from(format!("Description: {}", task.description)));
        if let Some(progress) = task.progress.as_ref() {
            lines.push(Line::from(format!(
                "Progress: {}{}",
                progress.current,
                progress
                    .total
                    .map(|total| format!("/{total}"))
                    .unwrap_or_default()
            )));
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
            lines.push(Line::from("(no logs)"));
        } else {
            recent_logs.reverse();
            for line in recent_logs {
                lines.push(Line::from(line));
            }
        }

        self.modal = Some(ModalState::TaskInspect(TaskInspectState {
            title: "Task details".to_string(),
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

                self.last_task_error = reason;
                if let Some(pos) = self.queued_tasks.iter().position(|t| t.id == id) {
                    let mut task = self.queued_tasks.remove(pos).expect("position existed");
                    task.status = TaskStatus::Cancelled;
                    task.finished_at = Some(at);
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
                self.log(format!(
                    "query returned {} matches",
                    self.query_results.len()
                ));
            }
            TaskResult::Query(Err(error)) => {
                self.query_results.clear();
                self.selected_query_result = normalized_selection(None, 0);
                self.log(format!("query failed: {error}"));
            }
            TaskResult::Retrieve(Ok(outcome)) => {
                self.log(format!(
                    "retrieve status=0x{:04X} completed={} failed={} warning={} remaining={}",
                    outcome.final_status,
                    outcome.completed,
                    outcome.failed,
                    outcome.warning,
                    outcome.remaining,
                ));
                self.refresh_local_studies()?;
            }
            TaskResult::Retrieve(Err(error)) => {
                self.log(format!("retrieve failed: {error}"));
            }
            TaskResult::Import(Ok(report)) => {
                self.log(format!(
                    "scanned={} accepted={} duplicates={} unreadable={} invalid_dicom={} rejected_total={} stored_bytes={}",
                    report.scanned_files,
                    report.accepted,
                    report.duplicates,
                    report.unreadable,
                    report.invalid_dicom,
                    report.rejected(),
                    report.stored_bytes,
                ));
                const IMPORT_FAILURE_LOG_LIMIT: usize = 5;
                if !report.failures.is_empty() {
                    for failure in report.failures.iter().take(IMPORT_FAILURE_LOG_LIMIT) {
                        self.log(format!("failure: {failure}"));
                    }
                    if report.failures.len() > IMPORT_FAILURE_LOG_LIMIT {
                        self.log(format!(
                            "and {} more failures omitted",
                            report.failures.len() - IMPORT_FAILURE_LOG_LIMIT
                        ));
                    }
                }
                self.refresh_local_studies()?;
            }
            TaskResult::Import(Err(error)) => {
                self.log(format!("import failed: {error}"));
            }
            TaskResult::Send(Ok(outcome)) => {
                self.log(format!(
                    "send attempted={} sent={} failed={}",
                    outcome.attempted, outcome.sent, outcome.failed,
                ));
            }
            TaskResult::Send(Err(error)) => {
                self.log(format!("send failed: {error}"));
            }
            TaskResult::InternalError(error) => {
                self.log(format!("background task internal error: {error}"));
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
