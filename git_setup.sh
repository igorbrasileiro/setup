#!/usr/bin/env bash
# Deprecated: use setup_git.sh instead.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/setup_git.sh" "$@"
