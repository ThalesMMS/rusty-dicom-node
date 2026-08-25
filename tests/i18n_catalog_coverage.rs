//! Catalog completeness: every shipped locale has the same Fluent keys as `en-US`.
//!
//! Shipped locales are `i18n/{locale}.ftl` files. This test fails until catalogs exist
//! and stay in key parity (including extra keys in a locale that `en-US` lacks).

mod common;

use std::collections::BTreeSet;

use common::i18n_ftl::{load_shipped_catalogs, REQUIRED_SHIPPED_LOCALES};

#[test]
fn shipped_locales_include_required_catalogs() {
    let catalogs = load_shipped_catalogs();
    let locales: BTreeSet<&str> = catalogs.keys().map(String::as_str).collect();

    for required in REQUIRED_SHIPPED_LOCALES {
        assert!(
            locales.contains(required),
            "required locale {required} is not shipped (expected i18n/{required}.ftl). present: {:?}",
            locales
        );
    }
}

#[test]
fn every_en_us_key_exists_in_every_shipped_locale_and_vice_versa() {
    let catalogs = load_shipped_catalogs();
    let en_keys = catalogs
        .get("en-US")
        .unwrap_or_else(|| panic!("i18n/en-US.ftl is required as the reference catalog"));

    let mut mismatches = Vec::new();

    for (locale, keys) in &catalogs {
        if locale == "en-US" {
            continue;
        }
        let missing_from_locale: Vec<_> = en_keys.difference(keys).cloned().collect();
        let extra_in_locale: Vec<_> = keys.difference(en_keys).cloned().collect();
        if !missing_from_locale.is_empty() || !extra_in_locale.is_empty() {
            mismatches.push(format!(
                "{locale}: missing_from_locale={missing_from_locale:?} extra_vs_en_US={extra_in_locale:?}"
            ));
        }
    }

    assert!(
        mismatches.is_empty(),
        "Fluent key sets must match en-US for every shipped locale (and vice versa):\n{}",
        mismatches.join("\n")
    );
}

#[test]
fn parser_rejects_dotted_message_ids_and_keeps_attributes() {
    use common::i18n_ftl::catalog_keys;

    let dotted = catalog_keys("tui.pane.remote-nodes = Invalid as a message id\n");
    assert!(
        !dotted.contains("tui.pane.remote-nodes"),
        "foo.bar is an attribute path, not a message id: {dotted:?}"
    );

    let hyphen = catalog_keys(
        "tui-pane-remote-nodes = Remote Nodes\n    .tooltip = List of peers\n",
    );
    assert!(hyphen.contains("tui-pane-remote-nodes"));
    assert!(
        hyphen.contains("tui-pane-remote-nodes.tooltip"),
        "attributes are keyed as message.attr: {hyphen:?}"
    );
}
