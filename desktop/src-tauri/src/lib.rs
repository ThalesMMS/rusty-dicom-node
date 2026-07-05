use std::{
    collections::HashMap,
    path::PathBuf,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc, Mutex,
    },
    thread::JoinHandle,
};

use serde::{Deserialize, Serialize};
use tauri::{AppHandle, Emitter, State};

use dicom_node_client::{
    config::AppPaths,
    models::{
        ImportReport, LocalInstance, MoveOutcome, MoveRequest, QueryCriteria, QueryMatch,
        RemoteNode, RemoteNodeDraft, RemoteNodePatch, ScpSessionReport, SendOutcome,
        SeriesSummary, StudySummary,
    },
    net::ServerMetricsSnapshot,
    services::{AppServices, TuiReceiverMode},
};

type CmdResult<T> = Result<T, String>;

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

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tracing_subscriber::fmt()
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "info".into()),
        )
        .init();

    let paths = AppPaths::discover().expect("failed to discover app paths");
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
            cancel_task,
            start_server,
            stop_server,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
