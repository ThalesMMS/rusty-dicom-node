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
            "local" => self.exec_local(&tokens[1..])?,
            "cancel" | "stop" => {
                self.cancel_active_task();
            }
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
        self.start_task(BackgroundTask::Retrieve {
            request: parse_retrieve_command_args(args)?,
        })?;
        Ok(())
    }

    pub(super) fn exec_send_study(&mut self, args: &[String]) -> anyhow::Result<()> {
        let (study_instance_uid, destination_node) = parse_send_study_command_args(args)?;
        self.start_task(BackgroundTask::SendStudy {
            study_instance_uid,
            destination_node,
        })?;
        Ok(())
    }

    pub(super) fn exec_send_series(&mut self, args: &[String]) -> anyhow::Result<()> {
        let (series_instance_uid, destination_node) = parse_send_series_command_args(args)?;
        self.start_task(BackgroundTask::SendSeries {
            series_instance_uid,
            destination_node,
        })?;
        Ok(())
    }

    pub(super) fn exec_local(&mut self, args: &[String]) -> anyhow::Result<()> {
        let (subcommand, rest) = args
            .split_first()
            .ok_or_else(|| anyhow!("local subcommand required"))?;

        match subcommand.as_str() {
            "studies" => {
                use crate::tui::commands::parse_key_values;

                let kv = parse_key_values(rest)?;

                let mut filters = dicom_node_client::filters::StudyFilters::default();
                filters.patient_name = kv.get("patient_name").cloned();
                filters.patient_id = kv.get("patient_id").cloned();
                filters.study_description = kv.get("study_description").cloned();
                filters.study_date = kv.get("study_date").cloned();
                filters.modalities = kv
                    .get("modality")
                    .map(|v| {
                        v.split(',')
                            .map(|s| s.trim().to_string())
                            .filter(|s| !s.is_empty())
                            .collect()
                    })
                    .unwrap_or_default();
                filters.imported_at = kv.get("imported_at").cloned();
                filters.duplicate = kv.get("duplicate").map(|v| v == "true");

                let studies = self.services.local_studies_filtered(&filters)?;
                if studies.is_empty() {
                    self.log("No indexed local studies");
                } else {
                    for study in studies {
                        self.log(crate::tui::format_study_row(&study));
                    }
                }
            }
            "series" => {
                use crate::aliases::STUDY_INSTANCE_UID_ALIASES;
                use crate::tui::commands::{parse_key_values, required_kv_alt};

                let kv = parse_key_values(rest)?;
                let study_instance_uid = required_kv_alt(&kv, STUDY_INSTANCE_UID_ALIASES)?;

                let series = self.services.local_series(study_instance_uid)?;
                if series.is_empty() {
                    self.log("No indexed local series");
                } else {
                    for row in &series {
                        self.log(crate::tui::format_series_row(row));
                    }
                }

                // Update local pane state to match drill-down behavior: show series for this study.
                self.local_series = series;
                self.local_instances.clear();
                self.selected_local_series =
                    crate::tui::state::normalized_selection(None, self.local_series.len());
                self.selected_local_instance = None;
                self.local_drill_down = true;
                self.local_instance_drill_down = false;
                self.drill_down_study_uid = Some(study_instance_uid.to_string());
                self.focus = crate::tui::state::FocusPane::Local;
                self.detail_scroll = 0;
            }
            "instances" => {
                use crate::aliases::SERIES_INSTANCE_UID_ALIASES;
                use crate::tui::commands::{parse_key_values, required_kv_alt};

                let kv = parse_key_values(rest)?;
                let series_instance_uid = required_kv_alt(&kv, SERIES_INSTANCE_UID_ALIASES)?;

                let instances = self.services.local_instances(series_instance_uid)?;
                if instances.is_empty() {
                    self.log("No indexed local instances");
                } else {
                    for row in &instances {
                        self.log(crate::tui::format_instance_row(row));
                    }
                }

                // Update local pane state to match drill-down behavior: show instances for this series.
                self.local_instances = instances;
                self.selected_local_instance =
                    crate::tui::state::normalized_selection(None, self.local_instances.len());
                self.local_instance_drill_down = true;
                self.focus = crate::tui::state::FocusPane::Local;
                self.detail_scroll = 0;
            }
            other => return Err(anyhow!("unsupported local subcommand: {other}")),
        }

        Ok(())
    }
}
