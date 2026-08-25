//! Helpers for Fluent catalog tests (key coverage and fallback).

use std::collections::{BTreeMap, BTreeSet};
use std::fs;
use std::path::{Path, PathBuf};

pub const REQUIRED_SHIPPED_LOCALES: &[&str] = &["en-US", "pt-BR"];

pub fn i18n_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("i18n")
}

fn is_fluent_ident(s: &str) -> bool {
    let mut chars = s.chars();
    match chars.next() {
        Some(c) if c.is_ascii_alphabetic() => {
            chars.all(|c| c.is_ascii_alphanumeric() || c == '_' || c == '-')
        }
        _ => false,
    }
}

/// Fluent message id or term (`-brand`). Dotted names are NOT message ids
/// (`foo.bar` is message `foo` + attribute `bar`).
fn is_message_id(s: &str) -> bool {
    if s.is_empty() || s.contains('.') {
        return false;
    }
    let ident = s.strip_prefix('-').unwrap_or(s);
    is_fluent_ident(ident)
}

/// Message ids, terms (`-name`), and attributes (`message.attr`) from a Fluent resource.
pub fn catalog_keys(source: &str) -> BTreeSet<String> {
    let mut keys = BTreeSet::new();
    let mut current_message: Option<String> = None;

    for line in source.lines() {
        // Fluent message ids start at column 0. Indented lines are continuations
        // or attributes (`.attr =`); CLI examples like `patient_name="DOE^JOHN"`
        // must not be counted as catalog keys.
        let indented = line.starts_with(' ') || line.starts_with('\t');
        let trimmed = line.trim();
        if trimmed.is_empty() || trimmed.starts_with('#') {
            continue;
        }

        if indented {
            if let Some(rest) = trimmed.strip_prefix('.') {
                if let Some((raw_id, _)) = rest.split_once('=') {
                    let id = raw_id.trim();
                    if is_fluent_ident(id) {
                        if let Some(msg) = &current_message {
                            keys.insert(format!("{msg}.{id}"));
                        }
                    }
                }
            }
            continue;
        }

        if let Some((raw_id, _)) = trimmed.split_once('=') {
            let id = raw_id.trim();
            if is_message_id(id) {
                current_message = Some(id.to_string());
                keys.insert(id.to_string());
            }
        }
    }

    keys
}

pub fn load_shipped_catalogs() -> BTreeMap<String, BTreeSet<String>> {
    let dir = i18n_dir();
    assert!(
        dir.is_dir(),
        "missing i18n catalog directory at {} — add i18n/en-US.ftl and other locales",
        dir.display()
    );
    load_catalogs_from(&dir)
}

pub fn load_catalogs_from(dir: &Path) -> BTreeMap<String, BTreeSet<String>> {
    let mut catalogs = BTreeMap::new();
    let mut entries: Vec<_> = fs::read_dir(dir)
        .unwrap_or_else(|e| panic!("read {}: {e}", dir.display()))
        .collect::<Result<_, _>>()
        .expect("read i18n directory entries");
    entries.sort_by_key(|e| e.file_name());

    for entry in entries {
        let path = entry.path();
        if path.extension().and_then(|e| e.to_str()) != Some("ftl") {
            continue;
        }
        let locale = path
            .file_stem()
            .and_then(|s| s.to_str())
            .unwrap_or("")
            .to_string();
        assert!(
            !locale.is_empty(),
            "catalog file {} has no locale stem",
            path.display()
        );
        let source =
            fs::read_to_string(&path).unwrap_or_else(|e| panic!("read {}: {e}", path.display()));
        let keys = catalog_keys(&source);
        assert!(
            !keys.is_empty(),
            "catalog {} has no Fluent message keys",
            path.display()
        );
        catalogs.insert(locale, keys);
    }

    catalogs
}

/// Message-locale fallback: requested → language (`pt`) → `en-US`.
/// The message id itself is the final debug fallback and is not a locale.
pub fn locale_fallback_chain(requested: &str) -> Vec<String> {
    let mut chain = Vec::new();
    let mut push = |id: &str| {
        if !chain.iter().any(|s| s == id) {
            chain.push(id.to_string());
        }
    };
    push(requested);
    if let Some(lang) = requested.split('-').next() {
        if lang != requested {
            push(lang);
        }
    }
    push("en-US");
    chain
}

/// Locale selection: `--lang` → `DICOM_NODE_LANG` → persisted config → OS locale → `en-US`.
pub fn resolve_locale_preference(
    cli_lang: Option<&str>,
    env_lang: Option<&str>,
    config_lang: Option<&str>,
    os_lang: Option<&str>,
) -> String {
    cli_lang
        .or(env_lang)
        .or(config_lang)
        .or(os_lang)
        .unwrap_or("en-US")
        .to_string()
}

pub fn first_catalog_owning_key(
    catalogs: &BTreeMap<String, BTreeSet<String>>,
    requested: &str,
    key: &str,
) -> Option<String> {
    locale_fallback_chain(requested)
        .into_iter()
        .find(|locale| catalogs.get(locale).is_some_and(|keys| keys.contains(key)))
}
