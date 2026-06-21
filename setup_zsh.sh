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
  if [[ -d "$HOME/.zplug/.git" ]]; then
    git -C "$HOME/.zplug" pull --ff-only
  else
    rm -rf "$HOME/.zplug"
    git clone --depth 1 https://github.com/zplug/zplug "$HOME/.zplug"
  fi

  if [[ ! -f "$HOME/.zplug/init.zsh" ]]; then
    log_error "zplug installation failed (missing ~/.zplug/init.zsh)"
    exit 1
  fi

  log_success "zplug installed"
}

install_nerd_font() {
  if brew list --cask font-roboto-mono-nerd-font >/dev/null 2>&1; then
    log_success "Nerd font already installed"
    return 0
  fi

  log_info "Installing Roboto Mono Nerd Font"
  brew install --cask font-roboto-mono-nerd-font
}

install_powerlevel10k() {
  log_info "Ensuring powerlevel10k is installed"
  if zsh -lc 'source "$HOME/.zplug/init.zsh"; zplug "romkatv/powerlevel10k", as:theme, depth:1; zplug check "romkatv/powerlevel10k"' >/dev/null 2>&1; then
    log_success "powerlevel10k already installed"
    return 0
  fi

  zsh -lc 'source "$HOME/.zplug/init.zsh"; zplug "romkatv/powerlevel10k", as:theme, depth:1; zplug install "romkatv/powerlevel10k"'
  log_success "powerlevel10k installed"
}

install_p10k_config() {
  if [[ -f "$HOME/.p10k.zsh" ]]; then
    log_success "~/.p10k.zsh already installed"
    return 0
  fi

  if [[ -f "$HOME/p10k.zsh" ]]; then
    install_file "$HOME/p10k.zsh" "$HOME/.p10k.zsh"
    log_success "Copied ~/p10k.zsh to ~/.p10k.zsh"
    return 0
  fi

  install_file "$REPO_ROOT/.p10k.zsh" "$HOME/.p10k.zsh"
}

install_dotfiles() {
  install_file "$REPO_ROOT/.zprofile" "$HOME/.zprofile"
  install_file "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
  install_file "$REPO_ROOT/.bash_aliases" "$HOME/.bash_aliases"

  if [[ ! -f "$HOME/.zshrc.local" ]] && [[ -f "$REPO_ROOT/.zshrc.local.example" ]]; then
    cp "$REPO_ROOT/.zshrc.local.example" "$HOME/.zshrc.local"
    log_warn "Created ~/.zshrc.local from example — add machine-specific secrets there"
  fi
}

main() {
  install_oh_my_zsh
  install_zplug
  install_powerlevel10k
  install_nerd_font
  install_p10k_config
  install_dotfiles
  log_success "Zsh setup complete — restart your terminal or run: source ~/.zshrc"
}

main "$@"
