use super::*;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(super) enum NodeFormMode {
    Add,
    Edit,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
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

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
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

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
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
pub(super) enum ModalState {
    AddNode(NodeFormState),
    EditNode(NodeFormState),
    ConfirmDeleteNode(DeleteConfirmState),
    Query(QueryFormState),
    Retrieve(RetrieveFormState),
}

pub(super) fn parse_node_form(form: &NodeFormState) -> anyhow::Result<NodeFormValues> {
    Ok(NodeFormValues {
        name: form.name.trim().to_string(),
        ae_title: form.ae_title.trim().to_string(),
        host: form.host.trim().to_string(),
        port: parse_port(form.port.trim())?,
        move_destination: trim_to_option(Some(form.move_destination.clone())),
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

pub(super) fn build_move_request(form: &RetrieveFormState) -> anyhow::Result<MoveRequest> {
    let study_instance_uid = trim_to_option(Some(form.study_uid.clone()))
        .ok_or_else(|| anyhow!("study UID is required"))?;
    let input_series_instance_uid = trim_to_option(Some(form.series_uid.clone()));
    let input_sop_instance_uid = trim_to_option(Some(form.instance_uid.clone()));

    let (series_instance_uid, sop_instance_uid) = match form.level {
        QueryLevel::Patient => return Err(anyhow!("patient-level retrieve is not supported")),
        QueryLevel::Study => (None, None),
        QueryLevel::Series => {
            let series_instance_uid = input_series_instance_uid
                .ok_or_else(|| anyhow!("series UID is required for series-level retrieve"))?;
            (Some(series_instance_uid), None)
        }
        QueryLevel::Image => {
            let series_instance_uid = input_series_instance_uid
                .ok_or_else(|| anyhow!("series UID is required for image-level retrieve"))?;
            let sop_instance_uid = input_sop_instance_uid
                .ok_or_else(|| anyhow!("instance UID is required for image-level retrieve"))?;
            (Some(series_instance_uid), Some(sop_instance_uid))
        }
    };

    Ok(MoveRequest {
        node_name_or_id: form.node.id.clone(),
        model: form.model,
        level: form.level,
        study_instance_uid,
        series_instance_uid,
        sop_instance_uid,
        move_destination: trim_to_option(Some(form.destination.clone())),
    })
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
}
