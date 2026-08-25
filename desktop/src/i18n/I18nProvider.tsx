import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import type { FluentBundle } from "@fluent/bundle";
import {
  applyDocumentLocale,
  availableLocales,
  bundleFor,
  detectLocale,
  FALLBACK_LOCALE,
  formatMessage,
  persistLocale,
  resolveLocale,
  type Translate,
} from "./catalogs";

interface I18nValue {
  locale: string;
  locales: string[];
  t: Translate;
  setLocale: (next: string) => void;
}

const I18nContext = createContext<I18nValue | null>(null);

function bundlesFor(locale: string): FluentBundle[] {
  const primary = bundleFor(locale);
  if (locale === FALLBACK_LOCALE) return [primary];
  return [primary, bundleFor(FALLBACK_LOCALE)];
}

export function I18nProvider({ children }: { children: ReactNode }) {
  const locales = useMemo(() => availableLocales(), []);
  const [locale, setLocaleState] = useState(() => detectLocale(locales));

  const bundles = useMemo(() => bundlesFor(locale), [locale]);

  const t = useCallback<Translate>(
    (id, args) => formatMessage(bundles, id, args),
    [bundles],
  );

  const setLocale = useCallback(
    (next: string) => {
      const resolved = resolveLocale(next, locales) ?? FALLBACK_LOCALE;
      persistLocale(resolved);
      setLocaleState(resolved);
    },
    [locales],
  );

  useEffect(() => {
    applyDocumentLocale(locale, t("desktop-doc-title"));
  }, [locale, t]);

  const value = useMemo<I18nValue>(
    () => ({ locale, locales, t, setLocale }),
    [locale, locales, t, setLocale],
  );

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}

export function useI18n(): I18nValue {
  const ctx = useContext(I18nContext);
  if (!ctx) throw new Error("useI18n must be used within I18nProvider");
  return ctx;
}

export type { Translate } from "./catalogs";
