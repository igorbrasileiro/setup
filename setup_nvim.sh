#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

NVIM_DEST="$HOME/.config/nvim"
NVIM_SRC="$REPO_ROOT/nvim"
LINK_MODE="${LINK_MODE:-copy}"

ensure_macos
ensure_brew_in_path || {
  log_error "Homebrew is required. Run ./setup_homebrew.sh first."
  exit 1
}

install_dependencies() {
  local packages=(neovim ripgrep fd fzf)
  for pkg in "${packages[@]}"; do
    if brew list "$pkg" >/dev/null 2>&1; then
      log_success "$pkg already installed"
    else
      brew install "$pkg"
    fi
  done

  if ! brew list --cask font-roboto-mono-nerd-font >/dev/null 2>&1; then
    brew install --cask font-roboto-mono-nerd-font
  fi
}

install_mcphub_config() {
  local example="$REPO_ROOT/mcphub/servers.json.example"
  local local_repo_config="$REPO_ROOT/mcphub/servers.json"
  local user_config="$HOME/.config/mcphub/servers.json"

  if [[ ! -f "$example" ]]; then
    return 0
  fi

  mkdir -p "$HOME/.config/mcphub"

  if [[ ! -f "$local_repo_config" ]]; then
    cp "$example" "$local_repo_config"
    log_success "Created local MCP config at $local_repo_config (gitignored)"
  fi

  if [[ ! -f "$user_config" ]]; then
    cp "$example" "$user_config"
    log_success "Created MCP config at $user_config"
  fi
}

install_config() {
  if [[ ! -d "$NVIM_SRC" ]]; then
    log_error "Neovim config not found at $NVIM_SRC"
    exit 1
  fi

  mkdir -p "$HOME/.config"

  if [[ -e "$NVIM_DEST" ]]; then
    if [[ "$LINK_MODE" == "link" ]]; then
      if [[ -L "$NVIM_DEST" ]] && [[ "$(readlink "$NVIM_DEST")" == "$NVIM_SRC" ]]; then
        log_success "Neovim config already linked"
        return 0
      fi
      backup_file "$NVIM_DEST"
      rm -rf "$NVIM_DEST"
      ln -sfn "$NVIM_SRC" "$NVIM_DEST"
      log_success "Linked $NVIM_DEST -> $NVIM_SRC"
      return 0
    fi

    backup_file "$NVIM_DEST"
    rm -rf "$NVIM_DEST"
  fi

  cp -R "$NVIM_SRC" "$NVIM_DEST"
  log_success "Copied Neovim config to $NVIM_DEST"
}

main() {
  install_dependencies
  install_config
  install_mcphub_config
  log_success "Neovim setup complete — run: nvim"
  log_info "Inside Neovim, run :Lazy sync and :checkhealth"
}

main "$@"
