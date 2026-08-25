//! Contextual footer suggestions.
//!
//! This module is intentionally small and pure: it defines the minimal data model
//! used to describe a "next action" suggestion based on current UI context.

use super::state::FocusPane;
use super::tr;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
#[cfg_attr(not(test), allow(dead_code))]
pub(super) enum SuggestionKind {
    Shortcut,
    Command,
}

#[derive(Clone, Debug, Eq, PartialEq)]
#[cfg_attr(not(test), allow(dead_code))]
pub(super) struct Suggestion {
    pub(super) kind: SuggestionKind,
    /// Human-facing text meant to appear after a "Next:" label.
    pub(super) text: String,
}

#[cfg_attr(not(test), allow(dead_code))]
impl Suggestion {
    pub(super) fn shortcut(text: impl Into<String>) -> Self {
        Self {
            kind: SuggestionKind::Shortcut,
            text: text.into(),
        }
    }

    pub(super) fn command(text: impl Into<String>) -> Self {
        Self {
            kind: SuggestionKind::Command,
            text: text.into(),
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
#[cfg_attr(not(test), allow(dead_code))]
pub(super) struct SuggestionContext {
    pub(super) focus: FocusPane,
    pub(super) has_selected_node: bool,
    pub(super) has_selected_query_result: bool,
    pub(super) has_query_results: bool,
    pub(super) local_drill_down: bool,
    pub(super) local_instance_drill_down: bool,
    pub(super) has_selected_local_study: bool,
    pub(super) has_selected_local_series: bool,
    pub(super) has_selected_local_instance: bool,
    pub(super) has_running_task: bool,
    pub(super) has_queued_tasks: bool,
    pub(super) show_help: bool,
}

#[cfg_attr(not(test), allow(dead_code))]
impl SuggestionContext {
    pub(super) fn new(focus: FocusPane) -> Self {
        Self {
            focus,
            has_selected_node: false,
            has_selected_query_result: false,
            has_query_results: false,
            local_drill_down: false,
            local_instance_drill_down: false,
            has_selected_local_study: false,
            has_selected_local_series: false,
            has_selected_local_instance: false,
            has_running_task: false,
            has_queued_tasks: false,
            show_help: false,
        }
    }
}

#[cfg_attr(not(test), allow(dead_code))]
pub(super) struct SuggestionRule {
    pub(super) matches: fn(SuggestionContext) -> bool,
    pub(super) suggestion: fn(SuggestionContext) -> Suggestion,
}

#[cfg_attr(not(test), allow(dead_code))]
pub(super) const SUGGESTION_RULES_V1: &[SuggestionRule] = &[
    // Help explicitly requested.
    SuggestionRule {
        matches: |ctx| ctx.show_help,
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.help")),
    },
    // Nodes pane.
    SuggestionRule {
        matches: |ctx| ctx.focus == FocusPane::Nodes && ctx.has_selected_node,
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.query-node")),
    },
    SuggestionRule {
        matches: |ctx| ctx.focus == FocusPane::Nodes,
        suggestion: |_| Suggestion::command(tr("tui.suggest.node-add")),
    },
    // Query pane.
    SuggestionRule {
        matches: |ctx| {
            ctx.focus == FocusPane::Query && ctx.has_query_results && ctx.has_selected_query_result
        },
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.retrieve")),
    },
    SuggestionRule {
        matches: |ctx| ctx.focus == FocusPane::Query,
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.query")),
    },
    // Local pane.
    SuggestionRule {
        matches: |ctx| {
            ctx.focus == FocusPane::Local && !ctx.local_drill_down && ctx.has_selected_local_study
        },
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.view-series")),
    },
    SuggestionRule {
        matches: |ctx| {
            ctx.focus == FocusPane::Local && ctx.local_drill_down && !ctx.local_instance_drill_down
        },
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.send-series")),
    },
    SuggestionRule {
        matches: |ctx| ctx.focus == FocusPane::Local && ctx.local_instance_drill_down,
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.back-series")),
    },
    // Tasks pane.
    SuggestionRule {
        matches: |ctx| ctx.focus == FocusPane::Tasks,
        suggestion: |ctx| {
            if ctx.has_running_task || ctx.has_queued_tasks {
                Suggestion::shortcut(tr("tui.suggest.inspect-task"))
            } else {
                Suggestion::shortcut(tr("tui.suggest.help"))
            }
        },
    },
    // Config pane.
    SuggestionRule {
        matches: |ctx| ctx.focus == FocusPane::Config,
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.edit-config")),
    },
    // Input pane.
    SuggestionRule {
        matches: |ctx| ctx.focus == FocusPane::Input,
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.run-command")),
    },
    // Generic fallback.
    SuggestionRule {
        matches: |_| true,
        suggestion: |_| Suggestion::shortcut(tr("tui.suggest.help")),
    },
];

#[cfg_attr(not(test), allow(dead_code))]
pub(super) fn resolve_top_suggestion(ctx: SuggestionContext) -> Suggestion {
    for rule in SUGGESTION_RULES_V1 {
        if (rule.matches)(ctx) {
            return (rule.suggestion)(ctx);
        }
    }

    // The rules table ends with an always() fallback, so this should never happen.
    Suggestion::shortcut(tr("tui.suggest.help"))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn help_requested_overrides_everything() {
        let mut ctx = SuggestionContext::new(FocusPane::Nodes);
        ctx.has_selected_node = true;
        ctx.show_help = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.help"))
        );
    }

    #[test]
    fn nodes_with_selection_suggests_query_shortcut() {
        let mut ctx = SuggestionContext::new(FocusPane::Nodes);
        ctx.has_selected_node = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.query-node"))
        );
    }

    #[test]
    fn nodes_without_selection_suggests_node_add_command() {
        let ctx = SuggestionContext::new(FocusPane::Nodes);
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::command(tr("tui.suggest.node-add"))
        );
    }

    #[test]
    fn query_with_results_and_selection_suggests_retrieve_shortcut() {
        let mut ctx = SuggestionContext::new(FocusPane::Query);
        ctx.has_query_results = true;
        ctx.has_selected_query_result = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.retrieve"))
        );
    }

    #[test]
    fn query_without_selection_suggests_query_shortcut() {
        let mut ctx = SuggestionContext::new(FocusPane::Query);
        ctx.has_query_results = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.query"))
        );
    }

    #[test]
    fn local_studies_level_suggests_enter_to_view_series() {
        let mut ctx = SuggestionContext::new(FocusPane::Local);
        ctx.has_selected_local_study = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.view-series"))
        );
    }

    #[test]
    fn local_series_level_suggests_send_series_shortcut() {
        let mut ctx = SuggestionContext::new(FocusPane::Local);
        ctx.local_drill_down = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.send-series"))
        );
    }

    #[test]
    fn local_instances_level_suggests_escape_back() {
        let mut ctx = SuggestionContext::new(FocusPane::Local);
        ctx.local_drill_down = true;
        ctx.local_instance_drill_down = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.back-series"))
        );
    }

    #[test]
    fn tasks_with_pending_or_running_suggests_inspect() {
        let mut ctx = SuggestionContext::new(FocusPane::Tasks);
        ctx.has_running_task = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.inspect-task"))
        );

        let mut ctx = SuggestionContext::new(FocusPane::Tasks);
        ctx.has_queued_tasks = true;
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.inspect-task"))
        );
    }

    #[test]
    fn tasks_without_anything_falls_back_to_help() {
        let ctx = SuggestionContext::new(FocusPane::Tasks);
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.help"))
        );
    }

    #[test]
    fn config_suggests_edit_config_shortcut() {
        let ctx = SuggestionContext::new(FocusPane::Config);
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.edit-config"))
        );
    }

    #[test]
    fn input_suggests_enter_to_run_command() {
        let ctx = SuggestionContext::new(FocusPane::Input);
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.run-command"))
        );
    }

    #[test]
    fn unknown_context_returns_generic_help_hint() {
        let ctx = SuggestionContext::new(FocusPane::Logs);
        assert_eq!(
            resolve_top_suggestion(ctx),
            Suggestion::shortcut(tr("tui.suggest.help"))
        );
    }
}
