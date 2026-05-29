use super::*;
use crate::models::validate_ae_title;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(super) enum NodeFormMode {
    Add,
    Edit,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub(super) enum NodeField {
    Name,
    AeTitle,
    Host,
    Port,
    MoveDestination,
    Notes,
}

impl NodeField {
    const ALL: [Self; 6] = [
        Self::Name,
        Self::AeTitle,
        Self::Host,
        Self::Port,
        Self::MoveDestination,
        Self::Notes,
    ];

    pub(super) fn next(self) -> Self {
        advance_enum(Self::ALL, self, 1)
    }

    pub(super) fn previous(self) -> Self {
        advance_enum(Self::ALL, self, -1)
    }
}

#[derive(Clone, Debug)]
pub(super) struct NodeFormState {
    pub(super) mode: NodeFormMode,
    pub(super) target: Option<RemoteNode>,
    pub(super) active: NodeField,
    pub(super) name: String,
    pub(super) ae_title: String,
    pub(super) host: String,
    pub(super) port: String,
    pub(super) move_destination: String,
    pub(super) notes: String,
    pub(super) error: Option<String>,

    pub(super) touched: std::collections::BTreeSet<NodeField>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub(super) struct NodeFormValues {
    pub(super) name: String,
    pub(super) ae_title: String,
    pub(super) host: String,
    pub(super) port: u16,
    pub(super) move_destination: Option<String>,
    pub(super) notes: Option<String>,
}

impl NodeFormState {
    pub(super) fn add() -> Self {
        Self {
            mode: NodeFormMode::Add,
            target: None,
            active: NodeField::Name,
            name: String::new(),
            ae_title: String::new(),
            host: String::new(),
            port: String::new(),
            move_destination: String::new(),
            notes: String::new(),
            error: None,
            touched: std::collections::BTreeSet::new(),
        }
    }

    pub(super) fn edit(node: &RemoteNode) -> Self {
        Self {
            mode: NodeFormMode::Edit,
            target: Some(node.clone()),
            active: NodeField::Name,
            name: node.name.clone(),
            ae_title: node.ae_title.clone(),
            host: node.host.clone(),
            port: node.port.to_string(),
            move_destination: node.preferred_move_destination.clone().unwrap_or_default(),
            notes: node.notes.clone().unwrap_or_default(),
            error: None,
            touched: std::collections::BTreeSet::new(),
        }
    }

    pub(super) fn title(&self) -> &'static str {
        match self.mode {
            NodeFormMode::Add => "Add Remote Node",
            NodeFormMode::Edit => "Edit Remote Node",
        }
    }

    pub(super) fn active_text_mut(&mut self) -> Option<&mut String> {
        match self.active {
            NodeField::Name => Some(&mut self.name),
            NodeField::AeTitle => Some(&mut self.ae_title),
            NodeField::Host => Some(&mut self.host),
            NodeField::Port => Some(&mut self.port),
            NodeField::MoveDestination => Some(&mut self.move_destination),
            NodeField::Notes => Some(&mut self.notes),
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub(super) enum QueryField {
    Model,
    Level,
    PatientName,
    PatientId,
    AccessionNumber,
    StudyUid,
    SeriesUid,
    SopInstanceUid,
    DateFrom,
    DateTo,
    Modality,
    StudyDescription,
}

impl QueryField {
    const ALL: [Self; 12] = [
        Self::Model,
        Self::Level,
        Self::PatientName,
        Self::PatientId,
        Self::AccessionNumber,
        Self::StudyUid,
        Self::SeriesUid,
        Self::SopInstanceUid,
        Self::DateFrom,
        Self::DateTo,
        Self::Modality,
        Self::StudyDescription,
    ];

    pub(super) fn next(self) -> Self {
        advance_enum(Self::ALL, self, 1)
    }

    pub(super) fn previous(self) -> Self {
        advance_enum(Self::ALL, self, -1)
    }
}

#[derive(Clone, Debug)]
pub(super) struct QueryFormState {
    pub(super) node: RemoteNode,
    pub(super) active: QueryField,
    pub(super) model: QueryModel,
    pub(super) level: QueryLevel,
    pub(super) patient_name: String,
    pub(super) patient_id: String,
    pub(super) accession_number: String,
    pub(super) study_uid: String,
    pub(super) series_uid: String,
    pub(super) sop_instance_uid: String,
    pub(super) date_from: String,
    pub(super) date_to: String,
    pub(super) modality: String,
    pub(super) study_description: String,
    pub(super) error: Option<String>,

    pub(super) touched: std::collections::BTreeSet<QueryField>,
}

impl QueryFormState {
    pub(super) fn new(node: RemoteNode) -> Self {
        Self {
            node,
            active: QueryField::Model,
            model: QueryModel::default(),
            level: QueryLevel::default(),
            patient_name: String::new(),
            patient_id: String::new(),
            accession_number: String::new(),
            study_uid: String::new(),
            series_uid: String::new(),
            sop_instance_uid: String::new(),
            date_from: String::new(),
            date_to: String::new(),
            modality: String::new(),
            study_description: String::new(),
            error: None,
            touched: std::collections::BTreeSet::new(),
        }
    }

    pub(super) fn active_text_mut(&mut self) -> Option<&mut String> {
        match self.active {
            QueryField::Model | QueryField::Level => None,
            QueryField::PatientName => Some(&mut self.patient_name),
            QueryField::PatientId => Some(&mut self.patient_id),
            QueryField::AccessionNumber => Some(&mut self.accession_number),
            QueryField::StudyUid => Some(&mut self.study_uid),
            QueryField::SeriesUid => Some(&mut self.series_uid),
            QueryField::SopInstanceUid => Some(&mut self.sop_instance_uid),
            QueryField::DateFrom => Some(&mut self.date_from),
            QueryField::DateTo => Some(&mut self.date_to),
            QueryField::Modality => Some(&mut self.modality),
            QueryField::StudyDescription => Some(&mut self.study_description),
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub(super) enum RetrieveField {
    Model,
    Level,
    StudyUid,
    SeriesUid,
    InstanceUid,
    Destination,
}

impl RetrieveField {
    const ALL: [Self; 6] = [
        Self::Model,
        Self::Level,
        Self::StudyUid,
        Self::SeriesUid,
        Self::InstanceUid,
        Self::Destination,
    ];

    pub(super) fn next(self) -> Self {
        advance_enum(Self::ALL, self, 1)
    }

    pub(super) fn previous(self) -> Self {
        advance_enum(Self::ALL, self, -1)
    }
}

#[derive(Clone, Debug)]
pub(super) struct RetrieveFormState {
    pub(super) node: RemoteNode,
    pub(super) active: RetrieveField,
    pub(super) model: QueryModel,
    pub(super) level: QueryLevel,
    pub(super) study_uid: String,
    pub(super) series_uid: String,
    pub(super) instance_uid: String,
    pub(super) destination: String,
    pub(super) error: Option<String>,

    pub(super) touched: std::collections::BTreeSet<RetrieveField>,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub(super) enum ImportField {
    Path,
}

#[derive(Clone, Debug)]
pub(super) struct ImportFormState {
    pub(super) active: ImportField,
    pub(super) path: String,
    pub(super) error: Option<String>,

    pub(super) touched: std::collections::BTreeSet<ImportField>,
}

impl ImportFormState {
    pub(super) fn new() -> Self {
        Self {
            active: ImportField::Path,
            path: String::new(),
            error: None,
            touched: std::collections::BTreeSet::new(),
        }
    }

    pub(super) fn active_text_mut(&mut self) -> Option<&mut String> {
        match self.active {
            ImportField::Path => Some(&mut self.path),
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub(super) enum SendKind {
    Study,
    Series,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub(super) enum SendField {
    Kind,
    Uid,
    DestinationNode,
}

impl SendField {
    const ALL: [Self; 3] = [Self::Kind, Self::Uid, Self::DestinationNode];

    pub(super) fn next(self) -> Self {
        advance_enum(Self::ALL, self, 1)
    }

    pub(super) fn previous(self) -> Self {
        advance_enum(Self::ALL, self, -1)
    }
}

#[derive(Clone, Debug)]
pub(super) struct SendFormState {
    pub(super) active: SendField,
    pub(super) kind: SendKind,
    pub(super) uid: String,
    pub(super) destination_node: String,
    pub(super) error: Option<String>,

    pub(super) touched: std::collections::BTreeSet<SendField>,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd)]
pub(super) enum StorageScpField {
    LocalAeTitle,
    BindAddr,
    Port,
    AllowPromiscuous,
    StrictPdu,
    MaxPduLength,

    MaxFileImportBytes,
    MaxZipEntryBytes,
    MaxZipTotalBytes,
    MaxZipEntryCount,
    MaxStoreObjectBytes,
}

impl StorageScpField {
    const ALL: [Self; 11] = [
        Self::LocalAeTitle,
        Self::BindAddr,
        Self::Port,
        Self::AllowPromiscuous,
        Self::StrictPdu,
        Self::MaxPduLength,
        Self::MaxFileImportBytes,
        Self::MaxZipEntryBytes,
        Self::MaxZipTotalBytes,
        Self::MaxZipEntryCount,
        Self::MaxStoreObjectBytes,
    ];

    pub(super) fn next(self) -> Self {
        advance_enum(Self::ALL, self, 1)
    }

    pub(super) fn previous(self) -> Self {
        advance_enum(Self::ALL, self, -1)
    }
}

#[derive(Clone, Debug)]
pub(super) struct StorageScpFormState {
    pub(super) active: StorageScpField,
    pub(super) local_ae_title: String,
    pub(super) bind_addr: String,
    pub(super) port: String,
    pub(super) allow_promiscuous_storage: bool,
    pub(super) strict_pdu: bool,
    pub(super) max_pdu_length: String,

    pub(super) max_file_import_bytes: String,
    pub(super) max_zip_entry_bytes: String,
    pub(super) max_zip_total_bytes: String,
    pub(super) max_zip_entry_count: String,
    pub(super) max_store_object_bytes: String,

    pub(super) error: Option<String>,

    pub(super) touched: std::collections::BTreeSet<StorageScpField>,
}

impl StorageScpFormState {
    pub(super) fn from_config(config: &crate::config::AppConfig) -> Self {
        Self {
            active: StorageScpField::LocalAeTitle,
            local_ae_title: config.local_ae_title.clone(),
            bind_addr: config.storage_bind_addr.clone(),
            port: config.storage_scp_port.to_string(),
            allow_promiscuous_storage: config.allow_promiscuous_storage,
            strict_pdu: config.strict_pdu,
            max_pdu_length: config.max_pdu_length.to_string(),

            max_file_import_bytes: config
                .max_file_import_bytes
                .map(|v| v.to_string())
                .unwrap_or_default(),
            max_zip_entry_bytes: config
                .max_zip_entry_bytes
                .map(|v| v.to_string())
                .unwrap_or_default(),
            max_zip_total_bytes: config
                .max_zip_total_bytes
                .map(|v| v.to_string())
                .unwrap_or_default(),
            max_zip_entry_count: config
                .max_zip_entry_count
                .map(|v| v.to_string())
                .unwrap_or_default(),
            max_store_object_bytes: config
                .max_store_object_bytes
                .map(|v| v.to_string())
                .unwrap_or_default(),

            error: None,
            touched: std::collections::BTreeSet::new(),
        }
    }

    pub(super) fn active_text_mut(&mut self) -> Option<&mut String> {
        match self.active {
            StorageScpField::LocalAeTitle => Some(&mut self.local_ae_title),
            StorageScpField::BindAddr => Some(&mut self.bind_addr),
            StorageScpField::Port => Some(&mut self.port),
            StorageScpField::MaxPduLength => Some(&mut self.max_pdu_length),
            StorageScpField::MaxFileImportBytes => Some(&mut self.max_file_import_bytes),
            StorageScpField::MaxZipEntryBytes => Some(&mut self.max_zip_entry_bytes),
            StorageScpField::MaxZipTotalBytes => Some(&mut self.max_zip_total_bytes),
            StorageScpField::MaxZipEntryCount => Some(&mut self.max_zip_entry_count),
            StorageScpField::MaxStoreObjectBytes => Some(&mut self.max_store_object_bytes),
            StorageScpField::AllowPromiscuous | StorageScpField::StrictPdu => None,
        }
    }
}

impl SendFormState {
    pub(super) fn new() -> Self {
        Self {
            active: SendField::Kind,
            kind: SendKind::Study,
            uid: String::new(),
            destination_node: String::new(),
            error: None,
            touched: std::collections::BTreeSet::new(),
        }
    }

    pub(super) fn title(&self) -> &'static str {
        match self.kind {
            SendKind::Study => "Send Study",
            SendKind::Series => "Send Series",
        }
    }

    pub(super) fn active_text_mut(&mut self) -> Option<&mut String> {
        match self.active {
            SendField::Kind => None,
            SendField::Uid => Some(&mut self.uid),
            SendField::DestinationNode => Some(&mut self.destination_node),
        }
    }
}

pub(super) fn cycle_send_form_field(form: &mut SendFormState, delta: isize) {
    match form.active {
        SendField::Kind => {
            form.kind = match (form.kind, delta.is_positive()) {
                (SendKind::Study, true) => SendKind::Series,
                (SendKind::Series, true) => SendKind::Study,
                (SendKind::Study, false) => SendKind::Series,
                (SendKind::Series, false) => SendKind::Study,
            };
        }
        SendField::Uid | SendField::DestinationNode => {}
    }
}

pub(super) fn build_send_request(
    form: &SendFormState,
) -> anyhow::Result<(SendKind, String, String)> {
    let uid = form.uid.trim();
    if uid.is_empty() {
        return Err(anyhow!("UID is required"));
    }
    validate_uid(uid)?;

    let destination = form.destination_node.trim();
    if destination.is_empty() {
        return Err(anyhow!("destination node is required"));
    }

    Ok((form.kind, uid.to_string(), destination.to_string()))
}

fn parse_optional_u64_unlimited(raw: &str, label: &str) -> anyhow::Result<Option<u64>> {
    let value = raw.trim();
    if value.is_empty() || value.eq_ignore_ascii_case("none") {
        return Ok(None);
    }

    let parsed: u64 = value
        .parse()
        .map_err(|_| anyhow!("{label} must be a non-negative integer"))?;
    if parsed == 0 {
        return Err(anyhow!("{label} must be greater than 0"));
    }

    Ok(Some(parsed))
}

fn parse_optional_usize_unlimited(raw: &str, label: &str) -> anyhow::Result<Option<usize>> {
    let value = raw.trim();
    if value.is_empty() || value.eq_ignore_ascii_case("none") {
        return Ok(None);
    }

    let parsed: usize = value
        .parse()
        .map_err(|_| anyhow!("{label} must be a non-negative integer"))?;
    if parsed == 0 {
        return Err(anyhow!("{label} must be greater than 0"));
    }

    Ok(Some(parsed))
}

pub(super) fn parse_storage_scp_form(
    existing: &crate::config::AppConfig,
    form: &StorageScpFormState,
) -> anyhow::Result<crate::config::AppConfig> {
    let local_ae_title = form.local_ae_title.trim().to_ascii_uppercase();
    if local_ae_title.is_empty() {
        return Err(anyhow!("local AE title is required"));
    }
    validate_ae_title(&local_ae_title)
        .map_err(|err| anyhow!("local AE title is invalid: {err}"))?;

    let bind_addr = form.bind_addr.trim();
    if bind_addr.is_empty() {
        return Err(anyhow!("bind address is required"));
    }

    let port = form.port.trim();
    if port.is_empty() {
        return Err(anyhow!("port is required"));
    }
    let storage_scp_port = parse_port(port)?;

    let max_pdu_length = form.max_pdu_length.trim();
    if max_pdu_length.is_empty() {
        return Err(anyhow!("max PDU length is required"));
    }
    let max_pdu_length: u32 = max_pdu_length
        .parse()
        .map_err(|_| anyhow!("max PDU length must be an integer"))?;
    if max_pdu_length == 0 {
        return Err(anyhow!("max PDU length must be greater than 0"));
    }

    let max_file_import_bytes =
        parse_optional_u64_unlimited(&form.max_file_import_bytes, "max file import bytes")?;
    let max_zip_entry_bytes =
        parse_optional_u64_unlimited(&form.max_zip_entry_bytes, "max zip entry bytes")?;
    let max_zip_total_bytes =
        parse_optional_u64_unlimited(&form.max_zip_total_bytes, "max zip total bytes")?;
    let max_zip_entry_count =
        parse_optional_usize_unlimited(&form.max_zip_entry_count, "max zip entry count")?;
    let max_store_object_bytes =
        parse_optional_u64_unlimited(&form.max_store_object_bytes, "max store object bytes")?;

    let mut next = existing.clone();
    next.local_ae_title = local_ae_title;
    next.storage_bind_addr = bind_addr.to_string();
    next.storage_scp_port = storage_scp_port;
    next.max_pdu_length = max_pdu_length;
    next.strict_pdu = form.strict_pdu;
    next.allow_promiscuous_storage = form.allow_promiscuous_storage;

    next.max_file_import_bytes = max_file_import_bytes;
    next.max_zip_entry_bytes = max_zip_entry_bytes;
    next.max_zip_total_bytes = max_zip_total_bytes;
    next.max_zip_entry_count = max_zip_entry_count;
    next.max_store_object_bytes = max_store_object_bytes;

    Ok(next)
}

impl RetrieveFormState {
    pub(super) fn from_result(
        node: RemoteNode,
        model: QueryModel,
        result: &QueryMatch,
        local_ae_title: &str,
    ) -> anyhow::Result<Self> {
        if result.level == QueryLevel::Patient {
            return Err(anyhow!("patient-level retrieve is not supported"));
        }

        let study_uid = result
            .study_instance_uid
            .as_deref()
            .map(str::trim)
            .filter(|value| !value.is_empty())
            .ok_or_else(|| anyhow!("selected result does not include a study UID"))?;

        let destination = node
            .preferred_move_destination
            .clone()
            .unwrap_or_else(|| local_ae_title.to_string());

        Ok(Self {
            node,
            active: RetrieveField::Model,
            model,
            level: result.level,
            study_uid: study_uid.to_string(),
            series_uid: result.series_instance_uid.clone().unwrap_or_default(),
            instance_uid: result.sop_instance_uid.clone().unwrap_or_default(),
            destination,
            error: None,
            touched: std::collections::BTreeSet::new(),
        })
    }

    pub(super) fn active_text_mut(&mut self) -> Option<&mut String> {
        match self.active {
            RetrieveField::Model | RetrieveField::Level => None,
            RetrieveField::StudyUid => Some(&mut self.study_uid),
            RetrieveField::SeriesUid => Some(&mut self.series_uid),
            RetrieveField::InstanceUid => Some(&mut self.instance_uid),
            RetrieveField::Destination => Some(&mut self.destination),
        }
    }
}

#[derive(Clone, Debug)]
pub(super) struct DeleteConfirmState {
    pub(super) node: RemoteNode,
}

#[derive(Clone, Debug)]
pub(super) struct TaskInspectState {
    pub(super) title: String,
    pub(super) content: Text<'static>,
}

fn validate_dicom_date(value: &str) -> anyhow::Result<()> {
    if value.len() != 8 {
        return Err(anyhow!("expected YYYYMMDD"));
    }
    if !value.chars().all(|c| c.is_ascii_digit()) {
        return Err(anyhow!("expected YYYYMMDD"));
    }
    Ok(())
}

pub(super) fn validate_uid(value: &str) -> anyhow::Result<()> {
    if value.is_empty() {
        return Err(anyhow!("UID cannot be empty"));
    }
    if value.len() > 64 {
        return Err(anyhow!("UID must be at most 64 characters"));
    }
    if value.starts_with('.') || value.ends_with('.') {
        return Err(anyhow!("UID cannot start or end with a dot"));
    }
    for part in value.split('.') {
        if part.is_empty() {
            return Err(anyhow!("UID cannot contain empty components"));
        }
        if part.len() > 16 {
            return Err(anyhow!("UID component '{}' is too long", part));
        }
        if !part.chars().all(|c| c.is_ascii_digit()) {
            return Err(anyhow!("UID component '{}' must be numeric", part));
        }
        if part.len() > 1 && part.starts_with('0') {
            return Err(anyhow!(
                "UID component '{}' cannot have leading zeros",
                part
            ));
        }
    }
    Ok(())
}

fn validate_modality(value: &str) -> anyhow::Result<()> {
    let trimmed = value.trim();
    if trimmed.is_empty() {
        return Err(anyhow!("modality cannot be empty"));
    }
    if trimmed.len() > 16 {
        return Err(anyhow!("modality must be at most 16 characters"));
    }
    if !trimmed
        .chars()
        .all(|c| c.is_ascii_uppercase() || c.is_ascii_digit())
    {
        return Err(anyhow!("modality must be A-Z or 0-9"));
    }
    Ok(())
}

#[cfg(test)]
mod validation_tests {
    use super::{validate_dicom_date, validate_uid};

    #[test]
    fn validate_uid_accepts_common_dicom_uids() {
        validate_uid("1.2.840.10008.1.2.1").expect("valid transfer syntax UID");
        validate_uid("2.25.1234567890123456")
            .expect("valid 2.25-style UID within component limits");
    }

    #[test]
    fn validate_uid_rejects_empty() {
        assert_eq!(
            validate_uid("").unwrap_err().to_string(),
            "UID cannot be empty"
        );
    }

    #[test]
    fn validate_uid_rejects_leading_or_trailing_dot() {
        assert_eq!(
            validate_uid(".1.2.3").unwrap_err().to_string(),
            "UID cannot start or end with a dot"
        );
        assert_eq!(
            validate_uid("1.2.3.").unwrap_err().to_string(),
            "UID cannot start or end with a dot"
        );
    }

    #[test]
    fn validate_uid_rejects_empty_components() {
        assert_eq!(
            validate_uid("1..2").unwrap_err().to_string(),
            "UID cannot contain empty components"
        );
    }

    #[test]
    fn validate_uid_rejects_non_numeric_components() {
        assert_eq!(
            validate_uid("1.2.a").unwrap_err().to_string(),
            "UID component 'a' must be numeric"
        );
    }

    #[test]
    fn validate_uid_rejects_leading_zeros_in_components() {
        assert_eq!(
            validate_uid("1.02.3").unwrap_err().to_string(),
            "UID component '02' cannot have leading zeros"
        );
    }

    #[test]
    fn validate_uid_rejects_component_length_over_16() {
        let too_long = "12345678901234567"; // 17
        assert_eq!(
            validate_uid(&format!("1.{too_long}.3"))
                .unwrap_err()
                .to_string(),
            format!("UID component '{too_long}' is too long")
        );
    }

    #[test]
    fn validate_uid_rejects_total_length_over_64() {
        let uid = "1.1234567890123456.1234567890123456.1234567890123456.1234567890123456";
        assert!(uid.len() > 64);
        assert_eq!(
            validate_uid(uid).unwrap_err().to_string(),
            "UID must be at most 64 characters"
        );
    }

    #[test]
    fn validate_dicom_date_requires_yyyymmdd_digits() {
        validate_dicom_date("20250131").expect("valid DICOM date");

        assert_eq!(
            validate_dicom_date("2025-01-31").unwrap_err().to_string(),
            "expected YYYYMMDD"
        );
        assert_eq!(
            validate_dicom_date("2025013").unwrap_err().to_string(),
            "expected YYYYMMDD"
        );
        assert_eq!(
            validate_dicom_date("202501AA").unwrap_err().to_string(),
            "expected YYYYMMDD"
        );
    }
}

#[derive(Clone, Debug)]
pub(super) enum ModalState {
    AddNode(NodeFormState),
    EditNode(NodeFormState),
    ConfirmDeleteNode(DeleteConfirmState),
    Query(QueryFormState),
    Retrieve(RetrieveFormState),
    Import(ImportFormState),
    Send(SendFormState),
    StorageScp(StorageScpFormState),
    TaskInspect(TaskInspectState),
}

pub(super) fn parse_node_form(form: &NodeFormState) -> anyhow::Result<NodeFormValues> {
    let name = form.name.trim();
    if name.is_empty() {
        return Err(anyhow!("node name is required"));
    }

    let ae_title = form.ae_title.trim().to_ascii_uppercase();
    if ae_title.is_empty() {
        return Err(anyhow!("AE title is required"));
    }
    validate_ae_title(&ae_title)?;

    let host = form.host.trim();
    if host.is_empty() {
        return Err(anyhow!("host is required"));
    }

    let port = form.port.trim();
    if port.is_empty() {
        return Err(anyhow!("port is required"));
    }

    let move_destination = trim_to_option(Some(form.move_destination.clone()))
        .map(|value| value.trim().to_ascii_uppercase());
    if let Some(ref value) = move_destination {
        validate_ae_title(value)
            .map_err(|err| anyhow!("move destination AE title is invalid: {}", err))?;
    }

    Ok(NodeFormValues {
        name: name.to_string(),
        ae_title,
        host: host.to_string(),
        port: parse_port(port)?,
        move_destination,
        notes: trim_to_option(Some(form.notes.clone())),
    })
}

pub(super) fn node_draft_values_from_form(values: NodeFormValues) -> NodeDraftValues {
    NodeDraftValues {
        name: values.name,
        ae_title: values.ae_title,
        host: values.host,
        port: values.port,
        move_destination: values.move_destination,
        notes: values.notes,
    }
}

pub(super) fn node_patch_values_from_form(values: NodeFormValues) -> NodePatchCliValues {
    NodePatchCliValues {
        name: Some(values.name),
        ae_title: Some(values.ae_title),
        host: Some(values.host),
        port: Some(values.port),
        move_destination: values.move_destination,
        notes: values.notes,
    }
}

pub(super) fn build_query_criteria(form: &QueryFormState) -> QueryCriteria {
    QueryCriteria {
        model: form.model,
        level: form.level,
        patient_name: trim_to_option(Some(form.patient_name.clone())),
        patient_id: trim_to_option(Some(form.patient_id.clone())),
        accession_number: trim_to_option(Some(form.accession_number.clone())),
        study_instance_uid: trim_to_option(Some(form.study_uid.clone())),
        series_instance_uid: trim_to_option(Some(form.series_uid.clone())),
        sop_instance_uid: trim_to_option(Some(form.sop_instance_uid.clone())),
        study_date_from: trim_to_option(Some(form.date_from.clone())),
        study_date_to: trim_to_option(Some(form.date_to.clone())),
        modality: trim_to_option(Some(form.modality.clone())),
        study_description: trim_to_option(Some(form.study_description.clone())),
    }
}

pub(super) fn validate_query_form(form: &QueryFormState) -> anyhow::Result<()> {
    let date_from = trim_to_option(Some(form.date_from.clone()));
    let date_to = trim_to_option(Some(form.date_to.clone()));

    if date_from.is_some() ^ date_to.is_some() {
        return Err(anyhow!(
            "both date from and date to must be set, or neither"
        ));
    }

    if let (Some(from), Some(to)) = (date_from.as_deref(), date_to.as_deref()) {
        validate_dicom_date(from).map_err(|err| anyhow!("date from is invalid: {}", err))?;
        validate_dicom_date(to).map_err(|err| anyhow!("date to is invalid: {}", err))?;

        if from > to {
            return Err(anyhow!("date from must be on or before date to"));
        }
    }

    if let Some(modality) = trim_to_option(Some(form.modality.clone())) {
        validate_modality(&modality)?;
    }

    // Enforce level-specific requirements for UID-based searching.
    match form.level {
        QueryLevel::Patient => {}
        QueryLevel::Study => {}
        QueryLevel::Series => {
            if trim_to_option(Some(form.study_uid.clone())).is_none() {
                return Err(anyhow!("study UID is required for series-level queries"));
            }
        }
        QueryLevel::Image => {
            if trim_to_option(Some(form.study_uid.clone())).is_none() {
                return Err(anyhow!("study UID is required for image-level queries"));
            }
            if trim_to_option(Some(form.series_uid.clone())).is_none() {
                return Err(anyhow!("series UID is required for image-level queries"));
            }
        }
    }

    Ok(())
}

pub(super) fn build_move_request(form: &RetrieveFormState) -> anyhow::Result<MoveRequest> {
    let study_instance_uid = trim_to_option(Some(form.study_uid.clone()))
        .ok_or_else(|| anyhow!("study UID is required"))?;
    validate_uid(&study_instance_uid).map_err(|err| anyhow!("study UID is invalid: {}", err))?;

    let input_series_instance_uid = trim_to_option(Some(form.series_uid.clone()));
    let input_sop_instance_uid = trim_to_option(Some(form.instance_uid.clone()));

    let (series_instance_uid, sop_instance_uid) = match form.level {
        QueryLevel::Patient => return Err(anyhow!("patient-level retrieve is not supported")),
        QueryLevel::Study => (None, None),
        QueryLevel::Series => {
            let series_instance_uid = input_series_instance_uid
                .ok_or_else(|| anyhow!("series UID is required for series-level retrieve"))?;
            validate_uid(&series_instance_uid)
                .map_err(|err| anyhow!("series UID is invalid: {}", err))?;
            (Some(series_instance_uid), None)
        }
        QueryLevel::Image => {
            let series_instance_uid = input_series_instance_uid
                .ok_or_else(|| anyhow!("series UID is required for image-level retrieve"))?;
            validate_uid(&series_instance_uid)
                .map_err(|err| anyhow!("series UID is invalid: {}", err))?;

            let sop_instance_uid = input_sop_instance_uid
                .ok_or_else(|| anyhow!("instance UID is required for image-level retrieve"))?;
            validate_uid(&sop_instance_uid)
                .map_err(|err| anyhow!("instance UID is invalid: {}", err))?;

            (Some(series_instance_uid), Some(sop_instance_uid))
        }
    };

    let move_destination = trim_to_option(Some(form.destination.clone()))
        .map(|value| value.trim().to_ascii_uppercase());
    if let Some(ref value) = move_destination {
        validate_ae_title(value)
            .map_err(|err| anyhow!("move destination AE title is invalid: {}", err))?;
    }

    Ok(MoveRequest {
        node_name_or_id: form.node.id.clone(),
        model: form.model,
        level: form.level,
        study_instance_uid,
        series_instance_uid,
        sop_instance_uid,
        move_destination,
    })
}

pub(super) fn build_import_path(form: &ImportFormState) -> anyhow::Result<std::path::PathBuf> {
    let path = form.path.trim();
    if path.is_empty() {
        return Err(anyhow!("import path is required"));
    }

    let path = std::path::PathBuf::from(path);
    let metadata = std::fs::metadata(&path)
        .with_context(|| format!("accessing import path {}", path.display()))?;
    if !(metadata.is_file() || metadata.is_dir()) {
        return Err(anyhow!(
            "import path must be a file or directory: {}",
            path.display()
        ));
    }
    if metadata.is_file() {
        std::fs::File::open(&path)
            .with_context(|| format!("opening import file {}", path.display()))?;
    } else {
        std::fs::read_dir(&path)
            .with_context(|| format!("reading import directory {}", path.display()))?;
    }

    Ok(path)
}

pub(super) fn cycle_query_form_field(form: &mut QueryFormState, delta: isize) {
    match form.active {
        QueryField::Model => {
            form.model = cycle_query_model(form.model, delta);
        }
        QueryField::Level => {
            form.level = cycle_query_level(form.level, delta);
        }
        QueryField::PatientName
        | QueryField::PatientId
        | QueryField::AccessionNumber
        | QueryField::StudyUid
        | QueryField::SeriesUid
        | QueryField::SopInstanceUid
        | QueryField::DateFrom
        | QueryField::DateTo
        | QueryField::Modality
        | QueryField::StudyDescription => {}
    }
}

pub(super) fn cycle_retrieve_form_field(form: &mut RetrieveFormState, delta: isize) {
    match form.active {
        RetrieveField::Model => {
            form.model = cycle_query_model(form.model, delta);
        }
        RetrieveField::Level => {
            form.level = cycle_retrieve_level(form.level, delta);
        }
        RetrieveField::StudyUid
        | RetrieveField::SeriesUid
        | RetrieveField::InstanceUid
        | RetrieveField::Destination => {}
    }
}

pub(super) fn cycle_query_model(current: QueryModel, delta: isize) -> QueryModel {
    advance_enum(
        [QueryModel::PatientRoot, QueryModel::StudyRoot],
        current,
        delta,
    )
}

pub(super) fn cycle_query_level(current: QueryLevel, delta: isize) -> QueryLevel {
    advance_enum(
        [
            QueryLevel::Patient,
            QueryLevel::Study,
            QueryLevel::Series,
            QueryLevel::Image,
        ],
        current,
        delta,
    )
}

pub(super) fn cycle_retrieve_level(current: QueryLevel, delta: isize) -> QueryLevel {
    advance_enum(
        [QueryLevel::Study, QueryLevel::Series, QueryLevel::Image],
        current,
        delta,
    )
}

fn advance_enum<T: Copy + Eq, const N: usize>(values: [T; N], current: T, delta: isize) -> T {
    let current_index = values
        .iter()
        .position(|value| *value == current)
        .unwrap_or(0);
    let next_index = (current_index as isize + delta).rem_euclid(N as isize) as usize;
    values[next_index]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn node_form_parses_and_trims_values() {
        let mut form = NodeFormState::add();
        form.name = "  PACS  ".to_string();
        form.ae_title = " PACSAE ".to_string();
        form.host = " 10.0.0.10 ".to_string();
        form.port = "104".to_string();
        form.move_destination = " DICOMNODECLIENT ".to_string();
        form.notes = " primary archive ".to_string();

        let values = parse_node_form(&form).unwrap();

        assert_eq!(
            values,
            NodeFormValues {
                name: "PACS".to_string(),
                ae_title: "PACSAE".to_string(),
                host: "10.0.0.10".to_string(),
                port: 104,
                move_destination: Some("DICOMNODECLIENT".to_string()),
                notes: Some("primary archive".to_string()),
            }
        );
    }
    #[test]
    fn query_form_maps_defaults_and_optional_fields() {
        let node = RemoteNode {
            id: "node-1".to_string(),
            name: "PACS".to_string(),
            ae_title: "PACSAE".to_string(),
            host: "10.0.0.10".to_string(),
            port: 104,
            preferred_move_destination: None,
            notes: None,
            created_at: String::new(),
            updated_at: String::new(),
        };
        let mut form = QueryFormState::new(node);
        form.patient_name = " DOE^JANE ".to_string();
        form.accession_number = " ACC-42 ".to_string();
        form.study_uid = " 1.2.3 ".to_string();
        form.series_uid = " 1.2.3.4 ".to_string();
        form.sop_instance_uid = " 1.2.3.4.5 ".to_string();
        form.study_description = " Head CT ".to_string();

        let criteria = build_query_criteria(&form);

        assert_eq!(criteria.model, QueryModel::StudyRoot);
        assert_eq!(criteria.level, QueryLevel::Study);
        assert_eq!(criteria.patient_name.as_deref(), Some("DOE^JANE"));
        assert_eq!(criteria.accession_number.as_deref(), Some("ACC-42"));
        assert_eq!(criteria.study_instance_uid.as_deref(), Some("1.2.3"));
        assert_eq!(criteria.series_instance_uid.as_deref(), Some("1.2.3.4"));
        assert_eq!(criteria.sop_instance_uid.as_deref(), Some("1.2.3.4.5"));
        assert_eq!(criteria.modality, None);
        assert_eq!(criteria.study_description.as_deref(), Some("Head CT"));
    }
    #[test]
    fn query_form_omits_empty_optional_fields() {
        let node = RemoteNode {
            id: "node-1".to_string(),
            name: "PACS".to_string(),
            ae_title: "PACSAE".to_string(),
            host: "10.0.0.10".to_string(),
            port: 104,
            preferred_move_destination: None,
            notes: None,
            created_at: String::new(),
            updated_at: String::new(),
        };
        let form = QueryFormState::new(node);

        let criteria = build_query_criteria(&form);

        assert_eq!(criteria.accession_number, None);
        assert_eq!(criteria.series_instance_uid, None);
        assert_eq!(criteria.sop_instance_uid, None);
        assert_eq!(criteria.study_description, None);
    }
    #[test]
    fn retrieve_form_builds_request_and_validates_required_uids() {
        let node = RemoteNode {
            id: "node-1".to_string(),
            name: "PACS".to_string(),
            ae_title: "PACSAE".to_string(),
            host: "10.0.0.10".to_string(),
            port: 104,
            preferred_move_destination: Some("LOCAL_AE".to_string()),
            notes: None,
            created_at: String::new(),
            updated_at: String::new(),
        };

        let mut form = RetrieveFormState {
            node,
            active: RetrieveField::Model,
            model: QueryModel::StudyRoot,
            level: QueryLevel::Image,
            study_uid: "1.2.3".to_string(),
            series_uid: "1.2.3.4".to_string(),
            instance_uid: "1.2.3.4.5".to_string(),
            destination: String::new(),
            error: None,
            touched: std::collections::BTreeSet::new(),
        };

        let request = build_move_request(&form).unwrap();
        assert_eq!(request.study_instance_uid, "1.2.3");
        assert_eq!(request.series_instance_uid.as_deref(), Some("1.2.3.4"));
        assert_eq!(request.sop_instance_uid.as_deref(), Some("1.2.3.4.5"));
        assert_eq!(request.move_destination, None);

        form.instance_uid.clear();
        let error = build_move_request(&form).unwrap_err().to_string();
        assert!(error.contains("instance UID is required"));
    }
    #[test]
    fn retrieve_form_drops_narrower_uids_for_broader_levels() {
        let node = RemoteNode {
            id: "node-1".to_string(),
            name: "PACS".to_string(),
            ae_title: "PACSAE".to_string(),
            host: "10.0.0.10".to_string(),
            port: 104,
            preferred_move_destination: Some("LOCAL_AE".to_string()),
            notes: None,
            created_at: String::new(),
            updated_at: String::new(),
        };

        let mut form = RetrieveFormState {
            node,
            active: RetrieveField::Model,
            model: QueryModel::StudyRoot,
            level: QueryLevel::Image,
            study_uid: "1.2.3".to_string(),
            series_uid: "1.2.3.4".to_string(),
            instance_uid: "1.2.3.4.5".to_string(),
            destination: String::new(),
            error: None,
            touched: std::collections::BTreeSet::new(),
        };

        form.level = QueryLevel::Study;
        let study_request = build_move_request(&form).unwrap();
        assert_eq!(study_request.series_instance_uid, None);
        assert_eq!(study_request.sop_instance_uid, None);

        form.level = QueryLevel::Series;
        let series_request = build_move_request(&form).unwrap();
        assert_eq!(
            series_request.series_instance_uid.as_deref(),
            Some("1.2.3.4")
        );
        assert_eq!(series_request.sop_instance_uid, None);
    }
    #[test]
    fn retrieve_form_prefills_from_selected_result() {
        let node = RemoteNode {
            id: "node-1".to_string(),
            name: "PACS".to_string(),
            ae_title: "PACSAE".to_string(),
            host: "10.0.0.10".to_string(),
            port: 104,
            preferred_move_destination: None,
            notes: None,
            created_at: String::new(),
            updated_at: String::new(),
        };
        let result = QueryMatch {
            level: QueryLevel::Series,
            patient_name: None,
            patient_id: None,
            accession_number: None,
            study_instance_uid: Some("1.2.3".to_string()),
            series_instance_uid: Some("1.2.3.4".to_string()),
            sop_instance_uid: None,
            study_date: None,
            study_description: None,
            series_description: None,
            series_number: None,
            modality: None,
            instance_number: None,
        };

        let form = RetrieveFormState::from_result(node, QueryModel::StudyRoot, &result, "LOCAL_AE")
            .unwrap();

        assert_eq!(form.level, QueryLevel::Series);
        assert_eq!(form.study_uid, "1.2.3");
        assert_eq!(form.series_uid, "1.2.3.4");
        assert_eq!(form.destination, "LOCAL_AE");
    }
    #[test]
    fn retrieve_level_cycles_forward_without_patient() {
        let mut level = QueryLevel::Study;

        level = cycle_retrieve_level(level, 1);
        assert_eq!(level, QueryLevel::Series);

        level = cycle_retrieve_level(level, 1);
        assert_eq!(level, QueryLevel::Image);

        level = cycle_retrieve_level(level, 1);
        assert_eq!(level, QueryLevel::Study);
    }
    #[test]
    fn retrieve_level_cycles_backward_without_patient() {
        let mut level = QueryLevel::Study;

        level = cycle_retrieve_level(level, -1);
        assert_eq!(level, QueryLevel::Image);

        level = cycle_retrieve_level(level, -1);
        assert_eq!(level, QueryLevel::Series);

        level = cycle_retrieve_level(level, -1);
        assert_eq!(level, QueryLevel::Study);
    }

    #[test]
    fn parse_optional_u64_unlimited_accepts_blank_and_none() {
        assert_eq!(parse_optional_u64_unlimited("", "value").unwrap(), None);
        assert_eq!(parse_optional_u64_unlimited("   ", "value").unwrap(), None);
        assert_eq!(parse_optional_u64_unlimited("none", "value").unwrap(), None);
        assert_eq!(parse_optional_u64_unlimited("NoNe", "value").unwrap(), None);
    }

    #[test]
    fn parse_optional_u64_unlimited_parses_numbers() {
        assert_eq!(
            parse_optional_u64_unlimited("42", "value").unwrap(),
            Some(42)
        );
        assert_eq!(
            parse_optional_u64_unlimited("  1048576  ", "value").unwrap(),
            Some(1_048_576)
        );
    }

    #[test]
    fn parse_optional_u64_unlimited_rejects_invalid_values() {
        let err = parse_optional_u64_unlimited("-1", "value")
            .unwrap_err()
            .to_string();
        assert!(err.contains("must be a non-negative integer"));

        let err = parse_optional_u64_unlimited("1.5", "value")
            .unwrap_err()
            .to_string();
        assert!(err.contains("must be a non-negative integer"));

        let err = parse_optional_u64_unlimited("nope", "value")
            .unwrap_err()
            .to_string();
        assert!(err.contains("must be a non-negative integer"));

        let err = parse_optional_u64_unlimited("0", "value")
            .unwrap_err()
            .to_string();
        assert!(err.contains("must be greater than 0"));
    }

    #[test]
    fn parse_optional_usize_unlimited_accepts_blank_and_none() {
        assert_eq!(parse_optional_usize_unlimited("", "value").unwrap(), None);
        assert_eq!(
            parse_optional_usize_unlimited(" none ", "value").unwrap(),
            None
        );
    }

    #[test]
    fn parse_optional_usize_unlimited_parses_numbers() {
        assert_eq!(
            parse_optional_usize_unlimited("3", "value").unwrap(),
            Some(3)
        );
    }

    #[test]
    fn parse_optional_usize_unlimited_rejects_invalid_values() {
        let err = parse_optional_usize_unlimited("-1", "value")
            .unwrap_err()
            .to_string();
        assert!(err.contains("must be a non-negative integer"));

        let err = parse_optional_usize_unlimited("1.5", "value")
            .unwrap_err()
            .to_string();
        assert!(err.contains("must be a non-negative integer"));

        let err = parse_optional_usize_unlimited("nope", "value")
            .unwrap_err()
            .to_string();
        assert!(err.contains("must be a non-negative integer"));

        let err = parse_optional_usize_unlimited("0", "value")
            .unwrap_err()
            .to_string();
        assert!(err.contains("must be greater than 0"));
    }
}
