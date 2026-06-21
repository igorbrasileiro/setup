#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
CURSOR_SRC="$REPO_ROOT/cursor"

install_cursor_settings() {
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

main() {
  if [[ ! -d "$HOME/Library/Application Support/Cursor" ]]; then
    log_warn "Cursor does not appear to be installed — settings were still written for when you install it"
  fi

  install_cursor_settings
  log_success "Cursor settings installed"
  log_info "Restart Cursor to pick up changes"
}

main "$@"
