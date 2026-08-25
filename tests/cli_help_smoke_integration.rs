mod common;

use std::process::Command;

const ENGLISH_ABOUT: &str = "Terminal-first DICOM node client built with dicom-rs";

fn bin() -> &'static str {
    env!("CARGO_BIN_EXE_dicom-node-client")
}

fn help_output(args: &[&str]) -> String {
    let output = Command::new(bin())
        .args(args)
        .env_remove("DICOM_NODE_LANG")
        .output()
        .unwrap_or_else(|_| panic!("run dicom-node-client {}", args.join(" ")));

    assert!(
        output.status.success(),
        "dicom-node-client {} failed ({:?}). stderr:\n{}",
        args.join(" "),
        output.status,
        String::from_utf8_lossy(&output.stderr)
    );

    String::from_utf8_lossy(&output.stdout).into_owned()
}

#[test]
fn cli_help_includes_top_level_commands() {
    let stdout = help_output(&["--lang", "en-US", "--help"]);

    for cmd in [
        "tui",
        "node",
        "import",
        "query",
        "retrieve",
        "send",
        "local",
        "serve",
        "storage-scp",
    ] {
        assert!(
            stdout.contains(cmd),
            "--help output missing expected command '{cmd}'. Output:\n{stdout}"
        );
    }
}

#[test]
fn cli_node_help_includes_expected_subcommands() {
    let stdout = help_output(&["--lang", "en-US", "node", "--help"]);

    for cmd in ["add", "edit", "delete", "list"] {
        assert!(
            stdout.contains(cmd),
            "node --help output missing expected subcommand '{cmd}'. Output:\n{stdout}"
        );
    }
}

#[test]
fn cli_serve_help_includes_metrics_snapshot_flag() {
    let stdout = help_output(&["--lang", "en-US", "serve", "--help"]);
    assert!(
        stdout.contains("--metrics-json"),
        "serve --help output missing --metrics-json. Output:\n{stdout}"
    );
}

#[test]
fn cli_help_en_us_includes_english_about() {
    let stdout = help_output(&["--lang", "en-US", "--help"]);
    assert!(
        stdout.contains(ENGLISH_ABOUT),
        "en-US --help missing English about string. Output:\n{stdout}"
    );
}

#[test]
fn cli_help_pt_br_does_not_include_english_about() {
    let stdout = help_output(&["--lang", "pt-BR", "--help"]);
    assert!(
        !stdout.contains(ENGLISH_ABOUT),
        "pt-BR --help still shows English about string. Output:\n{stdout}"
    );
    assert!(
        stdout.contains("Cliente DICOM"),
        "pt-BR --help missing Portuguese about. Output:\n{stdout}"
    );
}

#[test]
fn cli_help_pt_br_equals_form_localizes_about() {
    let stdout = help_output(&["--lang=pt-BR", "--help"]);
    assert!(
        !stdout.contains(ENGLISH_ABOUT),
        "--lang=pt-BR --help still shows English about string. Output:\n{stdout}"
    );
}
