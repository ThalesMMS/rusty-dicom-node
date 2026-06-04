use anyhow::anyhow;

use crate::{
    error::Result,
    models::{LocalInstance, QueryLevel, QueryModel},
};

use super::{ArchiveCatalogRead, RetrieveSelector, SqliteArchiveCatalog};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ArchiveRetrieveRequest {
    pub model: QueryModel,
    pub level: QueryLevel,
    pub study_instance_uid: Option<String>,
    pub series_instance_uid: Option<String>,
    pub sop_instance_uid: Option<String>,
}

#[derive(Debug, Clone)]
pub struct ArchiveRetrieveService {
    catalog: SqliteArchiveCatalog,
}

impl ArchiveRetrieveService {
    pub fn new(catalog: SqliteArchiveCatalog) -> Self {
        Self { catalog }
    }

    pub fn resolve(&self, request: ArchiveRetrieveRequest) -> Result<Vec<LocalInstance>> {
        if request.level == QueryLevel::Patient {
            return Err(anyhow!("Patient level retrieve is out of scope"));
        }
        if request.model == QueryModel::StudyRoot && request.level == QueryLevel::Patient {
            return Err(anyhow!(
                "Study Root retrieve does not support Patient level"
            ));
        }

        let selector = match request.level {
            QueryLevel::Patient => unreachable!("patient level is rejected above"),
            QueryLevel::Study => RetrieveSelector::Study {
                study_instance_uid: required_uid(request.study_instance_uid, "StudyInstanceUID")?,
            },
            QueryLevel::Series => RetrieveSelector::Series {
                series_instance_uid: required_uid(
                    request.series_instance_uid,
                    "SeriesInstanceUID",
                )?,
            },
            QueryLevel::Image => RetrieveSelector::Instance {
                sop_instance_uid: required_uid(request.sop_instance_uid, "SOPInstanceUID")?,
            },
        };

        self.catalog.instances_for_retrieve(selector)
    }
}

fn required_uid(value: Option<String>, name: &str) -> Result<String> {
    value
        .map(|value| value.trim().to_string())
        .filter(|value| !value.is_empty())
        .ok_or_else(|| anyhow!("{name} is required for this retrieve level"))
}

#[cfg(test)]
mod tests {
    use crate::{
        archive::{
            ArchiveCatalogWrite, ArchiveRetrieveRequest, ArchiveRetrieveService,
            SqliteArchiveCatalog,
        },
        db::Database,
        models::{LocalInstance, QueryLevel, QueryModel},
    };

    fn instance(study_uid: &str, series_uid: &str, sop_uid: &str) -> LocalInstance {
        LocalInstance {
            study_instance_uid: study_uid.to_string(),
            series_instance_uid: series_uid.to_string(),
            sop_instance_uid: sop_uid.to_string(),
            sop_class_uid: "1.2.840.10008.5.1.4.1.1.2".to_string(),
            transfer_syntax_uid: Some("1.2.840.10008.1.2.1".to_string()),
            patient_id: Some("PAT-MOVE".to_string()),
            patient_name: Some("MOVE^PATIENT".to_string()),
            accession_number: Some("ACC-MOVE".to_string()),
            study_date: Some("20260604".to_string()),
            study_description: Some("Move Study".to_string()),
            series_description: Some(format!("Series {series_uid}")),
            series_number: Some(series_uid.rsplit('.').next().unwrap_or("1").to_string()),
            modality: Some("CT".to_string()),
            instance_number: Some(sop_uid.rsplit('.').next().unwrap_or("1").to_string()),
            file_size_bytes: 128,
            sha256: format!("sha256-{sop_uid}"),
            source_path: format!("test://{sop_uid}"),
            managed_path: format!("/tmp/{sop_uid}.dcm"),
            attributes_json: None,
            imported_at: "2026-06-04T00:00:00Z".to_string(),
        }
    }

    fn seeded_service() -> (ArchiveRetrieveService, tempfile::TempDir) {
        let temp_dir = tempfile::tempdir().expect("temp dir");
        let db = Database::open(temp_dir.path().join("archive.sqlite3")).expect("open db");
        let catalog = SqliteArchiveCatalog::new(db);
        for item in [
            instance("1.2.840.move.1", "1.2.840.move.1.1", "1.2.840.move.1.1.1"),
            instance("1.2.840.move.1", "1.2.840.move.1.1", "1.2.840.move.1.1.2"),
            instance("1.2.840.move.2", "1.2.840.move.2.1", "1.2.840.move.2.1.1"),
        ] {
            catalog.upsert_instance(&item).expect("seed instance");
        }
        (ArchiveRetrieveService::new(catalog), temp_dir)
    }

    #[test]
    fn retrieve_service_resolves_study_series_and_image_requests() {
        let (service, _temp_dir) = seeded_service();

        let study = service
            .resolve(ArchiveRetrieveRequest {
                model: QueryModel::StudyRoot,
                level: QueryLevel::Study,
                study_instance_uid: Some("1.2.840.move.1".to_string()),
                series_instance_uid: None,
                sop_instance_uid: None,
            })
            .expect("resolve study");
        assert_eq!(study.len(), 2);

        let series = service
            .resolve(ArchiveRetrieveRequest {
                model: QueryModel::StudyRoot,
                level: QueryLevel::Series,
                study_instance_uid: None,
                series_instance_uid: Some("1.2.840.move.1.1".to_string()),
                sop_instance_uid: None,
            })
            .expect("resolve series");
        assert_eq!(series.len(), 2);

        let image = service
            .resolve(ArchiveRetrieveRequest {
                model: QueryModel::StudyRoot,
                level: QueryLevel::Image,
                study_instance_uid: None,
                series_instance_uid: None,
                sop_instance_uid: Some("1.2.840.move.1.1.2".to_string()),
            })
            .expect("resolve image");
        assert_eq!(image.len(), 1);
        assert_eq!(image[0].sop_instance_uid, "1.2.840.move.1.1.2");
    }

    #[test]
    fn retrieve_service_rejects_missing_unique_keys_and_patient_level() {
        let (service, _temp_dir) = seeded_service();

        let err = service
            .resolve(ArchiveRetrieveRequest {
                model: QueryModel::StudyRoot,
                level: QueryLevel::Series,
                study_instance_uid: Some("1.2.840.move.1".to_string()),
                series_instance_uid: None,
                sop_instance_uid: None,
            })
            .expect_err("series retrieve requires series uid");
        assert!(err.to_string().contains("SeriesInstanceUID"));

        let err = service
            .resolve(ArchiveRetrieveRequest {
                model: QueryModel::PatientRoot,
                level: QueryLevel::Patient,
                study_instance_uid: None,
                series_instance_uid: None,
                sop_instance_uid: None,
            })
            .expect_err("patient-level retrieve is out of scope");
        assert!(err.to_string().contains("Patient level"));
    }
}
