#!/usr/bin/env bash
# Install git hooks for this repository.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

if [[ ! -d "$REPO_ROOT/.git" ]]; then
  echo "Not a git repository: $REPO_ROOT"
  exit 1
fi

mkdir -p "$HOOKS_DIR"

cat >"$HOOKS_DIR/pre-commit" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(git rev-parse --show-toplevel)"
"$REPO_ROOT/scripts/check-secrets.sh"
EOF

chmod +x "$HOOKS_DIR/pre-commit" "$REPO_ROOT/scripts/check-secrets.sh"
echo "Installed pre-commit hook → runs scripts/check-secrets.sh"
