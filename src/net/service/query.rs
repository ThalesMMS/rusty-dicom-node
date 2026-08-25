use std::net::TcpStream;

use anyhow::Context;
use dicom_dictionary_std::{tags, uids};
use dicom_transfer_syntax_registry::{TransferSyntaxIndex, TransferSyntaxRegistry};
use dicom_ul::{
    association::ServerAssociation,
    pdu::{PDataValue, PDataValueType},
    Pdu,
};
use tracing::warn;

use crate::{
    archive::{ArchiveQuery, AttributePath, SqliteArchiveCatalog},
    dicom::{read_u16_opt_from_mem, DefaultMemObject},
    error::Result,
    models::{QueryLevel, QueryModel},
    net::{
        assoc::{create_find_response, AssociationFactory},
        metrics::ServerMetrics,
    },
};

use super::{DimseServiceKind, ServiceProvider};

const QUERY_COMMAND_FIELDS: &[u16] = &[0x0020];
const QUERY_ABSTRACT_SYNTAXES: &[&str] = &[
    uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND,
    uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND,
];
const DEFAULT_FIND_RESULT_LIMIT: usize = 1024;

#[derive(Debug, Clone)]
pub struct QueryProvider {
    catalog: SqliteArchiveCatalog,
    metrics: ServerMetrics,
}

#[derive(Debug, Clone, Copy, Default)]
pub struct QueryProviderDescriptor;

#[derive(Debug, Clone)]
pub struct FindCommand {
    pub message_id: u16,
    pub sop_class_uid: String,
    pub presentation_context_id: u8,
}

impl QueryProvider {
    pub fn new(catalog: SqliteArchiveCatalog) -> Self {
        Self::with_metrics(catalog, ServerMetrics::default())
    }

    pub fn with_metrics(catalog: SqliteArchiveCatalog, metrics: ServerMetrics) -> Self {
        Self { catalog, metrics }
    }

    pub fn descriptor() -> QueryProviderDescriptor {
        QueryProviderDescriptor
    }

    pub fn begin_find_command(
        &self,
        command: &DefaultMemObject,
        presentation_context_id: u8,
    ) -> Result<FindCommand> {
        let message_id = read_u16_opt_from_mem(command, tags::MESSAGE_ID)
            .ok_or_else(|| {
                crate::net::err_with("error-net-missing-message-id", [("operation", "C-FIND")])
            })?;
        let sop_class_uid = command
            .element(tags::AFFECTED_SOP_CLASS_UID)
            .context(crate::error::msg_with(
                "error-net-missing-affected-sop",
                [("operation", "C-FIND")],
            ))?
            .to_str()
            .context(crate::error::msg_with(
                "error-net-invalid-affected-sop",
                [("operation", "C-FIND")],
            ))?
            .trim_end_matches('\0')
            .to_string();

        Ok(FindCommand {
            message_id,
            sop_class_uid,
            presentation_context_id,
        })
    }

    pub fn handle_find_command(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        find_command: &FindCommand,
        identifier_bytes: &[u8],
    ) -> Result<()> {
        self.metrics.record_c_find_request();
        let context = association
            .presentation_contexts()
            .iter()
            .find(|context| context.id == find_command.presentation_context_id)
            .ok_or_else(|| {
                let id = find_command.presentation_context_id.to_string();
                crate::net::err_with(
                    "error-net-no-presentation-context-id",
                    [("id", id.as_str())],
                )
            })?;
        let transfer_syntax = TransferSyntaxRegistry
            .get(&context.transfer_syntax)
            .ok_or_else(|| crate::net::err("error-net-unsupported-transfer-syntax"))?;

        let identifier =
            match DefaultMemObject::read_dataset_with_ts(identifier_bytes, transfer_syntax)
                .context(crate::error::msg_with(
                    "error-net-reading-identifier",
                    [("operation", "C-FIND")],
                ))
            {
                Ok(identifier) => identifier,
                Err(err) => {
                    warn!("invalid C-FIND identifier: {err:#}");
                    return self.send_find_response(association, find_command, 0xA900, None);
                }
            };

        let query =
            match Self::archive_query_from_identifier(&find_command.sop_class_uid, &identifier) {
                Ok(query) => query,
                Err(err) => {
                    warn!("unsupported C-FIND query identifier: {err:#}");
                    return self.send_find_response(association, find_command, 0xA900, None);
                }
            };

        let entries = match self.catalog.query_dicom(&query) {
            Ok(entries) => entries,
            Err(err) => {
                warn!("failed to execute C-FIND archive query: {err:#}");
                return self.send_find_response(association, find_command, 0xC000, None);
            }
        };
        self.metrics.record_c_find_matches(entries.len() as u64);

        for entry in entries {
            let mut dataset_bytes = Vec::with_capacity(1024);
            entry
                .object
                .write_dataset_with_ts(&mut dataset_bytes, transfer_syntax)
                .context(crate::error::msg_with(
                    "error-net-writing-response-dataset",
                    [("operation", "C-FIND")],
                ))?;
            self.send_find_response(association, find_command, 0xFF00, Some(dataset_bytes))?;
        }

        self.send_find_response(association, find_command, 0x0000, None)
    }

    fn archive_query_from_identifier(
        sop_class_uid: &str,
        identifier: &DefaultMemObject,
    ) -> Result<ArchiveQuery> {
        let model = query_model_from_find_sop_class_uid(sop_class_uid)?;
        let mut query = ArchiveQuery::from_find_identifier(model, identifier)?;
        add_default_return_keys(&mut query);
        if query.limit.is_none() {
            query.limit = Some(DEFAULT_FIND_RESULT_LIMIT);
        }
        query.compile()?;
        Ok(query)
    }

    fn send_find_response(
        &self,
        association: &mut ServerAssociation<TcpStream>,
        find_command: &FindCommand,
        status: u16,
        dataset_bytes: Option<Vec<u8>>,
    ) -> Result<()> {
        let command = create_find_response(
            find_command.message_id,
            &find_command.sop_class_uid,
            status,
            dataset_bytes.is_some(),
        );
        let command_bytes = AssociationFactory::write_command_dataset(&command)?;

        association.send(&Pdu::PData {
            data: vec![PDataValue {
                presentation_context_id: find_command.presentation_context_id,
                value_type: PDataValueType::Command,
                is_last: true,
                data: command_bytes,
            }],
        })?;

        if let Some(dataset_bytes) = dataset_bytes {
            association.send(&Pdu::PData {
                data: vec![PDataValue {
                    presentation_context_id: find_command.presentation_context_id,
                    value_type: PDataValueType::Data,
                    is_last: true,
                    data: dataset_bytes,
                }],
            })?;
        }

        Ok(())
    }
}

impl ServiceProvider for QueryProvider {
    fn kind(&self) -> DimseServiceKind {
        DimseServiceKind::Query
    }

    fn name(&self) -> &'static str {
        "QueryProvider"
    }

    fn abstract_syntaxes(&self) -> &'static [&'static str] {
        QUERY_ABSTRACT_SYNTAXES
    }

    fn command_fields(&self) -> &'static [u16] {
        QUERY_COMMAND_FIELDS
    }
}

impl ServiceProvider for QueryProviderDescriptor {
    fn kind(&self) -> DimseServiceKind {
        DimseServiceKind::Query
    }

    fn name(&self) -> &'static str {
        "QueryProvider"
    }

    fn abstract_syntaxes(&self) -> &'static [&'static str] {
        QUERY_ABSTRACT_SYNTAXES
    }

    fn command_fields(&self) -> &'static [u16] {
        QUERY_COMMAND_FIELDS
    }
}

fn query_model_from_find_sop_class_uid(sop_class_uid: &str) -> Result<QueryModel> {
    match sop_class_uid.trim_end_matches('\0') {
        uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND => Ok(QueryModel::StudyRoot),
        uids::PATIENT_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND => Ok(QueryModel::PatientRoot),
        other => Err(crate::net::err_with(
            "error-net-unsupported-model-sop",
            [("operation", "C-FIND"), ("uid", other)],
        )),
    }
}

fn add_default_return_keys(query: &mut ArchiveQuery) {
    let defaults = default_return_keys_for_level(query.level);
    for tag in defaults {
        let path = AttributePath::tag(*tag);
        if !query.return_keys.contains(&path) {
            query.return_keys.push(path);
        }
    }
}

fn default_return_keys_for_level(level: QueryLevel) -> &'static [dicom_core::Tag] {
    match level {
        QueryLevel::Patient => &[tags::PATIENT_NAME, tags::PATIENT_ID],
        QueryLevel::Study => &[
            tags::PATIENT_NAME,
            tags::PATIENT_ID,
            tags::STUDY_INSTANCE_UID,
            tags::STUDY_DATE,
            tags::STUDY_DESCRIPTION,
            tags::ACCESSION_NUMBER,
            tags::MODALITIES_IN_STUDY,
            tags::NUMBER_OF_STUDY_RELATED_SERIES,
            tags::NUMBER_OF_STUDY_RELATED_INSTANCES,
        ],
        QueryLevel::Series => &[
            tags::PATIENT_NAME,
            tags::PATIENT_ID,
            tags::STUDY_INSTANCE_UID,
            tags::STUDY_DATE,
            tags::STUDY_DESCRIPTION,
            tags::ACCESSION_NUMBER,
            tags::SERIES_INSTANCE_UID,
            tags::MODALITY,
            tags::SERIES_NUMBER,
            tags::SERIES_DESCRIPTION,
            tags::NUMBER_OF_SERIES_RELATED_INSTANCES,
        ],
        QueryLevel::Image => &[
            tags::PATIENT_NAME,
            tags::PATIENT_ID,
            tags::STUDY_INSTANCE_UID,
            tags::STUDY_DATE,
            tags::STUDY_DESCRIPTION,
            tags::ACCESSION_NUMBER,
            tags::SERIES_INSTANCE_UID,
            tags::MODALITY,
            tags::SERIES_NUMBER,
            tags::SERIES_DESCRIPTION,
            tags::SOP_CLASS_UID,
            tags::SOP_INSTANCE_UID,
            tags::INSTANCE_NUMBER,
        ],
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        archive::{AttributePath, MatchingRule},
        dicom::{put_string, DefaultMemObject},
        models::{QueryLevel, QueryModel},
    };
    use dicom_core::VR;
    use dicom_dictionary_std::{tags, uids};

    #[test]
    fn find_identifier_becomes_bounded_study_root_archive_query() {
        let mut identifier = DefaultMemObject::new_empty();
        put_string(&mut identifier, tags::QUERY_RETRIEVE_LEVEL, VR::CS, "STUDY");
        put_string(&mut identifier, tags::PATIENT_ID, VR::LO, "PAT-1");
        put_string(
            &mut identifier,
            tags::STUDY_DATE,
            VR::DA,
            "20260101-20260131",
        );

        let query = QueryProvider::archive_query_from_identifier(
            uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND,
            &identifier,
        )
        .expect("build archive query");

        assert_eq!(query.model, QueryModel::StudyRoot);
        assert_eq!(query.level, QueryLevel::Study);
        assert_eq!(query.limit, Some(DEFAULT_FIND_RESULT_LIMIT));
        assert!(query
            .return_keys
            .contains(&AttributePath::tag(tags::STUDY_INSTANCE_UID)));
        assert!(query
            .return_keys
            .contains(&AttributePath::tag(tags::MODALITIES_IN_STUDY)));
        assert!(query
            .return_keys
            .contains(&AttributePath::tag(tags::NUMBER_OF_STUDY_RELATED_SERIES)));

        assert!(query.predicates.iter().any(|predicate| {
            predicate.path == AttributePath::tag(tags::PATIENT_ID)
                && predicate.rule == MatchingRule::SingleValue("PAT-1".to_string())
        }));
        assert!(query.predicates.iter().any(|predicate| {
            predicate.path == AttributePath::tag(tags::STUDY_DATE)
                && predicate.rule
                    == MatchingRule::Range {
                        start: Some("20260101".to_string()),
                        end: Some("20260131".to_string()),
                    }
        }));
    }

    #[test]
    fn find_identifier_rejects_missing_query_retrieve_level() {
        let identifier = DefaultMemObject::new_empty();

        let err = QueryProvider::archive_query_from_identifier(
            uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND,
            &identifier,
        )
        .expect_err("missing level should fail");

        assert!(err.to_string().contains("QueryRetrieveLevel"));
    }

    #[test]
    fn find_identifier_rejects_unsupported_model_and_level() {
        let mut identifier = DefaultMemObject::new_empty();
        put_string(
            &mut identifier,
            tags::QUERY_RETRIEVE_LEVEL,
            VR::CS,
            "PATIENT",
        );

        let err = QueryProvider::archive_query_from_identifier(
            uids::STUDY_ROOT_QUERY_RETRIEVE_INFORMATION_MODEL_FIND,
            &identifier,
        )
        .expect_err("study root patient level should fail");
        assert!(err.to_string().contains("Study Root"));

        let err = QueryProvider::archive_query_from_identifier("1.2.840.10008.9.9.9", &identifier)
            .expect_err("unknown C-FIND model should fail");
        assert!(err.to_string().contains("unsupported C-FIND model"));
    }
}
