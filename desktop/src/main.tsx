import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import { I18nProvider } from "./i18n";
import {
  applyDocumentLocale,
  availableLocales,
  bundleFor,
  detectLocale,
  FALLBACK_LOCALE,
  formatMessage,
} from "./i18n/catalogs";
import "./styles.css";

const startupLocales = availableLocales();
const startupLocale = detectLocale(startupLocales);
const startupBundles =
  startupLocale === FALLBACK_LOCALE
    ? [bundleFor(startupLocale)]
    : [bundleFor(startupLocale), bundleFor(FALLBACK_LOCALE)];
applyDocumentLocale(
  startupLocale,
  formatMessage(startupBundles, "desktop-doc-title"),
);

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <I18nProvider>
      <App />
    </I18nProvider>
  </React.StrictMode>,
);
