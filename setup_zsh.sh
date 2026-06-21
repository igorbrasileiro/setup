#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ensure_macos
ensure_brew_in_path || {
  log_error "Homebrew is required. Run ./setup_homebrew.sh first."
  exit 1
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log_success "Oh My Zsh already installed"
    return 0
  fi

  log_info "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_zplug() {
  if [[ -f "$HOME/.zplug/init.zsh" ]]; then
    log_success "zplug already installed"
    return 0
  fi

  log_info "Installing zplug"
  curl -sSf --retry 3 --retry-delay 3 \
    https://raw.githubusercontent.com/zplug/zplug/2.4.2/installer | zsh
}

install_nerd_font() {
  if brew list --cask font-roboto-mono-nerd-font >/dev/null 2>&1; then
    log_success "Nerd font already installed"
    return 0
  fi

  log_info "Installing Roboto Mono Nerd Font"
  brew install --cask font-roboto-mono-nerd-font
}

install_dotfiles() {
  install_file "$REPO_ROOT/.zprofile" "$HOME/.zprofile"
  install_file "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
  install_file "$REPO_ROOT/.p10k.zsh" "$HOME/.p10k.zsh"
  install_file "$REPO_ROOT/.bash_aliases" "$HOME/.bash_aliases"

  if [[ ! -f "$HOME/.zshrc.local" ]] && [[ -f "$REPO_ROOT/.zshrc.local.example" ]]; then
    cp "$REPO_ROOT/.zshrc.local.example" "$HOME/.zshrc.local"
    log_warn "Created ~/.zshrc.local from example — add machine-specific secrets there"
  fi
}

main() {
  install_oh_my_zsh
  install_zplug
  install_nerd_font
  install_dotfiles
  log_success "Zsh setup complete — restart your terminal or run: source ~/.zshrc"
}

main "$@"
