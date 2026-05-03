use super::*;

use crate::models::LocalInstance;

impl TuiApp {
    pub(super) fn move_current_selection(&mut self, delta: isize) {
        match self.focus {
            FocusPane::Nodes => {
                self.selected_node = move_selection(self.selected_node, self.nodes.len(), delta);
                self.detail_scroll = 0;
            }
            FocusPane::Query => {
                self.selected_query_result =
                    move_selection(self.selected_query_result, self.query_results.len(), delta);
                self.detail_scroll = 0;
            }
            FocusPane::Local => {
                if self.local_instance_drill_down {
                    self.selected_local_instance = move_selection(
                        self.selected_local_instance,
                        self.local_instances.len(),
                        delta,
                    );
                } else if self.local_drill_down {
                    self.selected_local_series =
                        move_selection(self.selected_local_series, self.local_series.len(), delta);
                } else {
                    self.selected_local_study =
                        move_selection(self.selected_local_study, self.local_studies.len(), delta);
                }
                self.detail_scroll = 0;
            }
            FocusPane::Tasks => {
                let len = match self.selected_task_scope {
                    TaskListScope::Queued => self.queued_tasks.len(),
                    TaskListScope::History => self.task_history.len(),
                };
                self.selected_task = move_selection(self.selected_task, len, delta);
            }
            FocusPane::Config | FocusPane::Logs | FocusPane::Input => {}
        }
    }

    pub(super) fn selected_node(&self) -> Option<&RemoteNode> {
        self.selected_node.and_then(|index| self.nodes.get(index))
    }

    pub(super) fn selected_local_study(&self) -> Option<&StudySummary> {
        self.selected_local_study
            .and_then(|index| self.local_studies.get(index))
    }

    pub(super) fn selected_local_series(&self) -> Option<&SeriesSummary> {
        self.selected_local_series
            .and_then(|index| self.local_series.get(index))
    }

    pub(super) fn selected_local_instance(&self) -> Option<&LocalInstance> {
        self.selected_local_instance
            .and_then(|index| self.local_instances.get(index))
    }

    pub(super) fn selected_query_result(&self) -> Option<&QueryMatch> {
        self.selected_query_result
            .and_then(|index| self.query_results.get(index))
    }

    pub(super) fn enter_local_drill_down(&mut self) -> anyhow::Result<()> {
        if self.local_instance_drill_down {
            return Ok(());
        }

        if self.local_drill_down {
            let Some(series) = self.selected_local_series().cloned() else {
                return Ok(());
            };

            self.local_instances = self.services.local_instances(&series.series_instance_uid)?;
            self.selected_local_instance = normalized_selection(None, self.local_instances.len());
            self.local_instance_drill_down = true;
            self.detail_scroll = 0;
            return Ok(());
        }

        let Some(study) = self.selected_local_study().cloned() else {
            return Ok(());
        };

        self.local_series = self.services.local_series(&study.study_instance_uid)?;
        self.selected_local_series = normalized_selection(None, self.local_series.len());
        self.local_drill_down = true;
        self.drill_down_study_uid = Some(study.study_instance_uid);
        self.detail_scroll = 0;

        Ok(())
    }

    pub(super) fn clear_local_instance_drill_down(&mut self) {
        self.selected_local_instance = None;
        self.local_instance_drill_down = false;
        self.detail_scroll = 0;
    }

    pub(super) fn clear_local_drill_down(&mut self) {
        self.clear_local_instance_drill_down();
        self.selected_local_series = None;
        self.local_drill_down = false;
    }

    pub(super) fn reset_local_drill_down_cache(&mut self) {
        self.clear_local_drill_down();
        self.local_instances.clear();
        self.local_series.clear();
        self.drill_down_study_uid = None;
    }

    pub(super) fn select_node_by_id(&mut self, id: &str) {
        self.selected_node = self
            .nodes
            .iter()
            .position(|node| node.id == id)
            .or_else(|| normalized_selection(None, self.nodes.len()));
    }
}
