use std::{fmt, str::FromStr};

use anyhow::{anyhow, Context};
use chrono::Utc;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, clap::ValueEnum, Default)]
#[value(rename_all = "kebab-case")]
pub enum QueryModel {
    PatientRoot,
    #[default]
    StudyRoot,
}

impl QueryModel {
    pub fn find_sop_class_uid(&self) -> &'static str {
        match self {
            QueryModel::PatientRoot => {
                dicom_dictionary_std::uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND
            }
            QueryModel::StudyRoot => {
                dicom_dictionary_std::uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND
            }
        }
    }

    pub fn move_sop_class_uid(&self) -> &'static str {
        match self {
            QueryModel::PatientRoot => {
                dicom_dictionary_std::uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE
            }
            QueryModel::StudyRoot => {
                dicom_dictionary_std::uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_MOVE
            }
        }
    }
}

impl fmt::Display for QueryModel {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            QueryModel::PatientRoot => write!(f, "patient-root"),
            QueryModel::StudyRoot => write!(f, "study-root"),
        }
    }
}

impl FromStr for QueryModel {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let normalized = s.trim().to_ascii_lowercase();
        match normalized.as_str() {
            "patient-root" | "patient" => Ok(Self::PatientRoot),
            "study-root" | "study" => Ok(Self::StudyRoot),
            _ => Err(anyhow!("unsupported query model: {s}")),
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, clap::ValueEnum, Default)]
#[value(rename_all = "kebab-case")]
pub enum QueryLevel {
    Patient,
    #[default]
    Study,
    Series,
    Image,
}

impl QueryLevel {
    pub fn as_dicom_str(&self) -> &'static str {
        match self {
            QueryLevel::Patient => "PATIENT",
            QueryLevel::Study => "STUDY",
            QueryLevel::Series => "SERIES",
            QueryLevel::Image => "IMAGE",
        }
    }
}

impl fmt::Display for QueryLevel {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            QueryLevel::Patient => write!(f, "patient"),
            QueryLevel::Study => write!(f, "study"),
            QueryLevel::Series => write!(f, "series"),
            QueryLevel::Image => write!(f, "image"),
        }
    }
}

impl FromStr for QueryLevel {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let normalized = s.trim().to_ascii_lowercase();
        match normalized.as_str() {
            "patient" => Ok(Self::Patient),
            "study" => Ok(Self::Study),
            "series" => Ok(Self::Series),
            "image" | "instance" => Ok(Self::Image),
            _ => Err(anyhow!("unsupported query level: {s}")),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RemoteNode {
    pub id: String,
    pub name: String,
    pub ae_title: String,
    pub host: String,
    pub port: u16,
    pub preferred_move_destination: Option<String>,
    pub notes: Option<String>,
    pub created_at: String,
    pub updated_at: String,
}

#[derive(Debug, Clone, Default)]
pub struct RemoteNodeDraft {
    pub name: String,
    pub ae_title: String,
    pub host: String,
    pub port: u16,
    pub preferred_move_destination: Option<String>,
    pub notes: Option<String>,
}

impl RemoteNodeDraft {
    pub fn into_new_node(self) -> anyhow::Result<RemoteNode> {
        let name = normalize_node_name(&self.name);
        let ae_title = normalize_ae_title(&self.ae_title);
        let host = self.host.trim().to_string();

        if name.is_empty() {
            return Err(anyhow!("node name cannot be empty"));
        }
        validate_ae_title(&ae_title)?;
        validate_port(self.port)?;
        if host.is_empty() {
            return Err(anyhow!("node host cannot be empty"));
        }

        let now = Utc::now().to_rfc3339();
        Ok(RemoteNode {
            id: Uuid::new_v4().to_string(),
            name,
            ae_title,
            host,
            port: self.port,
            preferred_move_destination: trim_to_option(self.preferred_move_destination),
            notes: trim_to_option(self.notes),
            created_at: now.clone(),
            updated_at: now,
        })
    }
}

#[derive(Debug, Clone, Default)]
pub struct RemoteNodePatch {
    pub name: Option<String>,
    pub ae_title: Option<String>,
    pub host: Option<String>,
    pub port: Option<u16>,
    pub preferred_move_destination: Option<String>,
    pub notes: Option<String>,
}

impl RemoteNodePatch {
    pub fn apply_to(self, mut node: RemoteNode) -> anyhow::Result<RemoteNode> {
        if let Some(name) = self.name {
            let name = normalize_node_name(&name);
            if !name.is_empty() {
                node.name = name;
            }
        }
        if let Some(ae_title) = self.ae_title {
            let ae_title = normalize_ae_title(&ae_title);
            validate_ae_title(&ae_title)?;
            node.ae_title = ae_title;
        }
        if let Some(host) = self.host {
            if !host.trim().is_empty() {
                node.host = host.trim().to_string();
            }
        }
        if let Some(port) = self.port {
            validate_port(port)?;
            node.port = port;
        }
        if let Some(move_destination) = self.preferred_move_destination {
            node.preferred_move_destination = trim_to_option(Some(move_destination));
        }
        if let Some(notes) = self.notes {
            node.notes = trim_to_option(Some(notes));
        }
        node.updated_at = Utc::now().to_rfc3339();
        Ok(node)
    }
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct QueryCriteria {
    pub model: QueryModel,
    pub level: QueryLevel,
    pub patient_name: Option<String>,
    pub patient_id: Option<String>,
    pub accession_number: Option<String>,
    pub study_instance_uid: Option<String>,
    pub series_instance_uid: Option<String>,
    pub sop_instance_uid: Option<String>,
    pub study_date_from: Option<String>,
    pub study_date_to: Option<String>,
    pub modality: Option<String>,
    pub study_description: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct QueryMatch {
    pub level: QueryLevel,
    pub patient_name: Option<String>,
    pub patient_id: Option<String>,
    pub accession_number: Option<String>,
    pub study_instance_uid: Option<String>,
    pub series_instance_uid: Option<String>,
    pub sop_instance_uid: Option<String>,
    pub study_date: Option<String>,
    pub study_description: Option<String>,
    pub series_description: Option<String>,
    pub series_number: Option<String>,
    pub modality: Option<String>,
    pub instance_number: Option<String>,
}

impl QueryMatch {
    pub fn primary_uid(&self) -> Option<&str> {
        self.sop_instance_uid
            .as_deref()
            .or(self.series_instance_uid.as_deref())
            .or(self.study_instance_uid.as_deref())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MoveRequest {
    pub node_name_or_id: String,
    pub model: QueryModel,
    pub level: QueryLevel,
    pub study_instance_uid: String,
    pub series_instance_uid: Option<String>,
    pub sop_instance_uid: Option<String>,
    pub move_destination: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MoveOutcome {
    pub final_status: u16,
    pub remaining: u32,
    pub completed: u32,
    pub failed: u32,
    pub warning: u32,
    pub started_at: String,
    pub finished_at: String,
}

impl Default for MoveOutcome {
    fn default() -> Self {
        let now = Utc::now().to_rfc3339();
        Self {
            final_status: 0,
            remaining: 0,
            completed: 0,
            failed: 0,
            warning: 0,
            started_at: now.clone(),
            finished_at: now,
        }
    }
}

#[derive(Debug, Clone, Copy, Default, PartialEq, Eq, Serialize, Deserialize)]
pub struct ScpSessionReport {
    pub received: u32,
    pub stored: u32,
    pub failed: u32,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct SendOutcome {
    pub attempted: usize,
    pub sent: usize,
    pub failed: usize,
    pub failures: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LocalInstance {
    pub study_instance_uid: String,
    pub series_instance_uid: String,
    pub sop_instance_uid: String,
    pub sop_class_uid: String,
    pub transfer_syntax_uid: Option<String>,
    pub patient_id: Option<String>,
    pub patient_name: Option<String>,
    pub accession_number: Option<String>,
    pub study_date: Option<String>,
    pub study_description: Option<String>,
    pub series_description: Option<String>,
    pub series_number: Option<String>,
    pub modality: Option<String>,
    pub instance_number: Option<String>,
    pub file_size_bytes: u64,
    pub sha256: String,
    pub source_path: String,
    pub managed_path: String,
    pub imported_at: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StudySummary {
    pub study_instance_uid: String,
    pub patient_name: Option<String>,
    pub patient_id: Option<String>,
    pub study_date: Option<String>,
    pub study_description: Option<String>,
    pub modalities: Option<String>,
    pub series_count: i64,
    pub instance_count: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SeriesSummary {
    pub study_instance_uid: String,
    pub series_instance_uid: String,
    pub modality: Option<String>,
    pub series_number: Option<String>,
    pub series_description: Option<String>,
    pub instance_count: i64,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct ImportReport {
    pub scanned_files: usize,
    pub accepted: usize,
    pub duplicates: usize,
    pub unreadable: usize,
    pub invalid_dicom: usize,
    pub failures: Vec<String>,
    pub stored_bytes: u64,
}

impl ImportReport {
    pub fn rejected(&self) -> usize {
        self.unreadable + self.invalid_dicom
    }

    pub fn record_unreadable(&mut self, source: impl fmt::Display, reason: impl fmt::Display) {
        self.unreadable += 1;
        self.failures.push(format!("{source}: {reason}"));
    }

    pub fn record_invalid_dicom(&mut self, source: impl fmt::Display, reason: impl fmt::Display) {
        self.invalid_dicom += 1;
        self.failures.push(format!("{source}: {reason}"));
    }
}

pub fn trim_to_option(value: Option<String>) -> Option<String> {
    value.and_then(|v| {
        let trimmed = v.trim().trim_matches('"').to_string();
        if trimmed.is_empty() {
            None
        } else {
            Some(trimmed)
        }
    })
}

/// Normalize remote node names to the canonical persisted form.
///
/// Remote node names are case-insensitive identifiers in the CLI. Creation,
/// update, and non-UUID lookup paths all use this lowercase value, while the
/// database also enforces `NOCASE` uniqueness as a safety net.
pub fn normalize_node_name(name: &str) -> String {
    name.trim().to_lowercase()
}

/// Normalize a DICOM Application Entity title before validation and storage.
///
/// DICOM AE titles are limited to 16 characters from the configured character
/// repertoire used by this app: uppercase `A-Z`, digits `0-9`, and space.
/// User input is trimmed and ASCII-uppercased before that validation so common
/// lowercase CLI input is accepted without storing mixed-case values.
pub fn normalize_ae_title(ae_title: &str) -> String {
    ae_title.trim().to_ascii_uppercase()
}

pub fn validate_ae_title(ae_title: &str) -> anyhow::Result<()> {
    let trimmed = ae_title.trim();
    if trimmed.is_empty() {
        return Err(anyhow!("AE title cannot be empty"));
    }
    if ae_title != trimmed {
        return Err(anyhow!(
            "AE title cannot have leading or trailing whitespace"
        ));
    }
    if ae_title.chars().count() > 16 {
        return Err(anyhow!("AE title must be at most 16 characters"));
    }
    for character in ae_title.chars() {
        if !matches!(character, 'A'..='Z' | '0'..='9' | ' ') {
            return Err(anyhow!(
                "AE title contains invalid character '{}'; allowed: A-Z, 0-9, space",
                character
            ));
        }
    }
    Ok(())
}

pub fn parse_port(value: &str) -> anyhow::Result<u16> {
    let port: u16 = value
        .parse()
        .with_context(|| format!("invalid port: {value}"))?;
    validate_port(port)?;
    Ok(port)
}

fn validate_port(port: u16) -> anyhow::Result<()> {
    if port == 0 {
        return Err(anyhow!("port must be between 1 and 65535"));
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{
        normalize_ae_title, normalize_node_name, parse_port, validate_ae_title, RemoteNode,
        RemoteNodeDraft, RemoteNodePatch,
    };

    fn sample_node() -> RemoteNode {
        RemoteNode {
            id: "node-1".to_string(),
            name: "pacs".to_string(),
            ae_title: "PACS".to_string(),
            host: "127.0.0.1".to_string(),
            port: 104,
            preferred_move_destination: None,
            notes: None,
            created_at: "2026-04-16T00:00:00Z".to_string(),
            updated_at: "2026-04-16T00:00:00Z".to_string(),
        }
    }

    #[test]
    fn normalizers_return_canonical_values() {
        assert_eq!(normalize_node_name("  PACS Archive  "), "pacs archive");
        assert_eq!(normalize_ae_title("  pacs1  "), "PACS1");
    }

    #[test]
    fn ae_title_validation_enforces_canonical_dicom_subset() {
        validate_ae_title("PACS 1").expect("valid AE title");

        assert_eq!(
            validate_ae_title("PACS_AE").unwrap_err().to_string(),
            "AE title contains invalid character '_'; allowed: A-Z, 0-9, space"
        );
        assert_eq!(
            validate_ae_title("pacs").unwrap_err().to_string(),
            "AE title contains invalid character 'p'; allowed: A-Z, 0-9, space"
        );
        assert_eq!(
            validate_ae_title(" PACS").unwrap_err().to_string(),
            "AE title cannot have leading or trailing whitespace"
        );
        assert_eq!(
            validate_ae_title("   ").unwrap_err().to_string(),
            "AE title cannot be empty"
        );
    }

    #[test]
    fn parse_port_rejects_zero() {
        assert_eq!(parse_port("104").expect("valid port"), 104);
        assert_eq!(
            parse_port("0").unwrap_err().to_string(),
            "port must be between 1 and 65535"
        );
    }

    #[test]
    fn draft_normalizes_before_validation_and_storage() {
        let node = RemoteNodeDraft {
            name: "  PACS Archive  ".to_string(),
            ae_title: " pacs1 ".to_string(),
            host: " 10.0.0.10 ".to_string(),
            port: 104,
            preferred_move_destination: None,
            notes: None,
        }
        .into_new_node()
        .expect("draft should normalize into a valid node");

        assert_eq!(node.name, "pacs archive");
        assert_eq!(node.ae_title, "PACS1");
        assert_eq!(node.host, "10.0.0.10");
    }

    #[test]
    fn draft_rejects_zero_port() {
        let error = RemoteNodeDraft {
            name: "pacs".to_string(),
            ae_title: "PACS".to_string(),
            host: "127.0.0.1".to_string(),
            port: 0,
            preferred_move_destination: None,
            notes: None,
        }
        .into_new_node()
        .unwrap_err();

        assert_eq!(error.to_string(), "port must be between 1 and 65535");
    }

    #[test]
    fn patch_normalizes_name_and_ae_title() {
        let node = RemoteNodePatch {
            name: Some("  ARCHIVE  ".to_string()),
            ae_title: Some(" archive1 ".to_string()),
            host: None,
            port: None,
            preferred_move_destination: None,
            notes: None,
        }
        .apply_to(sample_node())
        .expect("patch should normalize into a valid node");

        assert_eq!(node.name, "archive");
        assert_eq!(node.ae_title, "ARCHIVE1");
    }

    #[test]
    fn patch_rejects_zero_port() {
        let error = RemoteNodePatch {
            name: None,
            ae_title: None,
            host: None,
            port: Some(0),
            preferred_move_destination: None,
            notes: None,
        }
        .apply_to(sample_node())
        .unwrap_err();

        assert_eq!(error.to_string(), "port must be between 1 and 65535");
    }
}
