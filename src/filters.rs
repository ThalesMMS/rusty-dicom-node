//! Local inventory filter types.
//!
//! This module is intentionally small: it just defines the structured filter
//! inputs which later phases will translate into parameterized SQL.

#[derive(Debug, Default, Clone, PartialEq, Eq)]
pub struct StudyFilters {
    pub patient_name: Option<String>,
    pub patient_id: Option<String>,
    pub accession_number: Option<String>,
    pub study_description: Option<String>,

    /// StudyDate (DICOM: (0008,0020)) in `YYYYMMDD` form.
    ///
    /// Supports:
    /// - exact: `YYYYMMDD`
    /// - open-ended: `..YYYYMMDD` or `YYYYMMDD..`
    /// - inclusive range: `YYYYMMDD..YYYYMMDD`
    pub study_date: Option<String>,

    /// Modalities to filter by (e.g. `["CT", "MR"]`).
    ///
    /// Matching semantics are implemented in a later subtask.
    pub modalities: Vec<String>,

    pub source_path: Option<String>,

    /// Imported timestamp (stored as TEXT in SQLite).
    ///
    /// Supports:
    /// - exact: `YYYY-MM-DDTHH:MM:SSZ` (or the stored format)
    /// - open-ended: `..TIMESTAMP` or `TIMESTAMP..`
    /// - inclusive range: `START..END`
    pub imported_at: Option<String>,

    /// Placeholder for future schema/feature work.
    pub retrieved_at: Option<String>,

    /// Placeholder for future schema/feature work.
    pub duplicate: Option<bool>,
}

#[derive(Debug, Default, Clone, PartialEq, Eq)]
pub struct SeriesFilters {
    /// Filter series within a given study. This is commonly provided as a
    /// required argument (e.g. `local series <study_uid>`) but is represented
    /// here as an optional filter so query logic can be reused.
    pub study_instance_uid: Option<String>,

    pub accession_number: Option<String>,

    pub series_description: Option<String>,

    /// Modalities to filter by (e.g. `["CT", "MR"]`).
    pub modalities: Vec<String>,

    pub source_path: Option<String>,

    /// Imported timestamp (stored as TEXT in SQLite).
    ///
    /// Supports:
    /// - exact: `YYYY-MM-DDTHH:MM:SSZ` (or the stored format)
    /// - open-ended: `..TIMESTAMP` or `TIMESTAMP..`
    /// - inclusive range: `START..END`
    pub imported_at: Option<String>,
    pub retrieved_at: Option<String>,

    pub duplicate: Option<bool>,
}
