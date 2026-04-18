use super::*;

use std::sync::atomic::{AtomicBool, Ordering};

static TERMINAL_RESTORE_NEEDED: AtomicBool = AtomicBool::new(false);

pub(super) type TuiTerminal = Terminal<CrosstermBackend<Stdout>>;

#[allow(deprecated)]
pub(super) type PanicHook = Box<dyn Fn(&panic::PanicInfo<'_>) + Sync + Send + 'static>;

pub(super) struct TerminalGuard {
    pub(super) terminal: TuiTerminal,
}

impl TerminalGuard {
    pub(super) fn new() -> anyhow::Result<Self> {
        enable_raw_mode().context("failed to enable terminal raw mode")?;

        let mut stdout = io::stdout();
        if let Err(error) = execute!(stdout, EnterAlternateScreen) {
            let _ = disable_raw_mode();
            return Err(error).context("failed to enter alternate terminal screen");
        }
        let _ = execute!(stdout, EnableBracketedPaste);

        TERMINAL_RESTORE_NEEDED.store(true, Ordering::SeqCst);

        let backend = CrosstermBackend::new(stdout);
        let terminal = Terminal::new(backend).map_err(|error| {
            restore_terminal_from_stdout();
            error
        })?;

        Ok(Self { terminal })
    }

    pub(super) fn draw(&mut self, view: &TuiView) -> anyhow::Result<()> {
        self.terminal.draw(|frame| draw_ui(frame, view))?;
        Ok(())
    }
}

impl Drop for TerminalGuard {
    fn drop(&mut self) {
        if TERMINAL_RESTORE_NEEDED.swap(false, Ordering::SeqCst) {
            let _ = disable_raw_mode();
            let _ = execute!(
                self.terminal.backend_mut(),
                DisableBracketedPaste,
                LeaveAlternateScreen
            );
            let _ = self.terminal.show_cursor();
        }
    }
}

pub(super) struct PanicHookGuard {
    pub(super) previous: Option<Arc<PanicHook>>,
}

impl PanicHookGuard {
    pub(super) fn install() -> Self {
        let previous = Arc::new(panic::take_hook());
        let previous_for_hook = Arc::clone(&previous);

        panic::set_hook(Box::new(move |panic_info| {
            restore_terminal_from_stdout();
            previous_for_hook.as_ref()(panic_info);
        }));

        Self {
            previous: Some(previous),
        }
    }
}

impl Drop for PanicHookGuard {
    fn drop(&mut self) {
        if thread::panicking() {
            return;
        }

        drop(panic::take_hook());

        if let Some(previous) = self
            .previous
            .take()
            .and_then(|previous| Arc::try_unwrap(previous).ok())
        {
            panic::set_hook(previous);
        }
    }
}

fn restore_terminal_from_stdout() {
    if TERMINAL_RESTORE_NEEDED.swap(false, Ordering::SeqCst) {
        let _ = disable_raw_mode();
        let mut stdout = io::stdout();
        let _ = execute!(stdout, DisableBracketedPaste, LeaveAlternateScreen, Show);
    }
}

pub(super) fn text_input_modifiers(modifiers: KeyModifiers) -> bool {
    let command_modifiers = KeyModifiers::CONTROL
        | KeyModifiers::ALT
        | KeyModifiers::SUPER
        | KeyModifiers::HYPER
        | KeyModifiers::META;
    !modifiers.intersects(command_modifiers)
}
