use anyhow::anyhow;
use dicom_core::{
    dictionary::{DataDictionary, DataDictionaryEntry},
    header::Header,
    DataElement, PrimitiveValue, Tag, VR,
};
use dicom_dictionary_std::{tags, StandardDataDictionary};

use crate::{
    dicom::{clean_dicom_str, get_str_opt_from_mem, put_string, DefaultMemObject},
    models::{QueryCriteria, QueryLevel, QueryModel},
};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct AttributePath {
    tag: Tag,
}

impl AttributePath {
    pub fn tag(tag: Tag) -> Self {
        Self { tag }
    }

    pub fn dicom_tag(&self) -> Tag {
        self.tag
    }
}

impl From<Tag> for AttributePath {
    fn from(tag: Tag) -> Self {
        Self::tag(tag)
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum MatchingRule {
    SingleValue(String),
    Wildcard(String),
    Universal,
    Range {
        start: Option<String>,
        end: Option<String>,
    },
    UidList(Vec<String>),
    MultipleValues(Vec<String>),
    EmptyValue,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct QueryPredicate {
    pub path: AttributePath,
    pub rule: MatchingRule,
}

impl QueryPredicate {
    pub fn new(tag: Tag, rule: MatchingRule) -> Self {
        Self {
            path: AttributePath::tag(tag),
            rule,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ArchiveQuery {
    pub model: QueryModel,
    pub level: QueryLevel,
    pub predicates: Vec<QueryPredicate>,
    pub return_keys: Vec<AttributePath>,
    pub limit: Option<usize>,
    pub offset: Option<usize>,
}

impl ArchiveQuery {
    pub fn new(model: QueryModel, level: QueryLevel) -> Self {
        Self {
            model,
            level,
            predicates: Vec::new(),
            return_keys: Vec::new(),
            limit: None,
            offset: None,
        }
    }

    pub fn from_criteria(criteria: &QueryCriteria) -> Self {
        let mut query = Self::new(criteria.model, criteria.level);
        push_optional_predicate(&mut query, tags::PATIENT_NAME, &criteria.patient_name);
        push_optional_predicate(&mut query, tags::PATIENT_ID, &criteria.patient_id);
        push_optional_predicate(
            &mut query,
            tags::ACCESSION_NUMBER,
            &criteria.accession_number,
        );
        push_optional_predicate(
            &mut query,
            tags::STUDY_INSTANCE_UID,
            &criteria.study_instance_uid,
        );
        push_optional_predicate(
            &mut query,
            tags::SERIES_INSTANCE_UID,
            &criteria.series_instance_uid,
        );
        push_optional_predicate(
            &mut query,
            tags::SOP_INSTANCE_UID,
            &criteria.sop_instance_uid,
        );
        push_optional_predicate(&mut query, tags::MODALITY, &criteria.modality);
        push_optional_predicate(
            &mut query,
            tags::STUDY_DESCRIPTION,
            &criteria.study_description,
        );
        if criteria.study_date_from.is_some() || criteria.study_date_to.is_some() {
            query.predicates.push(QueryPredicate::new(
                tags::STUDY_DATE,
                MatchingRule::Range {
                    start: criteria.study_date_from.clone(),
                    end: criteria.study_date_to.clone(),
                },
            ));
        }
        query
    }

    pub fn from_find_identifier(model: QueryModel, identifier: &DefaultMemObject) -> Result<Self> {
        let level_value = get_str_opt_from_mem(identifier, tags::QUERY_RETRIEVE_LEVEL)
            .ok_or_else(|| {
                anyhow!(
                    "{}",
                    crate::error::msg_with(
                        "error-net-missing-qr-level",
                        [("operation", "C-FIND")],
                    )
                )
            })?;
        let level = match level_value.as_str() {
            "PATIENT" => QueryLevel::Patient,
            "STUDY" => QueryLevel::Study,
            "SERIES" => QueryLevel::Series,
            "IMAGE" => QueryLevel::Image,
            other => {
                return Err(anyhow!(
                    "{}",
                    crate::error::msg_with("error-net-unsupported-qr-level", [("level", other)])
                ))
            }
        };
        let mut query = Self::new(model, level);

        for element in identifier.iter() {
            let tag = element.tag();
            if tag == tags::QUERY_RETRIEVE_LEVEL {
                continue;
            }
            let Ok(value) = element.value().to_str() else {
                continue;
            };
            let value = clean_dicom_str(value.as_ref());
            if value.is_empty() {
                query.return_keys.push(AttributePath::tag(tag));
            } else {
                query.predicates.push(QueryPredicate::new(
                    tag,
                    matching_rule_for_identifier(tag, &value),
                ));
            }
        }

        Ok(query)
    }

    pub fn with_predicate(mut self, predicate: QueryPredicate) -> Self {
        self.predicates.push(predicate);
        self
    }

    pub fn with_return_key(mut self, tag: Tag) -> Self {
        self.return_keys.push(AttributePath::tag(tag));
        self
    }

    pub fn with_return_path(mut self, path: AttributePath) -> Self {
        self.return_keys.push(path);
        self
    }

    pub fn with_limit(mut self, limit: usize) -> Self {
        self.limit = Some(limit);
        self
    }

    pub fn with_offset(mut self, offset: usize) -> Self {
        self.offset = Some(offset);
        self
    }

    pub fn compile(&self) -> Result<CompiledArchiveQuery> {
        compile_archive_query(self)
    }
}

#[derive(Debug, Clone)]
pub struct ArchiveQueryEntry {
    pub level: QueryLevel,
    pub object: DefaultMemObject,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CompiledArchiveQuery {
    pub sql: String,
    pub params: Vec<String>,
    pub level: QueryLevel,
    pub(crate) return_keys: Vec<AttributePath>,
}

pub type Result<T> = std::result::Result<T, anyhow::Error>;

pub fn compile_archive_query(query: &ArchiveQuery) -> Result<CompiledArchiveQuery> {
    validate_model_level(query.model, query.level)?;

    let mut params = Vec::new();
    let mut where_parts = Vec::new();
    for predicate in &query.predicates {
        push_predicate_sql(predicate, &mut where_parts, &mut params);
    }

    let select_parts = if query.return_keys.is_empty() {
        vec!["1 AS _match".to_string()]
    } else {
        query
            .return_keys
            .iter()
            .enumerate()
            .map(|(index, path)| {
                format!(
                    "{} AS return_{}",
                    return_expr_for_path(*path, query.level),
                    index
                )
            })
            .collect()
    };

    let mut sql = format!(
        "SELECT {}\nFROM local_instances li",
        select_parts.join(", ")
    );
    if !where_parts.is_empty() {
        sql.push_str("\nWHERE ");
        sql.push_str(&where_parts.join(" AND "));
    }
    if let Some(group_by) = group_by_for_level(query.level) {
        sql.push_str("\nGROUP BY ");
        sql.push_str(group_by);
    }
    sql.push_str("\n");
    sql.push_str(order_by_for_level(query.level));

    if let Some(limit) = query.limit {
        let idx = params.len() + 1;
        sql.push_str(&format!("\nLIMIT ?{idx}"));
        params.push(limit.to_string());
    }
    if let Some(offset) = query.offset {
        let idx = params.len() + 1;
        sql.push_str(&format!("\nOFFSET ?{idx}"));
        params.push(offset.to_string());
    }

    Ok(CompiledArchiveQuery {
        sql,
        params,
        level: query.level,
        return_keys: query.return_keys.clone(),
    })
}

pub(crate) fn archive_query_entry_from_values(
    level: QueryLevel,
    return_keys: &[AttributePath],
    values: Vec<Option<String>>,
) -> ArchiveQueryEntry {
    let mut object = DefaultMemObject::new_empty();
    put_string(
        &mut object,
        tags::QUERY_RETRIEVE_LEVEL,
        VR::CS,
        level.as_dicom_str(),
    );

    for (path, value) in return_keys.iter().zip(values) {
        if let Some(value) = value.filter(|value| !value.is_empty()) {
            object.put(DataElement::new(
                path.dicom_tag(),
                vr_for_tag(path.dicom_tag()),
                PrimitiveValue::from(value),
            ));
        }
    }

    ArchiveQueryEntry { level, object }
}

fn push_optional_predicate(query: &mut ArchiveQuery, tag: Tag, value: &Option<String>) {
    if let Some(value) = value.as_ref().filter(|value| !value.trim().is_empty()) {
        query.predicates.push(QueryPredicate::new(
            tag,
            matching_rule_for_identifier(tag, value),
        ));
    }
}

fn matching_rule_for_identifier(tag: Tag, value: &str) -> MatchingRule {
    if tag == tags::STUDY_DATE && value.contains('-') {
        let (start, end) = value.split_once('-').unwrap_or((value, ""));
        return MatchingRule::Range {
            start: (!start.is_empty()).then(|| start.to_string()),
            end: (!end.is_empty()).then(|| end.to_string()),
        };
    }

    if tag == tags::STUDY_INSTANCE_UID
        || tag == tags::SERIES_INSTANCE_UID
        || tag == tags::SOP_INSTANCE_UID
    {
        if value.contains('\\') {
            return MatchingRule::UidList(split_multi_value(value));
        }
    }

    if value.contains('\\') {
        return MatchingRule::MultipleValues(split_multi_value(value));
    }

    if value
        .chars()
        .any(|character| matches!(character, '*' | '?'))
    {
        return MatchingRule::Wildcard(value.to_string());
    }

    MatchingRule::SingleValue(value.to_string())
}

fn split_multi_value(value: &str) -> Vec<String> {
    value
        .split('\\')
        .map(str::trim)
        .filter(|part| !part.is_empty())
        .map(str::to_string)
        .collect()
}

fn validate_model_level(model: QueryModel, level: QueryLevel) -> Result<()> {
    if model == QueryModel::StudyRoot && level == QueryLevel::Patient {
        return Err(anyhow!(
            "{}",
            crate::error::msg("error-archive-study-root-patient-query")
        ));
    }
    Ok(())
}

fn push_predicate_sql(
    predicate: &QueryPredicate,
    where_parts: &mut Vec<String>,
    params: &mut Vec<String>,
) {
    let expr = predicate_expr(predicate.path);
    match &predicate.rule {
        MatchingRule::Universal => {}
        MatchingRule::SingleValue(value) => {
            let idx = push_param(params, value);
            where_parts.push(format!("{expr} = ?{idx}"));
        }
        MatchingRule::Wildcard(value) => {
            let pattern = dicom_wildcard_to_sql_like(value);
            let idx = push_param(params, &pattern);
            where_parts.push(format!("{expr} LIKE ?{idx} ESCAPE '\\'"));
        }
        MatchingRule::Range { start, end } => match (start, end) {
            (Some(start), Some(end)) => {
                let start_idx = push_param(params, start);
                let end_idx = push_param(params, end);
                where_parts.push(format!("{expr} >= ?{start_idx} AND {expr} <= ?{end_idx}"));
            }
            (Some(start), None) => {
                let idx = push_param(params, start);
                where_parts.push(format!("{expr} >= ?{idx}"));
            }
            (None, Some(end)) => {
                let idx = push_param(params, end);
                where_parts.push(format!("{expr} <= ?{idx}"));
            }
            (None, None) => {}
        },
        MatchingRule::UidList(values) | MatchingRule::MultipleValues(values) => {
            if values.is_empty() {
                where_parts.push("1 = 0".to_string());
            } else {
                let placeholders = values
                    .iter()
                    .map(|value| format!("?{}", push_param(params, value)))
                    .collect::<Vec<_>>();
                where_parts.push(format!("{expr} IN ({})", placeholders.join(", ")));
            }
        }
        MatchingRule::EmptyValue => {
            where_parts.push(format!("({expr} IS NULL OR {expr} = '')"));
        }
    }
}

fn push_param(params: &mut Vec<String>, value: &str) -> usize {
    params.push(value.to_string());
    params.len()
}

fn predicate_expr(path: AttributePath) -> String {
    if let Some(column) = column_for_tag(path.dicom_tag()) {
        format!("li.{column}")
    } else {
        json_extract_expr("li.attributes_json", path)
    }
}

fn return_expr_for_path(path: AttributePath, level: QueryLevel) -> String {
    if let Some(expr) = aggregate_return_expr_for_path(path, level) {
        return expr.to_string();
    }

    if let Some(column) = column_for_tag(path.dicom_tag()) {
        if path.dicom_tag() == tags::MODALITIES_IN_STUDY {
            return "GROUP_CONCAT(DISTINCT li.modality)".to_string();
        }
        match level {
            QueryLevel::Image => format!("li.{column}"),
            QueryLevel::Patient | QueryLevel::Study | QueryLevel::Series => {
                format!("MAX(li.{column})")
            }
        }
    } else {
        let expr = json_extract_expr("li.attributes_json", path);
        match level {
            QueryLevel::Image => expr,
            QueryLevel::Patient | QueryLevel::Study | QueryLevel::Series => format!("MAX({expr})"),
        }
    }
}

fn aggregate_return_expr_for_path(path: AttributePath, level: QueryLevel) -> Option<&'static str> {
    match (path.dicom_tag(), level) {
        (tags::NUMBER_OF_STUDY_RELATED_SERIES, QueryLevel::Study) => {
            Some("CAST(COUNT(DISTINCT li.series_instance_uid) AS TEXT)")
        }
        (tags::NUMBER_OF_STUDY_RELATED_INSTANCES, QueryLevel::Study) => {
            Some("CAST(COUNT(DISTINCT li.sop_instance_uid) AS TEXT)")
        }
        (tags::NUMBER_OF_SERIES_RELATED_INSTANCES, QueryLevel::Series) => {
            Some("CAST(COUNT(DISTINCT li.sop_instance_uid) AS TEXT)")
        }
        _ => None,
    }
}

fn column_for_tag(tag: Tag) -> Option<&'static str> {
    match tag {
        tags::PATIENT_NAME => Some("patient_name"),
        tags::PATIENT_ID => Some("patient_id"),
        tags::ACCESSION_NUMBER => Some("accession_number"),
        tags::STUDY_INSTANCE_UID => Some("study_instance_uid"),
        tags::STUDY_DATE => Some("study_date"),
        tags::STUDY_DESCRIPTION => Some("study_description"),
        tags::MODALITY => Some("modality"),
        tags::MODALITIES_IN_STUDY => Some("modality"),
        tags::SERIES_INSTANCE_UID => Some("series_instance_uid"),
        tags::SERIES_DESCRIPTION => Some("series_description"),
        tags::SERIES_NUMBER => Some("series_number"),
        tags::SOP_CLASS_UID => Some("sop_class_uid"),
        tags::SOP_INSTANCE_UID => Some("sop_instance_uid"),
        tags::INSTANCE_NUMBER => Some("instance_number"),
        _ => None,
    }
}

fn group_by_for_level(level: QueryLevel) -> Option<&'static str> {
    match level {
        QueryLevel::Patient => Some("li.patient_id, li.patient_name"),
        QueryLevel::Study => Some("li.study_instance_uid"),
        QueryLevel::Series => Some("li.series_instance_uid"),
        QueryLevel::Image => None,
    }
}

fn order_by_for_level(level: QueryLevel) -> &'static str {
    match level {
        QueryLevel::Patient => "ORDER BY li.patient_id, li.patient_name",
        QueryLevel::Study => "ORDER BY MAX(li.study_date) DESC, li.study_instance_uid",
        QueryLevel::Series => {
            "ORDER BY MIN(li.series_number_sort_class), CASE WHEN MIN(li.series_number_sort_class) = 0 THEN MIN(li.series_number_sort_int) END, MAX(li.series_number), li.series_instance_uid"
        }
        QueryLevel::Image => {
            "ORDER BY li.instance_number_sort_class, CASE WHEN li.instance_number_sort_class = 0 THEN li.instance_number_sort_int END, li.instance_number, li.sop_instance_uid"
        }
    }
}

fn dicom_wildcard_to_sql_like(value: &str) -> String {
    let mut out = String::new();
    for character in value.chars() {
        match character {
            '*' => out.push('%'),
            '?' => out.push('_'),
            '%' | '_' | '\\' => {
                out.push('\\');
                out.push(character);
            }
            _ => out.push(character),
        }
    }
    out
}

fn json_extract_expr(json_column: &str, path: AttributePath) -> String {
    format!(
        "json_extract({json_column}, {})",
        quote_sql_string(&json_path_for_tag(path.dicom_tag()))
    )
}

fn json_path_for_tag(tag: Tag) -> String {
    let key = attribute_json_key(tag);
    format!("$.{}", json_path_key(&key))
}

fn attribute_json_key(tag: Tag) -> String {
    let dictionary = StandardDataDictionary;
    dictionary
        .by_tag(tag)
        .map(|entry| entry.alias().to_string())
        .unwrap_or_else(|| format!("({:04X},{:04X})", tag.0, tag.1))
}

fn json_path_key(key: &str) -> String {
    if key
        .chars()
        .all(|character| character.is_ascii_alphanumeric() || character == '_')
    {
        key.to_string()
    } else {
        format!("\"{}\"", key.replace('"', "\\\""))
    }
}

fn quote_sql_string(value: &str) -> String {
    format!("'{}'", value.replace('\'', "''"))
}

fn vr_for_tag(tag: Tag) -> VR {
    let dictionary = StandardDataDictionary;
    dictionary
        .by_tag(tag)
        .map(|entry| entry.vr().relaxed())
        .unwrap_or(VR::LO)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn wildcard_conversion_escapes_sql_like_metacharacters() {
        assert_eq!(
            dicom_wildcard_to_sql_like("A*B?C%D_E\\F"),
            "A%B_C\\%D\\_E\\\\F"
        );
    }

    #[test]
    fn identifier_parser_separates_return_keys_from_matching_keys() {
        let mut identifier = DefaultMemObject::new_empty();
        put_string(&mut identifier, tags::QUERY_RETRIEVE_LEVEL, VR::CS, "STUDY");
        put_string(&mut identifier, tags::PATIENT_NAME, VR::PN, "DOE*");
        identifier.put(DataElement::new(
            tags::STUDY_INSTANCE_UID,
            VR::UI,
            PrimitiveValue::from(""),
        ));

        let query = ArchiveQuery::from_find_identifier(QueryModel::StudyRoot, &identifier).unwrap();

        assert_eq!(query.level, QueryLevel::Study);
        assert_eq!(query.predicates.len(), 1);
        assert_eq!(
            query.return_keys,
            vec![AttributePath::tag(tags::STUDY_INSTANCE_UID)]
        );
        assert!(matches!(
            query.predicates[0].rule,
            MatchingRule::Wildcard(_)
        ));
    }

    #[test]
    fn compile_does_not_interpolate_user_values() {
        let query = ArchiveQuery::new(QueryModel::StudyRoot, QueryLevel::Study).with_predicate(
            QueryPredicate::new(
                tags::PATIENT_NAME,
                MatchingRule::SingleValue("DOE%' OR 1=1 --".to_string()),
            ),
        );

        let compiled = query.compile().unwrap();

        assert!(!compiled.sql.contains("DOE%"));
        assert_eq!(compiled.params, vec!["DOE%' OR 1=1 --".to_string()]);
    }
}
