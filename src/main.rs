mod aliases;
mod cli;
mod config;
mod db;
mod dicom;
mod error;
mod importer;
mod models;
mod net;
mod services;
mod tui;

use std::path::Path;

use clap::Parser;
use tracing_subscriber::{fmt, prelude::*, EnvFilter};

use crate::{
    cli::{Cli, Commands, LocalCommand, NodeCommand, SendCommand},
    config::AppPaths,
    models::{MoveRequest, QueryCriteria},
    services::{AppServices, NodeDraftValues, NodePatchCliValues},
};

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    let paths = AppPaths::discover()?;
    let _tracing_guard = init_tracing(&paths.logs_dir)?;
    let services = AppServices::load_from_paths(paths)?;

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
            let report = services.import_path(&args.path)?;
            print_import_report(&report);
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

            let results = services.query(&args.node, &criteria)?;
            println!("Results: {}", results.len());
            for item in results {
                println!(
                    "- level={} patient={} study_uid={} series_uid={} sop_uid={} date={} modality={} desc={}",
                    item.level,
                    item.patient_name.unwrap_or_else(|| "-".to_string()),
                    item.study_instance_uid.unwrap_or_else(|| "-".to_string()),
                    item.series_instance_uid.unwrap_or_else(|| "-".to_string()),
                    item.sop_instance_uid.unwrap_or_else(|| "-".to_string()),
                    item.study_date.unwrap_or_else(|| "-".to_string()),
                    item.modality.unwrap_or_else(|| "-".to_string()),
                    item.study_description.unwrap_or_else(|| "-".to_string()),
                );
            }
        }
        Commands::Retrieve(args) => {
            let outcome = services.retrieve(MoveRequest {
                node_name_or_id: args.node,
                model: args.model,
                level: args.level,
                study_instance_uid: args.study_instance_uid,
                series_instance_uid: args.series_instance_uid,
                sop_instance_uid: args.sop_instance_uid,
                move_destination: args.move_destination,
            })?;
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
        }
        Commands::Send { command } => match command {
            SendCommand::Study(args) => {
                let outcome =
                    services.send_study(&args.study_instance_uid, &args.destination_node)?;
                print_send_outcome(&outcome);
            }
            SendCommand::Series(args) => {
                let outcome =
                    services.send_series(&args.series_instance_uid, &args.destination_node)?;
                print_send_outcome(&outcome);
            }
        },
        Commands::Local { command } => match command {
            LocalCommand::Studies => {
                let studies = services.local_studies()?;
                if studies.is_empty() {
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
            LocalCommand::Series { study_instance_uid } => {
                let series = services.local_series(&study_instance_uid)?;
                if series.is_empty() {
                    println!("No indexed series for study {}", study_instance_uid);
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
        Commands::StorageScp => {
            println!(
                "Starting storage SCP at {} with AE title {}",
                services.config.storage_socket_addr(),
                services.config.local_ae_title
            );
            services.run_storage_scp()?;
        }
    }

    Ok(())
}

fn init_tracing(logs_dir: &Path) -> anyhow::Result<tracing_appender::non_blocking::WorkerGuard> {
    let filter = EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info"));
    let file_appender = tracing_appender::rolling::daily(logs_dir, "app");
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

fn print_import_report(report: &crate::models::ImportReport) {
    println!(
        "Import complete\n  scanned={}\n  accepted={}\n  duplicates={}\n  unreadable={}\n  invalid_dicom={}\n  rejected_total={}\n  stored_bytes={}",
        report.scanned_files,
        report.accepted,
        report.duplicates,
        report.unreadable,
        report.invalid_dicom,
        report.rejected(),
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

fn print_send_outcome(outcome: &crate::models::SendOutcome) {
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
