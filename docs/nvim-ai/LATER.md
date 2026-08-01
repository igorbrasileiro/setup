# LATER — Deferred Neovim AI work

Out of scope for briefs 01–04. Use these stubs when spawning future agents.

## L1 — Claude Code agent backend

**Goal:** Add Claude Code as a second autonomous agent from Neovim (ACP if stable; otherwise terminal fallback).

**Ideas:**

- Prefer ACP bridge if still required (e.g. `@agentclientprotocol/claude-agent-acp`) — verify current package name and Claude Code release notes.
- Fallback: Neovim terminal / toggle term running `claude`.
- Keymap candidate: `<leader>ah` (Claude / “h” for Anthropic) without breaking `<leader>aa` / `<leader>ac`.
- Keep Cursor and Claude as **independent** backends; do not merge accounts or quotas.

**Acceptance sketch:**

- Launch Claude from Neovim
- Claude can read/edit the project and run tests
- Avante + Cursor ACP remain unchanged

**Depends on:** 01–04 complete; Claude Code installed and authenticated separately.

---

## L2 — Standardize MCP configuration

**Goal:** Reduce duplicated MCP server definitions across MCPHub, Cursor, and Claude without forcing a broken “one file fits all” assumption.

**Ideas:**

- Inventory current servers in `~/.config/mcphub/servers.json` (local) and project `.cursor/mcp.json` files.
- Document Global vs Project MCP scope.
- Propose a source of truth under setup or project `ai/mcp/` **only after** validating format compatibility.
- Credentials stay in env / keychain / gitignored local files.

**Acceptance sketch:**

- No credentials committed
- Avante/MCPHub still works
- Cursor Agent can use required MCPs via its native config
- Duplication minimized and documented

**Depends on:** Cursor ACP path working (briefs 02–03); optional Claude (L1).

---

## L3 — ACP UX polish

**Goal:** Improve long-running agent sessions after real usage.

**Candidates:**

- Better provider picker UI
- Diff review UX for ACP edits
- Diagnostics / selection context tuning
- Agent status indicators

**Depends on:** Real-world use of brief 03 for at least a few days.

---

## Do not do later without an explicit brief

- Unofficial Cursor API proxies
- Replacing Avante wholesale without a migration brief
- Committing MCP secrets into `~/dev/setup`
