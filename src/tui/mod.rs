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
    style::{Modifier, Style},
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
const TERMINAL_TOO_SMALL_MESSAGE: &str = "Terminal too small - please resize";

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
mod tasks;
mod terminal;

#[cfg(test)]
mod test_support;
#[cfg(test)]
mod tests;

use commands::*;
use editor::{floor_char_boundary, CommandEditor};
use forms::*;
use render::*;
use state::*;
use tasks::*;
use terminal::*;

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
