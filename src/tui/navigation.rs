use super::*;

impl TuiApp {
    pub(super) fn move_current_selection(&mut self, delta: isize) {
        match self.focus {
            FocusPane::Nodes => {
                self.selected_node = move_selection(self.selected_node, self.nodes.len(), delta);
            }
            FocusPane::Query => {
                self.selected_query_result =
                    move_selection(self.selected_query_result, self.query_results.len(), delta);
            }
            FocusPane::Local => {
                if self.local_drill_down {
                    self.selected_local_series =
                        move_selection(self.selected_local_series, self.local_series.len(), delta);
                } else {
                    self.selected_local_study =
                        move_selection(self.selected_local_study, self.local_studies.len(), delta);
                }
            }
            FocusPane::Logs | FocusPane::Input => {}
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

    pub(super) fn selected_query_result(&self) -> Option<&QueryMatch> {
        self.selected_query_result
            .and_then(|index| self.query_results.get(index))
    }

    pub(super) fn enter_local_drill_down(&mut self) -> anyhow::Result<()> {
        let Some(study) = self.selected_local_study().cloned() else {
            return Ok(());
        };

        self.local_series = self.services.local_series(&study.study_instance_uid)?;
        self.selected_local_series = normalized_selection(None, self.local_series.len());
        self.local_drill_down = true;
        self.drill_down_study_uid = Some(study.study_instance_uid);

        Ok(())
    }

    pub(super) fn clear_local_drill_down(&mut self) {
        self.selected_local_series = None;
        self.local_drill_down = false;
    }

    pub(super) fn reset_local_drill_down_cache(&mut self) {
        self.clear_local_drill_down();
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
