#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

CURSOR_CLI_INSTALL_URL="https://cursor.com/install"
CURSOR_CLI_BIN_DIR="${HOME}/.local/bin"
CURSOR_CLI_BIN="${CURSOR_CLI_BIN_DIR}/agent"

ensure_cursor_cli_on_path() {
  case ":$PATH:" in
    *":${CURSOR_CLI_BIN_DIR}:"*) return 0 ;;
  esac

  export PATH="${CURSOR_CLI_BIN_DIR}:$PATH"
}

install_cursor_agent_cli() {
  ensure_cursor_cli_on_path

  if command_exists agent; then
    log_success "Cursor Agent CLI already installed: $(command -v agent)"
    return 0
  fi

  if [[ -x "$CURSOR_CLI_BIN" ]]; then
    log_success "Cursor Agent CLI already installed: $CURSOR_CLI_BIN"
    return 0
  fi

  log_info "Installing Cursor Agent CLI from $CURSOR_CLI_INSTALL_URL"
  mkdir -p "$CURSOR_CLI_BIN_DIR"
  curl "$CURSOR_CLI_INSTALL_URL" -fsS | bash
  ensure_cursor_cli_on_path

  if command_exists agent; then
    log_success "Cursor Agent CLI installed: $(command -v agent)"
    return 0
  fi

  if [[ -x "$CURSOR_CLI_BIN" ]]; then
    log_success "Cursor Agent CLI installed: $CURSOR_CLI_BIN"
    return 0
  fi

  log_error "Cursor Agent CLI install finished but 'agent' was not found on PATH"
  log_info "Ensure ${CURSOR_CLI_BIN_DIR} is on PATH (see .zshrc.local.example)"
  return 1
}

usage() {
  cat <<EOF
Usage: $(basename "$0")

Install or update the official Cursor Agent CLI (agent).
Safe to re-run — skips install when the binary is already present.

After install, authenticate once (interactive):
  agent login

ACP docs: https://cursor.com/docs/cli/acp
EOF
}

main() {
  ensure_macos

  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ -n "${1:-}" ]]; then
    log_error "Unknown argument: $1"
    usage
    exit 1
  fi

  install_cursor_agent_cli

  echo
  log_warn "Human step required: run 'agent login' once to authenticate with your Cursor account"
  log_info "Neovim ACP wiring is handled in a separate brief — do not skip login if you plan to use agent acp"
}

main "$@"
