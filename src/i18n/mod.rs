//! Shared Fluent i18n for CLI, TUI, and desktop.
//!
//! Catalogs live in repo-root `i18n/{locale}.ftl`. Adding a language is a new
//! catalog file — not an enum variant in UI code.
//!
//! # Public API
//! - [`t`] / [`t_with`]: look up a hyphenated Fluent id (`tui-pane-remote-nodes`)
//! - [`current_locale`] / [`set_locale`]: active BCP-47 tag
//! - [`registered_locales`]: every `i18n/*.ftl` stem (auto-registered)
//! - [`init_from_cli_args`]: `--lang` → `DICOM_NODE_LANG` → persisted `locale` → OS → `en-US`
//!
//! Lookup fallback: requested → language (`pt`) → same-language catalog → `en-US` → key.
//! Fluent message IDs cannot contain `.` (`foo.bar` is an attribute). Catalogs use
//! hyphenated identifiers: `tui-pane-remote-nodes`, `cli-about`, `error-import-file-too-large`.

use std::cell::RefCell;
use std::collections::HashMap;
use std::sync::{Mutex, OnceLock, RwLock};

use fluent_bundle::{concurrent::FluentBundle, FluentArgs, FluentResource, FluentValue};
use rust_embed::Embed;
use unic_langid::LanguageIdentifier;

use crate::config::{AppConfig, AppPaths};
use crate::error::Result;

#[derive(Embed)]
#[folder = "i18n/"]
struct CatalogAssets;

struct Catalogs {
    bundles: HashMap<LanguageIdentifier, FluentBundle<FluentResource>>,
    locales: Vec<LanguageIdentifier>,
}

fn catalogs() -> &'static Catalogs {
    static CELL: OnceLock<Catalogs> = OnceLock::new();
    CELL.get_or_init(|| {
        let mut bundles = HashMap::new();
        let mut locales = Vec::new();
        for path in CatalogAssets::iter() {
            if !path.ends_with(".ftl") {
                continue;
            }
            let stem = path.trim_end_matches(".ftl");
            let Ok(lang) = stem.parse::<LanguageIdentifier>() else {
                continue;
            };
            let Some(file) = CatalogAssets::get(path.as_ref()) else {
                continue;
            };
            let src = match std::str::from_utf8(file.data.as_ref()) {
                Ok(s) => s.to_string(),
                Err(_) => continue,
            };
            let resource = match FluentResource::try_new(src) {
                Ok(res) => res,
                Err((res, _)) => res,
            };
            let mut bundle = FluentBundle::new_concurrent(vec![lang.clone()]);
            bundle.set_use_isolating(false);
            bundle.add_resource_overriding(resource);
            bundles.insert(lang.clone(), bundle);
            locales.push(lang);
        }
        locales.sort_by(|a, b| a.to_string().cmp(&b.to_string()));
        Catalogs { bundles, locales }
    })
}

fn locale_lock() -> &'static RwLock<LanguageIdentifier> {
    static CELL: OnceLock<RwLock<LanguageIdentifier>> = OnceLock::new();
    CELL.get_or_init(|| RwLock::new(fallback_en()))
}

fn explicit_override() -> &'static Mutex<bool> {
    static CELL: OnceLock<Mutex<bool>> = OnceLock::new();
    CELL.get_or_init(|| Mutex::new(false))
}

fn fallback_en() -> LanguageIdentifier {
    "en-US".parse().expect("en-US is a valid language id")
}

fn parse_langid(tag: &str) -> Option<LanguageIdentifier> {
    tag.trim().parse().ok()
}

fn to_fluent_id(key: &str) -> String {
    key.replace(['.', '_'], "-")
}

/// Parse `--lang` / `--lang=` from argv (skipping argv0). Does not print help.
pub fn peek_lang_from_args<I, S>(args: I) -> Option<String>
where
    I: IntoIterator<Item = S>,
    S: AsRef<str>,
{
    let mut iter = args.into_iter();
    let _argv0 = iter.next();
    while let Some(arg) = iter.next() {
        let arg = arg.as_ref();
        if arg == "--" {
            break;
        }
        if let Some(value) = arg.strip_prefix("--lang=") {
            if !value.is_empty() {
                return Some(value.to_string());
            }
        }
        if arg == "--lang" {
            if let Some(value) = iter.next() {
                let value = value.as_ref();
                if !value.is_empty() && !value.starts_with('-') {
                    return Some(value.to_string());
                }
            }
        }
    }
    None
}

fn peek_persisted_locale() -> Option<String> {
    let paths = AppPaths::discover().ok()?;
    let text = std::fs::read_to_string(&paths.config_json).ok()?;
    let value: serde_json::Value = serde_json::from_str(&text).ok()?;
    value
        .get("locale")
        .and_then(|v| v.as_str())
        .map(str::trim)
        .filter(|s| !s.is_empty())
        .map(ToOwned::to_owned)
}

/// Resolve locale: `--lang` → `DICOM_NODE_LANG` → config `locale` → OS → `en-US`.
pub fn init_from_cli_args() {
    let args: Vec<String> = std::env::args().collect();
    let from_cli = peek_lang_from_args(args.iter().map(String::as_str));
    let from_env = std::env::var("DICOM_NODE_LANG")
        .ok()
        .filter(|s| !s.trim().is_empty());
    let explicit = from_cli.is_some() || from_env.is_some();
    *explicit_override().lock().expect("i18n override lock") = explicit;

    let requested = from_cli
        .or(from_env)
        .or_else(peek_persisted_locale)
        .or_else(sys_locale::get_locale);

    let locale = requested
        .as_deref()
        .and_then(parse_langid)
        .unwrap_or_else(fallback_en);
    set_locale(locale);
}

/// Persist an explicit `--lang` choice onto `AppConfig.locale`.
pub fn persist_explicit_locale(tag: &str, paths: &AppPaths) -> Result<()> {
    let mut cfg = AppConfig::load_or_create(paths)?;
    if cfg.locale.as_deref() != Some(tag) {
        cfg.locale = Some(tag.to_string());
        cfg.save(paths)?;
    }
    Ok(())
}

/// Apply a saved config locale when CLI/env did not override.
pub fn apply_persisted_locale(tag: Option<&str>) {
    if *explicit_override().lock().expect("i18n override lock") {
        return;
    }
    if let Some(locale) = tag.and_then(parse_langid) {
        set_locale(locale);
    }
}

thread_local! {
    static THREAD_LOCALE: RefCell<Option<LanguageIdentifier>> = const { RefCell::new(None) };
}

pub fn set_locale(locale: LanguageIdentifier) {
    *locale_lock().write().expect("i18n locale lock") = locale;
}

/// Per-thread locale override for tests. `None` clears the override.
pub fn set_thread_locale(locale: Option<LanguageIdentifier>) {
    THREAD_LOCALE.with(|cell| *cell.borrow_mut() = locale);
}

pub fn current_locale() -> LanguageIdentifier {
    THREAD_LOCALE.with(|cell| {
        cell.borrow()
            .clone()
            .unwrap_or_else(|| locale_lock().read().expect("i18n locale lock").clone())
    })
}

/// Every catalog stem discovered in `i18n/*.ftl`.
pub fn registered_locales() -> Vec<LanguageIdentifier> {
    catalogs().locales.clone()
}

fn language_only(locale: &LanguageIdentifier) -> LanguageIdentifier {
    LanguageIdentifier::from_parts(locale.language, None, None, &[])
}

fn format_message(
    bundle: &FluentBundle<FluentResource>,
    key: &str,
    args: Option<&FluentArgs>,
) -> Option<String> {
    let id = to_fluent_id(key);
    let message = bundle.get_message(&id)?;
    let pattern = message.value()?;
    let mut errors = Vec::new();
    let formatted = bundle.format_pattern(pattern, args, &mut errors);
    Some(formatted.into_owned())
}

fn lookup_in(lang: &LanguageIdentifier, key: &str) -> Option<String> {
    let bundle = catalogs().bundles.get(lang)?;
    format_message(bundle, key, None)
}

fn lookup_in_with<'a>(
    lang: &LanguageIdentifier,
    key: &str,
    args: &HashMap<String, FluentValue<'a>>,
) -> Option<String> {
    let bundle = catalogs().bundles.get(lang)?;
    let mut fluent_args = FluentArgs::new();
    for (name, value) in args {
        fluent_args.set(name.clone(), value.clone());
    }
    format_message(bundle, key, Some(&fluent_args))
}

fn fallback_chain(requested: &LanguageIdentifier) -> Vec<LanguageIdentifier> {
    let mut chain = Vec::new();
    let mut push = |id: LanguageIdentifier| {
        if !chain.contains(&id) {
            chain.push(id);
        }
    };
    push(requested.clone());
    push(language_only(requested));
    for loc in &catalogs().locales {
        if loc.language == requested.language {
            push(loc.clone());
        }
    }
    push(fallback_en());
    chain
}

fn lookup_chain(key: &str) -> String {
    for lang in fallback_chain(&current_locale()) {
        if let Some(value) = lookup_in(&lang, key) {
            return value;
        }
    }
    key.to_string()
}

fn lookup_chain_with<'a>(key: &str, args: &HashMap<String, FluentValue<'a>>) -> String {
    for lang in fallback_chain(&current_locale()) {
        if let Some(value) = lookup_in_with(&lang, key, args) {
            return value;
        }
    }
    key.to_string()
}

/// Look up `key` in the current locale with fallback.
pub fn t(key: &str) -> String {
    lookup_chain(key)
}

/// Look up `key` with Fluent arguments (`{ $name }` in catalogs).
pub fn t_with<'a>(key: &str, args: &HashMap<String, FluentValue<'a>>) -> String {
    lookup_chain_with(key, args)
}

/// Look up `key` with a numeric argument so ICU plural categories apply.
pub fn t_n(key: &str, name: &str, n: impl Into<i64>) -> String {
    let mut args = HashMap::new();
    args.insert(name.to_string(), FluentValue::from(n.into()));
    t_with(key, &args)
}

fn padded2(n: u32) -> String {
    format!("{n:02}")
}

fn parse_dicom_da(raw: &str) -> Option<(i32, u32, u32)> {
    let compact: String = raw.chars().filter(|c| c.is_ascii_digit()).collect();
    if compact.len() != 8 {
        return None;
    }
    let year: i32 = compact[0..4].parse().ok()?;
    let month: u32 = compact[4..6].parse().ok()?;
    let day: u32 = compact[6..8].parse().ok()?;
    chrono::NaiveDate::from_ymd_opt(year, month, day)?;
    Some((year, month, day))
}

fn split_dicom_date_range(raw: &str) -> Option<(&str, &str)> {
    let s = raw.trim();
    if s.len() == 17 && s.as_bytes().get(8) == Some(&b'-') {
        let start = &s[..8];
        let end = &s[9..];
        if parse_dicom_da(start).is_some() && parse_dicom_da(end).is_some() {
            return Some((start, end));
        }
    }
    if let Some((start, end)) = s.split_once("..") {
        if parse_dicom_da(start).is_some() && parse_dicom_da(end).is_some() {
            return Some((start.trim(), end.trim()));
        }
    }
    None
}

fn format_ymd(year: i32, month: u32, day: u32) -> String {
    let mut args = HashMap::new();
    args.insert("year".into(), FluentValue::from(year.to_string()));
    args.insert("month".into(), FluentValue::from(padded2(month)));
    args.insert("day".into(), FluentValue::from(padded2(day)));
    let formatted = t_with("format-date", &args);
    if formatted == "format-date" {
        format!("{year:04}{month:02}{day:02}")
    } else {
        formatted
    }
}

fn format_datetime_parts(year: i32, month: u32, day: u32, hour: u32, minute: u32) -> String {
    let date = format_ymd(year, month, day);
    let time = format!("{hour:02}:{minute:02}");
    let mut args = HashMap::new();
    args.insert("date".into(), FluentValue::from(date));
    args.insert("time".into(), FluentValue::from(time));
    let formatted = t_with("format-datetime", &args);
    if formatted == "format-datetime" {
        format_ymd(year, month, day)
    } else {
        formatted
    }
}

/// Format a DICOM DA (`YYYYMMDD`) or RFC3339 timestamp for the current locale.
///
/// On-wire DICOM values and query parameters the operator types must stay raw;
/// call this only for operator-visible display.
pub fn format_operator_date(raw: &str) -> String {
    let s = raw.trim();
    if s.is_empty() {
        return String::new();
    }
    if let Some((start, end)) = split_dicom_date_range(s) {
        return format!(
            "{} – {}",
            format_operator_date(start),
            format_operator_date(end)
        );
    }
    if s.contains('T') || (s.contains(' ') && s.contains(':')) {
        if let Ok(dt) = chrono::DateTime::parse_from_rfc3339(s) {
            use chrono::{Datelike, Timelike};
            return format_datetime_parts(
                dt.year(),
                dt.month(),
                dt.day(),
                dt.hour(),
                dt.minute(),
            );
        }
        if let Ok(dt) = chrono::NaiveDateTime::parse_from_str(s, "%Y-%m-%dT%H:%M:%S") {
            use chrono::{Datelike, Timelike};
            return format_datetime_parts(
                dt.year(),
                dt.month(),
                dt.day(),
                dt.hour(),
                dt.minute(),
            );
        }
        if let Ok(dt) = chrono::NaiveDateTime::parse_from_str(s, "%Y-%m-%d %H:%M:%S") {
            use chrono::{Datelike, Timelike};
            return format_datetime_parts(
                dt.year(),
                dt.month(),
                dt.day(),
                dt.hour(),
                dt.minute(),
            );
        }
    }
    if let Some((year, month, day)) = parse_dicom_da(s) {
        return format_ymd(year, month, day);
    }
    s.to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    static TEST_LOCK: Mutex<()> = Mutex::new(());

    fn with_locale(tag: &str, f: impl FnOnce()) {
        let _guard = TEST_LOCK
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner());
        let previous = current_locale();
        set_locale(tag.parse().expect("test locale"));
        f();
        set_locale(previous);
    }

    #[test]
    fn peek_lang_space_and_equals() {
        assert_eq!(
            peek_lang_from_args(["dicom-node-client", "--lang", "pt-BR", "--help"]),
            Some("pt-BR".to_string())
        );
        assert_eq!(
            peek_lang_from_args(["dicom-node-client", "--lang=pt-BR", "--help"]),
            Some("pt-BR".to_string())
        );
        assert_eq!(
            peek_lang_from_args(["dicom-node-client", "--help", "--lang", "ja-JP"]),
            Some("ja-JP".to_string())
        );
        assert_eq!(peek_lang_from_args(["dicom-node-client", "--help"]), None);
    }

    #[test]
    fn loads_en_us_keys() {
        with_locale("en-US", || {
            assert_eq!(
                t("cli-about"),
                "Terminal-first DICOM node client built with dicom-rs"
            );
            assert!(t("error-import-file-too-large").contains("file too large"));
            assert_eq!(t("tui-pane-remote-nodes"), "Remote Nodes");
        });
    }

    #[test]
    fn missing_key_returns_key() {
        with_locale("en-US", || {
            assert_eq!(t("this-key-does-not-exist"), "this-key-does-not-exist");
        });
    }

    #[test]
    fn unknown_locale_falls_back_to_en_us() {
        with_locale("xx-YY", || {
            assert_eq!(
                t("cli-about"),
                "Terminal-first DICOM node client built with dicom-rs"
            );
        });
    }

    #[test]
    fn language_only_en_falls_back_to_en_us() {
        with_locale("en", || {
            assert_eq!(t("tui-pane-remote-nodes"), "Remote Nodes");
        });
    }

    #[test]
    fn t_with_substitutes_placeholders() {
        with_locale("en-US", || {
            let mut args = HashMap::new();
            args.insert("details".into(), FluentValue::from("4 > 3"));
            assert_eq!(
                t_with("error-import-file-too-large", &args),
                "file too large: 4 > 3"
            );
        });
    }

    #[test]
    fn registered_locales_include_en_us() {
        let locales = registered_locales();
        assert!(
            locales.iter().any(|l| l.to_string() == "en-US"),
            "en-US must be registered: {locales:?}"
        );
        assert!(
            locales.len() >= 1,
            "catalogs are file-backed, not a two-locale enum"
        );
    }

    #[test]
    fn format_operator_date_follows_locale_order() {
        with_locale("en-US", || {
            assert_eq!(format_operator_date("20240309"), "03/09/2024");
            assert_eq!(
                format_operator_date("20240309-20240311"),
                "03/09/2024 – 03/11/2024"
            );
        });
        with_locale("pt-BR", || {
            assert_eq!(format_operator_date("20240309"), "09/03/2024");
        });
        with_locale("de-DE", || {
            assert_eq!(format_operator_date("20240309"), "09.03.2024");
        });
        with_locale("ja-JP", || {
            assert_eq!(format_operator_date("20240309"), "2024/03/09");
        });
        with_locale("en-US", || {
            assert_eq!(format_operator_date("not-a-date"), "not-a-date");
            assert_eq!(format_operator_date("20240309..20240311"), "03/09/2024 – 03/11/2024");
        });
    }

    #[test]
    fn fluent_plurals_select_icu_categories() {
        with_locale("en-US", || {
            assert_eq!(t_n("count-studies", "n", 1), "1 study");
            assert_eq!(t_n("count-studies", "n", 2), "2 studies");
        });
        with_locale("pt-BR", || {
            assert_eq!(t_n("count-studies", "n", 1), "1 estudo");
            assert_eq!(t_n("count-studies", "n", 2), "2 estudos");
        });
        with_locale("ru-RU", || {
            assert_eq!(t_n("count-studies", "n", 1), "1 исследование");
            assert_eq!(t_n("count-studies", "n", 2), "2 исследования");
            assert_eq!(t_n("count-studies", "n", 5), "5 исследований");
        });
    }

    #[test]
    fn string_count_does_not_select_plural_category() {
        with_locale("en-US", || {
            let mut args = HashMap::new();
            args.insert("n".into(), FluentValue::from("1"));
            assert_eq!(t_with("count-studies", &args), "1 studies");
        });
    }
}
