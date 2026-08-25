use crate::error::{msg, msg_with};
use crate::summary::{DicomAETitles, NetworkPeer, OperationCounts, OperationSummary};

fn fmt_peer(peer: &NetworkPeer) -> String {
    format!("{}:{}", peer.host, peer.port)
}

fn fmt_ae(ae: &DicomAETitles) -> String {
    match ae.move_destination.as_ref() {
        Some(dest) => format!(
            "calling={} called={} move_destination={}",
            ae.calling, ae.called, dest
        ),
        None => format!("calling={} called={}", ae.calling, ae.called),
    }
}

fn push_kv(out: &mut String, key: &str, value: &str) {
    out.push_str(key);
    out.push_str(": ");
    out.push_str(value);
    out.push('\n');
}

fn push_counts(out: &mut String, counts: &OperationCounts) {
    let mut parts: Vec<String> = Vec::new();

    if let Some(v) = counts.requested {
        parts.push(format!("requested={v}"));
    }
    if let Some(v) = counts.matched {
        parts.push(format!("matched={v}"));
    }
    if let Some(v) = counts.sent {
        parts.push(format!("sent={v}"));
    }
    if let Some(v) = counts.received {
        parts.push(format!("received={v}"));
    }
    if let Some(v) = counts.stored {
        parts.push(format!("stored={v}"));
    }
    if let Some(v) = counts.failed {
        parts.push(format!("failed={v}"));
    }
    if let Some(v) = counts.duplicates {
        parts.push(format!("duplicates={v}"));
    }
    if let Some(v) = counts.skipped {
        parts.push(format!("skipped={v}"));
    }

    if !parts.is_empty() {
        push_kv(out, &msg("summary-counts"), &parts.join(" "));
    }
}

/// Render an operation summary into a concise, structured, human-readable block.
///
/// Intended for CLI output and TUI task details.
pub fn render_human(summary: &OperationSummary) -> String {
    let mut out = String::new();

    out.push_str(&msg("summary-title"));
    out.push('\n');
    out.push_str("-----------------\n");

    push_kv(&mut out, &msg("summary-kind"), &format!("{:?}", summary.kind));
    push_kv(
        &mut out,
        &msg("summary-status"),
        &format!("{:?}", summary.status),
    );
    let duration_ms = summary.duration_ms.to_string();
    push_kv(
        &mut out,
        &msg("summary-duration"),
        &msg_with("summary-duration-ms", [("ms", duration_ms.as_str())]),
    );

    if let Some(peer) = summary.peer.as_ref() {
        push_kv(&mut out, &msg("summary-peer"), &fmt_peer(peer));
    }
    if let Some(ae) = summary.ae_titles.as_ref() {
        push_kv(&mut out, &msg("summary-ae"), &fmt_ae(ae));
    }

    if let Some(criteria) = summary.criteria.as_ref() {
        // Keep stable and readable; callers can ensure criteria is not huge.
        match serde_json::to_string_pretty(criteria) {
            Ok(s) => push_kv(&mut out, &msg("summary-criteria"), &s),
            Err(_) => push_kv(
                &mut out,
                &msg("summary-criteria"),
                &msg("summary-unserializable"),
            ),
        }
    }

    push_counts(&mut out, &summary.counts);

    if !summary.failures.is_empty() {
        out.push_str(&msg("summary-failures"));
        out.push('\n');
        for (idx, f) in summary.failures.iter().enumerate() {
            match f.code.as_ref() {
                Some(code) => out.push_str(&format!("  {}. [{}] {}\n", idx + 1, code, f.message)),
                None => out.push_str(&format!("  {}. {}\n", idx + 1, f.message)),
            }
        }
    }

    if !summary.logs.is_empty() {
        out.push_str(&msg("summary-logs"));
        out.push('\n');
        for (idx, l) in summary.logs.iter().enumerate() {
            let mut line = format!("  {}. {}", idx + 1, l.path);
            if let Some(cid) = l.correlation_id.as_ref() {
                line.push_str(&format!(" (correlation_id={cid})"));
            }
            if let Some((start, end)) = l.line_range {
                let start = start.to_string();
                let end = end.to_string();
                line.push(' ');
                line.push_str(&msg_with(
                    "summary-log-lines",
                    [("start", start.as_str()), ("end", end.as_str())],
                ));
            }
            out.push_str(&line);
            out.push('\n');
        }
    }

    out
}
