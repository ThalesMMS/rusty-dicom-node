use super::*;

impl TuiApp {
    pub(super) fn handle_modal_key(&mut self, key: KeyEvent) -> anyhow::Result<()> {
        let Some(mut modal) = self.modal.take() else {
            return Ok(());
        };

        let keep_modal = match &mut modal {
            ModalState::AddNode(form) | ModalState::EditNode(form) => {
                self.handle_node_form_key(form, key)
            }
            ModalState::ConfirmDeleteNode(confirm) => self.handle_delete_confirm_key(confirm, key),
            ModalState::Query(form) => self.handle_query_form_key(form, key),
            ModalState::Retrieve(form) => self.handle_retrieve_form_key(form, key),
        };

        match keep_modal {
            Ok(true) => self.modal = Some(modal),
            Ok(false) => {}
            Err(error) => {
                self.modal = Some(modal);
                return Err(error);
            }
        }

        Ok(())
    }

    pub(super) fn handle_node_form_key(
        &mut self,
        form: &mut NodeFormState,
        key: KeyEvent,
    ) -> anyhow::Result<bool> {
        match key.code {
            KeyCode::Esc => return Ok(false),
            KeyCode::Tab | KeyCode::Down => {
                form.active = form.active.next();
                form.error = None;
            }
            KeyCode::BackTab | KeyCode::Up => {
                form.active = form.active.previous();
                form.error = None;
            }
            KeyCode::Backspace => {
                if let Some(text) = form.active_text_mut() {
                    text.pop();
                    form.error = None;
                }
            }
            // Handler return values mean "keep the modal open"; node form submission
            // returns true when the modal should close after a successful submit.
            KeyCode::Enter => {
                let submitted = self.submit_node_form(form)?;
                return Ok(!submitted);
            }
            KeyCode::Char(ch) => {
                if let Some(text) = form.active_text_mut() {
                    text.push(ch);
                    form.error = None;
                }
            }
            _ => {}
        }

        Ok(true)
    }

    pub(super) fn handle_delete_confirm_key(
        &mut self,
        confirm: &DeleteConfirmState,
        key: KeyEvent,
    ) -> anyhow::Result<bool> {
        match key.code {
            KeyCode::Esc | KeyCode::Char('n') => Ok(false),
            KeyCode::Enter | KeyCode::Char('y') => {
                let removed = self.services.delete_node(&confirm.node.id)?;
                self.log(format!(
                    "removed {} node(s); last target was {}",
                    removed, confirm.node.name
                ));
                self.refresh_all()?;
                Ok(false)
            }
            _ => Ok(true),
        }
    }

    pub(super) fn handle_query_form_key(
        &mut self,
        form: &mut QueryFormState,
        key: KeyEvent,
    ) -> anyhow::Result<bool> {
        match key.code {
            KeyCode::Esc => return Ok(false),
            KeyCode::Tab | KeyCode::Down => {
                form.active = form.active.next();
                form.error = None;
            }
            KeyCode::BackTab | KeyCode::Up => {
                form.active = form.active.previous();
                form.error = None;
            }
            KeyCode::Left => {
                form.error = None;
                cycle_query_form_field(form, -1);
            }
            KeyCode::Right => {
                form.error = None;
                cycle_query_form_field(form, 1);
            }
            KeyCode::Char(' ') if matches!(form.active, QueryField::Model | QueryField::Level) => {
                form.error = None;
                cycle_query_form_field(form, 1);
            }
            KeyCode::Backspace => {
                if let Some(text) = form.active_text_mut() {
                    text.pop();
                    form.error = None;
                }
            }
            KeyCode::Enter => {
                if !self.ensure_not_busy() {
                    return Ok(true);
                }

                let criteria = build_query_criteria(form);
                self.query_context_node = Some(form.node.clone());
                self.query_context_model = form.model;
                self.focus = FocusPane::Query;
                self.start_task(BackgroundTask::Query {
                    node_name_or_id: form.node.id.clone(),
                    criteria,
                })?;
                return Ok(false);
            }
            KeyCode::Char(ch) => {
                if let Some(text) = form.active_text_mut() {
                    text.push(ch);
                    form.error = None;
                }
            }
            _ => {}
        }

        Ok(true)
    }

    pub(super) fn handle_retrieve_form_key(
        &mut self,
        form: &mut RetrieveFormState,
        key: KeyEvent,
    ) -> anyhow::Result<bool> {
        match key.code {
            KeyCode::Esc => return Ok(false),
            KeyCode::Tab | KeyCode::Down => {
                form.active = form.active.next();
                form.error = None;
            }
            KeyCode::BackTab | KeyCode::Up => {
                form.active = form.active.previous();
                form.error = None;
            }
            KeyCode::Left => {
                form.error = None;
                cycle_retrieve_form_field(form, -1);
            }
            KeyCode::Right => {
                form.error = None;
                cycle_retrieve_form_field(form, 1);
            }
            KeyCode::Char(' ')
                if matches!(form.active, RetrieveField::Model | RetrieveField::Level) =>
            {
                form.error = None;
                cycle_retrieve_form_field(form, 1);
            }
            KeyCode::Backspace => {
                if let Some(text) = form.active_text_mut() {
                    text.pop();
                    form.error = None;
                }
            }
            KeyCode::Enter => {
                if !self.ensure_not_busy() {
                    return Ok(true);
                }

                let request = match build_move_request(form) {
                    Ok(request) => request,
                    Err(error) => {
                        form.error = Some(error.to_string());
                        return Ok(true);
                    }
                };

                self.start_task(BackgroundTask::Retrieve { request })?;
                return Ok(false);
            }
            KeyCode::Char(ch) => {
                if let Some(text) = form.active_text_mut() {
                    text.push(ch);
                    form.error = None;
                }
            }
            _ => {}
        }

        Ok(true)
    }

    pub(super) fn submit_node_form(&mut self, form: &mut NodeFormState) -> anyhow::Result<bool> {
        let values = match parse_node_form(form) {
            Ok(values) => values,
            Err(error) => {
                form.error = Some(error.to_string());
                return Ok(false);
            }
        };

        match form.mode {
            NodeFormMode::Add => {
                let draft = self
                    .services
                    .node_draft_from_values(node_draft_values_from_form(values));
                let node = self.services.add_node(draft)?;
                self.log(format!("saved node {} ({})", node.name, node.id));
                self.refresh_all()?;
                self.select_node_by_id(&node.id);
            }
            NodeFormMode::Edit => {
                let target = form
                    .target
                    .as_ref()
                    .ok_or_else(|| anyhow!("edit form lost its target node"))?;
                let patch = self
                    .services
                    .node_patch_from_cli(node_patch_values_from_form(values))?;
                let node = self.services.update_node(&target.id, patch)?;
                self.log(format!("updated node {} ({})", node.name, node.id));
                self.refresh_all()?;
                self.select_node_by_id(&node.id);
            }
        }

        Ok(true)
    }

    pub(super) fn open_edit_node_modal(&mut self) {
        if let Some(node) = self.selected_node().cloned() {
            self.modal = Some(ModalState::EditNode(NodeFormState::edit(&node)));
        } else {
            self.log("select a remote node first");
        }
    }

    pub(super) fn open_delete_node_modal(&mut self) {
        if let Some(node) = self.selected_node().cloned() {
            self.modal = Some(ModalState::ConfirmDeleteNode(DeleteConfirmState { node }));
        } else {
            self.log("select a remote node first");
        }
    }

    pub(super) fn open_query_modal(&mut self) {
        if let Some(node) = self.selected_node().cloned() {
            self.modal = Some(ModalState::Query(QueryFormState::new(node)));
        } else {
            self.log("select a remote node first");
        }
    }

    pub(super) fn open_retrieve_modal(&mut self) {
        let Some(result) = self.selected_query_result().cloned() else {
            self.log("select a query result first");
            return;
        };

        let Some(node) = self
            .query_context_node
            .clone()
            .or_else(|| self.selected_node().cloned())
        else {
            self.log("query a remote node first so retrieve knows which node to use");
            return;
        };

        match RetrieveFormState::from_result(
            node,
            self.query_context_model,
            &result,
            &self.services.config.local_ae_title,
        ) {
            Ok(form) => self.modal = Some(ModalState::Retrieve(form)),
            Err(error) => self.log(format!("cannot open retrieve flow: {error}")),
        }
    }
}
