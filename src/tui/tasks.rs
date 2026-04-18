use std::{error::Error, fmt};

use super::*;

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
    fn description(&self) -> String {
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

#[derive(Clone, Debug, PartialEq, Eq)]
pub(super) struct RunningTaskView {
    pub(super) description: String,
    pub(super) elapsed: Duration,
}

pub(super) struct TaskRunner {
    pub(super) services: Arc<AppServices>,
    pub(super) receiver: Option<Receiver<TaskResult>>,
    pub(super) active_task_kind: Option<ActiveTaskKind>,
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

impl TaskRunner {
    pub(super) fn new(services: Arc<AppServices>) -> Self {
        Self {
            services,
            receiver: None,
            active_task_kind: None,
        }
    }

    pub(super) fn spawn(&mut self, task: BackgroundTask) -> Result<RunningTask, TaskError> {
        if self.receiver.is_some() || self.active_task_kind.is_some() {
            return Err(TaskError::TaskAlreadyRunning);
        }

        let description = task.description();
        let started_at = Instant::now();
        let (sender, receiver) = mpsc::channel();
        let services = Arc::clone(&self.services);
        let active_task_kind = ActiveTaskKind::from(&task);
        let thread_name = task.thread_name().to_string();

        let worker = thread::Builder::new().name(thread_name).spawn(move || {
            let result = match task {
                BackgroundTask::Query {
                    node_name_or_id,
                    criteria,
                } => TaskResult::Query(services.query(&node_name_or_id, &criteria)),
                BackgroundTask::Retrieve { request } => {
                    TaskResult::Retrieve(services.retrieve(request))
                }
                BackgroundTask::Import { path } => TaskResult::Import(services.import_path(&path)),
                BackgroundTask::SendStudy {
                    study_instance_uid,
                    destination_node,
                } => TaskResult::Send(services.send_study(&study_instance_uid, &destination_node)),
                BackgroundTask::SendSeries {
                    series_instance_uid,
                    destination_node,
                } => {
                    TaskResult::Send(services.send_series(&series_instance_uid, &destination_node))
                }
            };

            let _ = sender.send(result);
        });

        if let Err(error) = worker {
            return Err(TaskError::ThreadLaunchFailed(error));
        }

        self.receiver = Some(receiver);
        self.active_task_kind = Some(active_task_kind);

        Ok(RunningTask {
            description,
            started_at,
        })
    }

    pub(super) fn try_recv(&mut self) -> Option<TaskResult> {
        let poll_result = match self.receiver.as_ref() {
            Some(receiver) => receiver.try_recv(),
            None => return None,
        };

        match poll_result {
            Ok(result) => {
                self.receiver = None;
                self.active_task_kind = None;
                Some(result)
            }
            Err(TryRecvError::Empty) => None,
            Err(TryRecvError::Disconnected) => {
                self.receiver = None;
                Some(match self.active_task_kind.take() {
                    Some(task_kind) => task_kind.disconnected_result(),
                    None => TaskResult::InternalError(anyhow!(
                        "background task thread disconnected but active_task_kind was None: unexpected state"
                    )),
                })
            }
        }
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
    fn task_runner_receives_import_result_from_background_thread() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let import_path = services.paths.base_dir.join("empty-import-dir");
        fs::create_dir_all(&import_path).unwrap();

        let running_task = runner
            .spawn(BackgroundTask::Import { path: import_path })
            .expect("spawn import task");

        assert!(running_task.description.starts_with("Importing "));

        let deadline = Instant::now() + Duration::from_secs(2);
        loop {
            match runner.try_recv() {
                Some(TaskResult::Import(result)) => {
                    let report = result.unwrap();
                    assert_eq!(report.scanned_files, 0);
                    assert!(runner.try_recv().is_none());
                    break;
                }
                Some(other) => panic!("unexpected task result: {other:?}"),
                None if Instant::now() < deadline => std::thread::sleep(Duration::from_millis(10)),
                None => panic!("timed out waiting for background task result"),
            }
        }
    }
    #[test]
    fn task_runner_returns_failure_when_worker_disconnects() {
        let fixture = test_services();
        let services = Arc::new(fixture.services.clone());
        let mut runner = TaskRunner::new(Arc::clone(&services));
        let (sender, receiver) = std::sync::mpsc::channel();
        drop(sender);

        runner.receiver = Some(receiver);
        runner.active_task_kind = Some(ActiveTaskKind::Retrieve);

        match runner.try_recv() {
            Some(TaskResult::Retrieve(Err(error))) => {
                assert!(error.to_string().contains("disconnected"));
            }
            other => panic!("unexpected task result: {other:?}"),
        }

        assert!(runner.receiver.is_none());
        assert!(runner.active_task_kind.is_none());
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
            Some(TaskResult::InternalError(error)) => {
                assert!(error.to_string().contains("active_task_kind was None"));
            }
            other => panic!("unexpected task result: {other:?}"),
        }

        assert!(runner.receiver.is_none());
        assert!(runner.active_task_kind.is_none());
    }
}
