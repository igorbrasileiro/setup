#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

PASS=0
FAIL=0

check() {
  local name="$1"
  shift

  if eval "$@"; then
    log_success "$name"
    PASS=$((PASS + 1))
  else
    log_error "$name"
    FAIL=$((FAIL + 1))
  fi
}

main() {
  log_info "Verifying development environment"

  check "macOS" '[[ "$(uname -s)" == "Darwin" ]]'
  check "Homebrew" 'command -v brew >/dev/null'
  check "Git" 'command -v git >/dev/null'
  check "GitHub CLI" 'command -v gh >/dev/null'
  check "Neovim" 'command -v nvim >/dev/null'
  check "ripgrep" 'command -v rg >/dev/null'
  check "fd" 'command -v fd >/dev/null'
  check "fzf" 'command -v fzf >/dev/null'
  check "Oh My Zsh" '[[ -d "$HOME/.oh-my-zsh" ]]'
  check "zplug" '[[ -f "$HOME/.zplug/init.zsh" ]]'
  check "~/.zshrc" '[[ -f "$HOME/.zshrc" ]]'
  check "p10k config" '[[ -f "$HOME/.p10k.zsh" || -f "$HOME/p10k.zsh" ]]'
  check "Neovim config" '[[ -f "$HOME/.config/nvim/init.lua" ]]'
  check "SSH key" '[[ -f "$HOME/.ssh/id_ed25519" ]]'
  check "SSH config" '[[ -f "$HOME/.ssh/config" ]]'
  check "Git user.name" 'git config --global user.name >/dev/null'
  check "Git user.email" 'git config --global user.email >/dev/null'
  check "Cursor settings" '[[ -f "$HOME/Library/Application Support/Cursor/User/settings.json" ]]'

  if command_exists ssh; then
    local ssh_output
    ssh_output="$(ssh -o BatchMode=yes -o ConnectTimeout=5 -T git@github.com 2>&1 || true)"
    if echo "$ssh_output" | grep -qi "successfully authenticated"; then
      log_success "GitHub SSH authentication"
      PASS=$((PASS + 1))
    else
      log_error "GitHub SSH authentication"
      FAIL=$((FAIL + 1))
    fi
  fi

  echo
  log_info "Results: $PASS passed, $FAIL failed"

  if [[ "$FAIL" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
