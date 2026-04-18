use std::{collections::VecDeque, sync::Arc};

use ratatui::{
    style::{Modifier, Style},
    text::{Line, Span, Text},
};

use crate::{
    models::{QueryMatch, QueryModel, RemoteNode, SeriesSummary, StudySummary},
    services::{AppServices, TuiStatusSnapshot},
};

use super::{
    editor::CommandEditor,
    forms::ModalState,
    render::truncate_path,
    tasks::{RunningTask, RunningTaskView, TaskRunner},
};

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(super) enum FocusPane {
    Nodes,
    Query,
    Local,
    Logs,
    Input,
}

impl FocusPane {
    pub(super) fn next(self) -> Self {
        match self {
            FocusPane::Nodes => FocusPane::Query,
            FocusPane::Query => FocusPane::Local,
            FocusPane::Local => FocusPane::Logs,
            FocusPane::Logs => FocusPane::Input,
            FocusPane::Input => FocusPane::Nodes,
        }
    }

    pub(super) fn previous(self) -> Self {
        match self {
            FocusPane::Nodes => FocusPane::Input,
            FocusPane::Query => FocusPane::Nodes,
            FocusPane::Local => FocusPane::Query,
            FocusPane::Logs => FocusPane::Local,
            FocusPane::Input => FocusPane::Logs,
        }
    }
}

#[derive(Clone, Debug)]
pub(super) struct TuiView {
    pub(super) status: TuiStatusSnapshot,
    pub(super) focus: FocusPane,
    pub(super) nodes: Vec<RemoteNode>,
    pub(super) selected_node: Option<usize>,
    pub(super) local_studies: Vec<StudySummary>,
    pub(super) selected_local_study: Option<usize>,
    pub(super) local_series: Vec<SeriesSummary>,
    pub(super) selected_local_series: Option<usize>,
    pub(super) local_drill_down: bool,
    pub(super) drill_down_study_uid: Option<String>,
    pub(super) query_results: Vec<QueryMatch>,
    pub(super) selected_query_result: Option<usize>,
    pub(super) query_context_node: Option<RemoteNode>,
    pub(super) query_context_node_name: Option<String>,
    pub(super) input_content: String,
    pub(super) input_cursor: usize,
    pub(super) logs: Vec<String>,
    pub(super) running_task: Option<RunningTaskView>,
    pub(super) show_help: bool,
    pub(super) modal: Option<ModalState>,
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
    pub(super) local_drill_down: bool,
    pub(super) drill_down_study_uid: Option<String>,
    pub(super) query_results: Vec<QueryMatch>,
    pub(super) selected_query_result: Option<usize>,
    pub(super) query_context_node: Option<RemoteNode>,
    pub(super) query_context_model: QueryModel,
    pub(super) editor: CommandEditor,
    pub(super) history: VecDeque<String>,
    pub(super) history_index: Option<usize>,
    pub(super) draft: String,
    pub(super) logs: Vec<String>,
    pub(super) running_task: Option<RunningTask>,
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

impl TuiStatusSnapshot {
    pub(super) fn summary_lines(&self) -> Text<'static> {
        let receiver_mode = if self.receiver_mode.contains("on-demand") {
            "on-demand"
        } else {
            "standalone"
        };

        Text::from(vec![
            status_summary_line(vec![
                ("Local AE", self.local_ae_title.clone()),
                ("Listener", self.listener_addr.clone()),
                ("Mode", receiver_mode.to_string()),
            ]),
            status_summary_line(vec![
                ("PDU", self.max_pdu_length.to_string()),
                (
                    "Strict",
                    if self.strict_pdu { "y" } else { "n" }.to_string(),
                ),
                (
                    "Promiscuous",
                    if self.allow_promiscuous_storage {
                        "y"
                    } else {
                        "n"
                    }
                    .to_string(),
                ),
                ("TS Pref", self.preferred_store_transfer_syntax.clone()),
            ]),
            status_summary_line(vec![
                ("Config", truncate_path(&self.config_path, 28)),
                ("Data", truncate_path(&self.data_dir, 28)),
            ]),
        ])
    }
}

fn status_summary_line(fields: Vec<(&str, String)>) -> Line<'static> {
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
