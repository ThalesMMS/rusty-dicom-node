use std::{
    fs,
    path::{Path, PathBuf},
};

use anyhow::Context;
use dicom_core::{dicom_value, DataElement, PrimitiveValue, VR};
use dicom_dictionary_std::{
    tags,
    uids::{CT_IMAGE_STORAGE, EXPLICIT_VR_LITTLE_ENDIAN},
};
use dicom_object::{mem::InMemDicomObject, FileMetaTableBuilder};

#[derive(Debug, Clone)]
pub struct TestDicomSpec {
    pub study_instance_uid: String,
    pub series_instance_uid: String,
    pub sop_instance_uid: String,
    pub patient_name: String,
    pub patient_id: String,
    pub modality: String,
    pub series_number: u32,
    pub instance_number: u32,
    pub sop_class_uid: String,
    pub transfer_syntax_uid: String,
    pub pixel_byte: u8,
    pub rows: u16,
    pub columns: u16,
}

impl TestDicomSpec {
    pub fn new(
        study_instance_uid: impl Into<String>,
        series_instance_uid: impl Into<String>,
        sop_instance_uid: impl Into<String>,
    ) -> Self {
        Self {
            study_instance_uid: study_instance_uid.into(),
            series_instance_uid: series_instance_uid.into(),
            sop_instance_uid: sop_instance_uid.into(),
            patient_name: "TEST^PATIENT".to_string(),
            patient_id: "TEST-PATIENT".to_string(),
            modality: "CT".to_string(),
            series_number: 1,
            instance_number: 1,
            sop_class_uid: CT_IMAGE_STORAGE.to_string(),
            transfer_syntax_uid: EXPLICIT_VR_LITTLE_ENDIAN.to_string(),
            pixel_byte: 0x55,
            rows: 8,
            columns: 16,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TestDicomFile {
    pub path: PathBuf,
    pub study_instance_uid: String,
    pub series_instance_uid: String,
    pub sop_instance_uid: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TestStudy {
    pub study_instance_uid: String,
    pub files: Vec<TestDicomFile>,
}

pub fn write_valid_dicom_with_pixel_data(
    path: &Path,
    spec: &TestDicomSpec,
) -> anyhow::Result<TestDicomFile> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).with_context(|| format!("creating {}", parent.display()))?;
    }

    let obj = InMemDicomObject::from_element_iter([
        DataElement::new(
            tags::PATIENT_NAME,
            VR::PN,
            PrimitiveValue::from(spec.patient_name.clone()),
        ),
        DataElement::new(
            tags::PATIENT_ID,
            VR::LO,
            PrimitiveValue::from(spec.patient_id.clone()),
        ),
        DataElement::new(
            tags::STUDY_INSTANCE_UID,
            VR::UI,
            PrimitiveValue::from(spec.study_instance_uid.clone()),
        ),
        DataElement::new(
            tags::SERIES_INSTANCE_UID,
            VR::UI,
            PrimitiveValue::from(spec.series_instance_uid.clone()),
        ),
        DataElement::new(
            tags::SOP_CLASS_UID,
            VR::UI,
            PrimitiveValue::from(spec.sop_class_uid.clone()),
        ),
        DataElement::new(
            tags::SOP_INSTANCE_UID,
            VR::UI,
            PrimitiveValue::from(spec.sop_instance_uid.clone()),
        ),
        DataElement::new(
            tags::MODALITY,
            VR::CS,
            PrimitiveValue::from(spec.modality.clone()),
        ),
        DataElement::new(
            tags::SERIES_NUMBER,
            VR::IS,
            PrimitiveValue::from(spec.series_number.to_string()),
        ),
        DataElement::new(
            tags::INSTANCE_NUMBER,
            VR::IS,
            PrimitiveValue::from(spec.instance_number.to_string()),
        ),
        DataElement::new(tags::ROWS, VR::US, dicom_value!(U16, [spec.rows])),
        DataElement::new(tags::COLUMNS, VR::US, dicom_value!(U16, [spec.columns])),
        DataElement::new(tags::SAMPLES_PER_PIXEL, VR::US, dicom_value!(U16, [1])),
        DataElement::new(
            tags::PHOTOMETRIC_INTERPRETATION,
            VR::CS,
            PrimitiveValue::from("MONOCHROME2"),
        ),
        DataElement::new(tags::BITS_ALLOCATED, VR::US, dicom_value!(U16, [8])),
        DataElement::new(tags::BITS_STORED, VR::US, dicom_value!(U16, [8])),
        DataElement::new(tags::HIGH_BIT, VR::US, dicom_value!(U16, [7])),
        DataElement::new(tags::PIXEL_REPRESENTATION, VR::US, dicom_value!(U16, [0])),
        DataElement::new(
            tags::PIXEL_DATA,
            VR::OB,
            PrimitiveValue::from(vec![
                spec.pixel_byte;
                spec.rows as usize * spec.columns as usize
            ]),
        ),
    ]);
    let meta = FileMetaTableBuilder::new()
        .media_storage_sop_class_uid(&spec.sop_class_uid)
        .media_storage_sop_instance_uid(&spec.sop_instance_uid)
        .transfer_syntax(&spec.transfer_syntax_uid)
        .build()
        .context("building file meta")?;

    obj.with_exact_meta(meta)
        .write_to_file(path)
        .with_context(|| format!("writing {}", path.display()))?;

    Ok(TestDicomFile {
        path: path.to_path_buf(),
        study_instance_uid: spec.study_instance_uid.clone(),
        series_instance_uid: spec.series_instance_uid.clone(),
        sop_instance_uid: spec.sop_instance_uid.clone(),
    })
}

pub fn create_test_study(
    dir: &Path,
    study_instance_uid: &str,
    series_count: usize,
    instances_per_series: usize,
) -> anyhow::Result<TestStudy> {
    let mut files = Vec::with_capacity(series_count.saturating_mul(instances_per_series));

    for series_index in 0..series_count {
        let series_instance_uid = format!("{}.{}", study_instance_uid, series_index + 1);
        for instance_index in 0..instances_per_series {
            let sop_instance_uid = format!("{}.{}", series_instance_uid, instance_index + 1);
            let mut spec = TestDicomSpec::new(
                study_instance_uid.to_string(),
                series_instance_uid.clone(),
                sop_instance_uid,
            );
            spec.series_number = (series_index + 1) as u32;
            spec.instance_number = (instance_index + 1) as u32;

            let path = dir
                .join(format!("series-{}", series_index + 1))
                .join(format!("instance-{}.dcm", instance_index + 1));
            files.push(write_valid_dicom_with_pixel_data(&path, &spec)?);
        }
    }

    Ok(TestStudy {
        study_instance_uid: study_instance_uid.to_string(),
        files,
    })
}
