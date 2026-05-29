use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum OperationKind {
    QueryFind,
    RetrieveMove,
    RetrieveGet,
    SendStore,
    Import,
    StorageScp,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum OperationStatus {
    Success,
    Warning,
    Failure,
    Cancelled,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct NetworkPeer {
    pub host: String,
    pub port: u16,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct DicomAETitles {
    pub calling: String,
    pub called: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub move_destination: Option<String>,
}

#[derive(Debug, Clone, Default, PartialEq, Eq, Serialize, Deserialize)]
pub struct OperationCounts {
    #[serde(skip_serializing_if = "Option::is_none")]
    pub requested: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub matched: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub sent: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub received: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stored: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub failed: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub duplicates: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub skipped: Option<u64>,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct FailureDetail {
    pub message: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub code: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct LogReference {
    pub path: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub correlation_id: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub line_range: Option<(u64, u64)>,
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct OperationSummary {
    /// Schema version to keep JSON stable for scripts.
    pub version: u32,
    pub kind: OperationKind,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub peer: Option<NetworkPeer>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub ae_titles: Option<DicomAETitles>,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub criteria: Option<serde_json::Value>,

    pub duration_ms: u64,
    pub status: OperationStatus,

    #[serde(default, skip_serializing_if = "OperationCounts::is_empty")]
    pub counts: OperationCounts,

    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub failures: Vec<FailureDetail>,

    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub logs: Vec<LogReference>,
}

impl OperationSummary {
    pub const VERSION: u32 = 1;

    pub fn new(kind: OperationKind, duration_ms: u64, status: OperationStatus) -> Self {
        Self {
            version: Self::VERSION,
            kind,
            peer: None,
            ae_titles: None,
            criteria: None,
            duration_ms,
            status,
            counts: OperationCounts::default(),
            failures: Vec::new(),
            logs: Vec::new(),
        }
    }
}

impl OperationCounts {
    fn is_empty(&self) -> bool {
        self.requested.is_none()
            && self.matched.is_none()
            && self.sent.is_none()
            && self.received.is_none()
            && self.stored.is_none()
            && self.failed.is_none()
            && self.duplicates.is_none()
            && self.skipped.is_none()
    }
}
