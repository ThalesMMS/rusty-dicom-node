pub type Result<T> = anyhow::Result<T>;

/// Structured reasons for rejecting an import candidate.
///
/// This is intentionally small and focused: it exists to ensure we can render
/// consistent, user-friendly messages for common importer rejection scenarios
/// (limits, unreadable IO, invalid/corrupt DICOM, unsafe ZIP entry names, etc.).
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ImportRejectionReason {
    /// File/entry cannot be read or staged (IO errors, permissions, etc.).
    Unreadable(String),
    /// File/entry exceeds configured import limit.
    LimitExceeded {
        limit: &'static str,
        details: String,
    },
    /// DICOM parse/validation failed.
    InvalidDicom(String),
    /// ZIP entry name/path is unsafe (zip-slip, absolute path, etc.).
    UnsafeZipPath(String),
    /// ZIP is corrupt or entry cannot be decompressed.
    CorruptZip(String),
    /// ZIP contains multiple entries targeting the same normalized path.
    DuplicateZipPath(String),
    /// Entry/file skipped for an explicit reason.
    Skipped(String),
}

impl std::fmt::Display for ImportRejectionReason {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ImportRejectionReason::Unreadable(msg) => write!(f, "{msg}"),
            ImportRejectionReason::InvalidDicom(msg) => write!(f, "{msg}"),
            ImportRejectionReason::UnsafeZipPath(msg) => write!(f, "{msg}"),
            ImportRejectionReason::CorruptZip(msg) => write!(f, "{msg}"),
            ImportRejectionReason::DuplicateZipPath(msg) => write!(f, "{msg}"),
            ImportRejectionReason::Skipped(msg) => write!(f, "{msg}"),
            ImportRejectionReason::LimitExceeded { limit, details } => {
                if *limit == "max_file_import_bytes" {
                    write!(f, "file too large: {details}")
                } else {
                    write!(f, "{limit} exceeded: {details}")
                }
            }
        }
    }
}

impl std::error::Error for ImportRejectionReason {}
