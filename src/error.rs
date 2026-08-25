use std::collections::HashMap;

use fluent_bundle::FluentValue;

pub type Result<T> = anyhow::Result<T>;

/// Look up a user-facing error string (`error.*`) in the current locale.
pub fn msg(key: &str) -> String {
    crate::i18n::t(key)
}

/// Look up a user-facing error string with Fluent arguments.
pub fn msg_with<'a>(
    key: &str,
    pairs: impl IntoIterator<Item = (&'a str, &'a str)>,
) -> String {
    let mut args = HashMap::new();
    for (name, value) in pairs {
        args.insert(name.to_string(), FluentValue::from(value));
    }
    crate::i18n::t_with(key, &args)
}

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
            ImportRejectionReason::Unreadable(msg) => f.write_str(msg),
            ImportRejectionReason::InvalidDicom(msg) => f.write_str(msg),
            ImportRejectionReason::UnsafeZipPath(msg) => f.write_str(msg),
            ImportRejectionReason::CorruptZip(msg) => f.write_str(msg),
            ImportRejectionReason::DuplicateZipPath(msg) => f.write_str(msg),
            ImportRejectionReason::Skipped(msg) => f.write_str(msg),
            ImportRejectionReason::LimitExceeded { limit, details } => {
                if *limit == "max_file_import_bytes" {
                    f.write_str(&msg_with(
                        "error-import-file-too-large",
                        [("details", details.as_str())],
                    ))
                } else {
                    f.write_str(&msg_with(
                        "error-import-limit-exceeded",
                        [("limit", *limit), ("details", details.as_str())],
                    ))
                }
            }
        }
    }
}

impl std::error::Error for ImportRejectionReason {}

#[cfg(test)]
mod tests {
    use super::{msg_with, ImportRejectionReason};

    #[test]
    fn import_rejection_reason_renders_limit_exceeded() {
        let reason = ImportRejectionReason::LimitExceeded {
            limit: "max_zip_total_bytes",
            details: "1 > 0".to_string(),
        };
        assert_eq!(reason.to_string(), "max_zip_total_bytes exceeded: 1 > 0");
    }

    #[test]
    fn import_rejection_reason_renders_file_too_large() {
        let reason = ImportRejectionReason::LimitExceeded {
            limit: "max_file_import_bytes",
            details: "4 > 3".to_string(),
        };
        assert_eq!(reason.to_string(), "file too large: 4 > 3");
        assert_eq!(
            msg_with("error-import-file-too-large", [("details", "4 > 3")]),
            "file too large: 4 > 3"
        );
    }
}
