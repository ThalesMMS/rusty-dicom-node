use super::*;

pub(super) const COMMAND_HISTORY_LIMIT: usize = 100;

impl TuiApp {
    /// Dispatches a single key event to the application, updating focus, modal state, help visibility,
    /// command execution flow, selection movement, and other global actions.
    ///
    /// This method:
    /// - Hides or shows the help overlay when `Esc`, `F(1)`, or `?` are pressed according to the
    ///   current focus and editor content.
    /// - Routes input when a modal is active to `handle_modal_key`.
    /// - Delegates input-pane keystrokes to `handle_input_key`.
    /// - Handles global non-input controls such as quitting, focus cycling (Tab/BackTab),
    ///   refreshing, selection movement, node/query modal openers, and entering local drill-down.
    ///
    /// On success returns `Ok(())`. Errors produced by delegated operations (e.g., `refresh_all`,
    /// `handle_modal_key`, `enter_local_drill_down`) are propagated.
    ///
    /// # Examples
    ///
    /// ```
    /// // Example usage (pseudocode):
    /// // let mut app = TuiApp::new(...);
    /// // app.handle_key(KeyEvent::from(KeyCode::Tab)).unwrap();
    /// ```
    pub(super) fn handle_key(&mut self, key: KeyEvent) -> anyhow::Result<()> {
        if self.show_help {
            match key.code {
                KeyCode::Esc | KeyCode::F(1) => self.show_help = false,
                KeyCode::Char('?')
                    if self.focus != FocusPane::Input || self.editor.content().is_empty() =>
                {
                    self.show_help = false;
                }
                _ => {}
            }
            return Ok(());
        }

        if matches!(key.code, KeyCode::F(1))
            || (matches!(key.code, KeyCode::Char('?'))
                && (self.focus != FocusPane::Input || self.editor.content().is_empty()))
        {
            self.show_help = true;
            return Ok(());
        }

        if self.modal.is_some() {
            return self.handle_modal_key(key);
        }

        if self.handle_input_key(key)? {
            return Ok(());
        }

        match key.code {
            KeyCode::Char('q') if self.focus != FocusPane::Input => {
                self.should_quit = true;
            }
            KeyCode::Esc if self.focus == FocusPane::Local && self.local_drill_down => {
                self.clear_local_drill_down();
            }
            KeyCode::Esc => {
                self.focus = FocusPane::Input;
            }
            KeyCode::Tab => {
                self.focus = self.focus.next();
            }
            KeyCode::BackTab => {
                self.focus = self.focus.previous();
            }
            KeyCode::Char('r') if self.focus != FocusPane::Input => {
                self.refresh_all()?;
                self.log("refreshed");
            }
            KeyCode::Up => self.move_current_selection(-1),
            KeyCode::Down => self.move_current_selection(1),
            KeyCode::Char('j') if self.focus != FocusPane::Input => self.move_current_selection(1),
            KeyCode::Char('k') if self.focus != FocusPane::Input => self.move_current_selection(-1),
            KeyCode::Char('a') if self.focus == FocusPane::Nodes => {
                self.modal = Some(ModalState::AddNode(NodeFormState::add()));
            }
            KeyCode::Char('e') if self.focus == FocusPane::Nodes => {
                self.open_edit_node_modal();
            }
            KeyCode::Char('d') if self.focus == FocusPane::Nodes => {
                self.open_delete_node_modal();
            }
            KeyCode::Char('f') if self.focus == FocusPane::Nodes => {
                self.open_query_modal();
            }
            KeyCode::Char('m') if self.focus == FocusPane::Query => {
                self.open_retrieve_modal();
            }
            KeyCode::Enter if self.focus == FocusPane::Local && !self.local_drill_down => {
                self.enter_local_drill_down()?;
            }
            _ => {}
        }
        Ok(())
    }

    /// Handle a key event when the input editor has focus, performing editing, history navigation, and command submission.
    ///
    /// This consumes keys for editing the input buffer (cursor movement, deletions, insertions), navigates command history (Up/Down),
    /// and on Enter commits the trimmed command to history, clears or takes the editor content, resets history navigation, logs the command,
    /// and attempts to execute it (execution errors are logged).
    ///
    /// # Returns
    ///
    /// `Ok(true)` if the key was handled by the input editor, `Ok(false)` if the key should be handled elsewhere; returns an `Err` if command execution produced an error propagated by the caller.
    ///
    /// # Examples
    ///
    /// ```no_run
    /// # use crossterm::event::{KeyCode, KeyEvent, KeyModifiers};
    /// # use crate::tui::{TuiApp, FocusPane};
    /// let mut app = TuiApp::default();
    /// app.focus = FocusPane::Input;
    /// app.editor.insert_str("status");
    /// let handled = app.handle_input_key(KeyEvent::new(KeyCode::Enter, KeyModifiers::NONE)).unwrap();
    /// assert!(handled);
    /// ```
    pub(super) fn handle_input_key(&mut self, key: KeyEvent) -> anyhow::Result<bool> {
        if self.focus != FocusPane::Input {
            return Ok(false);
        }

        let control = key.modifiers.contains(KeyModifiers::CONTROL);

        match key.code {
            KeyCode::Enter => {
                let command = self.editor.content().trim().to_string();
                if command.is_empty() {
                    self.editor.clear();
                } else {
                    self.push_history(command.clone());
                    let _ = self.editor.take_content();
                }
                self.reset_history_navigation();

                if !command.is_empty() {
                    self.log(format!("> {command}"));
                    match self.execute_command(&command) {
                        Ok(()) => {}
                        Err(error) => self.log(format!("error: {error:#}")),
                    }
                }
            }
            KeyCode::Up => self.previous_history_entry(),
            KeyCode::Down => self.next_history_entry(),
            KeyCode::Left if control => self.editor.move_word_left(),
            KeyCode::Right if control => self.editor.move_word_right(),
            KeyCode::Backspace if control => {
                self.detach_history_navigation();
                self.editor.delete_word_left();
            }
            KeyCode::Delete if control => {
                self.detach_history_navigation();
                self.editor.delete_word_right();
            }
            KeyCode::Left => self.editor.move_left(),
            KeyCode::Right => self.editor.move_right(),
            KeyCode::Home => self.editor.move_home(),
            KeyCode::End => self.editor.move_end(),
            KeyCode::Delete => {
                self.detach_history_navigation();
                self.editor.delete_char();
            }
            KeyCode::Backspace => {
                self.detach_history_navigation();
                self.editor.backspace();
            }
            KeyCode::Char(ch) if text_input_modifiers(key.modifiers) => {
                self.detach_history_navigation();
                self.editor.insert_char(ch);
            }
            _ => return Ok(false),
        }

        Ok(true)
    }

    /// Inserts the given pasted `text` into the input editor when pasting is allowed.
    ///
    /// This performs the paste only if help is not shown, no modal is active, the focus
    /// is on the input pane, and `text` is not empty. When the paste is applied,
    /// history navigation is detached so subsequent edits are treated as new input.
    ///
    /// # Parameters
    ///
    /// - `text`: the clipboard text to insert into the input editor.
    ///
    /// # Examples
    ///
    /// ```
    /// // Prepare an application in a state where pasting is allowed:
    /// let mut app = TuiApp::default(); // assumes Default is implemented for example purposes
    /// app.show_help = false;
    /// app.modal = None;
    /// app.focus = FocusPane::Input;
    ///
    /// app.handle_paste("hello world");
    /// assert!(app.editor.content().contains("hello world"));
    /// ```
    pub(super) fn handle_paste(&mut self, text: &str) {
        if !self.show_help
            && self.modal.is_none()
            && self.focus == FocusPane::Input
            && !text.is_empty()
        {
            self.detach_history_navigation();
            self.editor.insert_str(text);
        }
    }

    /// Appends a command to the end of the history, avoiding an immediate duplicate and enforcing the history size limit.
    ///
    /// If the given `command` is identical to the most recently stored entry, it is not added. When adding would
    /// make the history exceed `COMMAND_HISTORY_LIMIT`, the oldest entry is removed to keep the history within the limit.
    ///
    /// # Examples
    ///
    /// ```
    /// // Given a mutable TuiApp `app` with a `history: VecDeque<String>`
    /// app.push_history("ls -la".to_string()); // appended
    /// app.push_history("ls -la".to_string()); // ignored because it's a consecutive duplicate
    /// // After many pushes, the total kept entries will never exceed COMMAND_HISTORY_LIMIT.
    /// ```
    pub(super) fn push_history(&mut self, command: String) {
        if self.history.back() == Some(&command) {
            return;
        }

        self.history.push_back(command);
        if self.history.len() > COMMAND_HISTORY_LIMIT {
            self.history.pop_front();
        }
    }

    /// Move the input editor to the previous entry in command history.
    ///
    /// If history browsing is not already active this saves the current editor
    /// content into `draft` and starts browsing from the most recent history
    /// entry. If already browsing, it advances the history index one entry
    /// older. If history is empty this does nothing.
    ///
    /// # Examples
    ///
    /// ```
    /// // Assume `app` is a mutable `TuiApp` set up for testing:
    /// // app.push_history("first".into());
    /// // app.push_history("second".into());
    /// // app.previous_history_entry(); // loads "second" into the editor
    /// // app.previous_history_entry(); // then loads "first"
    /// ```
    pub(super) fn previous_history_entry(&mut self) {
        if self.history.is_empty() {
            return;
        }

        let index = match self.history_index {
            Some(index) => index.saturating_sub(1),
            None => {
                self.draft = self.editor.content().to_string();
                self.history.len() - 1
            }
        };

        self.history_index = Some(index);
        self.load_history_entry(index);
    }

    /// Advances the current history cursor toward newer entries, restoring the draft when past the newest.
    ///
    /// If there is no active history navigation this is a no-op. When advancing moves past the most-recent
    /// entry the method clears `history_index`, restores `draft` into the editor, and clears `draft`.
    /// Otherwise it increments `history_index` and loads the corresponding history entry into the editor.
    ///
    /// # Examples
    ///
    /// ```no_run
    /// // Move forward through history (e.g., after previous_history_entry was used)
    /// app.next_history_entry();
    /// ```
    pub(super) fn next_history_entry(&mut self) {
        let Some(index) = self.history_index else {
            return;
        };

        let next = index + 1;
        if next >= self.history.len() {
            self.history_index = None;
            self.editor.set_content(&self.draft);
            self.draft.clear();
        } else {
            self.history_index = Some(next);
            self.load_history_entry(next);
        }
    }

    /// Loads the command at `index` from the command history into the input editor if present.
    ///
    /// If `index` is out of bounds, the editor is not modified.
    ///
    /// # Examples
    ///
    /// ```
    /// // Assuming `app` is a `TuiApp` with populated `history` and an editor:
    /// // app.load_history_entry(0);
    /// ```
    pub(super) fn load_history_entry(&mut self, index: usize) {
        if let Some(command) = self.history.get(index) {
            self.editor.set_content(command);
        }
    }

    /// Cancels ongoing history browsing and clears the temporary draft saved while navigating history.
    ///
    /// If the app was currently showing a historical entry (i.e., `history_index` was set), this method
    /// takes (clears) that index and also clears the `draft` buffer that held the user's in-progress text.
    ///
    /// # Examples
    ///
    /// ```
    /// let mut app = TuiApp::default();
    /// app.history_index = Some(0);
    /// app.draft = "partial".to_string();
    /// app.detach_history_navigation();
    /// assert!(app.history_index.is_none());
    /// assert!(app.draft.is_empty());
    /// ```
    pub(super) fn detach_history_navigation(&mut self) {
        if self.history_index.take().is_some() {
            self.draft.clear();
        }
    }

    /// Reset history navigation state and clear the current draft.
    ///
    /// This stops any ongoing history browsing by clearing `history_index` and
    /// removing the saved draft text so new edits start fresh.
    ///
    /// # Examples
    ///
    /// ```no_run
    /// // Assume `TuiApp::default()` exists for example purposes.
    /// let mut app = TuiApp::default();
    /// app.history_index = Some(0);
    /// app.draft.push_str("partial command");
    /// app.reset_history_navigation();
    /// assert!(app.history_index.is_none());
    /// assert!(app.draft.is_empty());
    /// ```
    pub(super) fn reset_history_navigation(&mut self) {
        self.history_index = None;
        self.draft.clear();
    }
}
