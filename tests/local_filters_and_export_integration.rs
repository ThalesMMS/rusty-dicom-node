mod common;

use std::time::Duration;

use common::{run_with_timeout, write_valid_dicom_with_pixel_data, TestDicomSpec, TestServices};
use dicom_node_client::{
    export::{
        export_series_csv, export_series_json, export_studies_csv, export_studies_json,
        ExportTarget,
    },
    filters::{SeriesFilters, StudyFilters},
};
use std::io::Read;

#[test]
fn local_studies_and_series_filters_and_exports_work_against_real_sqlite() {
    run_with_timeout(Duration::from_secs(10), || {
        let services = TestServices::new().expect("create test services");

        let base_dir = services.temp_dir.path().join("local-filter-export");

        // Study 1: CT
        let mut spec1 = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.250.10",
            "1.2.826.0.1.3680043.10.250.10.1",
            "1.2.826.0.1.3680043.10.250.10.1.1",
        );
        spec1.patient_name = "Alice^Smith".to_string();
        spec1.patient_id = "ALICE1".to_string();
        spec1.modality = "CT".to_string();
        spec1.series_number = 1;

        write_valid_dicom_with_pixel_data(&base_dir.join("s1_1.dcm"), &spec1).expect("write s1");

        // Study 2: MR
        let mut spec2 = TestDicomSpec::new(
            "1.2.826.0.1.3680043.10.250.20",
            "1.2.826.0.1.3680043.10.250.20.1",
            "1.2.826.0.1.3680043.10.250.20.1.1",
        );
        spec2.patient_name = "Bob^Jones".to_string();
        spec2.patient_id = "BOB1".to_string();
        spec2.modality = "MR".to_string();
        spec2.series_number = 2;

        write_valid_dicom_with_pixel_data(&base_dir.join("s2_1.dcm"), &spec2).expect("write s2");

        services
            .services
            .importer
            .import_folder(&base_dir)
            .expect("import folder");

        // Filter studies by modality
        let studies_ct = services
            .services
            .local_studies_filtered(&StudyFilters {
                modalities: vec!["CT".to_string()],
                ..Default::default()
            })
            .expect("list filtered studies");
        assert_eq!(studies_ct.len(), 1);
        assert_eq!(studies_ct[0].study_instance_uid, spec1.study_instance_uid);

        // Filter studies by patient substring
        let studies_alice = services
            .services
            .local_studies_filtered(&StudyFilters {
                patient_name: Some("alice".to_string()),
                ..Default::default()
            })
            .expect("list filtered studies");
        assert_eq!(studies_alice.len(), 1);
        assert_eq!(
            studies_alice[0].study_instance_uid,
            spec1.study_instance_uid
        );

        // Filter series by study UID + modality
        let series_ct = services
            .services
            .local_series_filtered(&SeriesFilters {
                study_instance_uid: Some(spec1.study_instance_uid.clone()),
                modalities: vec!["CT".to_string()],
                ..Default::default()
            })
            .expect("list filtered series");
        assert_eq!(series_ct.len(), 1);
        assert_eq!(series_ct[0].series_instance_uid, spec1.series_instance_uid);

        // Export studies JSON/CSV and ensure it contains stable IDs.
        let studies_all = services
            .services
            .local_studies_filtered(&StudyFilters::default())
            .expect("list all studies");

        let mut tmp_json = tempfile::NamedTempFile::new().expect("tmp json");
        export_studies_json(
            &studies_all,
            ExportTarget::File(tmp_json.path().to_path_buf()),
        )
        .expect("export studies json");
        let mut json = String::new();
        tmp_json.read_to_string(&mut json).expect("read json");
        assert!(json.contains(&spec1.study_instance_uid));
        assert!(json.contains(&spec2.study_instance_uid));

        let mut tmp_csv = tempfile::NamedTempFile::new().expect("tmp csv");
        export_studies_csv(
            &studies_all,
            ExportTarget::File(tmp_csv.path().to_path_buf()),
        )
        .expect("export studies csv");
        let mut csv = String::new();
        tmp_csv.read_to_string(&mut csv).expect("read csv");
        assert!(csv.lines().next().unwrap().contains("study_instance_uid"));
        assert!(csv.contains(&spec1.study_instance_uid));

        // Export series JSON/CSV scoped to study 1 and ensure it contains series ID.
        let series_for_study = services
            .services
            .local_series_filtered(&SeriesFilters {
                study_instance_uid: Some(spec1.study_instance_uid.clone()),
                ..Default::default()
            })
            .expect("list series");

        let mut tmp_series_json = tempfile::NamedTempFile::new().expect("tmp series json");
        export_series_json(
            &series_for_study,
            ExportTarget::File(tmp_series_json.path().to_path_buf()),
        )
        .expect("export series json");
        let mut json_series = String::new();
        tmp_series_json
            .read_to_string(&mut json_series)
            .expect("read series json");
        assert!(json_series.contains(&spec1.series_instance_uid));

        let mut tmp_series_csv = tempfile::NamedTempFile::new().expect("tmp series csv");
        export_series_csv(
            &series_for_study,
            ExportTarget::File(tmp_series_csv.path().to_path_buf()),
        )
        .expect("export series csv");
        let mut csv_series = String::new();
        tmp_series_csv
            .read_to_string(&mut csv_series)
            .expect("read series csv");
        assert!(csv_series
            .lines()
            .next()
            .unwrap()
            .contains("series_instance_uid"));
        assert!(csv_series.contains(&spec1.series_instance_uid));
    });
}
