#!/usr/bin/env bash
# Pull Cursor settings from ~/dev/talisman-web and ~/dev/talisman into this repo.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/../setup_cursor.sh" sync
