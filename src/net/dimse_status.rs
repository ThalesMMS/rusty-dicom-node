use std::fmt;

use crate::net::malformed_response::Operation;

/// Category of a DIMSE `Status` code.
///
/// This is intentionally a small classification used to drive response handling:
/// - `Pending` indicates multi-response sequences where more responses are expected
/// - `Success` indicates a terminal success
/// - `Warning` indicates a terminal response with non-fatal issues
/// - `Failure` indicates a terminal error response
/// - `Cancel` indicates the operation was canceled
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum StatusCategory {
    Success,
    Pending,
    Warning,
    Failure,
    Cancel,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct StatusInfo {
    pub code: u16,
    pub category: StatusCategory,
    pub meaning: &'static str,
    pub terminal: bool,
    pub hint: Option<&'static str>,
}

impl fmt::Display for StatusInfo {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "0x{:04X} ({}, {:?})",
            self.code, self.meaning, self.category
        )
    }
}

/// Interpret a DIMSE status code for a given operation.
///
/// The mapping here is deliberately conservative: it covers the common status
/// classes and a few well-known codes; any other code is treated as unknown.
///
/// References: DICOM PS3.4 (Service Class Specifications).
pub fn interpret_status(operation: Operation, code: u16) -> Option<StatusInfo> {
    let common = match code {
        0x0000 => Some(StatusInfo {
            code,
            category: StatusCategory::Success,
            meaning: "Success",
            terminal: true,
            hint: None,
        }),
        0xFE00 => Some(StatusInfo {
            code,
            category: StatusCategory::Cancel,
            meaning: "Cancel",
            terminal: true,
            hint: Some("operation was canceled (by SCU or SCP)"),
        }),
        // Generic warning class (Bxxx). Exact meaning varies by SOP class.
        0xB000..=0xBFFF => Some(StatusInfo {
            code,
            category: StatusCategory::Warning,
            meaning: "Warning",
            terminal: true,
            hint: Some("completed with warnings; inspect warning details in the response (if present)"),
        }),
        // Generic failure class (Axxx/Cxxx). Exact meaning varies by SOP class.
        0xA000..=0xAFFF | 0xC000..=0xCFFF => Some(StatusInfo {
            code,
            category: StatusCategory::Failure,
            meaning: "Failure",
            terminal: true,
            hint: Some(
                "operation failed; common causes include SOP class/transfer syntax not supported, invalid identifier, or authorization",
            ),
        }),
        _ => None,
    };

    if common.is_some() {
        return common;
    }

    match operation {
        Operation::CFind => match code {
            0xFF00 => Some(StatusInfo {
                code,
                category: StatusCategory::Pending,
                meaning: "Pending: matches are continuing",
                terminal: false,
                hint: None,
            }),
            0xFF01 => Some(StatusInfo {
                code,
                category: StatusCategory::Pending,
                meaning: "Pending: matches are continuing (warning)",
                terminal: false,
                hint: None,
            }),
            _ => None,
        },
        Operation::CMove => match code {
            0xFF00 => Some(StatusInfo {
                code,
                category: StatusCategory::Pending,
                meaning: "Pending: sub-operations are continuing",
                terminal: false,
                hint: None,
            }),
            0xFF01 => Some(StatusInfo {
                code,
                category: StatusCategory::Pending,
                meaning: "Pending: sub-operations are continuing (warning)",
                terminal: false,
                hint: None,
            }),
            _ => None,
        },
        Operation::CGet => match code {
            0xFF00 => Some(StatusInfo {
                code,
                category: StatusCategory::Pending,
                meaning: "Pending: sub-operations are continuing",
                terminal: false,
                hint: None,
            }),
            0xFF01 => Some(StatusInfo {
                code,
                category: StatusCategory::Pending,
                meaning: "Pending: sub-operations are continuing (warning)",
                terminal: false,
                hint: None,
            }),
            _ => None,
        },
        Operation::CStore => match code {
            // Note: C-STORE has no `Pending` status; common success/warning/failure handled above.
            _ => None,
        },
        Operation::CEcho => match code {
            // Note: C-ECHO has no `Pending` status; common success/failure handled above.
            _ => None,
        },
    }
}
