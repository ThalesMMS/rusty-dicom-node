/// <reference types="vite/client" />

declare module "*.ftl?raw" {
  const source: string;
  export default source;
}

declare module "virtual:i18n-catalogs" {
  export const catalogs: Record<string, string>;
}
