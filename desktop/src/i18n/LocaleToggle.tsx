import { useI18n } from "./I18nProvider";

export default function LocaleToggle() {
  const { locale, locales, setLocale, t } = useI18n();
  return (
    <label className="locale-toggle">
      <span>{t("desktop-locale-label")}</span>
      <select
        value={locale}
        aria-label={t("desktop-locale-label")}
        onChange={(event) => setLocale(event.target.value)}
      >
        {locales.map((id) => (
          <option key={id} value={id}>
            {id}
          </option>
        ))}
      </select>
    </label>
  );
}
