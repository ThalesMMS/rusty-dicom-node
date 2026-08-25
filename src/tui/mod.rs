use std::{
    collections::{HashMap, VecDeque},
    io::{self, Stdout},
    panic,
    path::PathBuf,
    sync::{
        mpsc::{self, Receiver, TryRecvError},
        Arc,
    },
    thread,
    time::{Duration, Instant},
};

use anyhow::{anyhow, Context};
use crossterm::{
    cursor::Show,
    event::{
        self, DisableBracketedPaste, EnableBracketedPaste, Event, KeyCode, KeyEvent, KeyEventKind,
        KeyModifiers,
    },
    execute,
    terminal::{disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen},
};
use ratatui::{
    backend::CrosstermBackend,
    layout::{Alignment, Constraint, Direction, Layout, Rect},
    style::{Color, Modifier, Style},
    text::{Line, Span, Text},
    widgets::{Block, Borders, Clear, List, ListItem, ListState, Paragraph, Wrap},
    Frame, Terminal,
};

use crate::{
    aliases::{
        ACCESSION_NUMBER_ALIASES, AE_TITLE_ALIASES, DESTINATION_NODE_ALIASES,
        MOVE_DESTINATION_ALIASES, SERIES_INSTANCE_UID_ALIASES, SOP_INSTANCE_UID_ALIASES,
        STUDY_DATE_FROM_ALIASES, STUDY_DATE_TO_ALIASES, STUDY_INSTANCE_UID_ALIASES,
    },
    models::{
        parse_port, trim_to_option, ImportReport, MoveOutcome, MoveRequest, QueryCriteria,
        QueryLevel, QueryMatch, QueryModel, RemoteNode, SendOutcome, SeriesSummary, StudySummary,
    },
    services::{AppServices, NodeDraftValues, NodePatchCliValues, TuiReceiverMode},
};

const MIN_TERMINAL_WIDTH: u16 = 40;
const MIN_TERMINAL_HEIGHT: u16 = 10;

mod app;
mod command_exec;
mod commands;
mod editor;
mod forms;
mod input;
mod modal_handlers;
mod navigation;
mod render;
mod state;
mod suggestions;
mod tasks;
mod terminal;

#[cfg(test)]
mod test_support;
#[cfg(test)]
mod tests;

use commands::*;
use editor::{floor_char_boundary, CommandEditor};
use fluent_bundle::FluentValue;
use forms::*;
use render::*;
use state::*;
use tasks::*;
use terminal::*;

pub(crate) fn tr(key: &str) -> String {
    crate::i18n::t(key)
}

pub(crate) fn tr_pairs(key: &str, pairs: &[(&str, String)]) -> String {
    let mut args = HashMap::new();
    for (name, value) in pairs {
        args.insert((*name).to_string(), FluentValue::from(value.clone()));
    }
    crate::i18n::t_with(key, &args)
}

pub(crate) fn tr1(key: &str, name: &str, value: impl ToString) -> String {
    let mut args = HashMap::new();
    args.insert(name.to_string(), FluentValue::from(value.to_string()));
    crate::i18n::t_with(key, &args)
}

pub(crate) fn tr_n(key: &str, name: &str, n: impl Into<i64>) -> String {
    crate::i18n::t_n(key, name, n)
}

pub(crate) fn tr_n1(
    key: &str,
    num_name: &str,
    n: impl Into<i64>,
    str_name: &str,
    s: impl ToString,
) -> String {
    let mut args = HashMap::new();
    args.insert(num_name.to_string(), FluentValue::from(n.into()));
    args.insert(str_name.to_string(), FluentValue::from(s.to_string()));
    crate::i18n::t_with(key, &args)
}

pub(crate) fn tr3(
    key: &str,
    a: &str,
    av: impl ToString,
    b: &str,
    bv: impl ToString,
    c: &str,
    cv: impl ToString,
) -> String {
    let mut args = HashMap::new();
    args.insert(a.to_string(), FluentValue::from(av.to_string()));
    args.insert(b.to_string(), FluentValue::from(bv.to_string()));
    args.insert(c.to_string(), FluentValue::from(cv.to_string()));
    crate::i18n::t_with(key, &args)
}

pub(crate) fn tr2(
    key: &str,
    a: &str,
    av: impl ToString,
    b: &str,
    bv: impl ToString,
) -> String {
    let mut args = HashMap::new();
    args.insert(a.to_string(), FluentValue::from(av.to_string()));
    args.insert(b.to_string(), FluentValue::from(bv.to_string()));
    crate::i18n::t_with(key, &args)
}

pub(crate) fn tr4(
    key: &str,
    a: &str,
    av: impl ToString,
    b: &str,
    bv: impl ToString,
    c: &str,
    cv: impl ToString,
    d: &str,
    dv: impl ToString,
) -> String {
    let mut args = HashMap::new();
    args.insert(a.to_string(), FluentValue::from(av.to_string()));
    args.insert(b.to_string(), FluentValue::from(bv.to_string()));
    args.insert(c.to_string(), FluentValue::from(cv.to_string()));
    args.insert(d.to_string(), FluentValue::from(dv.to_string()));
    crate::i18n::t_with(key, &args)
}

pub(crate) fn tr5(
    key: &str,
    a: &str,
    av: impl ToString,
    b: &str,
    bv: impl ToString,
    c: &str,
    cv: impl ToString,
    d: &str,
    dv: impl ToString,
    e: &str,
    ev: impl ToString,
) -> String {
    let mut args = HashMap::new();
    args.insert(a.to_string(), FluentValue::from(av.to_string()));
    args.insert(b.to_string(), FluentValue::from(bv.to_string()));
    args.insert(c.to_string(), FluentValue::from(cv.to_string()));
    args.insert(d.to_string(), FluentValue::from(dv.to_string()));
    args.insert(e.to_string(), FluentValue::from(ev.to_string()));
    crate::i18n::t_with(key, &args)
}

pub(crate) fn text_from_ftl(key: &str) -> Text<'static> {
    Text::from(
        tr(key)
            .lines()
            .map(|line| Line::from(line.to_string()))
            .collect::<Vec<_>>(),
    )
}

/// Initializes a TUI application with the provided services and runs its main loop.
///
/// # Examples
///
/// ```no_run
/// use crate::aliases::AppServices;
/// // Construct `services` as appropriate for your application, then:
/// // run_tui(services).expect("failed to run TUI");
/// ```
///
/// # Returns
///
/// `Ok(())` if the application exited successfully, `Err` containing the error otherwise.
pub fn run_tui(services: AppServices) -> anyhow::Result<()> {
    let mut app = TuiApp::new(services);
    app.run()
}
