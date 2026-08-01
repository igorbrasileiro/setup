# 02 — Install Cursor Agent CLI

## Goal

Install and authenticate the official Cursor Agent CLI so Neovim can later speak ACP via `agent acp`, using the user’s Cursor account / Enterprise quota.

## Depends on

- Brief **01** is recommended first (clean Neovim), but not strictly required for CLI install.
- Brief **03** must wait until this brief’s acceptance criteria pass (including auth).

## Context

- Cursor **IDE** is installed (`/usr/local/bin/cursor` or similar).
- Cursor **Agent CLI** (`agent`) was **not** on PATH as of 2026-08-01.
- Official ACP docs: https://cursor.com/docs/cli/acp
- ACP entrypoint (conceptually): `agent acp` (JSON-RPC over stdio).
- Auth: `agent login` (or env-based tokens if Cursor documents them — prefer login).

Setup repo already has:

- `/Users/igor.brasileiro/dev/setup/setup_cursor.sh` — IDE settings/keybindings sync
- `/Users/igor.brasileiro/dev/setup/verify_setup.sh` — environment checks
- `/Users/igor.brasileiro/dev/setup/setup_nvim.sh` — Neovim config install
- `/Users/igor.brasileiro/dev/setup/README.md` — user docs

## Constraints

- Use **only** the official Cursor CLI installer and auth. **Do not** reverse-engineer or proxy Cursor internal APIs.
- Do **not** wire Avante ACP or AI keymaps (brief 03).
- Do **not** commit API keys, auth tokens, or cookies.
- Auth (`agent login`) is **interactive** — the agent must pause and instruct the human; do not fake auth.
- Keep changes idempotent (safe to re-run setup scripts).

## Files to touch

| File | Change |
|------|--------|
| Prefer new `/Users/igor.brasileiro/dev/setup/setup_cursor_cli.sh` **or** extend `/Users/igor.brasileiro/dev/setup/setup_cursor.sh` | Idempotent install of Cursor Agent CLI |
| `/Users/igor.brasileiro/dev/setup/setup_mac.sh` | Wire the new/extended step if other setup scripts are orchestrated there |
| `/Users/igor.brasileiro/dev/setup/verify_setup.sh` | Check `command -v agent` |
| `/Users/igor.brasileiro/dev/setup/README.md` | Document install + `agent login` + PATH |
| `/Users/igor.brasileiro/dev/setup/.zshrc.local.example` and/or shell docs | Ensure `~/.local/bin` (or install dir) is on PATH |
| Live machine | Run installer; human runs `agent login` |

## Concrete steps

### 1. Install Cursor Agent CLI

Use the official installer (verify current URL against Cursor docs if it changed):

```bash
curl https://cursor.com/install -fsS | bash
```

Confirm the binary location (often `~/.local/bin/agent`). Ensure that directory is on PATH for interactive shells and for Neovim (Neovim inherits the shell PATH when launched from a terminal).

If PATH is missing `~/.local/bin`, document adding it in `~/.zshrc.local` (gitignored) and/or `.zshrc.local.example`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 2. Add an idempotent setup script

Either:

**Option A (preferred):** create `setup_cursor_cli.sh` that:

1. Sources `lib/common.sh`
2. Installs/updates the CLI if `agent` is missing or outdated
3. Prints a clear reminder: “Run `agent login` once to authenticate”
4. Does **not** attempt non-interactive auth

**Option B:** extend `setup_cursor.sh` with a clearly named function `install_cursor_agent_cli`.

Wire the script into `setup_mac.sh` if that orchestrator lists cursor/nvim steps.

### 3. Human authentication

Instruct the user to run:

```bash
agent login
```

Wait for confirmation that login succeeded (user message or `agent` status command if documented).

Do not store credentials in the setup repo.

### 4. Smoke-test ACP process

Verify the ACP server starts (it speaks stdio; a short run / help check is enough):

```bash
command -v agent
agent --help   # or equivalent
# Optional: timeout 2 agent acp </dev/null || true
# Expect: process starts without “command not found” / auth hard-fail if already logged in
```

Exact flags may vary by CLI version — prefer what `agent --help` shows.

### 5. Update verify + README

- `verify_setup.sh`: `check "Cursor Agent CLI" 'command -v agent >/dev/null'`
- README: short section under Cursor or Neovim AI:

  - Install via setup script / curl installer
  - `agent login` required once
  - Used by Neovim Avante ACP in brief 03
  - Link: https://cursor.com/docs/cli/acp

## Acceptance criteria

- [ ] `command -v agent` succeeds in a normal login shell.
- [ ] User has completed `agent login` (human step confirmed).
- [ ] Setup script exists and is idempotent (re-run does not break IDE cursor setup).
- [ ] `verify_setup.sh` reports Cursor Agent CLI present when `agent` is installed.
- [ ] README documents install + login; no secrets committed.
- [ ] No Avante `acp_providers` or AI keymaps added in this brief.

## Out of scope

- Avante ACP wiring (brief 03)
- Mirroring nvim Lua changes (brief 04), except README/verify/setup script edits belonging here
- Claude Code install
- MCP standardization
