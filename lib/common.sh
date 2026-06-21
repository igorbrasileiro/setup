#!/usr/bin/env bash
# Shared helpers for setup scripts.

set -euo pipefail

NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log_info()    { echo -e "${BLUE}==>${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warn()    { echo -e "${YELLOW}!${NC} $*"; }
log_error()   { echo -e "${RED}✗${NC} $*" >&2; }

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

ensure_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    log_error "This setup is intended for macOS."
    exit 1
  fi
}

brew_prefix() {
  if command_exists brew; then
    brew --prefix
    return 0
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    echo /opt/homebrew
    return 0
  fi

  if [[ -x /usr/local/bin/brew ]]; then
    echo /usr/local
    return 0
  fi

  return 1
}

ensure_brew_in_path() {
  local prefix
  if prefix="$(brew_prefix 2>/dev/null)"; then
    eval "$("$prefix/bin/brew" shellenv)"
    return 0
  fi

  return 1
}

backup_file() {
  local file="$1"
  if [[ -e "$file" ]]; then
    local backup="${file}.bak.$(date +%Y%m%d%H%M%S)"
    cp -p "$file" "$backup"
    log_warn "Backed up $file to $backup"
  fi
}

install_file() {
  local src="$1"
  local dest="$2"

  if [[ ! -f "$src" ]]; then
    log_error "Missing source file: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]] && cmp -s "$src" "$dest"; then
    log_success "$dest is already up to date"
    return 0
  fi

  backup_file "$dest"
  cp "$src" "$dest"
  log_success "Installed $dest"
}

append_line_once() {
  local line="$1"
  local file="$2"

  mkdir -p "$(dirname "$file")"
  touch "$file"

  if grep -Fqx "$line" "$file" 2>/dev/null; then
    log_success "Already present in $file: $line"
    return 0
  fi

  printf '%s\n' "$line" >>"$file"
  log_success "Appended to $file: $line"
}

run_script() {
  local script="$1"
  shift

  if [[ ! -x "$script" ]]; then
    chmod +x "$script"
  fi

  log_info "Running $(basename "$script")"
  "$script" "$@"
}
