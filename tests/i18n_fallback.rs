//! Fallback chain for locale selection and Fluent message lookup (issue #90).
//!
//! Selection: `--lang` → `DICOM_NODE_LANG` → persisted config → OS locale → `en-US`.
//! Message: requested → language (`pt`) → `en-US` → message id (debug).

mod common;

use common::i18n_ftl::{
    first_catalog_owning_key, load_catalogs_from, load_shipped_catalogs, locale_fallback_chain,
    resolve_locale_preference,
};
use std::fs;

#[test]
fn message_fallback_chain_is_requested_then_language_then_en_us() {
    assert_eq!(locale_fallback_chain("pt-BR"), vec!["pt-BR", "pt", "en-US"]);
    assert_eq!(locale_fallback_chain("pt"), vec!["pt", "en-US"]);
    assert_eq!(locale_fallback_chain("en-US"), vec!["en-US", "en"]);
    assert_eq!(locale_fallback_chain("zh-CN"), vec!["zh-CN", "zh", "en-US"]);
}

#[test]
fn locale_preference_prefers_cli_then_env_then_config_then_os_then_en_us() {
    assert_eq!(
        resolve_locale_preference(Some("pt-BR"), Some("de-DE"), Some("fr-FR"), Some("ja-JP")),
        "pt-BR"
    );
    assert_eq!(
        resolve_locale_preference(None, Some("de-DE"), Some("fr-FR"), Some("ja-JP")),
        "de-DE"
    );
    assert_eq!(
        resolve_locale_preference(None, None, Some("fr-FR"), Some("ja-JP")),
        "fr-FR"
    );
    assert_eq!(
        resolve_locale_preference(None, None, None, Some("ja-JP")),
        "ja-JP"
    );
    assert_eq!(resolve_locale_preference(None, None, None, None), "en-US");
}

#[test]
fn unknown_locale_falls_back_to_en_us_catalog() {
    let catalogs = load_shipped_catalogs();
    let en_keys = catalogs
        .get("en-US")
        .expect("i18n/en-US.ftl must exist for fallback");
    let key = en_keys
        .iter()
        .next()
        .expect("en-US catalog must contain at least one key");

    assert_eq!(
        first_catalog_owning_key(&catalogs, "zz-ZZ", key).as_deref(),
        Some("en-US")
    );
}

#[test]
fn missing_message_falls_back_to_the_key() {
    let catalogs = load_shipped_catalogs();
    let key = "this-key-must-not-exist-in-any-catalog";
    assert!(
        first_catalog_owning_key(&catalogs, "pt-BR", key).is_none(),
        "debug fallback is the message id itself when no catalog defines it"
    );
}

#[test]
fn language_fallback_uses_parent_catalog_when_region_is_missing() {
    let dir = tempfile::tempdir().expect("temp i18n dir");
    fs::write(dir.path().join("en-US.ftl"), "cli-about = English about\n").unwrap();
    fs::write(dir.path().join("pt.ftl"), "cli-about = Sobre\n").unwrap();

    let catalogs = load_catalogs_from(dir.path());
    assert_eq!(
        first_catalog_owning_key(&catalogs, "pt-PT", "cli-about").as_deref(),
        Some("pt"),
        "pt-PT should use language catalog pt before en-US"
    );
}

#[test]
fn region_catalog_wins_over_language_and_en_us() {
    let dir = tempfile::tempdir().expect("temp i18n dir");
    fs::write(dir.path().join("en-US.ftl"), "cli-about = English about\n").unwrap();
    fs::write(dir.path().join("pt.ftl"), "cli-about = Sobre\n").unwrap();
    fs::write(
        dir.path().join("pt-BR.ftl"),
        "cli-about = Sobre o cliente\n",
    )
    .unwrap();

    let catalogs = load_catalogs_from(dir.path());
    assert_eq!(
        first_catalog_owning_key(&catalogs, "pt-BR", "cli-about").as_deref(),
        Some("pt-BR")
    );
}

#[test]
fn runtime_lookup_falls_back_to_en_us_then_the_key() {
    use dicom_node_client::i18n::{set_locale, t};

    let catalogs = load_shipped_catalogs();
    let key = catalogs
        .get("en-US")
        .expect("en-US catalog")
        .iter()
        .next()
        .expect("en-US key")
        .clone();

    set_locale("zz-ZZ".parse().expect("langid"));
    let unknown_locale = t(&key);
    set_locale("en-US".parse().expect("langid"));
    let en = t(&key);
    assert_ne!(
        unknown_locale, key,
        "unknown locale must not stay on the raw key when en-US defines {key}"
    );
    assert_eq!(unknown_locale, en);

    assert_eq!(
        t("this-key-must-not-exist-in-any-catalog"),
        "this-key-must-not-exist-in-any-catalog"
    );
}
