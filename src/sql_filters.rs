//! Parameterized SQL WHERE clause construction for local inventory filters.
//!
//! This module is intentionally narrow in scope: it builds `WHERE` fragments and
//! a parallel ordered parameter list, leaving query execution to callers.

use crate::filters::{SeriesFilters, StudyFilters};

/// An owned SQL fragment with positional parameters (`?1`, `?2`, ...).
#[derive(Debug, Default, Clone, PartialEq, Eq)]
pub struct WhereClause {
    /// The SQL fragment starting with `WHERE ...` or an empty string if there
    /// are no conditions.
    pub sql: String,

    /// Ordered parameter values corresponding to the positional placeholders.
    pub params: Vec<String>,
}

impl WhereClause {
    fn push_condition(&mut self, condition: impl AsRef<str>, value: String) {
        if self.sql.is_empty() {
            self.sql.push_str("WHERE ");
        } else {
            self.sql.push_str(" AND ");
        }
        self.sql.push_str(condition.as_ref());
        self.params.push(value);
    }

    fn next_param_index(&self) -> usize {
        self.params.len() + 1
    }
}

fn like_pattern(s: &str) -> String {
    format!("%{}%", s)
}

/// Parse a filter value that may represent an exact match or an inclusive range.
///
/// Supported forms:
/// - `VALUE` => exact
/// - `..END` => <= END
/// - `START..` => >= START
/// - `START..END` => between START and END (inclusive)
fn parse_range_expr(s: &str) -> (Option<&str>, Option<&str>) {
    if let Some((a, b)) = s.split_once("..") {
        let start = (!a.is_empty()).then_some(a);
        let end = (!b.is_empty()).then_some(b);
        (start, end)
    } else {
        (Some(s), Some(s))
    }
}

fn push_range_condition(out: &mut WhereClause, column: &str, value: &str) {
    let (start, end) = parse_range_expr(value);
    match (start, end) {
        (Some(start), Some(end)) if start == end => {
            let idx = out.next_param_index();
            out.push_condition(format!("{column} = ?{idx}"), start.to_string());
        }
        (Some(start), Some(end)) => {
            let idx1 = out.next_param_index();
            out.push_condition(format!("{column} >= ?{idx1}"), start.to_string());
            let idx2 = out.next_param_index();
            out.push_condition(format!("{column} <= ?{idx2}"), end.to_string());
        }
        (Some(start), None) => {
            let idx = out.next_param_index();
            out.push_condition(format!("{column} >= ?{idx}"), start.to_string());
        }
        (None, Some(end)) => {
            let idx = out.next_param_index();
            out.push_condition(format!("{column} <= ?{idx}"), end.to_string());
        }
        (None, None) => {}
    }
}

/// Build a parameterized WHERE clause for querying `local_studies`.
///
/// Matching semantics:
/// - Text fields: case-insensitive substring via `LOWER(col) LIKE LOWER(?N)`
/// - Exact-ish fields (study date): equality for now (range support later)
/// - Modalities: not yet applied here (requires join/subquery; later subtask)
pub fn build_study_where_clause(filters: &StudyFilters) -> WhereClause {
    let mut out = WhereClause::default();

    if let Some(v) = filters.patient_name.as_ref().filter(|v| !v.is_empty()) {
        let idx = out.next_param_index();
        out.push_condition(
            format!("LOWER(patient_name) LIKE LOWER(?{idx})"),
            like_pattern(v),
        );
    }

    if let Some(v) = filters.patient_id.as_ref().filter(|v| !v.is_empty()) {
        let idx = out.next_param_index();
        out.push_condition(
            format!("LOWER(patient_id) LIKE LOWER(?{idx})"),
            like_pattern(v),
        );
    }

    if let Some(v) = filters.accession_number.as_ref().filter(|v| !v.is_empty()) {
        let idx = out.next_param_index();
        out.push_condition(
            format!(
                "EXISTS (SELECT 1 FROM local_instances li WHERE li.study_instance_uid = local_studies.study_instance_uid AND LOWER(li.accession_number) LIKE LOWER(?{idx}))"
            ),
            like_pattern(v),
        );
    }

    if let Some(v) = filters.study_description.as_ref().filter(|v| !v.is_empty()) {
        let idx = out.next_param_index();
        out.push_condition(
            format!("LOWER(study_description) LIKE LOWER(?{idx})"),
            like_pattern(v),
        );
    }

    if let Some(v) = filters.study_date.as_ref().filter(|v| !v.is_empty()) {
        // NOTE: `study_date` is exposed as NULLIF(study_date_max,'') in SELECT,
        // but ordering/real storage uses `study_date_max`. We filter on
        // `study_date_max` to match the denormalized table.
        push_range_condition(&mut out, "study_date_max", v);
    }

    // imported_at is only present on local_instances, not local_studies.
    // We support filtering studies by imported_at via a correlated subquery.
    if let Some(v) = filters.imported_at.as_ref().filter(|v| !v.is_empty()) {
        let (start, end) = parse_range_expr(v);

        if let (Some(start), Some(end)) = (start, end) {
            if start == end {
                let idx = out.next_param_index();
                out.push_condition(
                    format!(
                        "EXISTS (SELECT 1 FROM local_instances li WHERE li.study_instance_uid = local_studies.study_instance_uid AND li.imported_at = ?{idx})"
                    ),
                    start.to_string(),
                );
            } else {
                let idx1 = out.next_param_index();
                let idx2 = idx1 + 1;
                if out.sql.is_empty() {
                    out.sql.push_str("WHERE ");
                } else {
                    out.sql.push_str(" AND ");
                }
                out.sql.push_str(&format!(
                    "EXISTS (SELECT 1 FROM local_instances li WHERE li.study_instance_uid = local_studies.study_instance_uid AND li.imported_at >= ?{idx1} AND li.imported_at <= ?{idx2})",
                ));
                out.params.push(start.to_string());
                out.params.push(end.to_string());
            }
        } else if let Some(start) = start {
            let idx = out.next_param_index();
            out.push_condition(
                format!(
                    "EXISTS (SELECT 1 FROM local_instances li WHERE li.study_instance_uid = local_studies.study_instance_uid AND li.imported_at >= ?{idx})"
                ),
                start.to_string(),
            );
        } else if let Some(end) = end {
            let idx = out.next_param_index();
            out.push_condition(
                format!(
                    "EXISTS (SELECT 1 FROM local_instances li WHERE li.study_instance_uid = local_studies.study_instance_uid AND li.imported_at <= ?{idx})"
                ),
                end.to_string(),
            );
        }
    }

    if let Some(v) = filters.duplicate {
        // Duplicate definition in current schema:
        // - An instance is a "duplicate" if its SOPInstanceUID already exists OR its sha256 already exists.
        // There is no persisted boolean flag; we compute it via EXISTS subqueries.
        //
        // For studies, interpret duplicate=true as: at least one instance in the study
        // has a duplicate (by SOPInstanceUID or sha256) elsewhere in local_instances.
        // duplicate=false means: no instances in the study are duplicates.
        if out.sql.is_empty() {
            out.sql.push_str("WHERE ");
        } else {
            out.sql.push_str(" AND ");
        }
        if v {
            out.sql.push_str(
                "EXISTS (\
SELECT 1 FROM local_instances li \
WHERE li.study_instance_uid = local_studies.study_instance_uid \
  AND (\
    EXISTS(SELECT 1 FROM local_instances li2 WHERE li2.sop_instance_uid = li.sop_instance_uid AND li2.study_instance_uid <> li.study_instance_uid) \
    OR EXISTS(SELECT 1 FROM local_instances li3 WHERE li3.sha256 = li.sha256 AND li3.sop_instance_uid <> li.sop_instance_uid)\
  )\
)",
            );
        } else {
            out.sql.push_str(
                "NOT EXISTS (\
SELECT 1 FROM local_instances li \
WHERE li.study_instance_uid = local_studies.study_instance_uid \
  AND (\
    EXISTS(SELECT 1 FROM local_instances li2 WHERE li2.sop_instance_uid = li.sop_instance_uid AND li2.study_instance_uid <> li.study_instance_uid) \
    OR EXISTS(SELECT 1 FROM local_instances li3 WHERE li3.sha256 = li.sha256 AND li3.sop_instance_uid <> li.sop_instance_uid)\
  )\
)",
            );
        }
    }

    if let Some(v) = filters.source_path.as_ref().filter(|v| !v.is_empty()) {
        let idx = out.next_param_index();
        out.push_condition(
            format!(
                "EXISTS (SELECT 1 FROM local_instances li WHERE li.study_instance_uid = local_studies.study_instance_uid AND LOWER(li.source_path) LIKE LOWER(?{idx}))"
            ),
            like_pattern(v),
        );
    }

    // retrieved_at is not currently persisted in the local schema.

    if !filters.modalities.is_empty() {
        // local_studies stores modalities as a comma-separated aggregate, but we
        // treat modality filtering as "study has at least one instance with any
        // of the requested modalities" to avoid substring pitfalls.
        //
        // This uses a correlated EXISTS subquery so we can remain on
        // `local_studies` for study summaries.
        let mods = &filters.modalities;
        let placeholders: Vec<String> = (0..mods.len())
            .map(|i| format!("?{}", out.params.len() + i + 1))
            .collect();

        if out.sql.is_empty() {
            out.sql.push_str("WHERE ");
        } else {
            out.sql.push_str(" AND ");
        }

        out.sql.push_str(&format!(
            "EXISTS (SELECT 1 FROM local_instances li WHERE li.study_instance_uid = local_studies.study_instance_uid AND li.modality IN ({}))",
            placeholders.join(", ")
        ));

        for m in mods {
            out.params.push(m.clone());
        }
    }

    out
}

/// Build a parameterized WHERE clause for querying series (grouped out of
/// `local_instances`).
///
/// This expects the outer query to be selecting from `local_instances` and/or a
/// derived series grouping, so column names refer to `local_instances` fields.
pub fn build_series_where_clause(filters: &SeriesFilters) -> WhereClause {
    let mut out = WhereClause::default();

    if let Some(v) = filters
        .study_instance_uid
        .as_ref()
        .filter(|v| !v.is_empty())
    {
        let idx = out.next_param_index();
        out.push_condition(format!("study_instance_uid = ?{idx}"), v.clone());
    }

    if let Some(v) = filters.accession_number.as_ref().filter(|v| !v.is_empty()) {
        let idx = out.next_param_index();
        out.push_condition(
            format!("LOWER(accession_number) LIKE LOWER(?{idx})"),
            like_pattern(v),
        );
    }

    if let Some(v) = filters
        .series_description
        .as_ref()
        .filter(|v| !v.is_empty())
    {
        let idx = out.next_param_index();
        out.push_condition(
            format!("LOWER(series_description) LIKE LOWER(?{idx})"),
            like_pattern(v),
        );
    }

    if let Some(v) = filters.imported_at.as_ref().filter(|v| !v.is_empty()) {
        // Column is on local_instances, so range filtering is direct.
        push_range_condition(&mut out, "imported_at", v);
    }

    if !filters.modalities.is_empty() {
        let mods = &filters.modalities;
        let placeholders: Vec<String> = (0..mods.len())
            .map(|i| format!("?{}", out.params.len() + i + 1))
            .collect();

        if out.sql.is_empty() {
            out.sql.push_str("WHERE ");
        } else {
            out.sql.push_str(" AND ");
        }

        out.sql
            .push_str(&format!("modality IN ({})", placeholders.join(", ")));

        for m in mods {
            out.params.push(m.clone());
        }
    }

    if let Some(v) = filters.duplicate {
        // Duplicate definition in current schema:
        // - An instance is a "duplicate" if its SOPInstanceUID already exists OR its sha256 already exists.
        // There is no persisted boolean flag; we compute it via EXISTS subqueries.
        //
        // For series, interpret duplicate=true as: at least one instance in the series
        // has a duplicate (by SOPInstanceUID or sha256) elsewhere in local_instances.
        // duplicate=false means: no instances in the series are duplicates.
        if out.sql.is_empty() {
            out.sql.push_str("WHERE ");
        } else {
            out.sql.push_str(" AND ");
        }
        if v {
            out.sql.push_str(
                "EXISTS(\
SELECT 1 FROM local_instances li_dup \
WHERE li_dup.series_instance_uid = series_instance_uid \
  AND (\
    EXISTS(SELECT 1 FROM local_instances li2 WHERE li2.sop_instance_uid = li_dup.sop_instance_uid AND li2.series_instance_uid <> li_dup.series_instance_uid) \
    OR EXISTS(SELECT 1 FROM local_instances li3 WHERE li3.sha256 = li_dup.sha256 AND li3.sop_instance_uid <> li_dup.sop_instance_uid)\
  )\
)",
            );
        } else {
            out.sql.push_str(
                "NOT EXISTS(\
SELECT 1 FROM local_instances li_dup \
WHERE li_dup.series_instance_uid = series_instance_uid \
  AND (\
    EXISTS(SELECT 1 FROM local_instances li2 WHERE li2.sop_instance_uid = li_dup.sop_instance_uid AND li2.series_instance_uid <> li_dup.series_instance_uid) \
    OR EXISTS(SELECT 1 FROM local_instances li3 WHERE li3.sha256 = li_dup.sha256 AND li3.sop_instance_uid <> li_dup.sop_instance_uid)\
  )\
)",
            );
        }
    }

    if let Some(v) = filters.source_path.as_ref().filter(|v| !v.is_empty()) {
        let idx = out.next_param_index();
        out.push_condition(
            format!("LOWER(source_path) LIKE LOWER(?{idx})"),
            like_pattern(v),
        );
    }

    // retrieved_at is not currently persisted in the local schema.

    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn build_study_where_clause_empty_filters_is_empty() {
        let filters = StudyFilters::default();
        let clause = build_study_where_clause(&filters);
        assert_eq!(clause.sql, "");
        assert!(clause.params.is_empty());
    }

    #[test]
    fn build_study_where_clause_adds_multiple_conditions_with_ordered_params() {
        let mut filters = StudyFilters::default();
        filters.patient_name = Some("Alice".to_string());
        filters.patient_id = Some("123".to_string());
        filters.study_description = Some("head".to_string());
        filters.study_date = Some("20250101".to_string());

        let clause = build_study_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE LOWER(patient_name) LIKE LOWER(?1) AND LOWER(patient_id) LIKE LOWER(?2) AND LOWER(study_description) LIKE LOWER(?3) AND study_date_max = ?4"
        );
        assert_eq!(
            clause.params,
            vec![
                "%Alice%".to_string(),
                "%123%".to_string(),
                "%head%".to_string(),
                "20250101".to_string()
            ]
        );
    }

    #[test]
    fn build_study_where_clause_supports_study_date_range() {
        let mut filters = StudyFilters::default();
        filters.study_date = Some("20250101..20250131".to_string());

        let clause = build_study_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE study_date_max >= ?1 AND study_date_max <= ?2"
        );
        assert_eq!(
            clause.params,
            vec!["20250101".to_string(), "20250131".to_string()]
        );
    }

    #[test]
    fn build_series_where_clause_supports_imported_at_open_ended_ranges() {
        let mut filters = SeriesFilters::default();
        filters.study_instance_uid = Some("1.2.3".to_string());
        filters.imported_at = Some("..2026-01-01T00:00:00Z".to_string());

        let clause = build_series_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE study_instance_uid = ?1 AND imported_at <= ?2"
        );
        assert_eq!(
            clause.params,
            vec!["1.2.3".to_string(), "2026-01-01T00:00:00Z".to_string()]
        );
    }

    #[test]
    fn build_series_where_clause_includes_study_uid_and_description() {
        let mut filters = SeriesFilters::default();
        filters.study_instance_uid = Some("1.2.3".to_string());
        filters.series_description = Some("t2".to_string());

        let clause = build_series_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE study_instance_uid = ?1 AND LOWER(series_description) LIKE LOWER(?2)"
        );
        assert_eq!(clause.params, vec!["1.2.3".to_string(), "%t2%".to_string()]);
    }

    #[test]
    fn build_series_where_clause_supports_multi_value_modalities() {
        let mut filters = SeriesFilters::default();
        filters.study_instance_uid = Some("1.2.3".to_string());
        filters.modalities = vec!["CT".to_string(), "MR".to_string()];

        let clause = build_series_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE study_instance_uid = ?1 AND modality IN (?2, ?3)"
        );
        assert_eq!(
            clause.params,
            vec!["1.2.3".to_string(), "CT".to_string(), "MR".to_string()]
        );
    }

    #[test]
    fn build_series_where_clause_supports_duplicate_true() {
        let mut filters = SeriesFilters::default();
        filters.study_instance_uid = Some("1.2.3".to_string());
        filters.duplicate = Some(true);

        let clause = build_series_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE study_instance_uid = ?1 AND EXISTS(\
SELECT 1 FROM local_instances li_dup \
WHERE li_dup.series_instance_uid = series_instance_uid \
  AND (\
    EXISTS(SELECT 1 FROM local_instances li2 WHERE li2.sop_instance_uid = li_dup.sop_instance_uid AND li2.series_instance_uid <> li_dup.series_instance_uid) \
    OR EXISTS(SELECT 1 FROM local_instances li3 WHERE li3.sha256 = li_dup.sha256 AND li3.sop_instance_uid <> li_dup.sop_instance_uid)\
  )\
)"
        );
        assert_eq!(clause.params, vec!["1.2.3".to_string()]);
    }

    #[test]
    fn build_series_where_clause_supports_duplicate_false() {
        let mut filters = SeriesFilters::default();
        filters.study_instance_uid = Some("1.2.3".to_string());
        filters.duplicate = Some(false);

        let clause = build_series_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE study_instance_uid = ?1 AND NOT EXISTS(\
SELECT 1 FROM local_instances li_dup \
WHERE li_dup.series_instance_uid = series_instance_uid \
  AND (\
    EXISTS(SELECT 1 FROM local_instances li2 WHERE li2.sop_instance_uid = li_dup.sop_instance_uid AND li2.series_instance_uid <> li_dup.series_instance_uid) \
    OR EXISTS(SELECT 1 FROM local_instances li3 WHERE li3.sha256 = li_dup.sha256 AND li3.sop_instance_uid <> li_dup.sop_instance_uid)\
  )\
)"
        );
        assert_eq!(clause.params, vec!["1.2.3".to_string()]);
    }

    #[test]
    fn build_study_where_clause_supports_duplicate_true() {
        let mut filters = StudyFilters::default();
        filters.duplicate = Some(true);

        let clause = build_study_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE EXISTS (\
SELECT 1 FROM local_instances li \
WHERE li.study_instance_uid = local_studies.study_instance_uid \
  AND (\
    EXISTS(SELECT 1 FROM local_instances li2 WHERE li2.sop_instance_uid = li.sop_instance_uid AND li2.study_instance_uid <> li.study_instance_uid) \
    OR EXISTS(SELECT 1 FROM local_instances li3 WHERE li3.sha256 = li.sha256 AND li3.sop_instance_uid <> li.sop_instance_uid)\
  )\
)"
        );
        assert!(clause.params.is_empty());
    }

    #[test]
    fn build_study_where_clause_supports_duplicate_false() {
        let mut filters = StudyFilters::default();
        filters.duplicate = Some(false);

        let clause = build_study_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE NOT EXISTS (\
SELECT 1 FROM local_instances li \
WHERE li.study_instance_uid = local_studies.study_instance_uid \
  AND (\
    EXISTS(SELECT 1 FROM local_instances li2 WHERE li2.sop_instance_uid = li.sop_instance_uid AND li2.study_instance_uid <> li.study_instance_uid) \
    OR EXISTS(SELECT 1 FROM local_instances li3 WHERE li3.sha256 = li.sha256 AND li3.sop_instance_uid <> li.sop_instance_uid)\
  )\
)"
        );
        assert!(clause.params.is_empty());
    }

    #[test]
    fn build_study_where_clause_supports_multi_value_modalities_via_exists() {
        let mut filters = StudyFilters::default();
        filters.modalities = vec!["CT".to_string(), "MR".to_string()];

        let clause = build_study_where_clause(&filters);
        assert_eq!(
            clause.sql,
            "WHERE EXISTS (SELECT 1 FROM local_instances li WHERE li.study_instance_uid = local_studies.study_instance_uid AND li.modality IN (?1, ?2))"
        );
        assert_eq!(clause.params, vec!["CT".to_string(), "MR".to_string()]);
    }

    #[test]
    fn build_where_clause_ignores_empty_string_values() {
        let mut filters = StudyFilters::default();
        filters.patient_name = Some("".to_string());
        let clause = build_study_where_clause(&filters);
        assert_eq!(clause.sql, "");
        assert!(clause.params.is_empty());
    }
}
