use super::*;

impl TuiApp {
    pub(super) fn execute_command(&mut self, command: &str) -> anyhow::Result<()> {
        let tokens = shell_words::split(command).context("parsing command")?;
        if tokens.is_empty() {
            return Ok(());
        }

        match tokens[0].as_str() {
            "help" => {
                for line in tui_command_help_lines() {
                    self.log(*line);
                }
            }
            "refresh" => {
                self.refresh_all()?;
                self.log("refreshed");
            }
            "quit" | "exit" => {
                self.should_quit = true;
            }
            "node" => self.exec_node(&tokens[1..])?,
            "import" => self.exec_import(&tokens[1..])?,
            "query" => self.exec_query(&tokens[1..])?,
            "retrieve" => self.exec_retrieve(&tokens[1..])?,
            "send-study" => self.exec_send_study(&tokens[1..])?,
            "send-series" => self.exec_send_series(&tokens[1..])?,
            other => return Err(anyhow!("unknown command: {other}")),
        }

        Ok(())
    }

    pub(super) fn exec_node(&mut self, args: &[String]) -> anyhow::Result<()> {
        let (subcommand, rest) = args
            .split_first()
            .ok_or_else(|| anyhow!("node subcommand required"))?;
        let kv = parse_key_values(rest)?;

        match subcommand.as_str() {
            "add" => {
                let draft = self
                    .services
                    .node_draft_from_values(node_draft_values_from_kv(&self.services, &kv)?);
                let node = self.services.add_node(draft)?;
                self.log(format!("saved node {} ({})", node.name, node.id));
            }
            "edit" => {
                let patch = self
                    .services
                    .node_patch_from_cli(node_patch_values_from_kv(&self.services, &kv)?)?;
                let node = self
                    .services
                    .update_node(required_kv_alt(&kv, &["target", "id", "name"])?, patch)?;
                self.log(format!("updated node {} ({})", node.name, node.id));
            }
            "delete" => {
                let removed = self
                    .services
                    .delete_node(required_kv_alt(&kv, &["target", "id", "name"])?)?;
                self.log(format!("removed {} node(s)", removed));
            }
            other => return Err(anyhow!("unsupported node subcommand: {other}")),
        }

        self.refresh_all()?;
        Ok(())
    }

    pub(super) fn exec_import(&mut self, args: &[String]) -> anyhow::Result<()> {
        if !self.ensure_not_busy() {
            return Ok(());
        }

        let kv = parse_key_values(args)?;
        let path = required_kv(&kv, "path")?;
        let path = PathBuf::from(path);
        let metadata = std::fs::metadata(&path)
            .with_context(|| format!("accessing import path {}", path.display()))?;
        if !(metadata.is_file() || metadata.is_dir()) {
            return Err(anyhow!(
                "import path must be a file or directory: {}",
                path.display()
            ));
        }
        if metadata.is_file() {
            std::fs::File::open(&path)
                .with_context(|| format!("opening import file {}", path.display()))?;
        } else {
            std::fs::read_dir(&path)
                .with_context(|| format!("reading import directory {}", path.display()))?;
        }

        self.start_task(BackgroundTask::Import { path })?;
        Ok(())
    }

    pub(super) fn exec_query(&mut self, args: &[String]) -> anyhow::Result<()> {
        if !self.ensure_not_busy() {
            return Ok(());
        }

        let (node_name_or_id, criteria) = parse_query_command_args(args)?;
        let node = self.services.get_node(&node_name_or_id)?;
        self.query_context_node = Some(node.clone());
        self.query_context_model = criteria.model;
        self.focus = FocusPane::Query;
        self.start_task(BackgroundTask::Query {
            node_name_or_id: node.id.clone(),
            criteria,
        })?;
        Ok(())
    }

    pub(super) fn exec_retrieve(&mut self, args: &[String]) -> anyhow::Result<()> {
        if !self.ensure_not_busy() {
            return Ok(());
        }

        self.start_task(BackgroundTask::Retrieve {
            request: parse_retrieve_command_args(args)?,
        })?;
        Ok(())
    }

    pub(super) fn exec_send_study(&mut self, args: &[String]) -> anyhow::Result<()> {
        if !self.ensure_not_busy() {
            return Ok(());
        }

        let (study_instance_uid, destination_node) = parse_send_study_command_args(args)?;
        self.start_task(BackgroundTask::SendStudy {
            study_instance_uid,
            destination_node,
        })?;
        Ok(())
    }

    pub(super) fn exec_send_series(&mut self, args: &[String]) -> anyhow::Result<()> {
        if !self.ensure_not_busy() {
            return Ok(());
        }

        let (series_instance_uid, destination_node) = parse_send_series_command_args(args)?;
        self.start_task(BackgroundTask::SendSeries {
            series_instance_uid,
            destination_node,
        })?;
        Ok(())
    }
}
