use super::*;

pub(super) fn node_draft_values_from_kv(
    services: &AppServices,
    kv: &HashMap<String, String>,
) -> anyhow::Result<NodeDraftValues> {
    Ok(NodeDraftValues {
        name: required_trimmed_kv(kv, "name")?.to_string(),
        ae_title: required_trimmed_kv_alt(kv, AE_TITLE_ALIASES)?.to_string(),
        host: required_trimmed_kv(kv, "host")?.to_string(),
        port: services.parse_port_kv(required_kv(kv, "port")?)?,
        move_destination: trim_to_option(
            get_kv_alt(kv, MOVE_DESTINATION_ALIASES).map(str::to_string),
        ),
        notes: trim_to_option(kv.get("notes").cloned()),
    })
}

pub(super) fn node_patch_values_from_kv(
    services: &AppServices,
    kv: &HashMap<String, String>,
) -> anyhow::Result<NodePatchCliValues> {
    Ok(NodePatchCliValues {
        name: kv.get("name").map(|value| value.trim().to_string()),
        ae_title: get_kv_alt(kv, AE_TITLE_ALIASES).map(|value| value.trim().to_string()),
        host: kv.get("host").map(|value| value.trim().to_string()),
        port: kv
            .get("port")
            .map(|value| services.parse_port_kv(value))
            .transpose()?,
        move_destination: trim_to_option(
            get_kv_alt(kv, MOVE_DESTINATION_ALIASES).map(str::to_string),
        ),
        notes: trim_to_option(kv.get("notes").cloned()),
    })
}

pub(super) fn tui_command_help_lines() -> &'static [&'static str] {
    &[
        "commands:",
        "  refresh",
        "  note: canonical names match CLI flags without '--', using underscores.",
        "  node add name=<n> ae=<AE> (or ae_title=<AE>) host=<host> port=<port>",
        "           [dest=<AE> (or move_destination=<AE>)] [notes=..]",
        "  node edit target=<id|name> [name=..] [ae=<AE> (or ae_title=<AE>)]",
        "            [host=..] [port=..] [dest=<AE> (or move_destination=<AE>)] [notes=..]",
        "  node delete target=<id|name> (or id=<id> / name=<name>)",
        "  import path=<folder|file|zip>",
        "  query node=<name> [model=patient|study] [level=patient|study|series|image]",
        "        [patient_name=..] [patient_id=..] [accession=<n> (or accession_number=<n>)]",
        "        [study_uid=<uid> (or study_instance_uid=<uid>)]",
        "        [series_uid=<uid> (or series_instance_uid=<uid>)]",
        "        [instance_uid=<uid> (or sop_instance_uid=<uid>)]",
        "        [date_from=YYYYMMDD (or study_date_from=YYYYMMDD)]",
        "        [date_to=YYYYMMDD (or study_date_to=YYYYMMDD)] [modality=..] [study_description=..]",
        "  retrieve node=<name> study_uid=<uid> (or study_instance_uid=<uid>)",
        "           [series_uid=.. (or series_instance_uid=..)]",
        "           [instance_uid=.. (or sop_instance_uid=..)]",
        "           [dest=<AE> (or move_destination=<AE>)]",
        "  send-study node=<name> (or destination_node=<name>)",
        "             study_uid=<uid> (or study_instance_uid=<uid> or study=<uid>)",
        "  send-series node=<name> (or destination_node=<name>)",
        "              series_uid=<uid> (or series_instance_uid=<uid> or series=<uid>)",
        "  quit",
    ]
}

pub(super) fn parse_key_values(args: &[String]) -> anyhow::Result<HashMap<String, String>> {
    let mut out = HashMap::new();
    for arg in args {
        let (key, value) = arg
            .split_once('=')
            .ok_or_else(|| anyhow!("expected key=value argument, got {arg}"))?;
        out.insert(key.to_string(), value.to_string());
    }
    Ok(out)
}

pub(super) fn parse_query_command_args(args: &[String]) -> anyhow::Result<(String, QueryCriteria)> {
    let kv = parse_key_values(args)?;
    let node_name_or_id = required_kv(&kv, "node")?.to_string();
    let criteria = QueryCriteria {
        model: kv
            .get("model")
            .map(|value| value.parse())
            .transpose()?
            .unwrap_or_default(),
        level: kv
            .get("level")
            .map(|value| value.parse())
            .transpose()?
            .unwrap_or_default(),
        patient_name: kv.get("patient_name").cloned(),
        patient_id: kv.get("patient_id").cloned(),
        accession_number: get_kv_alt(&kv, ACCESSION_NUMBER_ALIASES).map(str::to_string),
        study_instance_uid: get_kv_alt(&kv, STUDY_INSTANCE_UID_ALIASES).map(str::to_string),
        series_instance_uid: get_kv_alt(&kv, SERIES_INSTANCE_UID_ALIASES).map(str::to_string),
        sop_instance_uid: get_kv_alt(&kv, SOP_INSTANCE_UID_ALIASES).map(str::to_string),
        study_date_from: get_kv_alt(&kv, STUDY_DATE_FROM_ALIASES).map(str::to_string),
        study_date_to: get_kv_alt(&kv, STUDY_DATE_TO_ALIASES).map(str::to_string),
        modality: kv.get("modality").cloned(),
        study_description: kv.get("study_description").cloned(),
    };

    Ok((node_name_or_id, criteria))
}

pub(super) fn parse_retrieve_command_args(args: &[String]) -> anyhow::Result<MoveRequest> {
    let kv = parse_key_values(args)?;
    Ok(MoveRequest {
        node_name_or_id: required_kv(&kv, "node")?.to_string(),
        model: kv
            .get("model")
            .map(|value| value.parse())
            .transpose()?
            .unwrap_or_default(),
        level: kv
            .get("level")
            .map(|value| value.parse())
            .transpose()?
            .unwrap_or_default(),
        study_instance_uid: required_kv_alt(&kv, STUDY_INSTANCE_UID_ALIASES)?.to_string(),
        series_instance_uid: get_kv_alt(&kv, SERIES_INSTANCE_UID_ALIASES).map(str::to_string),
        sop_instance_uid: get_kv_alt(&kv, SOP_INSTANCE_UID_ALIASES).map(str::to_string),
        move_destination: get_kv_alt(&kv, MOVE_DESTINATION_ALIASES).map(str::to_string),
    })
}

pub(super) fn parse_send_study_command_args(args: &[String]) -> anyhow::Result<(String, String)> {
    parse_send_command_args(args, STUDY_INSTANCE_UID_ALIASES)
}

pub(super) fn parse_send_series_command_args(args: &[String]) -> anyhow::Result<(String, String)> {
    parse_send_command_args(args, SERIES_INSTANCE_UID_ALIASES)
}

pub(super) fn parse_send_command_args(
    args: &[String],
    uid_aliases: &[&str],
) -> anyhow::Result<(String, String)> {
    let kv = parse_key_values(args)?;
    Ok((
        required_kv_alt(&kv, uid_aliases)?.to_string(),
        required_kv_alt(&kv, DESTINATION_NODE_ALIASES)?.to_string(),
    ))
}

pub(super) fn required_kv<'a>(
    map: &'a HashMap<String, String>,
    key: &str,
) -> anyhow::Result<&'a str> {
    map.get(key)
        .map(String::as_str)
        .ok_or_else(|| anyhow!("missing required argument: {key}"))
}

pub(super) fn get_kv_alt<'a>(map: &'a HashMap<String, String>, keys: &[&str]) -> Option<&'a str> {
    keys.iter()
        .find_map(|key| map.get(*key).map(String::as_str))
}

pub(super) fn required_kv_alt<'a>(
    map: &'a HashMap<String, String>,
    keys: &[&str],
) -> anyhow::Result<&'a str> {
    get_kv_alt(map, keys)
        .ok_or_else(|| anyhow!("missing required argument: one of {}", keys.join(", ")))
}

pub(super) fn required_trimmed_kv<'a>(
    map: &'a HashMap<String, String>,
    key: &str,
) -> anyhow::Result<&'a str> {
    let value = required_kv(map, key)?.trim();
    if value.is_empty() {
        Err(anyhow!("missing required argument: {key}"))
    } else {
        Ok(value)
    }
}

pub(super) fn required_trimmed_kv_alt<'a>(
    map: &'a HashMap<String, String>,
    keys: &[&str],
) -> anyhow::Result<&'a str> {
    if let Some(value) = get_kv_alt(map, keys) {
        let value = value.trim();
        if !value.is_empty() {
            return Ok(value);
        }
    }
    Err(anyhow!(
        "missing required argument: one of {}",
        keys.join(", ")
    ))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::tui::test_support::{args, test_services};

    #[test]
    fn help_command_lists_aliases_and_canonical_names() {
        let services = test_services();
        let mut app = TuiApp::new(services.services.clone());

        app.execute_command("help").unwrap();

        let output = app.logs.join("\n");
        // README.md "Quick start" -> "TUI syntax".
        assert!(output.contains("node add name=<n> ae=<AE> (or ae_title=<AE>)"));
        assert!(
            output.contains("retrieve node=<name> study_uid=<uid> (or study_instance_uid=<uid>)")
        );
        assert!(output.contains("send-series node=<name> (or destination_node=<name>)"));
        // README.md "Command interfaces" -> "TUI alias support".
        assert!(output.contains("canonical names match CLI flags without '--', using underscores."));
        assert!(output.contains("ae=<AE> (or ae_title=<AE>)"));
        assert!(output.contains("dest=<AE> (or move_destination=<AE>)"));
        assert!(output.contains("date_from=YYYYMMDD (or study_date_from=YYYYMMDD)"));
        assert!(output.contains("study_uid=<uid> (or study_instance_uid=<uid> or study=<uid>)"));
        assert!(output.contains("node=<name> (or destination_node=<name>)"));
    }
    #[test]
    fn query_command_parser_accepts_short_and_canonical_aliases() {
        let (short_node, short_criteria) = parse_query_command_args(&args(&[
            "node=pacs",
            "model=study",
            "level=study",
            "patient_name=DOE^JOHN",
            "patient_id=MRN-123",
            "accession=ACC-1",
            "study_uid=1.2.3",
            "series_uid=1.2.3.4",
            "instance_uid=1.2.3.4.5",
            "date_from=20240101",
            "date_to=20240131",
            "modality=CT",
            "study_description=HeadCT",
        ]))
        .unwrap();

        assert_eq!(short_node, "pacs");
        assert_eq!(short_criteria.study_instance_uid.as_deref(), Some("1.2.3"));
        assert_eq!(
            short_criteria.series_instance_uid.as_deref(),
            Some("1.2.3.4")
        );
        assert_eq!(
            short_criteria.sop_instance_uid.as_deref(),
            Some("1.2.3.4.5")
        );
        assert_eq!(short_criteria.study_date_from.as_deref(), Some("20240101"));
        assert_eq!(short_criteria.study_date_to.as_deref(), Some("20240131"));
        assert_eq!(short_criteria.accession_number.as_deref(), Some("ACC-1"));
        assert_eq!(short_criteria.modality.as_deref(), Some("CT"));
        assert_eq!(short_criteria.study_description.as_deref(), Some("HeadCT"));

        let (canonical_node, canonical_criteria) = parse_query_command_args(&args(&[
            "node=archive",
            "model=patient",
            "level=series",
            "accession_number=ACC-2",
            "study_instance_uid=2.3.4",
            "series_instance_uid=2.3.4.5",
            "sop_instance_uid=2.3.4.5.6",
            "study_date_from=20240201",
            "study_date_to=20240229",
        ]))
        .unwrap();

        assert_eq!(canonical_node, "archive");
        assert_eq!(canonical_criteria.model, QueryModel::PatientRoot);
        assert_eq!(canonical_criteria.level, QueryLevel::Series);
        assert_eq!(
            canonical_criteria.study_instance_uid.as_deref(),
            Some("2.3.4")
        );
        assert_eq!(
            canonical_criteria.series_instance_uid.as_deref(),
            Some("2.3.4.5")
        );
        assert_eq!(
            canonical_criteria.sop_instance_uid.as_deref(),
            Some("2.3.4.5.6")
        );
        assert_eq!(
            canonical_criteria.study_date_from.as_deref(),
            Some("20240201")
        );
        assert_eq!(
            canonical_criteria.study_date_to.as_deref(),
            Some("20240229")
        );
        assert_eq!(
            canonical_criteria.accession_number.as_deref(),
            Some("ACC-2")
        );
    }
    #[test]
    fn retrieve_command_parser_accepts_dest_and_move_destination_forms() {
        let short = parse_retrieve_command_args(&args(&[
            "node=pacs",
            "study_uid=1.2.3",
            "series_uid=1.2.3.4",
            "instance_uid=1.2.3.4.5",
            "dest=LOCAL_AE",
        ]))
        .unwrap();

        assert_eq!(short.node_name_or_id, "pacs");
        assert_eq!(short.study_instance_uid, "1.2.3");
        assert_eq!(short.series_instance_uid.as_deref(), Some("1.2.3.4"));
        assert_eq!(short.sop_instance_uid.as_deref(), Some("1.2.3.4.5"));
        assert_eq!(short.move_destination.as_deref(), Some("LOCAL_AE"));

        let canonical = parse_retrieve_command_args(&args(&[
            "node=archive",
            "model=patient",
            "level=series",
            "study_instance_uid=2.3.4",
            "series_instance_uid=2.3.4.5",
            "sop_instance_uid=2.3.4.5.6",
            "move_destination=STORE_AE",
        ]))
        .unwrap();

        assert_eq!(canonical.node_name_or_id, "archive");
        assert_eq!(canonical.model, QueryModel::PatientRoot);
        assert_eq!(canonical.level, QueryLevel::Series);
        assert_eq!(canonical.study_instance_uid, "2.3.4");
        assert_eq!(canonical.move_destination.as_deref(), Some("STORE_AE"));
    }
    #[test]
    fn send_command_parsers_accept_node_and_destination_node_forms() {
        let (study_uid, study_node) =
            parse_send_study_command_args(&args(&["node=archive", "study_uid=1.2.3"])).unwrap();
        assert_eq!(study_uid, "1.2.3");
        assert_eq!(study_node, "archive");

        let (study_uid, study_node) =
            parse_send_study_command_args(&args(&["destination_node=store", "study=2.3.4"]))
                .unwrap();
        assert_eq!(study_uid, "2.3.4");
        assert_eq!(study_node, "store");

        let (series_uid, series_node) =
            parse_send_series_command_args(&args(&["node=archive", "series_uid=1.2.3.4"])).unwrap();
        assert_eq!(series_uid, "1.2.3.4");
        assert_eq!(series_node, "archive");

        let (series_uid, series_node) = parse_send_series_command_args(&args(&[
            "destination_node=store",
            "series_instance_uid=2.3.4.5",
        ]))
        .unwrap();
        assert_eq!(series_uid, "2.3.4.5");
        assert_eq!(series_node, "store");
    }
    #[test]
    fn command_parsers_report_missing_required_arguments() {
        let query_error = parse_query_command_args(&args(&["patient_name=DOE^JOHN"])).unwrap_err();
        assert_eq!(query_error.to_string(), "missing required argument: node");

        let retrieve_error = parse_retrieve_command_args(&args(&["node=pacs"])).unwrap_err();
        assert!(retrieve_error.to_string().contains("study_instance_uid"));

        let send_error = parse_send_study_command_args(&args(&["study_uid=1.2.3"])).unwrap_err();
        assert!(send_error.to_string().contains("destination_node"));
    }
    #[test]
    fn node_kv_mapping_normalizes_empty_optional_fields() {
        let services = test_services();
        let add_args = vec![
            "name=PACS".to_string(),
            "ae=PACSAE".to_string(),
            "host=10.0.0.10".to_string(),
            "port=104".to_string(),
            "move_destination=".to_string(),
            "notes= ".to_string(),
        ];
        let add_kv = parse_key_values(&add_args).unwrap();

        let draft = node_draft_values_from_kv(&services, &add_kv).unwrap();

        assert_eq!(draft.move_destination, None);
        assert_eq!(draft.notes, None);

        let edit_args = vec!["move_destination=".to_string(), "notes= ".to_string()];
        let edit_kv = parse_key_values(&edit_args).unwrap();

        let patch = node_patch_values_from_kv(&services, &edit_kv).unwrap();

        assert_eq!(patch.move_destination, None);
        assert_eq!(patch.notes, None);
    }
    #[test]
    fn node_kv_mapping_trims_and_validates_required_fields() {
        let services = test_services();
        let args = vec![
            "name= PACS ".to_string(),
            "ae= PACSAE ".to_string(),
            "host= 10.0.0.10 ".to_string(),
            "port=104".to_string(),
        ];
        let kv = parse_key_values(&args).unwrap();

        let draft = node_draft_values_from_kv(&services, &kv).unwrap();

        assert_eq!(draft.name, "PACS");
        assert_eq!(draft.ae_title, "PACSAE");
        assert_eq!(draft.host, "10.0.0.10");

        let edit_args = vec![
            "name= Updated ".to_string(),
            "ae= UPDATEDAE ".to_string(),
            "host= 10.0.0.11 ".to_string(),
        ];
        let edit_kv = parse_key_values(&edit_args).unwrap();

        let patch = node_patch_values_from_kv(&services, &edit_kv).unwrap();

        assert_eq!(patch.name.as_deref(), Some("Updated"));
        assert_eq!(patch.ae_title.as_deref(), Some("UPDATEDAE"));
        assert_eq!(patch.host.as_deref(), Some("10.0.0.11"));

        let blank_args = vec![
            "name= ".to_string(),
            "ae=PACSAE".to_string(),
            "host=10.0.0.10".to_string(),
            "port=104".to_string(),
        ];
        let blank_kv = parse_key_values(&blank_args).unwrap();

        let error = node_draft_values_from_kv(&services, &blank_kv).unwrap_err();

        assert_eq!(error.to_string(), "missing required argument: name");
    }
    #[test]
    fn node_kv_mapping_accepts_canonical_and_short_aliases() {
        let services = test_services();
        let add_args = vec![
            "name=PACS".to_string(),
            "ae_title=PACSAE".to_string(),
            "host=10.0.0.10".to_string(),
            "port=104".to_string(),
            "dest=LOCAL_AE".to_string(),
        ];
        let add_kv = parse_key_values(&add_args).unwrap();

        let draft = node_draft_values_from_kv(&services, &add_kv).unwrap();

        assert_eq!(draft.ae_title, "PACSAE");
        assert_eq!(draft.move_destination.as_deref(), Some("LOCAL_AE"));

        let edit_args = vec![
            "ae_title=UPDATEDAE".to_string(),
            "dest=UPDATED_DEST".to_string(),
        ];
        let edit_kv = parse_key_values(&edit_args).unwrap();

        let patch = node_patch_values_from_kv(&services, &edit_kv).unwrap();

        assert_eq!(patch.ae_title.as_deref(), Some("UPDATEDAE"));
        assert_eq!(patch.move_destination.as_deref(), Some("UPDATED_DEST"));
    }
    #[test]
    fn alias_registry_lookup_accepts_canonical_and_short_names() {
        let args = vec![
            "accession=ACC-1".to_string(),
            "study=1.2.3".to_string(),
            "series_instance_uid=1.2.3.4".to_string(),
            "instance_uid=1.2.3.4.5".to_string(),
            "date_from=20240101".to_string(),
            "study_date_to=20240131".to_string(),
            "destination_node=ARCHIVE".to_string(),
        ];
        let kv = parse_key_values(&args).unwrap();

        assert_eq!(get_kv_alt(&kv, ACCESSION_NUMBER_ALIASES), Some("ACC-1"));
        assert_eq!(get_kv_alt(&kv, STUDY_INSTANCE_UID_ALIASES), Some("1.2.3"));
        assert_eq!(
            get_kv_alt(&kv, SERIES_INSTANCE_UID_ALIASES),
            Some("1.2.3.4")
        );
        assert_eq!(get_kv_alt(&kv, SOP_INSTANCE_UID_ALIASES), Some("1.2.3.4.5"));
        assert_eq!(get_kv_alt(&kv, STUDY_DATE_FROM_ALIASES), Some("20240101"));
        assert_eq!(get_kv_alt(&kv, STUDY_DATE_TO_ALIASES), Some("20240131"));
        assert_eq!(
            required_kv_alt(&kv, DESTINATION_NODE_ALIASES).unwrap(),
            "ARCHIVE"
        );
    }
}
