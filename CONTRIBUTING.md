# Contributing

## Adding a language

User-facing copy lives in Fluent catalogs under `i18n/`. TUI, CLI help/about, desktop chrome, and operator-facing errors all consume those catalogs. Adding a language is a catalog change, not a render-code change.

1. Copy `i18n/en-US.ftl` to `i18n/{locale}.ftl` using a BCP-47 id (`pt-BR`, `es-ES`, `zh-CN`, …).
2. Translate message **values**. Keep the same hyphenated Fluent message ids (`cli-about`, not `cli.about`), terms, attributes, and placeholders (`{ $name }`, selectors, plurals). In Fluent, `foo.bar` is message `foo` plus attribute `bar`, not a message named `foo.bar`.
3. The Rust and desktop loaders auto-discover `i18n/*.ftl`. Do **not** register the locale in an enum, a shipped-locale list, or a new `match locale` arm in TUI panes, clap render paths, or desktop views.
4. Run the key-coverage test:

```bash
cargo test --test i18n_catalog_coverage --test i18n_fallback
```

Every `en-US` key must exist in the new locale, and the new locale must not introduce keys that `en-US` lacks.

Do **not** translate:

- DICOM protocol tokens, SOP class names, or AE titles
- JSON/CSV machine field names (`kind`, `duration_ms`, `study_instance_uid`, …)
- CLI subcommand tokens that are the command grammar (`query`, `retrieve`, `--json`)
- Raw on-disk tracing log lines

Locale resolution (highest priority first): `--lang` → `DICOM_NODE_LANG` → persisted config → OS locale → `en-US`. Fallback for a missing message: requested locale → language (`pt` from `pt-BR`) → `en-US` → the message id (debug).
