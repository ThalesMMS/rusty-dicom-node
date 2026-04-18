use dicom_dictionary_std::uids::*;
use dicom_encoding::TransferSyntaxIndex;
use dicom_transfer_syntax_registry::TransferSyntaxRegistry;

use crate::config::StoreTransferSyntaxPreference;

/// A storage-oriented set of abstract syntaxes for an embedded storage SCP.
/// This intentionally mirrors the broad pattern used by dicom-rs examples.
#[allow(deprecated)]
pub static STORAGE_ABSTRACT_SYNTAXES: &[&str] = &[
    CT_IMAGE_STORAGE,
    ENHANCED_CT_IMAGE_STORAGE,
    STANDALONE_CURVE_STORAGE,
    STANDALONE_OVERLAY_STORAGE,
    SECONDARY_CAPTURE_IMAGE_STORAGE,
    ULTRASOUND_IMAGE_STORAGE_RETIRED,
    NUCLEAR_MEDICINE_IMAGE_STORAGE_RETIRED,
    MR_IMAGE_STORAGE,
    ENHANCED_MR_IMAGE_STORAGE,
    MR_SPECTROSCOPY_STORAGE,
    ENHANCED_MR_COLOR_IMAGE_STORAGE,
    ULTRASOUND_MULTI_FRAME_IMAGE_STORAGE_RETIRED,
    COMPUTED_RADIOGRAPHY_IMAGE_STORAGE,
    DIGITAL_X_RAY_IMAGE_STORAGE_FOR_PRESENTATION,
    DIGITAL_X_RAY_IMAGE_STORAGE_FOR_PROCESSING,
    ENCAPSULATED_PDF_STORAGE,
    ENCAPSULATED_CDA_STORAGE,
    ENCAPSULATED_STL_STORAGE,
    GRAYSCALE_SOFTCOPY_PRESENTATION_STATE_STORAGE,
    POSITRON_EMISSION_TOMOGRAPHY_IMAGE_STORAGE,
    BREAST_TOMOSYNTHESIS_IMAGE_STORAGE,
    BREAST_PROJECTION_X_RAY_IMAGE_STORAGE_FOR_PRESENTATION,
    BREAST_PROJECTION_X_RAY_IMAGE_STORAGE_FOR_PROCESSING,
    ENHANCED_PET_IMAGE_STORAGE,
    RT_IMAGE_STORAGE,
    NUCLEAR_MEDICINE_IMAGE_STORAGE,
    ULTRASOUND_MULTI_FRAME_IMAGE_STORAGE,
    MULTI_FRAME_SINGLE_BIT_SECONDARY_CAPTURE_IMAGE_STORAGE,
    MULTI_FRAME_GRAYSCALE_BYTE_SECONDARY_CAPTURE_IMAGE_STORAGE,
    MULTI_FRAME_GRAYSCALE_WORD_SECONDARY_CAPTURE_IMAGE_STORAGE,
    MULTI_FRAME_TRUE_COLOR_SECONDARY_CAPTURE_IMAGE_STORAGE,
    BASIC_TEXT_SR_STORAGE,
    ENHANCED_SR_STORAGE,
    COMPREHENSIVE_SR_STORAGE,
    VERIFICATION,
];

pub fn all_supported_transfer_syntaxes() -> Vec<String> {
    TransferSyntaxRegistry
        .iter()
        .filter(|ts| !ts.is_unsupported())
        .map(|ts| ts.uid().to_string())
        .collect()
}

#[allow(deprecated)]
pub fn common_store_transfer_syntaxes(
    default_preference: StoreTransferSyntaxPreference,
    file_transfer_syntax: &str,
) -> Vec<String> {
    let mut out = Vec::new();

    push_transfer_syntax(&mut out, default_preference.uid());
    push_transfer_syntax(&mut out, file_transfer_syntax.trim());

    for uid in [
        IMPLICIT_VR_LITTLE_ENDIAN,
        EXPLICIT_VR_LITTLE_ENDIAN,
        DEFLATED_EXPLICIT_VR_LITTLE_ENDIAN,
        EXPLICIT_VR_BIG_ENDIAN,
    ] {
        push_transfer_syntax(&mut out, uid);
    }

    out
}

pub fn can_send_file_with_transfer_syntax(
    file_transfer_syntax: &str,
    target_transfer_syntax: &str,
) -> bool {
    let file_transfer_syntax = file_transfer_syntax.trim();
    let target_transfer_syntax = target_transfer_syntax.trim();

    if file_transfer_syntax.is_empty() || target_transfer_syntax.is_empty() {
        return false;
    }
    if file_transfer_syntax == target_transfer_syntax {
        return true;
    }

    let Some(source_ts) = TransferSyntaxRegistry.get(file_transfer_syntax) else {
        return false;
    };
    let Some(target_ts) = TransferSyntaxRegistry.get(target_transfer_syntax) else {
        return false;
    };

    if !source_ts.is_encapsulated_pixel_data() && !target_ts.is_encapsulated_pixel_data() {
        return true;
    }
    if target_ts.pixel_data_writer().is_some() {
        return true;
    }
    if !target_ts.is_encapsulated_pixel_data() && source_ts.pixel_data_reader().is_some() {
        return true;
    }

    false
}

fn push_transfer_syntax(out: &mut Vec<String>, uid: &str) {
    if !uid.is_empty() && !out.iter().any(|existing| existing == uid) {
        out.push(uid.to_string());
    }
}

#[cfg(test)]
mod tests {
    use super::{can_send_file_with_transfer_syntax, common_store_transfer_syntaxes};
    use crate::config::StoreTransferSyntaxPreference;
    use dicom_dictionary_std::uids::{
        EXPLICIT_VR_LITTLE_ENDIAN, IMPLICIT_VR_LITTLE_ENDIAN, JPEG2000_LOSSLESS,
    };

    #[test]
    fn common_store_transfer_syntaxes_puts_configured_preference_first() {
        let syntaxes = common_store_transfer_syntaxes(
            StoreTransferSyntaxPreference::Jpeg2000Lossless,
            EXPLICIT_VR_LITTLE_ENDIAN,
        );

        assert_eq!(
            syntaxes.first().map(String::as_str),
            Some(JPEG2000_LOSSLESS)
        );
        assert!(syntaxes.iter().any(|ts| ts == EXPLICIT_VR_LITTLE_ENDIAN));
        assert!(syntaxes.iter().any(|ts| ts == IMPLICIT_VR_LITTLE_ENDIAN));
    }

    #[test]
    fn can_send_between_uncompressed_transfer_syntaxes() {
        assert!(can_send_file_with_transfer_syntax(
            EXPLICIT_VR_LITTLE_ENDIAN,
            IMPLICIT_VR_LITTLE_ENDIAN,
        ));
    }

    #[test]
    fn can_always_send_when_transfer_syntax_is_unchanged() {
        assert!(can_send_file_with_transfer_syntax(
            JPEG2000_LOSSLESS,
            JPEG2000_LOSSLESS,
        ));
    }
}
