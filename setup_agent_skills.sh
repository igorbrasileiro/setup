#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_ROOT="$SCRIPT_DIR/ai-skills"

install_skill_links() {
  local namespace="$1"
  local source_root="$SKILLS_ROOT/$namespace/skills"
  local destination_root="$HOME/.$namespace/skills"

  if [[ ! -d "$source_root" ]]; then
    printf 'Missing skills directory: %s\n' "$source_root" >&2
    return 1
  fi

  mkdir -p "$destination_root"

  while IFS= read -r -d '' source_skill; do
    local skill_name destination
    skill_name="$(basename "$source_skill")"
    destination="$destination_root/$skill_name"

    if [[ -L "$destination" && "$(readlink "$destination")" == "$source_skill" ]]; then
      printf 'Already linked: %s\n' "$destination"
    elif [[ -e "$destination" ]]; then
      printf 'Keeping existing skill: %s\n' "$destination"
    else
      ln -s "$source_skill" "$destination"
      printf 'Linked: %s\n' "$destination"
    fi
  done < <(find "$source_root" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
}

install_skill_links agents
install_skill_links codex

if [[ ! -e "$HOME/.agents/.skill-lock.json" && -f "$SKILLS_ROOT/agents/.skill-lock.json" ]]; then
  cp "$SKILLS_ROOT/agents/.skill-lock.json" "$HOME/.agents/.skill-lock.json"
  printf 'Installed skill lockfile: %s\n' "$HOME/.agents/.skill-lock.json"
fi
