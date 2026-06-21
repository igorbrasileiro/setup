#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_ed25519"
SSH_CONFIG_SRC="$REPO_ROOT/ssh/config"
SSH_CONFIG_DEST="$SSH_DIR/config"
ALLOWED_SIGNERS="$SSH_DIR/allowed_signers"

ensure_macos

ensure_ssh_dir() {
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
}

generate_key() {
  if [[ -f "$KEY_FILE" ]]; then
    log_success "SSH key already exists at $KEY_FILE"
    return 0
  fi

  local email
  email="$(git config --global user.email 2>/dev/null || true)"
  if [[ -z "$email" ]]; then
    email="${GIT_EMAIL:-brasileiro456@gmail.com}"
  fi

  log_info "Generating ed25519 SSH key for $email"
  ssh-keygen -t ed25519 -C "$email" -f "$KEY_FILE" -N ""
  log_success "SSH key generated"
}

install_ssh_config() {
  if [[ ! -f "$SSH_CONFIG_SRC" ]]; then
    log_warn "Missing $SSH_CONFIG_SRC — skipping SSH config install"
    return 0
  fi

  if [[ -f "$SSH_CONFIG_DEST" ]] && cmp -s "$SSH_CONFIG_SRC" "$SSH_CONFIG_DEST"; then
    log_success "SSH config already up to date"
    return 0
  fi

  backup_file "$SSH_CONFIG_DEST"
  cp "$SSH_CONFIG_SRC" "$SSH_CONFIG_DEST"
  chmod 600 "$SSH_CONFIG_DEST"
  log_success "Installed SSH config"
}

add_key_to_agent() {
  if [[ ! -f "$KEY_FILE" ]]; then
    return 0
  fi

  eval "$(ssh-agent -s)" >/dev/null
  ssh-add --apple-use-keychain "$KEY_FILE" 2>/dev/null || ssh-add "$KEY_FILE"
  log_success "Added SSH key to agent"
}

setup_commit_signing() {
  local email pubkey
  email="$(git config --global user.email 2>/dev/null || echo "brasileiro456@gmail.com")"
  pubkey="$(cat "${KEY_FILE}.pub" 2>/dev/null || true)"

  if [[ -z "$pubkey" ]]; then
    log_warn "No public key found — skipping commit signing setup"
    return 0
  fi

  printf '%s %s\n' "$email" "$pubkey" >"$ALLOWED_SIGNERS"
  chmod 644 "$ALLOWED_SIGNERS"
  log_success "Updated $ALLOWED_SIGNERS"
}

print_next_steps() {
  if command_exists gh; then
    log_info "Authenticate GitHub CLI (if needed): gh auth login"
    log_info "Upload SSH key to GitHub: gh ssh-key add $KEY_FILE.pub -t \"$(hostname)-$(date +%Y-%m-%d)\""
  else
    log_info "Add this public key to GitHub → Settings → SSH and GPG keys:"
    cat "${KEY_FILE}.pub"
  fi

  log_info "Test GitHub SSH: ssh -T git@github.com"
}

main() {
  ensure_ssh_dir
  generate_key
  install_ssh_config
  add_key_to_agent
  setup_commit_signing
  print_next_steps
  log_success "SSH setup complete"
}

main "$@"
