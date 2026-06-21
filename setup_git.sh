#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

GIT_NAME="${GIT_NAME:-igorbrasileiro}"
GIT_EMAIL="${GIT_EMAIL:-brasileiro456@gmail.com}"
ALLOWED_SIGNERS="$HOME/.ssh/allowed_signers"

configure_git_identity() {
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global core.editor nvim
  git config --global init.defaultBranch main
  log_success "Configured git identity"
}

configure_git_aliases() {
  git config --global alias.l1 'log --oneline'
  git config --global alias.sw 'switch'
  git config --global alias.lg "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
  log_success "Configured git aliases"
}

configure_commit_signing() {
  if [[ ! -f "$ALLOWED_SIGNERS" ]]; then
    log_warn "Missing $ALLOWED_SIGNERS — run ./setup_ssh.sh first for signed commits"
    return 0
  fi

  git config --global gpg.format ssh
  git config --global commit.gpgsign true
  git config --global user.signingkey "$HOME/.ssh/id_ed25519.pub"
  git config --global gpg.ssh.allowedSignersFile "$ALLOWED_SIGNERS"
  log_success "Configured SSH commit signing"
}

install_helpers() {
  install_file "$REPO_ROOT/.bash_aliases" "$HOME/.bash_aliases"
  install_file "$REPO_ROOT/git-prune-local.sh" "$HOME/bin/git-prune-local.sh"
  chmod +x "$HOME/bin/git-prune-local.sh"
}

main() {
  mkdir -p "$HOME/bin"
  configure_git_identity
  configure_git_aliases
  configure_commit_signing
  install_helpers
  log_success "Git setup complete"
}

main "$@"
