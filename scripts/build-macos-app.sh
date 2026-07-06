#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESKTOP_DIR="$ROOT_DIR/desktop"
BUNDLE_DIR="$DESKTOP_DIR/src-tauri/target/release/bundle/macos"
EXPECTED_APP="$BUNDLE_DIR/DICOM Node.app"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "error: this script builds a macOS .app bundle and must run on macOS" >&2
  exit 1
fi

command -v npm >/dev/null 2>&1 || {
  echo "error: npm is required but was not found on PATH" >&2
  exit 1
}

command -v cargo >/dev/null 2>&1 || {
  echo "error: cargo is required but was not found on PATH" >&2
  exit 1
}

cd "$DESKTOP_DIR"

if [[ ! -d node_modules ]]; then
  echo "Installing desktop npm dependencies..."
  npm ci
fi

echo "Building DICOM Node.app..."
npm run tauri build -- --bundles app

app_path="$EXPECTED_APP"
if [[ ! -d "$app_path" ]]; then
  app_path="$(find "$BUNDLE_DIR" -maxdepth 1 -type d -name '*.app' -print -quit)"
fi

if [[ -z "${app_path:-}" || ! -d "$app_path" ]]; then
  echo "error: build completed but no .app bundle was found in $BUNDLE_DIR" >&2
  exit 1
fi

echo "Built app bundle:"
echo "$app_path"
