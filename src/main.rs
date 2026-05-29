use std::{path::Path, sync::Arc};

use clap::Parser;
pub use dicom_node_client::{
    aliases, cancel, config, db, dicom, error, importer, models, net, services,
};
use dicom_node_client::{
    cli::{Cli, Commands, LocalCommand, NodeCommand, SendCommand},
    config::AppPaths,
    export::{export_series, export_studies},
    filters::{SeriesFilters, StudyFilters},
    models::{MoveRequest, QueryCriteria},
    services::{AppServices, NodeDraftValues, NodePatchCliValues},
};
use tracing_subscriber::{fmt, prelude::*, EnvFilter};

mod tui;

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    let paths = AppPaths::discover()?;
    let log_path = paths.logs_dir.join("app.log");
    let _tracing_guard = init_tracing(&paths.logs_dir)?;
    let services = AppServices::load_from_paths(paths)?;

    let cancel_flag = Arc::new(std::sync::atomic::AtomicBool::new(false));
    install_sigint_cancel_handler(Arc::clone(&cancel_flag))?;

    match cli.command.unwrap_or(Commands::Tui) {
        Commands::Tui => tui::run_tui(services)?,
        Commands::Node { command } => match command {
            NodeCommand::Add(args) => {
                let node = services.add_node(services.node_draft_from_values(NodeDraftValues {
                    name: args.name,
                    ae_title: args.ae_title,
                    host: args.host,
                    port: args.port,
                    move_destination: args.move_destination,
                    notes: args.notes,
                }))?;
                println!(
                    "Saved node {} [{}] => {}@{}:{}",
                    node.name, node.id, node.ae_title, node.host, node.port
                );
            }
            NodeCommand::Edit(args) => {
                let patch = services.node_patch_from_cli(NodePatchCliValues {
                    name: args.name,
                    ae_title: args.ae_title,
                    host: args.host,
                    port: args.port,
                    move_destination: args.move_destination,
                    notes: args.notes,
                })?;
                let node = services.update_node(&args.node, patch)?;
                println!(
                    "Updated node {} [{}] => {}@{}:{}",
                    node.name, node.id, node.ae_title, node.host, node.port
                );
            }
            NodeCommand::Delete(args) => {
                let removed = services.delete_node(&args.node)?;
                println!("Removed {} node(s)", removed);
            }
            NodeCommand::List => {
                let nodes = services.list_nodes()?;
                if nodes.is_empty() {
                    println!("No saved nodes");
                } else {
                    for node in nodes {
                        println!(
                            "{} [{}]  {}@{}:{}  move_dest={}",
                            node.name,
                            node.id,
                            node.ae_title,
                            node.host,
                            node.port,
                            node.preferred_move_destination
                                .unwrap_or_else(|| "-".to_string())
                        );
                    }
                }
            }
        },
        Commands::Import(args) => {
            let started_at = std::time::Instant::now();
            let report_result = services.import_path_cancellable(&args.path, &cancel_flag);
            let duration_ms = started_at.elapsed().as_millis() as u64;

            match report_result {
                Ok(report) => {
                    if args.json {
                        let summary = dicom_node_client::summary::OperationSummary {
                            version: dicom_node_client::summary::OperationSummary::VERSION,
                            kind: dicom_node_client::summary::OperationKind::Import,
                            peer: None,
                            ae_titles: None,
                            criteria: Some(serde_json::json!({
                                "source_path": args.path.display().to_string()
                            })),
                            duration_ms,
                            status: dicom_node_client::summary::OperationStatus::Success,
                            counts: dicom_node_client::summary::OperationCounts {
                                requested: Some(report.scanned_files as u64),
                                stored: Some(report.accepted as u64),
                                duplicates: Some(report.duplicates as u64),
                                skipped: Some(report.skipped as u64),
                                failed: Some(
                                    (report.unreadable
                                        + report.invalid_dicom
                                        + report.failed_cleanup)
                                        as u64,
                                ),
                                ..Default::default()
                            },
                            failures: report
                                .failures
                                .iter()
                                .map(|failure| dicom_node_client::summary::FailureDetail {
                                    message: failure.clone(),
                                    code: None,
                                })
                                .collect(),
                            logs: vec![dicom_node_client::summary::LogReference {
                                path: log_path.display().to_string(),
                                correlation_id: None,
                                line_range: None,
                            }],
                        };
                        println!("{}", serde_json::to_string_pretty(&summary)?);
                    } else {
                        print_import_report(&report);

                        let summary = dicom_node_client::summary::OperationSummary {
                            version: dicom_node_client::summary::OperationSummary::VERSION,
                            kind: dicom_node_client::summary::OperationKind::Import,
                            peer: None,
                            ae_titles: None,
                            criteria: Some(serde_json::json!({
                                "source_path": args.path.display().to_string()
                            })),
                            duration_ms,
                            status: dicom_node_client::summary::OperationStatus::Success,
                            counts: dicom_node_client::summary::OperationCounts {
                                requested: Some(report.scanned_files as u64),
                                stored: Some(report.accepted as u64),
                                duplicates: Some(report.duplicates as u64),
                                skipped: Some(report.skipped as u64),
                                failed: Some(
                                    (report.unreadable
                                        + report.invalid_dicom
                                        + report.failed_cleanup)
                                        as u64,
                                ),
                                ..Default::default()
                            },
                            failures: report
                                .failures
                                .iter()
                                .map(|failure| dicom_node_client::summary::FailureDetail {
                                    message: failure.clone(),
                                    code: None,
                                })
                                .collect(),
                            logs: vec![dicom_node_client::summary::LogReference {
                                path: log_path.display().to_string(),
                                correlation_id: None,
                                line_range: None,
                            }],
                        };
                        println!();
                        println!(
                            "{}",
                            dicom_node_client::summary_render::render_human(&summary)
                        );
                    }
                }
                Err(err) => {
                    let summary = dicom_node_client::summary::OperationSummary {
                        version: dicom_node_client::summary::OperationSummary::VERSION,
                        kind: dicom_node_client::summary::OperationKind::Import,
                        peer: None,
                        ae_titles: None,
                        criteria: Some(serde_json::json!({
                            "source_path": args.path.display().to_string()
                        })),
                        duration_ms,
                        status: dicom_node_client::summary::OperationStatus::Failure,
                        counts: Default::default(),
                        failures: vec![dicom_node_client::summary::FailureDetail {
                            message: err.to_string(),
                            code: None,
                        }],
                        logs: Vec::new(),
                    };

                    if args.json {
                        println!("{}", serde_json::to_string_pretty(&summary)?);
                    } else {
                        eprintln!("Import failed: {err:#}");
                        eprintln!();
                        eprintln!(
                            "{}",
                            dicom_node_client::summary_render::render_human(&summary)
                        );
                    }

                    return Err(err);
                }
            }
        }
        Commands::Query(args) => {
            let criteria = QueryCriteria {
                model: args.model,
                level: args.level,
                patient_name: args.patient_name,
                patient_id: args.patient_id,
                accession_number: args.accession_number,
                study_instance_uid: args.study_instance_uid,
                series_instance_uid: args.series_instance_uid,
                sop_instance_uid: args.sop_instance_uid,
                study_date_from: args.study_date_from,
                study_date_to: args.study_date_to,
                modality: args.modality,
                study_description: args.study_description,
            };

            let started_at = std::time::Instant::now();
            let query_result = services.query_cancellable(&args.node, &criteria, &cancel_flag);
            let duration_ms = started_at.elapsed().as_millis() as u64;

            match query_result {
                Ok(results) => {
                    if args.json {
                        let node = services.get_node(&args.node)?;
                        let summary = dicom_node_client::summary::OperationSummary {
                            version: dicom_node_client::summary::OperationSummary::VERSION,
                            kind: dicom_node_client::summary::OperationKind::QueryFind,
                            peer: Some(dicom_node_client::summary::NetworkPeer {
                                host: node.host,
                                port: node.port,
                            }),
                            ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                                calling: services.config.local_ae_title.clone(),
                                called: node.ae_title,
                                move_destination: None,
                            }),
                            criteria: Some(serde_json::to_value(&criteria)?),
                            duration_ms,
                            status: dicom_node_client::summary::OperationStatus::Success,
                            counts: dicom_node_client::summary::OperationCounts {
                                matched: Some(results.len() as u64),
                                ..Default::default()
                            },
                            failures: Vec::new(),
                            logs: vec![dicom_node_client::summary::LogReference {
                                path: log_path.display().to_string(),
                                correlation_id: None,
                                line_range: None,
                            }],
                        };
                        println!("{}", serde_json::to_string_pretty(&summary)?);
                    } else {
                        println!("Results: {}", results.len());
                        for item in &results {
                            println!(
                                "- level={} patient={} study_uid={} series_uid={} sop_uid={} date={} modality={} desc={}",
                                item.level,
                                item.patient_name.clone().unwrap_or_else(|| "-".to_string()),
                                item.study_instance_uid.clone().unwrap_or_else(|| "-".to_string()),
                                item.series_instance_uid.clone().unwrap_or_else(|| "-".to_string()),
                                item.sop_instance_uid.clone().unwrap_or_else(|| "-".to_string()),
                                item.study_date.clone().unwrap_or_else(|| "-".to_string()),
                                item.modality.clone().unwrap_or_else(|| "-".to_string()),
                                item.study_description.clone().unwrap_or_else(|| "-".to_string()),
                            );
                        }

                        let node = services.get_node(&args.node)?;
                        let summary = dicom_node_client::summary::OperationSummary {
                            version: dicom_node_client::summary::OperationSummary::VERSION,
                            kind: dicom_node_client::summary::OperationKind::QueryFind,
                            peer: Some(dicom_node_client::summary::NetworkPeer {
                                host: node.host,
                                port: node.port,
                            }),
                            ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                                calling: services.config.local_ae_title.clone(),
                                called: node.ae_title,
                                move_destination: None,
                            }),
                            criteria: Some(serde_json::to_value(&criteria)?),
                            duration_ms,
                            status: dicom_node_client::summary::OperationStatus::Success,
                            counts: dicom_node_client::summary::OperationCounts {
                                matched: Some(results.len() as u64),
                                ..Default::default()
                            },
                            failures: Vec::new(),
                            logs: vec![dicom_node_client::summary::LogReference {
                                path: log_path.display().to_string(),
                                correlation_id: None,
                                line_range: None,
                            }],
                        };
                        println!();
                        println!(
                            "{}",
                            dicom_node_client::summary_render::render_human(&summary)
                        );
                    }
                }
                Err(err) => {
                    let node = services.get_node(&args.node)?;
                    let summary = dicom_node_client::summary::OperationSummary {
                        version: dicom_node_client::summary::OperationSummary::VERSION,
                        kind: dicom_node_client::summary::OperationKind::QueryFind,
                        peer: Some(dicom_node_client::summary::NetworkPeer {
                            host: node.host,
                            port: node.port,
                        }),
                        ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                            calling: services.config.local_ae_title.clone(),
                            called: node.ae_title,
                            move_destination: None,
                        }),
                        criteria: Some(serde_json::to_value(&criteria)?),
                        duration_ms,
                        status: dicom_node_client::summary::OperationStatus::Failure,
                        counts: Default::default(),
                        failures: vec![dicom_node_client::summary::FailureDetail {
                            message: err.to_string(),
                            code: None,
                        }],
                        logs: Vec::new(),
                    };

                    if args.json {
                        println!("{}", serde_json::to_string_pretty(&summary)?);
                    } else {
                        eprintln!("Query failed: {err:#}");
                        eprintln!();
                        eprintln!(
                            "{}",
                            dicom_node_client::summary_render::render_human(&summary)
                        );
                    }

                    return Err(err);
                }
            }
        }
        Commands::Retrieve(args) => {
            let started = std::time::Instant::now();

            let node = services.get_node(&args.node)?;
            let resolved_destination = args
                .move_destination
                .clone()
                .or_else(|| node.preferred_move_destination.clone())
                .unwrap_or_else(|| services.config.local_ae_title.clone());

            let request = MoveRequest {
                node_name_or_id: args.node,
                model: args.model,
                level: args.level,
                study_instance_uid: args.study_instance_uid,
                series_instance_uid: args.series_instance_uid,
                sop_instance_uid: args.sop_instance_uid,
                move_destination: Some(resolved_destination.clone()),
            };

            let outcome = match services.retrieve_cancellable(request.clone(), &cancel_flag) {
                Ok(outcome) => outcome,
                Err(err) => {
                    let duration_ms = started.elapsed().as_millis() as u64;
                    let summary = dicom_node_client::summary::OperationSummary {
                        version: dicom_node_client::summary::OperationSummary::VERSION,
                        kind: dicom_node_client::summary::OperationKind::RetrieveMove,
                        peer: Some(dicom_node_client::summary::NetworkPeer {
                            host: node.host,
                            port: node.port,
                        }),
                        ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                            calling: services.config.local_ae_title.clone(),
                            called: node.ae_title,
                            move_destination: Some(resolved_destination),
                        }),
                        criteria: Some(serde_json::to_value(&request)?),
                        duration_ms,
                        status: dicom_node_client::summary::OperationStatus::Failure,
                        counts: Default::default(),
                        failures: vec![dicom_node_client::summary::FailureDetail {
                            message: err.to_string(),
                            code: None,
                        }],
                        logs: Vec::new(),
                    };

                    if args.json {
                        println!("{}", serde_json::to_string_pretty(&summary)?);
                    } else {
                        eprintln!("Retrieve failed: {err:#}");
                        eprintln!();
                        eprintln!(
                            "{}",
                            dicom_node_client::summary_render::render_human(&summary)
                        );
                    }

                    return Err(err);
                }
            };

            let duration_ms = started.elapsed().as_millis() as u64;
            let summary = dicom_node_client::summary::OperationSummary {
                version: dicom_node_client::summary::OperationSummary::VERSION,
                kind: dicom_node_client::summary::OperationKind::RetrieveMove,
                peer: Some(dicom_node_client::summary::NetworkPeer {
                    host: node.host,
                    port: node.port,
                }),
                ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                    calling: services.config.local_ae_title.clone(),
                    called: node.ae_title,
                    move_destination: Some(resolved_destination),
                }),
                criteria: Some(serde_json::to_value(&request)?),
                duration_ms,
                status: if outcome.final_status == 0x0000 {
                    dicom_node_client::summary::OperationStatus::Success
                } else {
                    dicom_node_client::summary::OperationStatus::Warning
                },
                counts: dicom_node_client::summary::OperationCounts {
                    requested: Some(1),
                    received: Some(outcome.completed as u64 + outcome.warning as u64),
                    stored: Some(outcome.completed as u64),
                    failed: Some(outcome.failed as u64),
                    ..Default::default()
                },
                failures: Vec::new(),
                logs: Vec::new(),
            };

            if args.json {
                println!("{}", serde_json::to_string_pretty(&summary)?);
            } else {
                println!(
                    "Retrieve status=0x{:04X}\n  completed={}\n  warning={}\n  failed={}\n  remaining={}\n  started_at={}\n  finished_at={}",
                    outcome.final_status,
                    outcome.completed,
                    outcome.warning,
                    outcome.failed,
                    outcome.remaining,
                    outcome.started_at,
                    outcome.finished_at
                );
                eprintln!();
                eprintln!(
                    "{}",
                    dicom_node_client::summary_render::render_human(&summary)
                );
            }
        }
        Commands::Send { json, command } => match command {
            SendCommand::Study(args) => {
                let started = std::time::Instant::now();
                let result = services.send_study_cancellable(
                    &args.study_instance_uid,
                    &args.destination_node,
                    &cancel_flag,
                );
                let duration_ms = started.elapsed().as_millis() as u64;

                match result {
                    Ok(outcome) => {
                        let node = services.get_node(&args.destination_node)?;
                        let summary = dicom_node_client::summary::OperationSummary {
                            version: dicom_node_client::summary::OperationSummary::VERSION,
                            kind: dicom_node_client::summary::OperationKind::SendStore,
                            peer: Some(dicom_node_client::summary::NetworkPeer {
                                host: node.host,
                                port: node.port,
                            }),
                            ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                                calling: services.config.local_ae_title.clone(),
                                called: node.ae_title,
                                move_destination: None,
                            }),
                            criteria: Some(serde_json::json!({
                                "scope": "study",
                                "study_instance_uid": args.study_instance_uid,
                            })),
                            duration_ms,
                            status: if outcome.failed > 0 {
                                dicom_node_client::summary::OperationStatus::Warning
                            } else {
                                dicom_node_client::summary::OperationStatus::Success
                            },
                            counts: dicom_node_client::summary::OperationCounts {
                                requested: Some(outcome.attempted as u64),
                                sent: Some(outcome.sent as u64),
                                failed: Some(outcome.failed as u64),
                                ..Default::default()
                            },
                            failures: outcome
                                .failures
                                .iter()
                                .map(|f| dicom_node_client::summary::FailureDetail {
                                    message: f.clone(),
                                    code: None,
                                })
                                .collect(),
                            logs: vec![dicom_node_client::summary::LogReference {
                                path: log_path.display().to_string(),
                                correlation_id: None,
                                line_range: None,
                            }],
                        };

                        if json {
                            println!("{}", serde_json::to_string_pretty(&summary)?);
                        } else {
                            print_send_outcome(&outcome);
                            println!();
                            println!(
                                "{}",
                                dicom_node_client::summary_render::render_human(&summary)
                            );
                        }
                    }
                    Err(err) => {
                        let node = services.get_node(&args.destination_node)?;
                        let summary = dicom_node_client::summary::OperationSummary {
                            version: dicom_node_client::summary::OperationSummary::VERSION,
                            kind: dicom_node_client::summary::OperationKind::SendStore,
                            peer: Some(dicom_node_client::summary::NetworkPeer {
                                host: node.host,
                                port: node.port,
                            }),
                            ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                                calling: services.config.local_ae_title.clone(),
                                called: node.ae_title,
                                move_destination: None,
                            }),
                            criteria: Some(serde_json::json!({
                                "scope": "study",
                                "study_instance_uid": args.study_instance_uid,
                            })),
                            duration_ms,
                            status: dicom_node_client::summary::OperationStatus::Failure,
                            counts: Default::default(),
                            failures: vec![dicom_node_client::summary::FailureDetail {
                                message: err.to_string(),
                                code: None,
                            }],
                            logs: vec![dicom_node_client::summary::LogReference {
                                path: log_path.display().to_string(),
                                correlation_id: None,
                                line_range: None,
                            }],
                        };

                        if json {
                            println!("{}", serde_json::to_string_pretty(&summary)?);
                        } else {
                            eprintln!("Send failed: {err:#}");
                            eprintln!();
                            eprintln!(
                                "{}",
                                dicom_node_client::summary_render::render_human(&summary)
                            );
                        }

                        return Err(err);
                    }
                }
            }
            SendCommand::Series(args) => {
                let started = std::time::Instant::now();
                let result = services.send_series_cancellable(
                    &args.series_instance_uid,
                    &args.destination_node,
                    &cancel_flag,
                );
                let duration_ms = started.elapsed().as_millis() as u64;

                match result {
                    Ok(outcome) => {
                        let node = services.get_node(&args.destination_node)?;
                        let summary = dicom_node_client::summary::OperationSummary {
                            version: dicom_node_client::summary::OperationSummary::VERSION,
                            kind: dicom_node_client::summary::OperationKind::SendStore,
                            peer: Some(dicom_node_client::summary::NetworkPeer {
                                host: node.host,
                                port: node.port,
                            }),
                            ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                                calling: services.config.local_ae_title.clone(),
                                called: node.ae_title,
                                move_destination: None,
                            }),
                            criteria: Some(serde_json::json!({
                                "scope": "series",
                                "series_instance_uid": args.series_instance_uid,
                            })),
                            duration_ms,
                            status: if outcome.failed > 0 {
                                dicom_node_client::summary::OperationStatus::Warning
                            } else {
                                dicom_node_client::summary::OperationStatus::Success
                            },
                            counts: dicom_node_client::summary::OperationCounts {
                                requested: Some(outcome.attempted as u64),
                                sent: Some(outcome.sent as u64),
                                failed: Some(outcome.failed as u64),
                                ..Default::default()
                            },
                            failures: outcome
                                .failures
                                .iter()
                                .map(|f| dicom_node_client::summary::FailureDetail {
                                    message: f.clone(),
                                    code: None,
                                })
                                .collect(),
                            logs: vec![dicom_node_client::summary::LogReference {
                                path: log_path.display().to_string(),
                                correlation_id: None,
                                line_range: None,
                            }],
                        };

                        if json {
                            println!("{}", serde_json::to_string_pretty(&summary)?);
                        } else {
                            print_send_outcome(&outcome);
                            println!();
                            println!(
                                "{}",
                                dicom_node_client::summary_render::render_human(&summary)
                            );
                        }
                    }
                    Err(err) => {
                        let node = services.get_node(&args.destination_node)?;
                        let summary = dicom_node_client::summary::OperationSummary {
                            version: dicom_node_client::summary::OperationSummary::VERSION,
                            kind: dicom_node_client::summary::OperationKind::SendStore,
                            peer: Some(dicom_node_client::summary::NetworkPeer {
                                host: node.host,
                                port: node.port,
                            }),
                            ae_titles: Some(dicom_node_client::summary::DicomAETitles {
                                calling: services.config.local_ae_title.clone(),
                                called: node.ae_title,
                                move_destination: None,
                            }),
                            criteria: Some(serde_json::json!({
                                "scope": "series",
                                "series_instance_uid": args.series_instance_uid,
                            })),
                            duration_ms,
                            status: dicom_node_client::summary::OperationStatus::Failure,
                            counts: Default::default(),
                            failures: vec![dicom_node_client::summary::FailureDetail {
                                message: err.to_string(),
                                code: None,
                            }],
                            logs: vec![dicom_node_client::summary::LogReference {
                                path: log_path.display().to_string(),
                                correlation_id: None,
                                line_range: None,
                            }],
                        };

                        if json {
                            println!("{}", serde_json::to_string_pretty(&summary)?);
                        } else {
                            eprintln!("Send failed: {err:#}");
                            eprintln!();
                            eprintln!(
                                "{}",
                                dicom_node_client::summary_render::render_human(&summary)
                            );
                        }

                        return Err(err);
                    }
                }
            }
        },
        Commands::Local { command } => match command {
            LocalCommand::Studies(args) => {
                let modalities: Vec<String> = args
                    .modality
                    .as_deref()
                    .unwrap_or("")
                    .split(',')
                    .map(|s| s.trim())
                    .filter(|s| !s.is_empty())
                    .map(|s| s.to_string())
                    .collect();

                let filters = StudyFilters {
                    patient_name: args.patient_name,
                    patient_id: args.patient_id,
                    accession_number: args.accession_number,
                    study_description: args.study_description,
                    study_date: args.study_date,
                    modalities,
                    source_path: args.source_path,
                    imported_at: args.imported_at,
                    retrieved_at: None,
                    duplicate: args.duplicate,
                };

                let studies = services.local_studies_filtered(&filters)?;

                if let Some(format) = args.export {
                    export_studies(format, &studies, args.out.as_deref())?;
                } else if studies.is_empty() {
                    println!("No indexed local studies");
                } else {
                    for study in studies {
                        println!(
                            "{} | patient={} | date={} | desc={} | modalities={} | series={} | instances={}",
                            study.study_instance_uid,
                            study.patient_name.unwrap_or_else(|| "-".to_string()),
                            study.study_date.unwrap_or_else(|| "-".to_string()),
                            study.study_description.unwrap_or_else(|| "-".to_string()),
                            study.modalities.unwrap_or_else(|| "-".to_string()),
                            study.series_count,
                            study.instance_count
                        );
                    }
                }
            }
            LocalCommand::Series(args) => {
                let modalities: Vec<String> = args
                    .modality
                    .as_deref()
                    .unwrap_or("")
                    .split(',')
                    .map(|s| s.trim())
                    .filter(|s| !s.is_empty())
                    .map(|s| s.to_string())
                    .collect();

                let filters = SeriesFilters {
                    study_instance_uid: Some(args.study_instance_uid.clone()),
                    accession_number: args.accession_number,
                    series_description: args.series_description,
                    modalities,
                    source_path: args.source_path,
                    imported_at: args.imported_at,
                    retrieved_at: None,
                    duplicate: args.duplicate,
                };

                let series = services.local_series_filtered(&filters)?;

                if let Some(format) = args.export {
                    export_series(format, &series, args.out.as_deref())?;
                } else if series.is_empty() {
                    println!("No indexed series for study {}", args.study_instance_uid);
                } else {
                    for row in series {
                        println!(
                            "{} | modality={} | number={} | desc={} | instances={}",
                            row.series_instance_uid,
                            row.modality.unwrap_or_else(|| "-".to_string()),
                            row.series_number.unwrap_or_else(|| "-".to_string()),
                            row.series_description.unwrap_or_else(|| "-".to_string()),
                            row.instance_count
                        );
                    }
                }
            }
        },
        Commands::StorageScp { json } => {
            use dicom_node_client::summary::{
                DicomAETitles, NetworkPeer, OperationCounts, OperationKind, OperationStatus,
                OperationSummary,
            };
            use dicom_node_client::summary_render::render_human;
            use std::time::Instant;

            let started = Instant::now();
            let listener_addr = services.config.storage_socket_addr();

            println!(
                "Starting storage SCP at {} with AE title {}",
                listener_addr, services.config.local_ae_title
            );

            let report_result = services.run_storage_scp();
            let duration = started.elapsed();

            let (status, report, err) = match report_result {
                Ok(report) => (OperationStatus::Success, Some(report), None),
                Err(err) => (OperationStatus::Failure, None, Some(err)),
            };

            let mut summary = OperationSummary::new(
                OperationKind::StorageScp,
                duration.as_millis() as u64,
                status,
            );
            summary.logs.push(dicom_node_client::summary::LogReference {
                path: log_path.display().to_string(),
                correlation_id: None,
                line_range: None,
            });

            summary.peer = Some(NetworkPeer {
                host: listener_addr,
                port: services.config.storage_scp_port,
            });
            summary.ae_titles = Some(DicomAETitles {
                calling: "".to_string(),
                called: services.config.local_ae_title.clone(),
                move_destination: None,
            });
            if let Some(report) = report {
                summary.counts = OperationCounts {
                    received: Some(report.received as u64),
                    stored: Some(report.stored as u64),
                    failed: Some(report.failed as u64),
                    ..Default::default()
                };
            }

            if let Some(err) = err.as_ref() {
                summary
                    .failures
                    .push(dicom_node_client::summary::FailureDetail {
                        message: format!("storage-scp exited with error: {err:#}"),
                        code: Some("storage_scp_error".to_string()),
                    });
            }

            if json {
                println!("{}", serde_json::to_string_pretty(&summary)?);
            } else {
                println!("{}", render_human(&summary));
            }

            if let Some(err) = err {
                return Err(err);
            }
        }
    }

    Ok(())
}

fn install_sigint_cancel_handler(
    cancel_flag: Arc<std::sync::atomic::AtomicBool>,
) -> anyhow::Result<()> {
    use signal_hook::consts::signal::SIGINT;
    use signal_hook::iterator::Signals;

    let mut signals = Signals::new([SIGINT])?;
    std::thread::spawn(move || {
        for _ in &mut signals {
            cancel_flag.store(true, std::sync::atomic::Ordering::SeqCst);
            eprintln!("Cancellation requested (SIGINT). Waiting for graceful shutdown...");
        }
    });

    Ok(())
}

fn init_tracing(logs_dir: &Path) -> anyhow::Result<tracing_appender::non_blocking::WorkerGuard> {
    let filter = EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info"));
    // We always write to a stable `app.log` path so that summaries can
    // reference a deterministic file location.
    let file_appender = tracing_appender::rolling::never(logs_dir, "app.log");
    let (file_writer, guard) = tracing_appender::non_blocking(file_appender);

    let console_layer = fmt::layer().with_writer(std::io::stderr);
    let file_layer = fmt::layer().with_writer(file_writer).with_ansi(false);

    tracing_subscriber::registry()
        .with(filter)
        .with(console_layer)
        .with(file_layer)
        .try_init()
        .map_err(|err| anyhow::anyhow!("initializing tracing subscriber: {err}"))?;

    Ok(guard)
}

fn print_import_report(report: &dicom_node_client::models::ImportReport) {
    println!(
        "Import complete\n  scanned={}\n  accepted={}\n  duplicates={} (by_sop_instance_uid={}, by_sha256={})\n  unreadable={}\n  invalid_dicom={}\n  rejected_total={}\n  skipped={}\n  failed_cleanup={}\n  total={}\n  stored_bytes={}",
        report.scanned_files,
        report.accepted,
        report.duplicates,
        report.duplicate_by_sop_instance_uid,
        report.duplicate_by_sha256,
        report.unreadable,
        report.invalid_dicom,
        report.rejected(),
        report.skipped,
        report.failed_cleanup,
        report.total(),
        report.stored_bytes
    );
    const IMPORT_FAILURE_PRINT_LIMIT: usize = 10;
    if !report.failures.is_empty() {
        println!("failures:");
        for failure in report.failures.iter().take(IMPORT_FAILURE_PRINT_LIMIT) {
            println!("  - {}", failure);
        }
        if report.failures.len() > IMPORT_FAILURE_PRINT_LIMIT {
            println!(
                "  (showing first {} of {} failures)",
                IMPORT_FAILURE_PRINT_LIMIT,
                report.failures.len()
            );
        }
    }
}

fn print_send_outcome(outcome: &dicom_node_client::models::SendOutcome) {
    println!(
        "attempted={}\nsent={}\nfailed={}",
        outcome.attempted, outcome.sent, outcome.failed
    );
    if !outcome.failures.is_empty() {
        println!("failures:");
        for failure in &outcome.failures {
            println!("  - {}", failure);
        }
    }
}
