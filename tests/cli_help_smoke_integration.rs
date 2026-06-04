mod common;

use std::process::Command;

#[test]
fn cli_help_includes_top_level_commands() {
    let bin = env!("CARGO_BIN_EXE_dicom-node-client");

    let output = Command::new(bin)
        .arg("--help")
        .output()
        .expect("run dicom-node-client --help");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

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
    let bin = env!("CARGO_BIN_EXE_dicom-node-client");

    let output = Command::new(bin)
        .args(["node", "--help"])
        .output()
        .expect("run dicom-node-client node --help");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);

    for cmd in ["add", "edit", "delete", "list"] {
        assert!(
            stdout.contains(cmd),
            "node --help output missing expected subcommand '{cmd}'. Output:\n{stdout}"
        );
    }
}

#[test]
fn cli_serve_help_includes_metrics_snapshot_flag() {
    let bin = env!("CARGO_BIN_EXE_dicom-node-client");

    let output = Command::new(bin)
        .args(["serve", "--help"])
        .output()
        .expect("run dicom-node-client serve --help");

    assert!(output.status.success());

    let stdout = String::from_utf8_lossy(&output.stdout);
    assert!(
        stdout.contains("--metrics-json"),
        "serve --help output missing --metrics-json. Output:\n{stdout}"
    );
}
