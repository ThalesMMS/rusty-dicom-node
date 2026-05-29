use std::{
    error::Error,
    fmt,
    sync::{
        atomic::{AtomicBool, Ordering},
        mpsc::Sender,
        Arc,
    },
};

#[derive(Clone, Debug)]
pub(crate) struct CancelHandle {
    flag: Arc<AtomicBool>,
}

impl CancelHandle {
    pub(crate) fn new(flag: Arc<AtomicBool>) -> Self {
        Self { flag }
    }

    pub(crate) fn cancel(&self) {
        self.flag.store(true, Ordering::Release);
    }

    pub(crate) fn is_cancelled(&self) -> bool {
        self.flag.load(Ordering::Acquire)
    }

    pub(crate) fn flag(&self) -> Arc<AtomicBool> {
        Arc::clone(&self.flag)
    }
}

use super::*;
use crate::cancel;

pub(super) type TaskId = u64;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(super) enum TaskStatus {
    Queued,
    Running,
    /// Cancellation was requested; task is still winding down.
    Cancelling,
    Succeeded,
    Failed,
    Cancelled,
}

impl fmt::Display for TaskStatus {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            TaskStatus::Queued => f.write_str("Queued"),
            TaskStatus::Running => f.write_str("Running"),
            TaskStatus::Cancelling => f.write_str("Cancelling"),
            TaskStatus::Succeeded => f.write_str("Succeeded"),
            TaskStatus::Failed => f.write_str("Failed"),
            TaskStatus::Cancelled => f.write_str("Cancelled"),
        }
    }
}

#[derive(Clone, Debug, PartialEq, Eq, Default)]
pub(super) struct TaskProgress {
    pub(super) current: u64,
    pub(super) total: Option<u64>,
}

#[derive(Clone, Debug)]
pub(super) struct TaskInfo {
    pub(super) id: TaskId,
    pub(super) description: String,
    pub(super) status: TaskStatus,
    #[allow(
        dead_code,
        reason = "task history keeps creation time for upcoming task pane rendering"
    )]
    pub(super) created_at: Instant,
    pub(super) started_at: Option<Instant>,
    pub(super) finished_at: Option<Instant>,
    pub(super) progress: Option<TaskProgress>,
    pub(super) outcome: Option<TaskOutcome>,
    pub(super) summary: Option<dicom_node_client::summary::OperationSummary>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(super) enum TaskOutcome {
    Succeeded,
    Failed,
    Cancelled,
}

#[derive(Clone, Debug)]
pub(super) enum BackgroundTask {
    Query {
        node_name_or_id: String,
        criteria: QueryCriteria,
    },
    Retrieve {
        request: MoveRequest,
    },
    Import {
        path: PathBuf,
    },
    SendStudy {
        study_instance_uid: String,
        destination_node: String,
    },
    SendSeries {
        series_instance_uid: String,
        destination_node: String,
    },
}

impl BackgroundTask {
    pub(super) fn description(&self) -> String {
        match self {
            Self::Query {
                node_name_or_id, ..
            } => format!("Querying {node_name_or_id}..."),
            Self::Retrieve { request } => {
                format!("Retrieving from {}...", request.node_name_or_id)
            }
            Self::Import { path } => format!("Importing {}...", path.display()),
            Self::SendStudy {
                study_instance_uid,
                destination_node,
            } => format!("Sending study {study_instance_uid} to {destination_node}..."),
            Self::SendSeries {
                series_instance_uid,
                destination_node,
            } => format!("Sending series {series_instance_uid} to {destination_node}..."),
        }
    }

    fn thread_name(&self) -> &'static str {
        match self {
            Self::Query { .. } => "background-task-query",
            Self::Retrieve { .. } => "background-task-retrieve",
            Self::Import { .. } => "background-task-import",
            Self::SendStudy { .. } => "background-task-send-study",
            Self::SendSeries { .. } => "background-task-send-series",
        }
    }
}

#[derive(Debug)]
pub(super) enum TaskResult {
    Query(anyhow::Result<Vec<QueryMatch>>),
    Retrieve(anyhow::Result<MoveOutcome>),
    Import(anyhow::Result<ImportReport>),
    Send(anyhow::Result<SendOutcome>),
    InternalError(anyhow::Error),
}

#[derive(Debug)]
pub(super) enum TaskEvent {
    Queued {
        id: TaskId,
        description: String,
        at: Instant,
    },
    Started {
        id: TaskId,
        at: Instant,
    },
    Log {
        id: TaskId,
        #[allow(
            dead_code,
            reason = "log timestamps are kept for task diagnostics even when current UI hides them"
        )]
        at: Instant,
        line: String,
    },
    Progress {
        id: TaskId,
        #[allow(
            dead_code,
            reason = "progress timestamps are kept for task diagnostics even when current UI hides them"
        )]
        at: Instant,
        progress: TaskProgress,
    },
    Finished {
        id: TaskId,
        at: Instant,
        result: TaskResult,
    },
    Cancelled {
        id: TaskId,
        at: Instant,
        reason: Option<String>,
    },
}

#[derive(Clone, Debug)]
pub(super) struct TaskReporter {
    id: TaskId,
    tx: Sender<TaskEvent>,
}

impl TaskReporter {
    pub(super) fn log(&self, line: impl Into<String>) {
        let _ = self.tx.send(TaskEvent::Log {
            id: self.id,
            at: Instant::now(),
            line: line.into(),
        });
    }

    pub(super) fn progress(&self, current: u64, total: Option<u64>) {
        let _ = self.tx.send(TaskEvent::Progress {
            id: self.id,
            at: Instant::now(),
            progress: TaskProgress { current, total },
        });
    }

    pub(super) fn started(&self) {
        let _ = self.tx.send(TaskEvent::Started {
            id: self.id,
            at: Instant::now(),
        });
    }

    #[allow(
        dead_code,
        reason = "background workers may report explicit completion through this reporter API"
    )]
    pub(super) fn finished(&self, result: TaskResult) {
        let _ = self.tx.send(TaskEvent::Finished {
            id: self.id,
            at: Instant::now(),
            result,
        });
    }

    pub(super) fn cancelled(&self, reason: Option<String>) {
        let _ = self.tx.send(TaskEvent::Cancelled {
            id: self.id,
            at: Instant::now(),
            reason,
        });
    }
}

#[derive(Debug)]
pub(super) enum TaskError {
    TaskAlreadyRunning,
    ThreadLaunchFailed(std::io::Error),
}

impl fmt::Display for TaskError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::TaskAlreadyRunning => f.write_str("background task already running"),
            Self::ThreadLaunchFailed(error) => {
                write!(f, "failed to launch background task thread: {error}")
            }
        }
    }
}

impl Error for TaskError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        match self {
            Self::TaskAlreadyRunning => None,
            Self::ThreadLaunchFailed(error) => Some(error),
        }
    }
}

#[derive(Clone, Debug)]
pub(super) struct RunningTask {
    pub(super) description: String,
    pub(super) started_at: Instant,
}

#[derive(Clone, Debug)]
pub(super) struct QueuedTask {
    pub(super) id: TaskId,
    pub(super) description: String,
    pub(super) enqueued_at: Instant,
    pub(super) task: BackgroundTask,
    pub(super) cleanup_on_cancel: Option<fn(&AppServices, &BackgroundTask)>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub(super) struct RunningTaskView {
    pub(super) description: String,
    pub(super) elapsed: Duration,
}

pub(super) struct TaskRunner {
    pub(super) services: Arc<AppServices>,
    pub(super) receiver: Option<Receiver<TaskResult>>,
    pub(super) active_task_kind: Option<ActiveTaskKind>,

    pub(super) events_rx: Option<Receiver<TaskEvent>>,
    pub(super) active_task_id: Option<TaskId>,
    pub(super) active_cancel_handle: Option<CancelHandle>,
    pub(super) next_task_id: TaskId,
    pub(super) queue: VecDeque<QueuedTask>,
}

#[derive(Clone, Copy, Debug)]
pub(super) enum ActiveTaskKind {
    Query,
    Retrieve,
    Import,
    Send,
}

impl ActiveTaskKind {
    fn disconnected_result(self) -> TaskResult {
        let error = anyhow!("background task thread disconnected before sending a result");
        match self {
            Self::Query => TaskResult::Query(Err(error)),
            Self::Retrieve => TaskResult::Retrieve(Err(error)),
            Self::Import => TaskResult::Import(Err(error)),
            Self::Send => TaskResult::Send(Err(error)),
        }
    }
}

impl TaskResult {
    fn is_cancelled(&self) -> bool {
        match self {
            Self::Query(Err(error))
            | Self::Retrieve(Err(error))
            | Self::Import(Err(error))
            | Self::Send(Err(error))
            | Self::InternalError(error) => cancel::is_cancelled_error(error),
            Self::Query(Ok(_))
            | Self::Retrieve(Ok(_))
            | Self::Import(Ok(_))
            | Self::Send(Ok(_)) => false,
        }
    }
}

impl From<&BackgroundTask> for ActiveTaskKind {
    fn from(task: &BackgroundTask) -> Self {
        match task {
            BackgroundTask::Query { .. } => Self::Query,
            BackgroundTask::Retrieve { .. } => Self::Retrieve,
            BackgroundTask::Import { .. } => Self::Import,
            BackgroundTask::SendStudy { .. } | BackgroundTask::SendSeries { .. } => Self::Send,
        }
    }
}

impl QueuedTask {
    fn with_cleanup(mut self, cleanup: fn(&AppServices, &BackgroundTask)) -> Self {
        self.cleanup_on_cancel = Some(cleanup);
        self
    }
}

impl TaskRunner {
    pub(super) fn new(services: Arc<AppServices>) -> Self {
        Self {
            services,
            receiver: None,
            active_task_kind: None,
            events_rx: None,
            active_task_id: None,
            active_cancel_handle: None,
            next_task_id: 1,
            queue: VecDeque::new(),
        }
    }

    fn cleanup_task(services: &AppServices, task: &BackgroundTask) {
        match task {
            BackgroundTask::Import { .. } => {
                let staging_dir = &services.paths.managed_store_dir;
                if let Ok(entries) = std::fs::read_dir(staging_dir) {
                    for entry in entries.flatten() {
                        let path = entry.path();
                        if path.is_file()
                            && path
                                .file_name()
                                .and_then(|name| name.to_str())
                                .is_some_and(|name| name.ends_with(".tmp"))
                        {
                            if let Err(error) = std::fs::remove_file(&path) {
                                tracing::warn!(
                                    %error,
                                    tmp_path=%path.display(),
                                    "failed to cleanup import staged tmp file after cancel"
                                );
                            }
                        }
                    }
                }
            }
            BackgroundTask::Retrieve { .. } => {
                let incoming_dir = services.paths.managed_store_dir.join(".incoming");
                if let Ok(entries) = std::fs::read_dir(&incoming_dir) {
                    for entry in entries.flatten() {
                        let path = entry.path();
                        if path.is_file()
                            && path
                                .file_name()
                                .and_then(|name| name.to_str())
                                .is_some_and(|name| {
                                    name.starts_with("incoming-") && name.ends_with(".dcm")
                                })
                        {
                            if let Err(error) = std::fs::remove_file(&path) {
                                tracing::warn!(
                                    %error,
                                    incoming_path=%path.display(),
                                    "failed to cleanup retrieve incoming tmp file after cancel"
                                );
                            }
                        }
                    }
                }
            }
            BackgroundTask::Query { .. }
            | BackgroundTask::SendStudy { .. }
            | BackgroundTask::SendSeries { .. } => {}
        }
    }

    fn queued_task(&mut self, task: BackgroundTask) -> QueuedTask {
        if self.next_task_id == 0 {
            self.next_task_id = 1;
        }
        let id = self.next_task_id;
        self.next_task_id = self.next_task_id.wrapping_add(1);
        if self.next_task_id == 0 {
            self.next_task_id = 1;
        }
        QueuedTask {
            id,
            description: task.description(),
            enqueued_at: Instant::now(),
            cleanup_on_cancel: None,
            task,
        }
    }

    #[cfg(test)]
    pub(super) fn spawn(&mut self, task: BackgroundTask) -> Result<RunningTask, TaskError> {
        let queued_task = self.queued_task(task);
        self.spawn_queued(queued_task)
    }

    fn spawn_queued(&mut self, queued_task: QueuedTask) -> Result<RunningTask, TaskError> {
        if self.receiver.is_some() || self.active_task_kind.is_some() {
            return Err(TaskError::TaskAlreadyRunning);
        }

        let id = queued_task.id;
        let description = queued_task.description;
        let task = queued_task.task;
        let cleanup_on_cancel = queued_task.cleanup_on_cancel;
        let started_at = Instant::now();
        let (result_tx, result_rx) = mpsc::channel();
        let (events_tx, events_rx) = mpsc::channel();
        let reporter = TaskReporter {
            id,
            tx: events_tx.clone(),
        };
        let services = Arc::clone(&self.services);
        let active_task_kind = ActiveTaskKind::from(&task);
        let thread_name = task.thread_name().to_string();

        let cancel_flag = Arc::new(AtomicBool::new(false));
        let cancel_handle = CancelHandle::new(Arc::clone(&cancel_flag));
        self.active_task_id = Some(id);
        self.active_cancel_handle = Some(cancel_handle);
        self.events_rx = Some(events_rx);

        let worker = thread::Builder::new().name(thread_name).spawn(move || {
            if cancel_flag.load(Ordering::Acquire) {
                reporter.cancelled(Some("cancelled before start".to_string()));
                return;
            }

            reporter.started();

            match &task {
                BackgroundTask::Query {
                    node_name_or_id, ..
                } => reporter.log(format!("Starting query against {node_name_or_id}")),
                BackgroundTask::Retrieve { request } => reporter.log(format!(
                    "Starting retrieve from {}",
                    request.node_name_or_id
                )),
                BackgroundTask::Import { path } => {
                    reporter.log(format!("Starting import of {}", path.display()))
                }
                BackgroundTask::SendStudy {
                    study_instance_uid,
                    destination_node,
                } => reporter.log(format!(
                    "Starting send study {study_instance_uid} to {destination_node}"
                )),
                BackgroundTask::SendSeries {
                    series_instance_uid,
                    destination_node,
                } => reporter.log(format!(
                    "Starting send series {series_instance_uid} to {destination_node}"
                )),
            }

            let result = match &task {
                BackgroundTask::Query {
                    node_name_or_id,
                    criteria,
                } => TaskResult::Query(services.query_cancellable(
                    node_name_or_id,
                    criteria,
                    &cancel_flag,
                )),
                BackgroundTask::Retrieve { request } => TaskResult::Retrieve(
                    services.retrieve_cancellable(request.clone(), &cancel_flag),
                ),
                BackgroundTask::Import { path } => {
                    let mut progress = |current: u64, total: Option<u64>| {
                        if cancel_flag.load(Ordering::Acquire) {
                            return;
                        }
                        reporter.progress(current, total);
                    };
                    TaskResult::Import(services.import_path_cancellable_with_progress(
                        path,
                        &cancel_flag,
                        &mut progress,
                    ))
                }
                BackgroundTask::SendStudy {
                    study_instance_uid,
                    destination_node,
                } => TaskResult::Send(services.send_study_cancellable(
                    study_instance_uid,
                    destination_node,
                    &cancel_flag,
                )),
                BackgroundTask::SendSeries {
                    series_instance_uid,
                    destination_node,
                } => TaskResult::Send(services.send_series_cancellable(
                    series_instance_uid,
                    destination_node,
                    &cancel_flag,
                )),
            };

            if result.is_cancelled() {
                if let Some(cleanup) = cleanup_on_cancel {
                    cleanup(&services, &task);
                }
                reporter.cancelled(Some("cancelled".to_string()));
                return;
            }

            let outcome_summary = match &result {
                TaskResult::Query(Ok(matches)) => {
                    reporter.progress(1, Some(1));
                    format!("Query completed: {} matches", matches.len())
                }
                TaskResult::Query(Err(error)) => format!("Query failed: {error}"),
                TaskResult::Retrieve(Ok(outcome)) => {
                    reporter.progress(1, Some(1));
                    format!("Retrieve completed: {:?}", outcome)
                }
                TaskResult::Retrieve(Err(error)) => format!("Retrieve failed: {error}"),
                TaskResult::Import(Ok(report)) => {
                    reporter.progress(1, Some(1));
                    format!("Import completed: {:?}", report)
                }
                TaskResult::Import(Err(error)) => format!("Import failed: {error}"),
                TaskResult::Send(Ok(outcome)) => {
                    reporter.progress(1, Some(1));
                    format!("Send completed: {:?}", outcome)
                }
                TaskResult::Send(Err(error)) => format!("Send failed: {error}"),
                TaskResult::InternalError(error) => format!("Task failed: {error}"),
            };
            reporter.log(outcome_summary);

            let _ = result_tx.send(result);
            // NOTE: We intentionally do not send a Finished event here; the UI drives finalization
            // via TaskRunner::try_recv() to avoid requiring TaskResult to be Clone.
        });

        if let Err(error) = worker {
            self.events_rx = None;
            self.active_task_id = None;
            self.active_cancel_handle = None;
            return Err(TaskError::ThreadLaunchFailed(error));
        }

        self.receiver = Some(result_rx);
        self.active_task_kind = Some(active_task_kind);

        Ok(RunningTask {
            description,
            started_at,
        })
    }

    pub(super) fn try_recv(&mut self) -> Option<TaskEvent> {
        let poll_result = match self.receiver.as_ref() {
            Some(receiver) => receiver.try_recv(),
            None => return None,
        };

        match poll_result {
            Ok(result) => Some(self.finish_active_task(result, Instant::now())),
            Err(TryRecvError::Empty) => None,
            Err(TryRecvError::Disconnected) => {
                Some(self.disconnected_terminal_event(Instant::now()))
            }
        }
    }

    pub(super) fn try_recv_event(&mut self) -> Option<TaskEvent> {
        match self.events_rx.as_ref() {
            Some(rx) => match rx.try_recv() {
                Ok(TaskEvent::Cancelled { id, reason, .. }) => {
                    Some(self.finish_cancelled_task(id, Instant::now(), reason))
                }
                Ok(event) => Some(event),
                Err(TryRecvError::Empty) => None,
                Err(TryRecvError::Disconnected) => {
                    let drained_result = match self.receiver.as_ref() {
                        Some(receiver) => match receiver.try_recv() {
                            Ok(result) => Some(result),
                            Err(TryRecvError::Empty) | Err(TryRecvError::Disconnected) => None,
                        },
                        None => None,
                    };

                    if let Some(result) = drained_result {
                        Some(self.finish_active_task(result, Instant::now()))
                    } else {
                        Some(self.disconnected_terminal_event(Instant::now()))
                    }
                }
            },
            None => None,
        }
    }

    pub(super) fn try_recv_real_result(&mut self) -> Option<TaskEvent> {
        let result = self.receiver.as_ref()?.try_recv().ok()?;
        Some(self.finish_active_task(result, Instant::now()))
    }

    fn finish_active_task(&mut self, result: TaskResult, at: Instant) -> TaskEvent {
        let id = self.active_task_id.unwrap_or(0);
        self.clear_active_state();
        TaskEvent::Finished { id, at, result }
    }

    fn disconnected_finished_event(&mut self, at: Instant) -> TaskEvent {
        let result = match self.active_task_kind.take() {
            Some(task_kind) => task_kind.disconnected_result(),
            None => TaskResult::InternalError(anyhow!(
                "background task thread disconnected but active_task_kind was None: unexpected state"
            )),
        };
        self.finish_active_task(result, at)
    }

    fn disconnected_terminal_event(&mut self, at: Instant) -> TaskEvent {
        if self.active_cancelled() {
            self.finish_cancelled_task(0, at, Some("cancelled".to_string()))
        } else {
            self.disconnected_finished_event(at)
        }
    }

    fn active_cancelled(&self) -> bool {
        self.active_cancel_handle
            .as_ref()
            .map(CancelHandle::is_cancelled)
            .unwrap_or(false)
    }

    fn finish_cancelled_task(
        &mut self,
        event_id: TaskId,
        at: Instant,
        reason: Option<String>,
    ) -> TaskEvent {
        let id = self.active_task_id.unwrap_or(event_id);
        self.clear_active_state();
        TaskEvent::Cancelled { id, at, reason }
    }

    pub(super) fn clear_active_state(&mut self) {
        self.receiver = None;
        self.events_rx = None;
        self.active_task_kind = None;
        self.active_task_id = None;
        self.active_cancel_handle = None;
    }

    pub(super) fn enqueue(&mut self, task: BackgroundTask) -> TaskEvent {
        let queued_task = self
            .queued_task(task)
            .with_cleanup(TaskRunner::cleanup_task);
        let event = TaskEvent::Queued {
            id: queued_task.id,
            description: queued_task.description.clone(),
            at: queued_task.enqueued_at,
        };
        self.queue.push_back(queued_task);
        event
    }

    pub(super) fn has_pending_tasks(&self) -> bool {
        !self.queue.is_empty()
    }

    pub(super) fn cancel_active(&mut self) -> Option<TaskId> {
        let id = self.active_task_id?;

        self.active_cancel_handle.as_ref()?.cancel();
        Some(id)
    }

    pub(super) fn active_cancel_handle(&self) -> Option<CancelHandle> {
        self.active_cancel_handle.clone()
    }

    #[cfg(test)]
    pub(super) fn test_set_active_cancel_handle(&mut self, handle: CancelHandle) {
        self.active_cancel_handle = Some(handle);
    }

    pub(super) fn try_start_next(&mut self) -> Result<Option<RunningTask>, TaskError> {
        if self.receiver.is_some() || self.active_task_kind.is_some() {
            return Ok(None);
        }

        let Some(task) = self.queue.front().cloned() else {
            return Ok(None);
        };

        let running = self.spawn_queued(task)?;
        self.queue.pop_front();
        Ok(Some(running))
    }
}

pub(super) fn running_task_status_line(task: &RunningTaskView) -> String {
    let spinner = match (task.elapsed.as_millis() / 125) % 4 {
        0 => '|',
        1 => '/',
        2 => '-',
        _ => '\\',
    };
    format!(
        "{spinner} {} ({}s)",
        task.description,
        task.elapsed.as_secs()
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::tui::test_support::test_services;
    use std::fs;

    #[test]
    fn task_runner_emits_task_lifecycle_events() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let import_path = services.paths.base_dir.join("empty-import-dir");
        fs::create_dir_all(&import_path).unwrap();

        runner
            .spawn(BackgroundTask::Import {
                path: import_path.clone(),
            })
            .expect("spawn import task");

        let mut saw_started = false;
        let mut saw_log = false;
        let mut saw_progress = false;

        let deadline = Instant::now() + Duration::from_secs(5);
        while Instant::now() < deadline {
            while let Some(event) = runner.try_recv_event() {
                match event {
                    TaskEvent::Started { .. } => saw_started = true,
                    TaskEvent::Log { .. } => saw_log = true,
                    TaskEvent::Progress { .. } => saw_progress = true,
                    TaskEvent::Queued { .. }
                    | TaskEvent::Finished { .. }
                    | TaskEvent::Cancelled { .. } => {}
                }
            }

            if saw_started && saw_log && saw_progress {
                break;
            }

            std::thread::sleep(Duration::from_millis(10));
        }

        assert!(saw_started);
        assert!(saw_log);
        assert!(saw_progress);
    }

    #[test]
    fn task_runner_produces_import_result() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let import_path = services.paths.base_dir.join("empty-import-dir-result");
        fs::create_dir_all(&import_path).unwrap();

        runner
            .spawn(BackgroundTask::Import { path: import_path })
            .expect("spawn import task");

        let deadline = Instant::now() + Duration::from_secs(5);
        loop {
            match runner.try_recv() {
                Some(TaskEvent::Finished {
                    result: TaskResult::Import(result),
                    ..
                }) => {
                    let report = result.unwrap();
                    assert_eq!(report.scanned_files, 0);
                    break;
                }
                Some(other) => panic!("unexpected task result: {other:?}"),
                None if Instant::now() < deadline => std::thread::sleep(Duration::from_millis(10)),
                None => panic!("timed out waiting for background task result"),
            }
        }
    }
    #[test]
    fn task_runner_emits_finished_event_when_worker_disconnects() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let (sender, receiver) = std::sync::mpsc::channel();
        drop(sender);

        runner.receiver = Some(receiver);
        runner.active_task_kind = Some(ActiveTaskKind::Retrieve);

        match runner.try_recv() {
            Some(TaskEvent::Finished {
                result: TaskResult::Retrieve(Err(error)),
                ..
            }) => {
                assert!(error.to_string().contains("disconnected"));
            }
            other => panic!("unexpected task result: {other:?}"),
        }

        assert!(runner.receiver.is_none());
        assert!(runner.active_task_kind.is_none());
    }

    #[test]
    fn task_runner_emits_cancelled_event_when_cancelled_worker_disconnects() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let (sender, receiver) = std::sync::mpsc::channel();
        drop(sender);

        runner.receiver = Some(receiver);
        runner.active_task_id = Some(42);
        runner.active_task_kind = Some(ActiveTaskKind::Retrieve);
        runner.active_cancel_handle = Some(CancelHandle::new(Arc::new(AtomicBool::new(true))));

        match runner.try_recv() {
            Some(TaskEvent::Cancelled { id, reason, .. }) => {
                assert_eq!(id, 42);
                assert_eq!(reason.as_deref(), Some("cancelled"));
            }
            other => panic!("unexpected task result: {other:?}"),
        }

        assert!(runner.receiver.is_none());
        assert!(runner.active_task_kind.is_none());
        assert!(runner.active_cancel_handle.is_none());
    }

    #[test]
    fn task_runner_emits_finished_event_when_events_channel_disconnects() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let (sender, receiver) = std::sync::mpsc::channel();
        drop(sender);

        runner.events_rx = Some(receiver);
        runner.active_task_id = Some(42);
        runner.active_task_kind = Some(ActiveTaskKind::Query);

        match runner.try_recv_event() {
            Some(TaskEvent::Finished { id, result, .. }) => {
                assert_eq!(id, 42);
                match result {
                    TaskResult::Query(Err(error)) => {
                        assert!(error.to_string().contains("disconnected"));
                    }
                    other => panic!("unexpected task result: {other:?}"),
                }
            }
            other => panic!("unexpected task event: {other:?}"),
        }

        assert!(runner.events_rx.is_none());
        assert!(runner.receiver.is_none());
        assert!(runner.active_task_id.is_none());
        assert!(runner.active_task_kind.is_none());
    }

    #[test]
    fn task_runner_emits_cancelled_event_when_cancelled_events_channel_disconnects() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let (sender, receiver) = std::sync::mpsc::channel();
        drop(sender);

        runner.events_rx = Some(receiver);
        runner.active_task_id = Some(42);
        runner.active_task_kind = Some(ActiveTaskKind::Query);
        runner.active_cancel_handle = Some(CancelHandle::new(Arc::new(AtomicBool::new(true))));

        match runner.try_recv_event() {
            Some(TaskEvent::Cancelled { id, reason, .. }) => {
                assert_eq!(id, 42);
                assert_eq!(reason.as_deref(), Some("cancelled"));
            }
            other => panic!("unexpected task event: {other:?}"),
        }

        assert!(runner.events_rx.is_none());
        assert!(runner.receiver.is_none());
        assert!(runner.active_task_id.is_none());
        assert!(runner.active_task_kind.is_none());
        assert!(runner.active_cancel_handle.is_none());
    }

    #[test]
    fn task_runner_treats_cancelled_event_as_terminal() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let (sender, receiver) = std::sync::mpsc::channel();
        sender
            .send(TaskEvent::Cancelled {
                id: 42,
                at: Instant::now(),
                reason: Some("cancelled".to_string()),
            })
            .expect("send cancelled event");

        runner.events_rx = Some(receiver);
        runner.active_task_id = Some(42);
        runner.active_task_kind = Some(ActiveTaskKind::Import);
        runner.active_cancel_handle = Some(CancelHandle::new(Arc::new(AtomicBool::new(true))));

        match runner.try_recv_event() {
            Some(TaskEvent::Cancelled { id, reason, .. }) => {
                assert_eq!(id, 42);
                assert_eq!(reason.as_deref(), Some("cancelled"));
            }
            other => panic!("unexpected task event: {other:?}"),
        }

        assert!(runner.events_rx.is_none());
        assert!(runner.receiver.is_none());
        assert!(runner.active_task_id.is_none());
        assert!(runner.active_task_kind.is_none());
        assert!(runner.active_cancel_handle.is_none());
    }

    #[test]
    fn cancel_active_sets_cancel_flag_when_active_task_exists() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));

        runner.active_task_id = Some(123);
        let flag = Arc::new(AtomicBool::new(false));
        runner.test_set_active_cancel_handle(CancelHandle::new(Arc::clone(&flag)));

        let id = runner.cancel_active();

        assert_eq!(id, Some(123));
        assert!(flag.load(Ordering::Acquire));
    }

    #[test]
    fn cancel_active_is_noop_when_no_active_task_exists() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));

        let flag = Arc::new(AtomicBool::new(false));
        runner.test_set_active_cancel_handle(CancelHandle::new(Arc::clone(&flag)));

        let id = runner.cancel_active();

        assert_eq!(id, None);
        assert!(!flag.load(Ordering::Acquire));
    }

    #[test]
    fn task_runner_preserves_finished_result_when_events_channel_disconnects() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let (event_sender, events_receiver) = std::sync::mpsc::channel();
        let (result_sender, result_receiver) = std::sync::mpsc::channel();
        drop(event_sender);
        result_sender
            .send(TaskResult::Query(Ok(Vec::new())))
            .expect("send task result");

        runner.events_rx = Some(events_receiver);
        runner.receiver = Some(result_receiver);
        runner.active_task_id = Some(42);
        runner.active_task_kind = Some(ActiveTaskKind::Query);

        match runner.try_recv_event() {
            Some(TaskEvent::Finished {
                id,
                result: TaskResult::Query(Ok(matches)),
                ..
            }) => {
                assert_eq!(id, 42);
                assert!(matches.is_empty());
            }
            other => panic!("unexpected task event: {other:?}"),
        }

        assert!(runner.events_rx.is_none());
        assert!(runner.receiver.is_none());
        assert!(runner.active_task_id.is_none());
        assert!(runner.active_task_kind.is_none());
    }

    #[test]
    fn task_runner_queue_runs_tasks_in_order() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));

        let import_path_a = services.paths.base_dir.join("empty-import-dir-a");
        fs::create_dir_all(&import_path_a).unwrap();
        let import_path_b = services.paths.base_dir.join("empty-import-dir-b");
        fs::create_dir_all(&import_path_b).unwrap();

        runner.enqueue(BackgroundTask::Import {
            path: import_path_a.clone(),
        });
        runner.enqueue(BackgroundTask::Import {
            path: import_path_b.clone(),
        });

        let first = runner
            .try_start_next()
            .expect("start first queued task")
            .expect("expected first task to start");
        assert!(first.description.contains("empty-import-dir-a"));

        // A second task should not start while the first one is running.
        assert!(runner
            .try_start_next()
            .expect("try start while running")
            .is_none());

        let mut results = Vec::new();
        let deadline = Instant::now() + Duration::from_secs(3);
        while results.len() < 2 {
            if let Some(result) = runner.try_recv() {
                results.push(result);
                // after completion, start next queued task (mirrors TuiApp main loop behavior)
                let _ = runner.try_start_next().unwrap();
                continue;
            }

            if Instant::now() >= deadline {
                panic!("timed out waiting for queued tasks to complete");
            }
            std::thread::sleep(Duration::from_millis(10));
        }

        assert!(matches!(
            results[0],
            TaskEvent::Finished {
                result: TaskResult::Import(_),
                ..
            }
        ));
        assert!(matches!(
            results[1],
            TaskEvent::Finished {
                result: TaskResult::Import(_),
                ..
            }
        ));
        assert!(runner.queue.is_empty());
    }

    #[test]
    fn task_runner_next_task_id_wraps_without_allocating_zero() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        runner.next_task_id = u64::MAX;

        let first = runner.enqueue(BackgroundTask::Import {
            path: services.paths.base_dir.join("overflow-a"),
        });
        let second = runner.enqueue(BackgroundTask::Import {
            path: services.paths.base_dir.join("overflow-b"),
        });

        match first {
            TaskEvent::Queued { id, .. } => assert_eq!(id, u64::MAX),
            other => panic!("unexpected task event: {other:?}"),
        }
        match second {
            TaskEvent::Queued { id, .. } => assert_eq!(id, 1),
            other => panic!("unexpected task event: {other:?}"),
        }
        assert_eq!(runner.next_task_id, 2);
        assert_eq!(runner.queue[0].id, u64::MAX);
        assert_eq!(runner.queue[1].id, 1);

        let mut runner = TaskRunner::new(Arc::clone(&services));
        runner.next_task_id = 0;
        let event = runner.enqueue(BackgroundTask::Import {
            path: services.paths.base_dir.join("reserved-zero"),
        });
        match event {
            TaskEvent::Queued { id, .. } => assert_eq!(id, 1),
            other => panic!("unexpected task event: {other:?}"),
        }
        assert_eq!(runner.next_task_id, 2);
        assert_eq!(runner.queue[0].id, 1);
    }

    #[test]
    fn task_runner_rejects_spawn_while_task_is_running() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let import_path = services.paths.base_dir.join("empty-import-dir");
        fs::create_dir_all(&import_path).unwrap();

        let _running_task = runner
            .spawn(BackgroundTask::Import {
                path: import_path.clone(),
            })
            .expect("spawn first import task");

        match runner.spawn(BackgroundTask::Import { path: import_path }) {
            Err(TaskError::TaskAlreadyRunning) => {}
            other => panic!("unexpected spawn result: {other:?}"),
        }

        let deadline = Instant::now() + Duration::from_secs(2);
        while runner.try_recv().is_none() {
            if Instant::now() >= deadline {
                panic!("timed out waiting for background task result");
            }
            std::thread::sleep(Duration::from_millis(10));
        }
    }

    #[test]
    fn task_runner_reports_unexpected_missing_task_kind() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let (sender, receiver) = std::sync::mpsc::channel();
        drop(sender);

        runner.receiver = Some(receiver);
        runner.active_task_kind = None;

        match runner.try_recv() {
            Some(TaskEvent::Finished {
                result: TaskResult::InternalError(error),
                ..
            }) => {
                assert!(error.to_string().contains("active_task_kind was None"));
            }
            other => panic!("unexpected task result: {other:?}"),
        }

        assert!(runner.receiver.is_none());
        assert!(runner.active_task_kind.is_none());
    }
}
