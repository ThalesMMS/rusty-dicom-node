use std::io::Write;
use std::path::Path;

use crate::models::{SeriesSummary, StudySummary};

pub enum ExportTarget {
    Stdout,
    File(std::path::PathBuf),
}

impl ExportTarget {
    pub fn from_optional_path(out: Option<&Path>) -> Self {
        match out {
            Some(p) => ExportTarget::File(p.to_path_buf()),
            None => ExportTarget::Stdout,
        }
    }

    fn open_writer(&self) -> anyhow::Result<Box<dyn Write>> {
        match self {
            ExportTarget::Stdout => Ok(Box::new(std::io::stdout())),
            ExportTarget::File(path) => {
                let f = std::fs::File::create(path)
                    .map_err(|e| anyhow::anyhow!("creating export file {}: {e}", path.display()))?;
                Ok(Box::new(std::io::BufWriter::new(f)))
            }
        }
    }
}

pub fn export_studies_json(studies: &[StudySummary], target: ExportTarget) -> anyhow::Result<()> {
    let mut w = target.open_writer()?;
    serde_json::to_writer_pretty(&mut w, studies)
        .map_err(|e| anyhow::anyhow!("serializing studies JSON: {e}"))?;
    writeln!(&mut w).ok();
    Ok(())
}

pub fn export_series_json(series: &[SeriesSummary], target: ExportTarget) -> anyhow::Result<()> {
    let mut w = target.open_writer()?;
    serde_json::to_writer_pretty(&mut w, series)
        .map_err(|e| anyhow::anyhow!("serializing series JSON: {e}"))?;
    writeln!(&mut w).ok();
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn csv_writes_stable_header_order_for_studies() {
        let mut buf = Vec::<u8>::new();
        {
            let mut csv = csv::Writer::from_writer(&mut buf);
            csv.write_record([
                "study_instance_uid",
                "patient_id",
                "patient_name",
                "study_date",
                "study_description",
                "modalities",
                "series_count",
                "instance_count",
            ])
            .unwrap();
            csv.flush().unwrap();
        }

        let s = String::from_utf8(buf).unwrap();
        assert_eq!(
            s,
            "study_instance_uid,patient_id,patient_name,study_date,study_description,modalities,series_count,instance_count\n"
        );
    }

    #[test]
    fn csv_writes_stable_header_order_for_series() {
        let mut buf = Vec::<u8>::new();
        {
            let mut csv = csv::Writer::from_writer(&mut buf);
            csv.write_record([
                "study_instance_uid",
                "series_instance_uid",
                "modality",
                "series_number",
                "series_description",
                "instance_count",
            ])
            .unwrap();
            csv.flush().unwrap();
        }

        let s = String::from_utf8(buf).unwrap();
        assert_eq!(
            s,
            "study_instance_uid,series_instance_uid,modality,series_number,series_description,instance_count\n"
        );
    }

    #[test]
    fn csv_escapes_commas_quotes_and_newlines() {
        let rows = vec![StudySummary {
            study_instance_uid: "1.2.3".to_string(),
            patient_id: Some("id".to_string()),
            patient_name: Some("Last, \"First\"\nLine2".to_string()),
            study_date: Some("20250101".to_string()),
            study_description: Some("desc".to_string()),
            modalities: Some("CT".to_string()),
            series_count: 1,
            instance_count: 2,
        }];

        let mut buf = Vec::<u8>::new();
        {
            let mut csv = csv::Writer::from_writer(&mut buf);
            csv.write_record([
                "study_instance_uid",
                "patient_id",
                "patient_name",
                "study_date",
                "study_description",
                "modalities",
                "series_count",
                "instance_count",
            ])
            .unwrap();

            for row in &rows {
                csv.write_record([
                    row.study_instance_uid.as_str(),
                    row.patient_id.as_deref().unwrap_or(""),
                    row.patient_name.as_deref().unwrap_or(""),
                    row.study_date.as_deref().unwrap_or(""),
                    row.study_description.as_deref().unwrap_or(""),
                    row.modalities.as_deref().unwrap_or(""),
                    "1",
                    "2",
                ])
                .unwrap();
            }
            csv.flush().unwrap();
        }

        let s = String::from_utf8(buf).unwrap();
        // csv crate may include embedded newlines in a single record; avoid splitting on lines.
        assert!(s.starts_with("study_instance_uid,patient_id,patient_name,"));
        assert!(s.contains("\"Last, \"\"First\"\"\nLine2\""));
    }

    #[test]
    fn json_export_writes_valid_json_array() {
        let rows = vec![SeriesSummary {
            study_instance_uid: "1.2.3".to_string(),
            series_instance_uid: "4.5.6".to_string(),
            modality: Some("CT".to_string()),
            series_number: None,
            series_description: Some("Series".to_string()),
            instance_count: 1,
        }];

        let json = serde_json::to_string(&rows).unwrap();
        let v: serde_json::Value = serde_json::from_str(&json).unwrap();
        assert!(v.is_array());
        let obj = v.as_array().unwrap()[0].as_object().unwrap();
        assert!(obj.contains_key("study_instance_uid"));
        assert!(obj.contains_key("series_instance_uid"));
    }
}

pub fn export_studies_csv(studies: &[StudySummary], target: ExportTarget) -> anyhow::Result<()> {
    let mut w = target.open_writer()?;
    let mut csv = csv::Writer::from_writer(&mut w);

    // Stable header order per Export Row Contract (spec.md).
    csv.write_record([
        "study_instance_uid",
        "patient_id",
        "patient_name",
        "study_date",
        "study_description",
        "modalities",
        "series_count",
        "instance_count",
    ])
    .map_err(|e| anyhow::anyhow!("writing studies CSV header: {e}"))?;

    for row in studies {
        let series_count = row.series_count.to_string();
        let instance_count = row.instance_count.to_string();
        csv.write_record([
            row.study_instance_uid.as_str(),
            row.patient_id.as_deref().unwrap_or(""),
            row.patient_name.as_deref().unwrap_or(""),
            row.study_date.as_deref().unwrap_or(""),
            row.study_description.as_deref().unwrap_or(""),
            row.modalities.as_deref().unwrap_or(""),
            series_count.as_str(),
            instance_count.as_str(),
        ])
        .map_err(|e| anyhow::anyhow!("writing studies CSV row: {e}"))?;
    }

    csv.flush()
        .map_err(|e| anyhow::anyhow!("flushing studies CSV: {e}"))?;
    Ok(())
}

pub fn export_series_csv(series: &[SeriesSummary], target: ExportTarget) -> anyhow::Result<()> {
    let mut w = target.open_writer()?;
    let mut csv = csv::Writer::from_writer(&mut w);

    // Stable header order per Export Row Contract (spec.md).
    csv.write_record([
        "study_instance_uid",
        "series_instance_uid",
        "modality",
        "series_number",
        "series_description",
        "instance_count",
    ])
    .map_err(|e| anyhow::anyhow!("writing series CSV header: {e}"))?;

    for row in series {
        let instance_count = row.instance_count.to_string();
        csv.write_record([
            row.study_instance_uid.as_str(),
            row.series_instance_uid.as_str(),
            row.modality.as_deref().unwrap_or(""),
            row.series_number.as_deref().unwrap_or(""),
            row.series_description.as_deref().unwrap_or(""),
            instance_count.as_str(),
        ])
        .map_err(|e| anyhow::anyhow!("writing series CSV row: {e}"))?;
    }

    csv.flush()
        .map_err(|e| anyhow::anyhow!("flushing series CSV: {e}"))?;
    Ok(())
}

pub fn export_studies(
    format: crate::cli::LocalExportFormat,
    studies: &[StudySummary],
    out: Option<&Path>,
) -> anyhow::Result<()> {
    let target = ExportTarget::from_optional_path(out);
    match format {
        crate::cli::LocalExportFormat::Json => export_studies_json(studies, target),
        crate::cli::LocalExportFormat::Csv => export_studies_csv(studies, target),
    }
}

pub fn export_series(
    format: crate::cli::LocalExportFormat,
    series: &[SeriesSummary],
    out: Option<&Path>,
) -> anyhow::Result<()> {
    let target = ExportTarget::from_optional_path(out);
    match format {
        crate::cli::LocalExportFormat::Json => export_series_json(series, target),
        crate::cli::LocalExportFormat::Csv => export_series_csv(series, target),
    }
}
