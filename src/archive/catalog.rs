use crate::{
    error::Result,
    models::{LocalInstance, SeriesSummary, StudySummary},
};

use super::StoredObjectRef;

#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct ArchiveRecordQuery {
    pub study_instance_uid: Option<String>,
    pub series_instance_uid: Option<String>,
    pub sop_instance_uid: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum RetrieveSelector {
    Study { study_instance_uid: String },
    Series { series_instance_uid: String },
    Instance { sop_instance_uid: String },
}

pub trait ArchiveCatalogRead {
    fn get_study(&self, study_instance_uid: &str) -> Result<Option<StudySummary>>;
    fn get_series(&self, series_instance_uid: &str) -> Result<Option<SeriesSummary>>;
    fn get_instance(&self, sop_instance_uid: &str) -> Result<Option<LocalInstance>>;
    fn query(&self, query: ArchiveRecordQuery) -> Result<Vec<LocalInstance>>;
    fn instances_for_retrieve(&self, selector: RetrieveSelector) -> Result<Vec<LocalInstance>>;
}

pub trait ArchiveCatalogWrite {
    fn upsert_instance(&self, instance: &LocalInstance) -> Result<()>;
    fn attach_object(&self, sop_instance_uid: &str, object: &StoredObjectRef) -> Result<bool>;
}

pub trait ArchiveCatalog: ArchiveCatalogRead + ArchiveCatalogWrite {}

impl<T> ArchiveCatalog for T where T: ArchiveCatalogRead + ArchiveCatalogWrite {}
