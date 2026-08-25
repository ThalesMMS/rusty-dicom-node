import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { defineConfig, type Plugin } from "vite";
import react from "@vitejs/plugin-react";

const desktopDir = path.dirname(fileURLToPath(import.meta.url));
const repoI18nDir = path.resolve(desktopDir, "../i18n");

/** Inlines repo `i18n/*.ftl` so desktop and CLI/TUI share one catalog tree. */
function repoFluentCatalogs(): Plugin {
  const virtualId = "virtual:i18n-catalogs";

  const loadCatalogs = (): Record<string, string> => {
    if (!fs.existsSync(repoI18nDir)) return {};
    const catalogs: Record<string, string> = {};
    for (const name of fs.readdirSync(repoI18nDir)) {
      if (!name.endsWith(".ftl")) continue;
      const locale = name.slice(0, -4);
      catalogs[locale] = fs.readFileSync(path.join(repoI18nDir, name), "utf8");
    }
    return catalogs;
  };

  return {
    name: "repo-fluent-catalogs",
    resolveId(id) {
      if (id === virtualId) return id;
      return undefined;
    },
    load(id) {
      if (id !== virtualId) return undefined;
      return `export const catalogs = ${JSON.stringify(loadCatalogs())};`;
    },
    configureServer(server) {
      if (!fs.existsSync(repoI18nDir)) return;
      server.watcher.add(repoI18nDir);
      server.watcher.on("change", (file) => {
        if (file.startsWith(repoI18nDir) && file.endsWith(".ftl")) {
          const mod = server.moduleGraph.getModuleById(virtualId);
          if (mod) void server.reloadModule(mod);
        }
      });
    },
  };
}

export default defineConfig({
  plugins: [react(), repoFluentCatalogs()],
  clearScreen: false,
  server: {
    port: 1420,
    strictPort: true,
    fs: {
      allow: [desktopDir, path.resolve(desktopDir, "..")],
    },
  },
  envPrefix: ["VITE_", "TAURI_"],
  build: {
    target: "es2021",
    sourcemap: !!process.env.TAURI_DEBUG,
  },
});
