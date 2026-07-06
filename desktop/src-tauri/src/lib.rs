use std::{
    collections::{HashMap, VecDeque},
    fs,
    io::{BufRead, BufReader},
    path::{Path, PathBuf},
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, Mutex,
    },
    thread::JoinHandle,
};

use serde::{Deserialize, Serialize};
use tauri::{AppHandle, Emitter, Manager, PhysicalPosition, PhysicalSize, State};

use dicom_node_client::{
    cli::LocalExportFormat,
    config::AppPaths,
    export::{export_series, export_studies},
    models::{
        ImportReport, LocalInstance, MoveOutcome, MoveRequest, QueryCriteria, QueryMatch,
        RemoteNode, RemoteNodeDraft, RemoteNodePatch, ScpSessionReport, SendOutcome,
        SeriesSummary, StudySummary,
    },
    net::ServerMetricsSnapshot,
    services::{AppServices, TuiReceiverMode},
};
use tracing_subscriber::{fmt, prelude::*, EnvFilter};

type CmdResult<T> = Result<T, String>;
const DEFAULT_LOG_TAIL_LINES: usize = 200;
const MAX_LOG_TAIL_LINES: usize = 1000;

fn err_str(err: anyhow::Error) -> String {
    format!("{err:#}")
}

struct ServerHandle {
    cancel: Arc<AtomicBool>,
    join: JoinHandle<anyhow::Result<ScpSessionReport>>,
}

struct AppState {
    services: AppServices,
    tasks: Mutex<HashMap<String, Arc<AtomicBool>>>,
    server: Mutex<Option<ServerHandle>>,
}

impl AppState {
    fn register_task(&self, task_id: &str) -> Arc<AtomicBool> {
        let flag = Arc::new(AtomicBool::new(false));
        self.tasks
            .lock()
            .unwrap()
            .insert(task_id.to_string(), flag.clone());
        flag
    }

    fn finish_task(&self, task_id: &str) {
        self.tasks.lock().unwrap().remove(task_id);
    }
}

/// Runs `work` on a blocking thread with a registered cancel flag for `task_id`.
async fn run_task<T, F>(state: State<'_, Arc<AppState>>, task_id: String, work: F) -> CmdResult<T>
where
    T: Send + 'static,
    F: FnOnce(AppServices, Arc<AtomicBool>) -> anyhow::Result<T> + Send + 'static,
{
    let state = state.inner().clone();
    let services = state.services.clone();
    let flag = state.register_task(&task_id);
    let result = tauri::async_runtime::spawn_blocking(move || work(services, flag))
        .await
        .map_err(|e| e.to_string())?;
    state.finish_task(&task_id);
    result.map_err(err_str)
}

#[derive(Debug, Clone, Serialize)]
struct StatusDto {
    local_ae_title: String,
    listener_addr: String,
    max_pdu_length: u32,
    strict_pdu: bool,
    allow_promiscuous_storage: bool,
    preferred_store_transfer_syntax: String,
    config_path: String,
    data_dir: String,
    log_dir: String,
    active_log_file: String,
    server_running: bool,
}

#[derive(Debug, Clone, Deserialize)]
struct NodeDraftDto {
    name: String,
    ae_title: String,
    host: String,
    port: u16,
    move_destination: Option<String>,
    notes: Option<String>,
}

#[derive(Debug, Clone, Serialize)]
struct ImportProgress {
    task_id: String,
    processed: u64,
    total: Option<u64>,
}

#[derive(Debug, Clone, Copy, Deserialize, Serialize, PartialEq, Eq)]
#[serde(rename_all = "lowercase")]
enum ArchiveExportScope {
    Studies,
    Series,
}

#[derive(Debug, Clone, Copy, Deserialize, Serialize, PartialEq, Eq)]
#[serde(rename_all = "lowercase")]
enum ArchiveExportFormat {
    Json,
    Csv,
}

impl ArchiveExportFormat {
    fn as_cli(self) -> LocalExportFormat {
        match self {
            Self::Json => LocalExportFormat::Json,
            Self::Csv => LocalExportFormat::Csv,
        }
    }
}

#[derive(Debug, Clone, Serialize)]
struct ArchiveExportResult {
    path: String,
    rows: usize,
    scope: ArchiveExportScope,
    format: ArchiveExportFormat,
}

#[derive(Debug, Clone, Serialize)]
struct LogTailResult {
    path: String,
    exists: bool,
    lines: Vec<String>,
    truncated: bool,
}

fn normalized_tail_limit(max_lines: Option<usize>) -> usize {
    max_lines
        .unwrap_or(DEFAULT_LOG_TAIL_LINES)
        .clamp(1, MAX_LOG_TAIL_LINES)
}

fn tail_log_file(path: &Path, max_lines: Option<usize>) -> anyhow::Result<LogTailResult> {
    let limit = normalized_tail_limit(max_lines);
    if !path.exists() {
        return Ok(LogTailResult {
            path: path.display().to_string(),
            exists: false,
            lines: Vec::new(),
            truncated: false,
        });
    }

    let file = fs::File::open(path)
        .map_err(|e| anyhow::anyhow!("opening log file {}: {e}", path.display()))?;
    let reader = BufReader::new(file);
    let mut lines = VecDeque::with_capacity(limit);
    let mut truncated = false;
    for line in reader.lines() {
        lines.push_back(line?);
        if lines.len() > limit {
            lines.pop_front();
            truncated = true;
        }
    }

    Ok(LogTailResult {
        path: path.display().to_string(),
        exists: true,
        lines: lines.into_iter().collect(),
        truncated,
    })
}

fn export_archive_to_path(
    services: &AppServices,
    scope: ArchiveExportScope,
    format: ArchiveExportFormat,
    out_path: &Path,
    study_instance_uid: Option<&str>,
) -> anyhow::Result<ArchiveExportResult> {
    match scope {
        ArchiveExportScope::Studies => {
            let studies = services.local_studies()?;
            let rows = studies.len();
            export_studies(format.as_cli(), &studies, Some(out_path))?;
            Ok(ArchiveExportResult {
                path: out_path.display().to_string(),
                rows,
                scope,
                format,
            })
        }
        ArchiveExportScope::Series => {
            let study_uid = study_instance_uid
                .filter(|uid| !uid.trim().is_empty())
                .ok_or_else(|| anyhow::anyhow!("study_instance_uid is required for series export"))?;
            let series = services.local_series(study_uid)?;
            let rows = series.len();
            export_series(format.as_cli(), &series, Some(out_path))?;
            Ok(ArchiveExportResult {
                path: out_path.display().to_string(),
                rows,
                scope,
                format,
            })
        }
    }
}

#[tauri::command(rename_all = "snake_case")]
fn get_status(state: State<'_, Arc<AppState>>) -> CmdResult<StatusDto> {
    let snapshot = state
        .services
        .tui_status_snapshot(TuiReceiverMode::OnDemandForLocalRetrieve);
    let server_running = state
        .server
        .lock()
        .unwrap()
        .as_ref()
        .is_some_and(|h| !h.join.is_finished());
    Ok(StatusDto {
        local_ae_title: snapshot.local_ae_title,
        listener_addr: snapshot.listener_addr,
        max_pdu_length: snapshot.max_pdu_length,
        strict_pdu: snapshot.strict_pdu,
        allow_promiscuous_storage: snapshot.allow_promiscuous_storage,
        preferred_store_transfer_syntax: snapshot.preferred_store_transfer_syntax,
        config_path: snapshot.config_path,
        data_dir: snapshot.data_dir,
        log_dir: snapshot.log_dir,
        active_log_file: state.services.paths.active_log_file.display().to_string(),
        server_running,
    })
}

#[tauri::command(rename_all = "snake_case")]
fn server_metrics(state: State<'_, Arc<AppState>>) -> CmdResult<ServerMetricsSnapshot> {
    Ok(state.services.server_metrics_snapshot())
}

#[tauri::command(rename_all = "snake_case")]
fn list_nodes(state: State<'_, Arc<AppState>>) -> CmdResult<Vec<RemoteNode>> {
    state.services.list_nodes().map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
fn add_node(state: State<'_, Arc<AppState>>, draft: NodeDraftDto) -> CmdResult<RemoteNode> {
    let draft = RemoteNodeDraft {
        name: draft.name,
        ae_title: draft.ae_title,
        host: draft.host,
        port: draft.port,
        preferred_move_destination: draft.move_destination,
        notes: draft.notes,
    };
    state.services.add_node(draft).map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
fn update_node(
    state: State<'_, Arc<AppState>>,
    id: String,
    draft: NodeDraftDto,
) -> CmdResult<RemoteNode> {
    let patch = RemoteNodePatch {
        name: Some(draft.name),
        ae_title: Some(draft.ae_title),
        host: Some(draft.host),
        port: Some(draft.port),
        preferred_move_destination: Some(draft.move_destination.unwrap_or_default()),
        notes: Some(draft.notes.unwrap_or_default()),
    };
    state.services.update_node(&id, patch).map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
fn delete_node(state: State<'_, Arc<AppState>>, id: String) -> CmdResult<usize> {
    state.services.delete_node(&id).map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
async fn query(
    state: State<'_, Arc<AppState>>,
    task_id: String,
    node: String,
    criteria: QueryCriteria,
) -> CmdResult<Vec<QueryMatch>> {
    run_task(state, task_id, move |services, flag| {
        services.query_cancellable(&node, &criteria, &flag)
    })
    .await
}

#[tauri::command(rename_all = "snake_case")]
async fn retrieve(
    state: State<'_, Arc<AppState>>,
    task_id: String,
    request: MoveRequest,
) -> CmdResult<MoveOutcome> {
    run_task(state, task_id, move |services, flag| {
        services.retrieve_cancellable(request, &flag)
    })
    .await
}

#[tauri::command(rename_all = "snake_case")]
async fn import_path(
    app: AppHandle,
    state: State<'_, Arc<AppState>>,
    task_id: String,
    path: String,
) -> CmdResult<ImportReport> {
    let emit_task_id = task_id.clone();
    run_task(state, task_id, move |services, flag| {
        let mut progress = |processed: u64, total: Option<u64>| {
            let _ = app.emit(
                "import-progress",
                ImportProgress {
                    task_id: emit_task_id.clone(),
                    processed,
                    total,
                },
            );
        };
        services.import_path_cancellable_with_progress(
            &PathBuf::from(path),
            &flag,
            &mut progress,
        )
    })
    .await
}

#[tauri::command(rename_all = "snake_case")]
async fn send_study(
    state: State<'_, Arc<AppState>>,
    task_id: String,
    study_instance_uid: String,
    destination_node: String,
) -> CmdResult<SendOutcome> {
    run_task(state, task_id, move |services, flag| {
        services.send_study_cancellable(&study_instance_uid, &destination_node, &flag)
    })
    .await
}

#[tauri::command(rename_all = "snake_case")]
async fn send_series(
    state: State<'_, Arc<AppState>>,
    task_id: String,
    series_instance_uid: String,
    destination_node: String,
) -> CmdResult<SendOutcome> {
    run_task(state, task_id, move |services, flag| {
        services.send_series_cancellable(&series_instance_uid, &destination_node, &flag)
    })
    .await
}

#[tauri::command(rename_all = "snake_case")]
fn local_studies(state: State<'_, Arc<AppState>>) -> CmdResult<Vec<StudySummary>> {
    state.services.local_studies().map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
fn local_series(
    state: State<'_, Arc<AppState>>,
    study_instance_uid: String,
) -> CmdResult<Vec<SeriesSummary>> {
    state
        .services
        .local_series(&study_instance_uid)
        .map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
fn local_instances(
    state: State<'_, Arc<AppState>>,
    series_instance_uid: String,
) -> CmdResult<Vec<LocalInstance>> {
    state
        .services
        .local_instances(&series_instance_uid)
        .map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
fn tail_log(
    state: State<'_, Arc<AppState>>,
    max_lines: Option<usize>,
) -> CmdResult<LogTailResult> {
    tail_log_file(&state.services.paths.active_log_file, max_lines).map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
fn export_local_archive(
    state: State<'_, Arc<AppState>>,
    scope: ArchiveExportScope,
    format: ArchiveExportFormat,
    out_path: String,
    study_instance_uid: Option<String>,
) -> CmdResult<ArchiveExportResult> {
    let out_path = PathBuf::from(out_path.trim());
    if out_path.as_os_str().is_empty() {
        return Err("out_path is required".into());
    }
    export_archive_to_path(
        &state.services,
        scope,
        format,
        &out_path,
        study_instance_uid.as_deref(),
    )
    .map_err(err_str)
}

#[tauri::command(rename_all = "snake_case")]
fn cancel_task(state: State<'_, Arc<AppState>>, task_id: String) -> CmdResult<bool> {
    let tasks = state.tasks.lock().unwrap();
    match tasks.get(&task_id) {
        Some(flag) => {
            flag.store(true, Ordering::SeqCst);
            Ok(true)
        }
        None => Ok(false),
    }
}

#[tauri::command(rename_all = "snake_case")]
fn start_server(state: State<'_, Arc<AppState>>) -> CmdResult<()> {
    let mut server = state.server.lock().unwrap();
    if server.as_ref().is_some_and(|h| !h.join.is_finished()) {
        return Err("storage server is already running".into());
    }
    let cancel = Arc::new(AtomicBool::new(false));
    let services = state.services.clone();
    let flag = cancel.clone();
    let join = std::thread::spawn(move || services.run_server_runtime(flag));
    *server = Some(ServerHandle { cancel, join });
    Ok(())
}

#[tauri::command(rename_all = "snake_case")]
async fn stop_server(state: State<'_, Arc<AppState>>) -> CmdResult<Option<ScpSessionReport>> {
    let handle = state.server.lock().unwrap().take();
    let Some(handle) = handle else {
        return Ok(None);
    };
    handle.cancel.store(true, Ordering::SeqCst);
    let report = tauri::async_runtime::spawn_blocking(move || {
        handle
            .join
            .join()
            .map_err(|_| anyhow::anyhow!("server thread panicked"))?
    })
    .await
    .map_err(|e| e.to_string())?;
    report.map(Some).map_err(err_str)
}

fn init_tracing(logs_dir: &Path) -> anyhow::Result<tracing_appender::non_blocking::WorkerGuard> {
    fs::create_dir_all(logs_dir)
        .map_err(|e| anyhow::anyhow!("creating log directory {}: {e}", logs_dir.display()))?;
    let filter = EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info"));
    let file_appender = tracing_appender::rolling::never(logs_dir, "app.log");
    let (file_writer, guard) = tracing_appender::non_blocking(file_appender);
    let console_layer = fmt::layer().with_writer(std::io::stderr);
    let file_layer = fmt::layer().with_writer(file_writer).with_ansi(false);
    tracing_subscriber::registry()
        .with(filter)
        .with(console_layer)
        .with(file_layer)
        .try_init()
        .map_err(|err| anyhow::anyhow!("initializing tracing subscriber: {err}"))?;
    Ok(guard)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    let paths = AppPaths::discover().expect("failed to discover app paths");
    let _tracing_guard = init_tracing(&paths.logs_dir).expect("failed to initialize logging");
    let services = AppServices::load_from_paths(paths).expect("failed to initialize services");
    let state = Arc::new(AppState {
        services,
        tasks: Mutex::new(HashMap::new()),
        server: Mutex::new(None),
    });

    tauri::Builder::default()
        .plugin(tauri_plugin_dialog::init())
        .plugin(tauri_plugin_opener::init())
        .manage(state.clone())
        .setup(|app| {
            if let Some(window) = app.get_webview_window("main") {
                let monitor = match window.current_monitor() {
                    Ok(Some(monitor)) => Some(monitor),
                    Ok(None) => window.primary_monitor().ok().flatten(),
                    Err(err) => {
                        eprintln!("could not determine current monitor: {err}");
                        window.primary_monitor().ok().flatten()
                    }
                };
                if let Some(monitor) = monitor {
                    let work_area = monitor.work_area();
                    if work_area.size.width > 0 && work_area.size.height > 0 {
                        if let Err(err) = window.set_position(PhysicalPosition::new(
                            work_area.position.x,
                            work_area.position.y,
                        )) {
                            eprintln!("could not position main window: {err}");
                        }
                        if let Err(err) = window.set_size(PhysicalSize::new(
                            work_area.size.width,
                            work_area.size.height,
                        )) {
                            eprintln!("could not size main window: {err}");
                        }
                    }
                }
            }
            Ok(())
        })
        .on_window_event(move |_window, event| {
            if let tauri::WindowEvent::Destroyed = event {
                // Stop the storage server and cancel outstanding tasks on exit.
                if let Some(handle) = state.server.lock().unwrap().take() {
                    handle.cancel.store(true, Ordering::SeqCst);
                }
                for flag in state.tasks.lock().unwrap().values() {
                    flag.store(true, Ordering::SeqCst);
                }
            }
        })
        .invoke_handler(tauri::generate_handler![
            get_status,
            server_metrics,
            list_nodes,
            add_node,
            update_node,
            delete_node,
            query,
            retrieve,
            import_path,
            send_study,
            send_series,
            local_studies,
            local_series,
            local_instances,
            tail_log,
            export_local_archive,
            cancel_task,
            start_server,
            stop_server,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

#[cfg(test)]
mod tests {
    use super::{
        export_archive_to_path, normalized_tail_limit, tail_log_file, ArchiveExportFormat,
        ArchiveExportScope,
    };
    use dicom_node_client::{config::AppPaths, services::AppServices};

    fn temp_services() -> (tempfile::TempDir, AppServices) {
        let temp_dir = tempfile::tempdir().expect("create temp dir");
        let base_dir = temp_dir.path().join("app");
        let paths = AppPaths {
            base_dir: base_dir.clone(),
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("rusty-dicom-node.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
            active_log_file: base_dir.join("logs").join("app.log"),
        };
        let services = AppServices::load_from_paths(paths).expect("load services");
        (temp_dir, services)
    }

    #[test]
    fn log_tail_reports_missing_file_without_error() {
        let dir = tempfile::tempdir().expect("temp dir");
        let path = dir.path().join("missing.log");
        let result = tail_log_file(&path, Some(20)).expect("tail missing log");
        assert!(!result.exists);
        assert!(result.lines.is_empty());
        assert!(!result.truncated);
    }

    #[test]
    fn log_tail_reads_short_file() {
        let dir = tempfile::tempdir().expect("temp dir");
        let path = dir.path().join("app.log");
        std::fs::write(&path, "one\ntwo\nthree\n").expect("write log");
        let result = tail_log_file(&path, Some(10)).expect("tail log");
        assert!(result.exists);
        assert_eq!(result.lines, vec!["one", "two", "three"]);
        assert!(!result.truncated);
    }

    #[test]
    fn log_tail_truncates_to_requested_limit() {
        let dir = tempfile::tempdir().expect("temp dir");
        let path = dir.path().join("app.log");
        std::fs::write(&path, "one\ntwo\nthree\nfour\n").expect("write log");
        let result = tail_log_file(&path, Some(2)).expect("tail log");
        assert_eq!(result.lines, vec!["three", "four"]);
        assert!(result.truncated);
    }

    #[test]
    fn log_tail_caps_max_lines() {
        assert_eq!(normalized_tail_limit(Some(usize::MAX)), 1000);
        assert_eq!(normalized_tail_limit(Some(0)), 1);
    }

    #[test]
    fn export_studies_json_writes_file_and_reports_rows() {
        let (_temp, services) = temp_services();
        let out = tempfile::NamedTempFile::new().expect("temp file");
        let result = export_archive_to_path(
            &services,
            ArchiveExportScope::Studies,
            ArchiveExportFormat::Json,
            out.path(),
            None,
        )
        .expect("export studies");

        let raw = std::fs::read_to_string(out.path()).expect("read export");
        let rows: serde_json::Value = serde_json::from_str(&raw).expect("valid json export");
        assert_eq!(rows.as_array().expect("array export").len(), result.rows);
    }

    #[test]
    fn export_series_csv_requires_study_uid() {
        let (_temp, services) = temp_services();
        let out = tempfile::NamedTempFile::new().expect("temp file");
        let err = export_archive_to_path(
            &services,
            ArchiveExportScope::Series,
            ArchiveExportFormat::Csv,
            out.path(),
            None,
        )
        .expect_err("series export requires a study");

        assert!(err.to_string().contains("study_instance_uid is required"));
    }
}
