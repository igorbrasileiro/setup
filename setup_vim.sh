#!/usr/bin/env bash
# Deprecated: legacy vim/coc setup. Use ./setup_nvim.sh instead.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

log_warn "setup_vim.sh is deprecated — running setup_nvim.sh instead"
exec "$SCRIPT_DIR/setup_nvim.sh" "$@"
