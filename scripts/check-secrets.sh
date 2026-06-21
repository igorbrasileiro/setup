#!/usr/bin/env bash
# Scan the repository for accidentally committed secrets.
# Run before commits: ./scripts/check-secrets.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Files/directories to skip
SKIP_PATHS=(
  '.git'
  'scripts/check-secrets.sh'
  '.zshrc.local.example'
  'mcphub/servers.json.example'
  'README.md'
)

# High-confidence secret patterns
PATTERNS=(
  'sk-proj-[A-Za-z0-9_-]{10,}'
  'sk-or-v1-[a-f0-9]{10,}'
  'gsk_[A-Za-z0-9]{10,}'
  'xox[baprs]-[A-Za-z0-9-]{10,}'
  'github_pat_[A-Za-z0-9_]{10,}'
  'ghp_[A-Za-z0-9]{20,}'
  'gho_[A-Za-z0-9]{20,}'
  'AKIA[0-9A-Z]{16}'
  '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
)

should_skip() {
  local file="$1"
  for skip in "${SKIP_PATHS[@]}"; do
    if [[ "$file" == "$skip" || "$file" == *"/$skip" || "$file" == "$skip"* ]]; then
      return 0
    fi
  done
  return 1
}

FOUND=0

while IFS= read -r -d '' file; do
  rel="${file#"$REPO_ROOT"/}"

  if should_skip "$rel"; then
    continue
  fi

  # Skip binary files
  if file "$file" | grep -q 'binary'; then
    continue
  fi

  for pattern in "${PATTERNS[@]}"; do
    if grep -qE "$pattern" "$file" 2>/dev/null; then
      echo -e "${RED}SECRET DETECTED${NC} in $rel (pattern: $pattern)"
      grep -nE "$pattern" "$file" | head -3
      FOUND=$((FOUND + 1))
    fi
  done
done < <(find "$REPO_ROOT" -type f -print0)

# Block suspicious api-key assignments (real values, not placeholders)
while IFS= read -r -d '' file; do
  rel="${file#"$REPO_ROOT"/}"
  should_skip "$rel" && continue
  file "$file" | grep -q 'binary' && continue

  if grep -qE '(api[_-]?key|token|secret|password)\s*[:=]\s*["\x27][^"\x27<]{20,}["\x27]' "$file" 2>/dev/null; then
    if ! grep -qE '(api[_-]?key|token|secret|password)\s*[:=]\s*["\x27](<[^>]+>|your-key|changeme|example|_?[A-Z_]+_KEY)["\x27]' "$file" 2>/dev/null; then
      echo -e "${RED}SUSPICIOUS CREDENTIAL${NC} in $rel"
      grep -nE '(api[_-]?key|token|secret|password)\s*[:=]' "$file" | head -3
      FOUND=$((FOUND + 1))
    fi
  fi
done < <(find "$REPO_ROOT" -type f \( -name '*.json' -o -name '*.lua' -o -name '*.sh' -o -name '*.zsh' -o -name '.zshrc' -o -name '*.env*' \) -print0)

if [[ "$FOUND" -gt 0 ]]; then
  echo
  echo -e "${RED}Found $FOUND potential secret(s). Remove them before committing.${NC}"
  echo "Store secrets in ~/.zshrc.local (gitignored) or a local .env file."
  exit 1
fi

echo -e "${GREEN}No secrets detected.${NC}"
exit 0
