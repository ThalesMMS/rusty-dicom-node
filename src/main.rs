use std::{collections::HashMap, path::Path, sync::Arc};

pub use dicom_node_client::{
    aliases, cancel, config, db, dicom, error, i18n, importer, models, net, services,
};
use dicom_node_client::{
    cli::{Cli, Commands, LocalCommand, NodeCommand, SendCommand},
    config::AppPaths,
    export::{export_series, export_studies},
    filters::{SeriesFilters, StudyFilters},
    models::{MoveRequest, QueryCriteria},
    services::{AppServices, NodeDraftValues, NodePatchCliValues},
};
use fluent_bundle::FluentValue;
use tracing_subscriber::{fmt, prelude::*, EnvFilter};

mod tui;

fn t(key: &str) -> String {
    dicom_node_client::i18n::t(key)
}

fn tf<'a>(key: &str, pairs: impl IntoIterator<Item = (&'a str, &'a str)>) -> String {
    dicom_node_client::error::msg_with(key, pairs)
}

fn t_owned(key: &str, pairs: &[(&str, String)]) -> String {
    let refs: Vec<(&str, &str)> = pairs.iter().map(|(k, v)| (*k, v.as_str())).collect();
    dicom_node_client::error::msg_with(key, refs)
}

fn t_n(key: &str, name: &str, n: impl Into<i64>) -> String {
    dicom_node_client::i18n::t_n(key, name, n)
}

fn t_mixed(key: &str, numbers: &[(&str, i64)], strings: &[(&str, String)]) -> String {
    let mut args = HashMap::new();
    for (name, n) in numbers {
        args.insert((*name).to_string(), FluentValue::from(*n));
    }
    for (name, value) in strings {
        args.insert((*name).to_string(), FluentValue::from(value.clone()));
    }
    dicom_node_client::i18n::t_with(key, &args)
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    let paths = AppPaths::discover()?;
    let log_path = paths.logs_dir.join("app.log");
    let _tracing_guard = init_tracing(&paths.logs_dir)?;
    let services = AppServices::load_from_paths(paths)?;
    if let Some(lang) = cli.lang.as_deref() {
        dicom_node_client::i18n::persist_explicit_locale(lang, &services.paths)?;
    } else {
        dicom_node_client::i18n::apply_persisted_locale(services.config.locale.as_deref());
    }

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
                    "{}",
                    t_owned(
                        "cli-msg-saved-node",
                        &[
                            ("name", node.name.clone()),
                            ("id", node.id.clone()),
                            ("ae", node.ae_title.clone()),
                            ("host", node.host.clone()),
                            ("port", node.port.to_string()),
                        ],
                    )
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
                    "{}",
                    t_owned(
                        "cli-msg-updated-node",
                        &[
                            ("name", node.name.clone()),
                            ("id", node.id.clone()),
                            ("ae", node.ae_title.clone()),
                            ("host", node.host.clone()),
                            ("port", node.port.to_string()),
                        ],
                    )
                );
            }
            NodeCommand::Delete(args) => {
                let removed = services.delete_node(&args.node)?;
                println!("{}", t_n("cli-msg-removed-nodes", "count", removed as i64));
            }
            NodeCommand::List => {
                let nodes = services.list_nodes()?;
                if nodes.is_empty() {
                    println!("{}", t("cli-msg-no-saved-nodes"));
                } else {
                    for node in nodes {
                        let dest = node
                            .preferred_move_destination
                            .clone()
                            .unwrap_or_else(|| "-".to_string());
                        println!(
                            "{}",
                            t_owned(
                                "cli-msg-node-list-row",
                                &[
                                    ("name", node.name),
                                    ("id", node.id),
                                    ("ae", node.ae_title),
                                    ("host", node.host),
                                    ("port", node.port.to_string()),
                                    ("dest", dest),
                                ],
                            )
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
                        let err_text = format!("{err:#}");
                        eprintln!("{}", tf("cli-msg-import-failed", [("error", err_text.as_str())]));
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
                        println!("{}", t_n("cli-msg-results-count", "count", results.len() as i64));
                        for item in &results {
                            let date = item
                                .study_date
                                .as_deref()
                                .map(dicom_node_client::i18n::format_operator_date)
                                .filter(|s| !s.is_empty())
                                .unwrap_or_else(|| "-".to_string());
                            println!(
                                "- level={} patient={} study_uid={} series_uid={} sop_uid={} date={} modality={} desc={}",
                                item.level,
                                item.patient_name.clone().unwrap_or_else(|| "-".to_string()),
                                item.study_instance_uid.clone().unwrap_or_else(|| "-".to_string()),
                                item.series_instance_uid.clone().unwrap_or_else(|| "-".to_string()),
                                item.sop_instance_uid.clone().unwrap_or_else(|| "-".to_string()),
                                date,
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
                        let err_text = format!("{err:#}");
                        eprintln!("{}", tf("cli-msg-query-failed", [("error", err_text.as_str())]));
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
                        let err_text = format!("{err:#}");
                        eprintln!("{}", tf("cli-msg-retrieve-failed", [("error", err_text.as_str())]));
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
                            let err_text = format!("{err:#}");
                            eprintln!("{}", tf("cli-msg-send-failed", [("error", err_text.as_str())]));
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
                            let err_text = format!("{err:#}");
                            eprintln!("{}", tf("cli-msg-send-failed", [("error", err_text.as_str())]));
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
                    println!("{}", t("cli-msg-no-local-studies"));
                } else {
                    for study in studies {
                        println!(
                            "{}",
                            t_owned(
                                "cli-msg-local-study-row",
                                &[
                                    ("uid", study.study_instance_uid),
                                    (
                                        "patient",
                                        study.patient_name.unwrap_or_else(|| "-".to_string()),
                                    ),
                                    (
                                        "date",
                                        study
                                            .study_date
                                            .as_deref()
                                            .map(dicom_node_client::i18n::format_operator_date)
                                            .filter(|s| !s.is_empty())
                                            .unwrap_or_else(|| "-".to_string()),
                                    ),
                                    (
                                        "desc",
                                        study.study_description.unwrap_or_else(|| "-".to_string()),
                                    ),
                                    (
                                        "modalities",
                                        study.modalities.unwrap_or_else(|| "-".to_string()),
                                    ),
                                    ("series", study.series_count.to_string()),
                                    ("instances", study.instance_count.to_string()),
                                ],
                            )
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
                    println!(
                        "{}",
                        t_owned(
                            "cli-msg-no-local-series",
                            &[("uid", args.study_instance_uid.clone())],
                        )
                    );
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
        Commands::Serve { json, metrics_json } => {
            use dicom_node_client::summary::{
                OperationCounts, OperationKind, OperationStatus, OperationSummary,
            };
            use dicom_node_client::summary_render::render_human;
            use std::time::Instant;

            let started = Instant::now();
            if services.config.local_aes.is_empty() {
                println!("{}", t("cli-msg-starting-server-no-aes"));
            } else {
                let listeners = services
                    .config
                    .local_aes
                    .iter()
                    .map(|ae| format!("{}@{}", ae.title, ae.bind_addr))
                    .collect::<Vec<_>>()
                    .join(", ");
                println!(
                    "{}",
                    t_mixed(
                        "cli-msg-starting-server",
                        &[("count", services.config.local_aes.len() as i64)],
                        &[("aes", listeners)],
                    )
                );
            }

            let report_result = services.run_server_runtime(Arc::clone(&cancel_flag));
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
                        message: t_owned("error-serve-exited", &[("error", format!("{err:#}"))]),
                        code: Some("serve_error".to_string()),
                    });
            }

            if json {
                println!("{}", serde_json::to_string_pretty(&summary)?);
            } else {
                println!("{}", render_human(&summary));
            }

            if metrics_json {
                println!(
                    "{}",
                    serde_json::to_string_pretty(&services.server_metrics_snapshot())?
                );
            }

            if let Some(err) = err {
                return Err(err);
            }
        }
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
                "{}",
                t_owned(
                    "cli-msg-starting-storage-scp",
                    &[
                        ("addr", listener_addr.to_string()),
                        ("ae", services.config.local_ae_title.clone()),
                    ],
                )
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
            eprintln!("{}", dicom_node_client::error::msg("error-cancel-sigint"));
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
        .map_err(|err| {
            let err = err.to_string();
            anyhow::anyhow!(
                "{}",
                dicom_node_client::error::msg_with("error-tracing-init", [("err", err.as_str())])
            )
        })?;

    Ok(guard)
}

fn print_import_report(report: &dicom_node_client::models::ImportReport) {
    println!("{}", t("cli-import-complete"));
    println!("  {}", t_owned("cli-import-scanned", &[("n", report.scanned_files.to_string())]));
    println!("  {}", t_owned("cli-import-accepted", &[("n", report.accepted.to_string())]));
    println!(
        "  {}",
        t_owned(
            "cli-import-dup-detail",
            &[
                ("n", report.duplicates.to_string()),
                ("sop", report.duplicate_by_sop_instance_uid.to_string()),
                ("sha", report.duplicate_by_sha256.to_string()),
            ],
        )
    );
    println!("  {}", t_owned("cli-import-unreadable", &[("n", report.unreadable.to_string())]));
    println!(
        "  {}",
        t_owned("cli-import-invalid-dicom", &[("n", report.invalid_dicom.to_string())])
    );
    println!(
        "  {}",
        t_owned("cli-import-rejected-total", &[("n", report.rejected().to_string())])
    );
    println!("  {}", t_owned("cli-import-skipped", &[("n", report.skipped.to_string())]));
    println!(
        "  {}",
        t_owned("cli-import-failed-cleanup", &[("n", report.failed_cleanup.to_string())])
    );
    println!("  {}", t_owned("cli-import-total", &[("n", report.total().to_string())]));
    println!(
        "  {}",
        t_owned("cli-import-stored-bytes", &[("n", report.stored_bytes.to_string())])
    );
    const IMPORT_FAILURE_PRINT_LIMIT: usize = 10;
    if !report.failures.is_empty() {
        println!("{}", t("cli-msg-failures"));
        for failure in report.failures.iter().take(IMPORT_FAILURE_PRINT_LIMIT) {
            println!("  - {}", failure);
        }
        if report.failures.len() > IMPORT_FAILURE_PRINT_LIMIT {
            println!(
                "  {}",
                t_owned(
                    "cli-msg-showing-failures",
                    &[
                        ("shown", IMPORT_FAILURE_PRINT_LIMIT.to_string()),
                        ("total", report.failures.len().to_string()),
                    ],
                )
            );
        }
    }
}

fn print_send_outcome(outcome: &dicom_node_client::models::SendOutcome) {
    println!("{}", t_owned("cli-send-attempted", &[("n", outcome.attempted.to_string())]));
    println!("{}", t_owned("cli-send-sent", &[("n", outcome.sent.to_string())]));
    println!("{}", t_owned("cli-send-failed-count", &[("n", outcome.failed.to_string())]));
    if !outcome.failures.is_empty() {
        println!("{}", t("cli-msg-failures"));
        for failure in &outcome.failures {
            println!("  - {}", failure);
        }
    }
}
