use std::path::{Path, PathBuf};

use anyhow::{anyhow, Context};
use dicom_core::{
    dictionary::{DataDictionary, DataDictionaryEntry},
    header::Header,
    DataElement, PrimitiveValue, Tag, VR,
};
use dicom_dictionary_std::{tags, StandardDataDictionary};
use dicom_object::{mem::InMemDicomObject, FileDicomObject};

use crate::{
    config::now_utc_string,
    error::Result,
    models::{LocalInstance, MoveRequest, QueryCriteria, QueryLevel, QueryMatch},
};

pub type DefaultMemObject = InMemDicomObject<StandardDataDictionary>;
pub type DefaultFileObject = FileDicomObject<DefaultMemObject>;

pub fn get_str_opt(file_obj: &DefaultFileObject, tag: Tag) -> Option<String> {
    file_obj
        .element(tag)
        .ok()
        .and_then(|e| e.to_str().ok())
        .as_deref()
        .map(clean_dicom_str)
        .filter(|s| !s.is_empty())
}
pub fn get_str_opt_from_mem(obj: &DefaultMemObject, tag: Tag) -> Option<String> {
    obj.element(tag)
        .ok()
        .and_then(|e| e.to_str().ok())
        .as_deref()
        .map(clean_dicom_str)
        .filter(|s| !s.is_empty())
}

pub fn required_str(file_obj: &DefaultFileObject, tag: Tag) -> Result<String> {
    get_str_opt(file_obj, tag).ok_or_else(|| {
        let group = format!("{:04X}", tag.0);
        let element = format!("{:04X}", tag.1);
        anyhow!(
            "{}",
            crate::error::msg_with(
                "error-dicom-required-attribute",
                [("group", group.as_str()), ("element", element.as_str())],
            )
        )
    })
}

pub fn clean_dicom_str(value: &str) -> String {
    value.trim_end_matches('\0').trim().to_string()
}

pub fn sanitize_uid_segment(value: &str) -> String {
    value
        .chars()
        .map(|c| match c {
            'a'..='z' | 'A'..='Z' | '0'..='9' | '.' | '_' | '-' => c,
            _ => '_',
        })
        .collect()
}

pub fn managed_file_path(
    store_dir: &Path,
    study_instance_uid: &str,
    series_instance_uid: &str,
    sop_instance_uid: &str,
) -> PathBuf {
    store_dir
        .join(sanitize_uid_segment(study_instance_uid))
        .join(sanitize_uid_segment(series_instance_uid))
        .join(format!("{}.dcm", sanitize_uid_segment(sop_instance_uid)))
}

pub fn attributes_json(file_obj: &DefaultFileObject) -> Result<String> {
    let dictionary = StandardDataDictionary;
    let mut attributes = serde_json::Map::new();

    for element in file_obj.iter() {
        let tag = element.tag();
        if tag == tags::PIXEL_DATA {
            continue;
        }

        let Ok(value) = element.value().to_str() else {
            continue;
        };
        let key = dictionary
            .by_tag(tag)
            .map(|entry| entry.alias().to_string())
            .unwrap_or_else(|| format!("({:04X},{:04X})", tag.0, tag.1));
        attributes.insert(
            key,
            serde_json::Value::String(clean_dicom_str(value.as_ref())),
        );
    }

    serde_json::to_string(&attributes).map_err(Into::into)
}

pub fn extract_local_instance(
    file_obj: &DefaultFileObject,
    source_path: String,
    managed_path: &Path,
    sha256: String,
    file_size_bytes: u64,
    imported_at: Option<String>,
) -> Result<LocalInstance> {
    let study_instance_uid = required_str(file_obj, tags::STUDY_INSTANCE_UID)?;
    let series_instance_uid = required_str(file_obj, tags::SERIES_INSTANCE_UID)?;
    let sop_instance_uid = file_obj.meta().media_storage_sop_instance_uid().to_string();
    let sop_class_uid = file_obj.meta().media_storage_sop_class_uid().to_string();

    Ok(LocalInstance {
        study_instance_uid,
        series_instance_uid,
        sop_instance_uid,
        sop_class_uid,
        transfer_syntax_uid: Some(file_obj.meta().transfer_syntax().to_string()),
        patient_id: get_str_opt(file_obj, tags::PATIENT_ID),
        patient_name: get_str_opt(file_obj, tags::PATIENT_NAME),
        accession_number: get_str_opt(file_obj, tags::ACCESSION_NUMBER),
        study_date: get_str_opt(file_obj, tags::STUDY_DATE),
        study_description: get_str_opt(file_obj, tags::STUDY_DESCRIPTION),
        series_description: get_str_opt(file_obj, tags::SERIES_DESCRIPTION),
        series_number: get_str_opt(file_obj, tags::SERIES_NUMBER),
        modality: get_str_opt(file_obj, tags::MODALITY),
        instance_number: get_str_opt(file_obj, tags::INSTANCE_NUMBER),
        file_size_bytes,
        sha256,
        source_path,
        managed_path: managed_path.to_string_lossy().to_string(),
        attributes_json: Some(attributes_json(file_obj)?),
        imported_at: imported_at.unwrap_or_else(now_utc_string),
    })
}

pub fn build_find_identifier(criteria: &QueryCriteria) -> DefaultMemObject {
    let mut obj = DefaultMemObject::new_empty();

    put_string(
        &mut obj,
        tags::QUERY_RETRIEVE_LEVEL,
        VR::CS,
        criteria.level.as_dicom_str(),
    );

    put_key(
        &mut obj,
        tags::PATIENT_NAME,
        VR::PN,
        criteria.patient_name.clone(),
    );
    put_key(
        &mut obj,
        tags::PATIENT_ID,
        VR::LO,
        criteria.patient_id.clone(),
    );
    put_key(
        &mut obj,
        tags::ACCESSION_NUMBER,
        VR::SH,
        criteria.accession_number.clone(),
    );
    put_key(
        &mut obj,
        tags::STUDY_INSTANCE_UID,
        VR::UI,
        criteria.study_instance_uid.clone(),
    );
    put_key(
        &mut obj,
        tags::SERIES_INSTANCE_UID,
        VR::UI,
        criteria.series_instance_uid.clone(),
    );
    put_key(
        &mut obj,
        tags::SOP_INSTANCE_UID,
        VR::UI,
        criteria.sop_instance_uid.clone(),
    );
    put_key(&mut obj, tags::MODALITY, VR::CS, criteria.modality.clone());
    put_key(
        &mut obj,
        tags::STUDY_DESCRIPTION,
        VR::LO,
        criteria.study_description.clone(),
    );

    if let Some(date_range) = dicom_date_range(
        criteria.study_date_from.as_deref(),
        criteria.study_date_to.as_deref(),
    ) {
        put_string(&mut obj, tags::STUDY_DATE, VR::DA, &date_range);
    }

    put_return_key(&mut obj, tags::PATIENT_NAME, VR::PN);
    put_return_key(&mut obj, tags::PATIENT_ID, VR::LO);
    put_return_key(&mut obj, tags::ACCESSION_NUMBER, VR::SH);
    put_return_key(&mut obj, tags::STUDY_INSTANCE_UID, VR::UI);
    put_return_key(&mut obj, tags::STUDY_DATE, VR::DA);
    put_return_key(&mut obj, tags::STUDY_DESCRIPTION, VR::LO);
    put_return_key(&mut obj, tags::MODALITY, VR::CS);
    put_return_key(&mut obj, tags::MODALITIES_IN_STUDY, VR::CS);
    put_return_key(&mut obj, tags::SERIES_INSTANCE_UID, VR::UI);
    put_return_key(&mut obj, tags::SERIES_DESCRIPTION, VR::LO);
    put_return_key(&mut obj, tags::SERIES_NUMBER, VR::IS);
    put_return_key(&mut obj, tags::SOP_INSTANCE_UID, VR::UI);
    put_return_key(&mut obj, tags::INSTANCE_NUMBER, VR::IS);

    obj
}

pub fn build_move_identifier(request: &MoveRequest) -> DefaultMemObject {
    let mut obj = DefaultMemObject::new_empty();
    put_string(
        &mut obj,
        tags::QUERY_RETRIEVE_LEVEL,
        VR::CS,
        request.level.as_dicom_str(),
    );
    put_string(
        &mut obj,
        tags::STUDY_INSTANCE_UID,
        VR::UI,
        &request.study_instance_uid,
    );

    if let Some(series_instance_uid) = &request.series_instance_uid {
        put_string(
            &mut obj,
            tags::SERIES_INSTANCE_UID,
            VR::UI,
            series_instance_uid,
        );
    }

    if let Some(sop_instance_uid) = &request.sop_instance_uid {
        put_string(&mut obj, tags::SOP_INSTANCE_UID, VR::UI, sop_instance_uid);
    }

    obj
}

pub fn query_match_from_response(obj: &DefaultMemObject, level: QueryLevel) -> QueryMatch {
    QueryMatch {
        level,
        patient_name: get_str_opt_from_mem(obj, tags::PATIENT_NAME),
        patient_id: get_str_opt_from_mem(obj, tags::PATIENT_ID),
        accession_number: get_str_opt_from_mem(obj, tags::ACCESSION_NUMBER),
        study_instance_uid: get_str_opt_from_mem(obj, tags::STUDY_INSTANCE_UID),
        series_instance_uid: get_str_opt_from_mem(obj, tags::SERIES_INSTANCE_UID),
        sop_instance_uid: get_str_opt_from_mem(obj, tags::SOP_INSTANCE_UID),
        study_date: get_str_opt_from_mem(obj, tags::STUDY_DATE),
        study_description: get_str_opt_from_mem(obj, tags::STUDY_DESCRIPTION),
        series_description: get_str_opt_from_mem(obj, tags::SERIES_DESCRIPTION),
        series_number: get_str_opt_from_mem(obj, tags::SERIES_NUMBER),
        modality: get_str_opt_from_mem(obj, tags::MODALITIES_IN_STUDY)
            .or_else(|| get_str_opt_from_mem(obj, tags::MODALITY)),
        instance_number: get_str_opt_from_mem(obj, tags::INSTANCE_NUMBER),
    }
}

pub fn dicom_date_range(from: Option<&str>, to: Option<&str>) -> Option<String> {
    match (from, to) {
        (Some(start), Some(end)) => Some(format!("{}-{}", start.trim(), end.trim())),
        (Some(start), None) => Some(format!("{}-", start.trim())),
        (None, Some(end)) => Some(format!("-{}", end.trim())),
        (None, None) => None,
    }
}

pub fn put_string(obj: &mut DefaultMemObject, tag: Tag, vr: VR, value: &str) {
    obj.put(DataElement::new(
        tag,
        vr,
        PrimitiveValue::from(value.trim().to_string()),
    ));
}

pub fn put_key(obj: &mut DefaultMemObject, tag: Tag, vr: VR, value: Option<String>) {
    if let Some(value) = value {
        let trimmed = value.trim().to_string();
        if !trimmed.is_empty() {
            obj.put(DataElement::new(tag, vr, PrimitiveValue::from(trimmed)));
        }
    }
}

pub fn put_return_key(obj: &mut DefaultMemObject, tag: Tag, vr: VR) {
    if obj.element(tag).is_err() {
        obj.put(DataElement::new(tag, vr, PrimitiveValue::from("")));
    }
}

pub fn read_u16_opt_from_mem(obj: &DefaultMemObject, tag: Tag) -> Option<u16> {
    obj.element(tag).ok()?.to_int::<u16>().ok()
}

pub fn read_u32_opt_from_mem(obj: &DefaultMemObject, tag: Tag) -> Option<u32> {
    obj.element(tag).ok()?.to_int::<u32>().ok()
}

pub fn inspect_file_identity(file_obj: &DefaultFileObject) -> Result<(String, String, String)> {
    let sop_class_uid = file_obj.meta().media_storage_sop_class_uid().to_string();
    let sop_instance_uid = file_obj.meta().media_storage_sop_instance_uid().to_string();
    let transfer_syntax_uid = file_obj.meta().transfer_syntax().to_string();

    if sop_class_uid.is_empty() || sop_instance_uid.is_empty() || transfer_syntax_uid.is_empty() {
        return Err(anyhow!(
            "{}",
            crate::error::msg("error-dicom-meta-incomplete")
        ));
    }

    Ok((sop_class_uid, sop_instance_uid, transfer_syntax_uid))
}

/// Open a DICOM file and extract only the identifiers required for networking (Store SCU),
/// without reading/decoding Pixel Data.
///
/// This uses `read_until(PixelData)` to stop parsing before the potentially-large pixel payload.
pub fn probe_file_identity(path: &std::path::Path) -> Result<(String, String, String)> {
    let file_obj: DefaultFileObject = dicom_object::OpenFileOptions::new()
        .read_until(dicom_dictionary_std::tags::PIXEL_DATA)
        .open_file(path)
        .with_context(|| format!("opening {}", path.display()))?;

    inspect_file_identity(&file_obj)
}

/// Like [`probe_file_identity`], but reads from a stream instead of a file path.
///
/// This is intended for tests where we want to ensure probing does not need to
/// consume an entire input stream.
#[cfg(test)]
pub fn probe_reader_identity<R>(mut reader: R) -> Result<(String, String, String)>
where
    R: std::io::Read,
{
    use std::io::Write;

    // The upstream `dicom_object::OpenFileOptions` API in use by this project
    // supports opening from a file path but not from an arbitrary `Read`.
    // For tests, we write the synthetic data to a temp file.
    let mut tmp = tempfile::NamedTempFile::new().context("creating temp dicom")?;
    std::io::copy(&mut reader, &mut tmp).context("writing temp dicom")?;
    tmp.flush().ok();

    probe_file_identity(tmp.path())
}

pub fn ensure_study_for_series_or_image(request: &MoveRequest) -> Result<()> {
    if request.study_instance_uid.trim().is_empty() {
        return Err(anyhow!(
            "{}",
            crate::error::msg("error-dicom-study-uid-required")
        ));
    }

    match request.level {
        QueryLevel::Patient => Err(anyhow!(
            "{}",
            crate::error::msg("error-dicom-patient-move-unsupported")
        )),
        QueryLevel::Study => Ok(()),
        QueryLevel::Series => {
            if request
                .series_instance_uid
                .as_deref()
                .unwrap_or("")
                .is_empty()
            {
                return Err(anyhow!(
                    "{}",
                    crate::error::msg("error-dicom-series-uid-required-series")
                ));
            }
            Ok(())
        }
        QueryLevel::Image => {
            if request
                .series_instance_uid
                .as_deref()
                .unwrap_or("")
                .is_empty()
            {
                return Err(anyhow!(
                    "{}",
                    crate::error::msg("error-dicom-series-uid-required-image")
                ));
            }
            if request.sop_instance_uid.as_deref().unwrap_or("").is_empty() {
                return Err(anyhow!(
                    "{}",
                    crate::error::msg("error-dicom-sop-uid-required-image")
                ));
            }
            Ok(())
        }
    }
    .context(crate::error::msg("error-dicom-validating-move"))
}

#[cfg(test)]
mod tests {
    use super::{attributes_json, build_find_identifier, dicom_date_range, probe_reader_identity};
    use crate::models::{QueryCriteria, QueryLevel, QueryModel};
    use dicom_dictionary_std::tags;

    #[test]
    fn date_range_for_exact_day_is_preserved() {
        assert_eq!(
            dicom_date_range(Some("20260411"), Some("20260411")).as_deref(),
            Some("20260411-20260411")
        );
    }

    #[test]
    fn find_identifier_keeps_query_keys_when_return_keys_are_added() {
        let criteria = QueryCriteria {
            model: QueryModel::StudyRoot,
            level: QueryLevel::Study,
            patient_name: Some("DOE^JOHN".to_string()),
            study_date_from: Some("20260411".to_string()),
            study_date_to: Some("20260411".to_string()),
            ..QueryCriteria::default()
        };

        let obj = build_find_identifier(&criteria);

        assert_eq!(
            obj.element(tags::PATIENT_NAME)
                .expect("patient name key present")
                .to_str()
                .expect("patient name as string")
                .trim_end_matches('\0'),
            "DOE^JOHN"
        );
        assert_eq!(
            obj.element(tags::STUDY_DATE)
                .expect("study date key present")
                .to_str()
                .expect("study date as string")
                .trim_end_matches('\0'),
            "20260411-20260411"
        );
    }

    #[test]
    fn attributes_json_preserves_unmapped_tags_and_skips_pixel_data() {
        use dicom_dictionary_std::uids::EXPLICIT_VR_LITTLE_ENDIAN;

        let sop_class_uid = "1.2.840.10008.5.1.4.1.1.2";
        let sop_instance_uid = "1.2.3.4.5";
        let obj = dicom_object::mem::InMemDicomObject::from_element_iter([
            dicom_core::DataElement::new(
                tags::MANUFACTURER,
                dicom_core::VR::LO,
                dicom_core::PrimitiveValue::from("ACME Scanner"),
            ),
            dicom_core::DataElement::new(
                tags::SOP_CLASS_UID,
                dicom_core::VR::UI,
                dicom_core::PrimitiveValue::from(sop_class_uid),
            ),
            dicom_core::DataElement::new(
                tags::SOP_INSTANCE_UID,
                dicom_core::VR::UI,
                dicom_core::PrimitiveValue::from(sop_instance_uid),
            ),
            dicom_core::DataElement::new(
                tags::PIXEL_DATA,
                dicom_core::VR::OB,
                dicom_core::PrimitiveValue::from(vec![0x55; 8]),
            ),
        ]);
        let meta = dicom_object::FileMetaTableBuilder::new()
            .media_storage_sop_class_uid(sop_class_uid)
            .media_storage_sop_instance_uid(sop_instance_uid)
            .transfer_syntax(EXPLICIT_VR_LITTLE_ENDIAN)
            .build()
            .expect("meta");
        let file_obj = obj.with_exact_meta(meta);

        let json = attributes_json(&file_obj).expect("serialize attributes");
        let parsed: serde_json::Value = serde_json::from_str(&json).expect("valid json");

        assert_eq!(parsed["Manufacturer"], "ACME Scanner");
        assert!(parsed.get("PixelData").is_none());
    }

    #[test]
    fn probe_reader_identity_returns_expected_uids() {
        use dicom_dictionary_std::uids::EXPLICIT_VR_LITTLE_ENDIAN;

        let dir = tempfile::tempdir().expect("tempdir");
        let path = dir.path().join("test.dcm");

        let sop_class_uid = "1.2.3.4";
        let sop_instance_uid = "1.2.3.4.5";

        let obj = dicom_object::mem::InMemDicomObject::from_element_iter([
            dicom_core::DataElement::new(
                tags::PATIENT_NAME,
                dicom_core::VR::PN,
                dicom_core::PrimitiveValue::from("TEST^PATIENT"),
            ),
            dicom_core::DataElement::new(
                tags::SOP_CLASS_UID,
                dicom_core::VR::UI,
                dicom_core::PrimitiveValue::from(sop_class_uid),
            ),
            dicom_core::DataElement::new(
                tags::SOP_INSTANCE_UID,
                dicom_core::VR::UI,
                dicom_core::PrimitiveValue::from(sop_instance_uid),
            ),
            dicom_core::DataElement::new(
                tags::PIXEL_DATA,
                dicom_core::VR::OB,
                dicom_core::PrimitiveValue::from(vec![0x55; 512 * 512]),
            ),
        ]);

        let meta = dicom_object::FileMetaTableBuilder::new()
            .media_storage_sop_class_uid(sop_class_uid)
            .media_storage_sop_instance_uid(sop_instance_uid)
            .transfer_syntax(EXPLICIT_VR_LITTLE_ENDIAN)
            .build()
            .expect("meta");

        obj.with_exact_meta(meta)
            .write_to_file(&path)
            .expect("write");

        let cursor = std::io::Cursor::new(std::fs::read(&path).expect("read"));

        let (got_sop_class_uid, got_sop_instance_uid, got_ts_uid) =
            probe_reader_identity(cursor).expect("probe ok");

        assert_eq!(got_sop_class_uid, sop_class_uid);
        assert_eq!(got_sop_instance_uid, sop_instance_uid);
        assert_eq!(got_ts_uid, EXPLICIT_VR_LITTLE_ENDIAN);
    }
}
