#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
CURSOR_SRC="$REPO_ROOT/cursor"
PROJECTS_MANIFEST="$CURSOR_SRC/projects.json"

expand_path() {
  local path="$1"
  path="${path/#\~/$HOME}"
  printf '%s' "$path"
}

install_global_settings() {
  if [[ ! -d "$CURSOR_SRC" ]]; then
    log_error "Missing cursor config directory at $CURSOR_SRC"
    exit 1
  fi

  mkdir -p "$CURSOR_USER_DIR"

  if [[ -f "$CURSOR_SRC/settings.json" ]]; then
    install_file "$CURSOR_SRC/settings.json" "$CURSOR_USER_DIR/settings.json"
  fi

  if [[ -f "$CURSOR_SRC/keybindings.json" ]]; then
    install_file "$CURSOR_SRC/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
  fi
}

install_project_file() {
  local src="$1"
  local dest="$2"

  if [[ ! -f "$src" ]]; then
    log_warn "Skipping missing snapshot: $src"
    return 0
  fi

  install_file "$src" "$dest"
}

install_project_configs() {
  if [[ ! -f "$PROJECTS_MANIFEST" ]]; then
    log_warn "No project manifest at $PROJECTS_MANIFEST"
    return 0
  fi

  if ! command_exists python3; then
    log_error "python3 is required to read $PROJECTS_MANIFEST"
    return 1
  fi

  local projects_json
  export PROJECTS_MANIFEST
  projects_json="$(python3 - <<'PY'
import json
from pathlib import Path

manifest = Path(__import__("os").environ["PROJECTS_MANIFEST"])
data = json.loads(manifest.read_text())
for project in data.get("projects", []):
    name = project["name"]
    path = project["path"]
    for rel in project.get("files", []):
        print(f"{name}\t{path}\t{rel}")
PY
)"

  while IFS=$'\t' read -r name project_path rel_file; do
    [[ -z "$name" ]] && continue

    local dest_root src_root
    dest_root="$(expand_path "$project_path")"
    src_root="$CURSOR_SRC/projects/$name"

    if [[ ! -d "$dest_root" ]]; then
      log_warn "Project not found, skipping $name: $dest_root"
      continue
    fi

    log_info "Installing Cursor project settings for $name"
    install_project_file "$src_root/$rel_file" "$dest_root/$rel_file"
  done <<<"$projects_json"
}

pull_from_live_projects() {
  if [[ ! -f "$PROJECTS_MANIFEST" ]]; then
    return 0
  fi

  local projects_json
  projects_json="$(PROJECTS_MANIFEST="$PROJECTS_MANIFEST" python3 - <<'PY'
import json
import os
from pathlib import Path

manifest = Path(os.environ["PROJECTS_MANIFEST"])
data = json.loads(manifest.read_text())
for project in data.get("projects", []):
    name = project["name"]
    source = os.path.expanduser(project.get("source", project["path"]))
    for rel in project.get("files", []):
        print(f"{name}\t{source}\t{rel}")
PY
)"

  while IFS=$'\t' read -r name source_path rel_file; do
    [[ -z "$name" ]] && continue

    local src dest
    src="$(expand_path "$source_path")/$rel_file"
    dest="$CURSOR_SRC/projects/$name/$rel_file"

    if [[ ! -f "$src" ]]; then
      log_warn "Source file missing for $name: $src"
      continue
    fi

    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    log_success "Synced $name/$rel_file into setup repo"
  done <<<"$projects_json"
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [install|sync]

  install  Install global + project Cursor settings (default)
  sync     Pull latest settings from ~/dev/talisman* into this repo, then install
EOF
}

main() {
  local mode="${1:-install}"

  if [[ "$mode" == "-h" || "$mode" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ ! -d "$HOME/Library/Application Support/Cursor" ]]; then
    log_warn "Cursor does not appear to be installed — settings will still be written"
  fi

  case "$mode" in
    sync)
      export PROJECTS_MANIFEST
      pull_from_live_projects
      install_global_settings
      install_project_configs
      ;;
    install)
      install_global_settings
      install_project_configs
      ;;
    *)
      log_error "Unknown mode: $mode"
      usage
      exit 1
      ;;
  esac

  log_success "Cursor setup complete"
  log_info "Restart Cursor to pick up global changes"
}

main "$@"
