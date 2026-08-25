use crate::dicom::DefaultMemObject;
use anyhow::{anyhow, Result};
use dicom_dictionary_std::tags;

#[derive(Debug, Clone, Copy)]
pub enum Operation {
    CEcho,
    CFind,
    CGet,
    CMove,
    CStore,
}

#[derive(Debug)]
pub struct MalformedDimseResponse {
    operation: Operation,
    details: String,
}

impl MalformedDimseResponse {
    pub fn new(operation: Operation, details: impl Into<String>) -> Self {
        Self {
            operation,
            details: details.into(),
        }
    }
}

impl std::fmt::Display for MalformedDimseResponse {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let operation = format!("{:?}", self.operation);
        f.write_str(&crate::error::msg_with(
            "error-net-malformed-dimse",
            [
                ("operation", operation.as_str()),
                ("details", self.details.as_str()),
            ],
        ))
    }
}

impl std::error::Error for MalformedDimseResponse {}

pub fn require_cmd_u16(
    operation: Operation,
    command: &DefaultMemObject,
    tag: dicom_core::Tag,
    name: &'static str,
) -> Result<u16> {
    use crate::dicom::read_u16_opt_from_mem;

    read_u16_opt_from_mem(command, tag).ok_or_else(|| {
        anyhow!(MalformedDimseResponse::new(
            operation,
            crate::error::msg_with(
                "error-net-missing-required-command-field",
                [("name", name), ("tag", format!("{tag:?}").as_str())],
            )
        ))
    })
}

pub fn validate_common_response_fields(
    operation: Operation,
    command: &DefaultMemObject,
) -> Result<()> {
    let _ = require_cmd_u16(operation, command, tags::COMMAND_FIELD, "CommandField")?;
    let _ = require_cmd_u16(
        operation,
        command,
        tags::MESSAGE_ID_BEING_RESPONDED_TO,
        "MessageIDBeingRespondedTo",
    )?;
    let _ = require_cmd_u16(operation, command, tags::STATUS, "Status")?;
    Ok(())
}
