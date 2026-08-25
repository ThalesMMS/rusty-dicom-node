use std::net::TcpStream;

use anyhow::Result;
use dicom_dictionary_std::{tags, uids};
use dicom_ul::{
    association::ServerAssociation,
    pdu::{PDataValue, PDataValueType},
    Pdu,
};

use crate::{
    dicom::{read_u16_opt_from_mem, DefaultMemObject},
    net::assoc::{create_echo_response, AssociationFactory},
};

use super::{DimseServiceKind, ServiceProvider};

const VERIFICATION_COMMAND_FIELDS: &[u16] = &[0x0030];
const VERIFICATION_ABSTRACT_SYNTAXES: &[&str] = &[uids::VERIFICATION];

#[derive(Debug, Clone, Copy, Default)]
pub struct VerificationProvider;

impl VerificationProvider {
    pub fn new() -> Self {
        Self
    }

    pub fn handle_command(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        command: &DefaultMemObject,
        presentation_context_id: u8,
    ) -> Result<()> {
        let message_id = read_u16_opt_from_mem(command, tags::MESSAGE_ID)
            .ok_or_else(|| {
                crate::net::err_with("error-net-missing-message-id", [("operation", "C-ECHO")])
            })?;
        let response = create_echo_response(message_id, 0x0000);
        let response_bytes = AssociationFactory::write_command_dataset(&response)?;
        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id,
                value_type: PDataValueType::Command,
                is_last: true,
                data: response_bytes,
            }],
        })?;
        Ok(())
    }
}

impl ServiceProvider for VerificationProvider {
    fn kind(&self) -> DimseServiceKind {
        DimseServiceKind::Verification
    }

    fn name(&self) -> &'static str {
        "VerificationProvider"
    }

    fn abstract_syntaxes(&self) -> &'static [&'static str] {
        VERIFICATION_ABSTRACT_SYNTAXES
    }

    fn command_fields(&self) -> &'static [u16] {
        VERIFICATION_COMMAND_FIELDS
    }
}
