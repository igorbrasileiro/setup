#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

usage() {
  cat <<EOF
Usage: $(basename "$0") [all|homebrew|zsh|nvim|ssh|git|cursor|cursor-cli|skills]

Bootstrap a macOS development environment from this repository.

Examples:
  ./setup_mac.sh           # full setup
  ./setup_mac.sh zsh       # only zsh/plugins/dotfiles
  ./setup_mac.sh nvim      # only neovim
EOF
}

run_target() {
  case "$1" in
    homebrew) run_script "$REPO_ROOT/setup_homebrew.sh" ;;
    zsh)      run_script "$REPO_ROOT/setup_zsh.sh" ;;
    nvim)     run_script "$REPO_ROOT/setup_nvim.sh" ;;
    ssh)      run_script "$REPO_ROOT/setup_ssh.sh" ;;
    git)      run_script "$REPO_ROOT/setup_git.sh" ;;
    cursor)      run_script "$REPO_ROOT/setup_cursor.sh" ;;
    cursor-cli)  run_script "$REPO_ROOT/setup_cursor_cli.sh" ;;
    skills)      run_script "$REPO_ROOT/setup_agent_skills.sh" ;;
    *)
      log_error "Unknown target: $1"
      usage
      exit 1
      ;;
  esac
}

main() {
  ensure_macos

  local target="${1:-all}"

  if [[ "$target" == "-h" || "$target" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ "$target" == "all" ]]; then
  run_script "$REPO_ROOT/setup_homebrew.sh"
  run_script "$REPO_ROOT/setup_zsh.sh"
  run_script "$REPO_ROOT/setup_ssh.sh"
  run_script "$REPO_ROOT/setup_git.sh"
  run_script "$REPO_ROOT/setup_nvim.sh"
  run_script "$REPO_ROOT/setup_cursor.sh"
  run_script "$REPO_ROOT/setup_cursor_cli.sh"
  run_script "$REPO_ROOT/setup_agent_skills.sh"
  else
    run_target "$target"
  fi

  log_success "Setup finished"
  log_info "Run ./verify_setup.sh to validate your environment"
  if [[ -d "$REPO_ROOT/.git" ]]; then
    run_script "$REPO_ROOT/scripts/install-git-hooks.sh"
  fi
}

main "$@"
