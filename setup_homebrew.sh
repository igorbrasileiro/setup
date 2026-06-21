#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ensure_macos

BREW_PACKAGES=(
  git
  gh
  neovim
  ripgrep
  fd
  fzf
  nvm
  yarn
  node
)

BREW_CASKS=(
  font-roboto-mono-nerd-font
)

install_homebrew() {
  if command_exists brew || ensure_brew_in_path; then
    log_success "Homebrew already installed"
    return 0
  fi

  log_info "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ensure_brew_in_path
}

setup_brew_shellenv() {
  local zprofile="$HOME/.zprofile"
  local line='eval "$(/opt/homebrew/bin/brew shellenv)"'

  if [[ -x /usr/local/bin/brew ]] && [[ ! -x /opt/homebrew/bin/brew ]]; then
    line='eval "$(/usr/local/bin/brew shellenv)"'
  fi

  append_line_once "$line" "$zprofile"
}

install_packages() {
  log_info "Installing Homebrew formulae"
  brew update
  brew install "${BREW_PACKAGES[@]}"

  log_info "Installing Homebrew casks"
  brew install --cask "${BREW_CASKS[@]}"
}

setup_nvm() {
  local brew_nvm_dir
  brew_nvm_dir="$(brew --prefix nvm)"
  mkdir -p "$HOME/.nvm"

  # shellcheck disable=SC1091
  source "$brew_nvm_dir/nvm.sh"
  if nvm ls --no-colors | grep -q 'lts'; then
    log_success "Node LTS already installed via nvm"
  else
    nvm install --lts
    log_success "Node LTS installed via nvm"
  fi
}

main() {
  install_homebrew
  ensure_brew_in_path
  setup_brew_shellenv
  install_packages
  setup_nvm
  log_success "Homebrew setup complete"
}

main "$@"
