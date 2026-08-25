use std::{collections::VecDeque, sync::Arc};

use ratatui::{
    style::{Modifier, Style},
    text::{Line, Span, Text},
};

use crate::{
    models::{LocalInstance, QueryMatch, QueryModel, RemoteNode, SeriesSummary, StudySummary},
    services::{AppServices, TuiStatusSnapshot},
};

use super::{
    editor::CommandEditor,
    forms::ModalState,
    render::truncate_path,
    tasks::{RunningTask, RunningTaskView, TaskId, TaskInfo, TaskRunner},
    tr,
};

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(super) enum TaskListScope {
    Queued,
    History,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(super) enum FocusPane {
    Nodes,
    Query,
    Local,
    Config,
    Logs,
    Tasks,
    Input,
}

impl FocusPane {
    pub(super) fn next(self) -> Self {
        match self {
            FocusPane::Nodes => FocusPane::Query,
            FocusPane::Query => FocusPane::Local,
            FocusPane::Local => FocusPane::Config,
            FocusPane::Config => FocusPane::Logs,
            FocusPane::Logs => FocusPane::Tasks,
            FocusPane::Tasks => FocusPane::Input,
            FocusPane::Input => FocusPane::Nodes,
        }
    }

    pub(super) fn previous(self) -> Self {
        match self {
            FocusPane::Nodes => FocusPane::Input,
            FocusPane::Query => FocusPane::Nodes,
            FocusPane::Local => FocusPane::Query,
            FocusPane::Config => FocusPane::Local,
            FocusPane::Logs => FocusPane::Config,
            FocusPane::Tasks => FocusPane::Logs,
            FocusPane::Input => FocusPane::Tasks,
        }
    }
}

#[derive(Debug)]
pub(super) struct TuiView<'a> {
    pub(super) status: TuiStatusSnapshot,
    pub(super) focus: FocusPane,
    pub(super) nodes: &'a [RemoteNode],
    pub(super) selected_node: Option<usize>,
    pub(super) local_studies: &'a [StudySummary],
    pub(super) selected_local_study: Option<usize>,
    pub(super) local_series: &'a [SeriesSummary],
    pub(super) selected_local_series: Option<usize>,
    pub(super) local_instances: &'a [LocalInstance],
    pub(super) selected_local_instance: Option<usize>,
    pub(super) local_drill_down: bool,
    pub(super) drill_down_study_uid: Option<&'a str>,
    pub(super) local_instance_drill_down: bool,
    pub(super) query_results: &'a [QueryMatch],
    pub(super) selected_query_result: Option<usize>,
    pub(super) query_context_node: Option<&'a RemoteNode>,
    pub(super) query_context_node_name: Option<&'a str>,
    pub(super) detail_scroll: u16,
    pub(super) input_content: String,
    pub(super) input_cursor: usize,
    pub(super) logs: &'a [String],
    pub(super) running_task: Option<RunningTaskView>,
    pub(super) queued_tasks: &'a [TaskInfo],
    #[allow(
        dead_code,
        reason = "view exposes task history for renderer/tests before the task pane renders it"
    )]
    pub(super) task_history: &'a [TaskInfo],
    #[allow(
        dead_code,
        reason = "view exposes task selection for renderer/tests before the task pane renders it"
    )]
    pub(super) selected_task: Option<usize>,
    #[allow(
        dead_code,
        reason = "view exposes task selection scope for renderer/tests before the task pane renders it"
    )]
    pub(super) selected_task_scope: TaskListScope,
    pub(super) show_help: bool,
    pub(super) modal: Option<&'a ModalState>,
}

pub(super) struct TuiApp {
    pub(super) services: Arc<AppServices>,
    pub(super) task_runner: TaskRunner,
    pub(super) status: TuiStatusSnapshot,
    pub(super) focus: FocusPane,
    pub(super) nodes: Vec<RemoteNode>,
    pub(super) selected_node: Option<usize>,
    pub(super) local_studies: Vec<StudySummary>,
    pub(super) selected_local_study: Option<usize>,
    pub(super) local_series: Vec<SeriesSummary>,
    pub(super) selected_local_series: Option<usize>,
    pub(super) local_instances: Vec<LocalInstance>,
    pub(super) selected_local_instance: Option<usize>,
    pub(super) local_drill_down: bool,
    pub(super) drill_down_study_uid: Option<String>,
    pub(super) local_instance_drill_down: bool,
    pub(super) query_results: Vec<QueryMatch>,
    pub(super) selected_query_result: Option<usize>,
    pub(super) query_context_node: Option<RemoteNode>,
    pub(super) query_context_model: QueryModel,
    pub(super) detail_scroll: u16,
    pub(super) editor: CommandEditor,
    pub(super) history: VecDeque<String>,
    pub(super) history_index: Option<usize>,
    pub(super) draft: String,
    pub(super) logs: Vec<String>,
    pub(super) running_task: Option<RunningTask>,
    pub(super) queued_tasks: VecDeque<TaskInfo>,
    pub(super) task_history: VecDeque<TaskInfo>,
    pub(super) selected_task: Option<usize>,
    pub(super) selected_task_scope: TaskListScope,
    pub(super) task_logs: VecDeque<(TaskId, String)>,
    pub(super) last_task_error: Option<String>,
    pub(super) show_help: bool,
    pub(super) modal: Option<ModalState>,
    pub(super) should_quit: bool,
}

pub(super) fn selection_by_key<T, F>(
    items: &[T],
    wanted_key: Option<&str>,
    key_of: F,
) -> Option<usize>
where
    F: Fn(&T) -> &str,
{
    if items.is_empty() {
        return None;
    }

    wanted_key
        .and_then(|wanted| items.iter().position(|item| key_of(item) == wanted))
        .or(Some(0))
}

pub(super) fn normalized_selection(current: Option<usize>, len: usize) -> Option<usize> {
    if len == 0 {
        None
    } else {
        Some(current.unwrap_or(0).min(len - 1))
    }
}

pub(super) fn move_selection(current: Option<usize>, len: usize, delta: isize) -> Option<usize> {
    if len == 0 {
        return None;
    }

    let index = current.unwrap_or(0);
    let next = (index as isize + delta).clamp(0, len.saturating_sub(1) as isize) as usize;
    Some(next)
}

pub(super) fn status_summary_lines(status: &TuiStatusSnapshot) -> Text<'static> {
    let receiver_mode = if status.receiver_mode == tr("tui-receiver-mode-on-demand") {
        tr("tui-status-mode-on-demand")
    } else {
        tr("tui-status-mode-standalone")
    };

    Text::from(vec![
        status_summary_line(vec![
            (tr("tui-status-local-ae"), status.local_ae_title.clone()),
            (tr("tui-status-listener"), status.listener_addr.clone()),
            (tr("tui-status-mode"), receiver_mode.to_string()),
        ]),
        status_summary_line(vec![
            (tr("tui-status-pdu"), status.max_pdu_length.to_string()),
            (
                tr("tui-status-strict"),
                if status.strict_pdu {
                    tr("tui-bool-yes")
                } else {
                    tr("tui-bool-no")
                },
            ),
            (
                tr("tui-status-promiscuous"),
                if status.allow_promiscuous_storage {
                    tr("tui-bool-yes")
                } else {
                    tr("tui-bool-no")
                },
            ),
            (tr("tui-status-ts-pref"), status.preferred_store_transfer_syntax.clone()),
        ]),
        status_summary_line(vec![
            (tr("tui-status-config"), truncate_path(&status.config_path, 28)),
            (tr("tui-status-data"), truncate_path(&status.data_dir, 28)),
        ]),
    ])
}

fn status_summary_line(fields: Vec<(String, String)>) -> Line<'static> {
    let mut spans = Vec::new();

    for (index, (label, value)) in fields.into_iter().enumerate() {
        if index > 0 {
            spans.push(Span::raw("  |  "));
        }

        spans.push(Span::styled(
            format!("{label}: "),
            Style::default().add_modifier(Modifier::DIM),
        ));
        spans.push(Span::raw(value));
    }

    Line::from(spans)
}
