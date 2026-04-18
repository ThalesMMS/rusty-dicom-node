use super::*;
use crate::{config::AppPaths, models::LocalInstance, services::AppServices};
use std::ops::Deref;
use tempfile::TempDir;

pub(super) struct TestServices {
    pub(super) services: AppServices,
    _temp_dir: TempDir,
}

impl Deref for TestServices {
    type Target = AppServices;

    /// Exposes the wrapped `AppServices` when a `TestServices` is dereferenced.
    ///
    /// Returns a reference to the inner `AppServices`.
    ///
    /// # Examples
    ///
    /// ```
    /// let ts = test_services();
    /// // Deref coercion lets you use &TestServices where &AppServices is expected:
    /// let app_ref: &AppServices = &*ts;
    /// assert_eq!(app_ref.paths.base_dir, ts.services.paths.base_dir);
    /// ```
    fn deref(&self) -> &Self::Target {
        &self.services
    }
}

/// Create an isolated AppServices instance backed by a temporary directory.
///
/// The temporary directory is owned by the returned `TestServices` and remains
/// alive for the lifetime of that value; dropping it removes the directory.
///
/// # Examples
///
/// ```
/// let ts = test_services();
/// // the app paths are rooted in the temporary directory
/// assert!(ts.paths.base_dir.exists());
/// ```
pub(super) fn test_services() -> TestServices {
    let temp_dir = TempDir::new().expect("create temp dir");
    let base_dir = temp_dir.path().to_path_buf();

    let paths = AppPaths {
        base_dir: base_dir.clone(),
        config_json: base_dir.join("config.json"),
        sqlite_db: base_dir.join("dicom-node-client.sqlite3"),
        managed_store_dir: base_dir.join("store"),
        logs_dir: base_dir.join("logs"),
    };
    paths.ensure().unwrap();

    let services = AppServices::load_from_paths(paths).unwrap();

    TestServices {
        services,
        _temp_dir: temp_dir,
    }
}

/// Create a `KeyEvent` for the given `KeyCode` with no modifiers.
///
/// # Examples
///
/// ```
/// use crossterm::event::{KeyCode, KeyModifiers};
/// let ev = key(KeyCode::Char('q'));
/// assert_eq!(ev.code, KeyCode::Char('q'));
/// assert_eq!(ev.modifiers, KeyModifiers::NONE);
/// ```
pub(super) fn key(code: KeyCode) -> KeyEvent {
    KeyEvent::new(code, crossterm::event::KeyModifiers::NONE)
}

/// Constructs a `KeyEvent` for the given key code and key modifiers.
///
/// # Examples
///
/// ```
/// use crossterm::event::{KeyCode, KeyModifiers};
/// let ev = crate::tui::test_support::key_with_modifiers(KeyCode::Char('a'), KeyModifiers::CONTROL);
/// assert_eq!(ev.code, KeyCode::Char('a'));
/// assert_eq!(ev.modifiers, KeyModifiers::CONTROL);
/// ```
pub(super) fn key_with_modifiers(code: KeyCode, modifiers: KeyModifiers) -> KeyEvent {
    KeyEvent::new(code, modifiers)
}

/// Convert a slice of string slices into an owned `Vec<String>`.
///
/// # Examples
///
/// ```
/// let v = args(&["foo", "bar"]);
/// assert_eq!(v, vec!["foo".to_string(), "bar".to_string()]);
/// ```
pub(super) fn args(values: &[&str]) -> Vec<String> {
    values.iter().map(|value| value.to_string()).collect()
}

/// Adds a network node to the application's node registry with the specified name and AE title.
///
/// The node is created with host "127.0.0.1", port 104, and no move destination or notes.
///
/// # Examples
///
/// ```
/// // create services for tests and add a node
/// let app = test_services();
/// add_test_node(&app.services, "test-node", "TEST_AE");
/// ```
pub(super) fn add_test_node(app: &AppServices, name: &str, ae_title: &str) {
    let draft = app.node_draft_from_values(NodeDraftValues {
        name: name.to_string(),
        ae_title: ae_title.to_string(),
        host: "127.0.0.1".to_string(),
        port: 104,
        move_destination: None,
        notes: None,
    });
    app.add_node(draft).unwrap();
}

pub(super) struct TestInstanceMeta<'a> {
    pub(super) study_uid: &'a str,
    pub(super) series_uid: &'a str,
    pub(super) sop_uid: &'a str,
    pub(super) series_number: Option<&'a str>,
    pub(super) modality: Option<&'a str>,
    pub(super) patient_name: Option<&'a str>,
    pub(super) study_date: Option<&'a str>,
    pub(super) study_description: Option<&'a str>,
    pub(super) series_description: Option<&'a str>,
}

/// Inserts a synthetic local DICOM instance record into the application's database using
/// values from `meta` and a small set of fixed/default fields.
///
/// The function derives managed and source file paths from `meta.sop_uid`, maps optional
/// metadata fields (patient name, study/series fields, modality, series number) into the
/// stored record, and sets fixed defaults for SOP class UID, patient ID, instance number,
/// file size, a synthetic `sha256`, and an `imported_at` timestamp.
///
/// # Examples
///
/// ```ignore
/// let meta = TestInstanceMeta {
///     study_uid: "1.2.3",
///     series_uid: "1.2.3.4",
///     sop_uid: "1.2.3.4.5",
///     series_number: Some("1"),
///     modality: Some("MR"),
///     patient_name: Some("Doe^John"),
///     study_date: Some("20260101"),
///     study_description: Some("Head MRI"),
///     series_description: Some("Axial T1"),
/// };
///
/// // `app` is an initialized `AppServices` from `test_services()`.
/// add_test_local_instance(&app, meta);
/// ```
pub(super) fn add_test_local_instance(app: &AppServices, meta: TestInstanceMeta<'_>) {
    let managed_path = app
        .paths
        .managed_store_dir
        .join(format!("{}.dcm", meta.sop_uid));
    let source_path = app
        .paths
        .base_dir
        .join(format!("{}-source.dcm", meta.sop_uid));

    app.db
        .upsert_instance(&LocalInstance {
            study_instance_uid: meta.study_uid.to_string(),
            series_instance_uid: meta.series_uid.to_string(),
            sop_instance_uid: meta.sop_uid.to_string(),
            sop_class_uid: "1.2.840.10008.5.1.4.1.1.2".to_string(),
            transfer_syntax_uid: None,
            patient_id: Some("MRN-1".to_string()),
            patient_name: meta.patient_name.map(str::to_string),
            accession_number: None,
            study_date: meta.study_date.map(str::to_string),
            study_description: meta.study_description.map(str::to_string),
            series_description: meta.series_description.map(str::to_string),
            series_number: meta.series_number.map(str::to_string),
            modality: meta.modality.map(str::to_string),
            instance_number: Some("1".to_string()),
            file_size_bytes: 128,
            sha256: format!("sha256-{}", meta.sop_uid),
            source_path: source_path.display().to_string(),
            managed_path: managed_path.display().to_string(),
            imported_at: "2026-04-16T00:00:00Z".to_string(),
        })
        .unwrap();
}

/// Concatenates all span contents from a TUI `Line` into a single `String`.
///
/// # Examples
///
/// ```
/// use ratatui::text::{Line, Span};
///
/// let line = Line::from(vec![Span::raw("Hello"), Span::raw(", "), Span::raw("world!")]);
/// assert_eq!(super::line_plain_text(&line), "Hello, world!");
/// ```
pub(super) fn line_plain_text(line: &Line<'_>) -> String {
    line.spans
        .iter()
        .map(|span| span.content.as_ref())
        .collect::<String>()
}
