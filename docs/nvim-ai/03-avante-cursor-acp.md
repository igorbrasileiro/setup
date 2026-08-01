# 03 — Avante Cursor ACP + AI keymaps

## Goal

Connect Neovim’s Avante to the authenticated Cursor Agent CLI over ACP, and expose a clear `<leader>a*` AI keymap namespace (Avante / Cursor / OpenRouter / MCPHub).

## Depends on

- **01** — Stabilize Neovim (treesitter must have freed `<leader>a`; Copilot dep removed; dressing input set).
- **02** — Cursor Agent CLI installed, on PATH, and `agent login` completed.

## Context

Architecture:

```text
Neovim → Avante.nvim → acp_providers.cursor → `agent acp` → Cursor account / quota
                 ↘ OpenRouter (default provider) for quick edits
                 ↘ MCPHub for Avante tools only
```

Official Cursor Neovim snippet pattern (docs: https://cursor.com/docs/cli/acp):

- `command` = `agent` (or absolute path under `~/.local/bin/agent`)
- `args` = `{ "acp" }`
- `auth_method` = `"cursor_login"`
- Pass through `HOME` and `PATH` in `env`

Current Avante config lives at:

- `/Users/igor.brasileiro/.config/nvim/lua/plugins/avante.lua`

which-key is already installed via `/Users/igor.brasileiro/.config/nvim/lua/plugins/ui.lua`.

Leader is `<Space>` (`vim.g.mapleader` in `lua/config/options.lua`).

## Constraints

- Keep **OpenRouter** as the default `provider` for quick interactive work.
- Use **only** official Cursor CLI ACP — no unofficial proxies.
- Keep MCPHub integration for Avante; do not turn MCPHub into a universal gateway for Cursor.
- Do not install Claude Code or a second ACP UI (CodeCompanion / agentic.nvim).
- Do not commit secrets.
- Prefer resolving `agent` via PATH; absolute path fallback is OK if documented.

## Files to touch

| File | Change |
|------|--------|
| `/Users/igor.brasileiro/.config/nvim/lua/plugins/avante.lua` | Add `acp_providers.cursor`; keep OpenRouter default; keep hardened MCPHub hooks from 01 |
| `/Users/igor.brasileiro/.config/nvim/lua/config/ai.lua` (**create**) | AI keymaps + which-key group |
| `/Users/igor.brasileiro/.config/nvim/init.lua` | `require('config.ai')` after other config modules |
| Optional: `/Users/igor.brasileiro/.config/nvim/lua/config/keymaps.lua` | Only if you prefer not to add `config/ai.lua` — still keep keys centralized |

Mirror into `~/dev/setup/nvim` either here or in brief 04.

## Concrete steps

### 1. Add Cursor ACP provider to Avante

In `avante.lua` `opts`:

```lua
provider = "openrouter", -- keep default for quick edits

acp_providers = {
  cursor = {
    command = "agent",
    args = { "acp" },
    auth_method = "cursor_login",
    env = {
      HOME = os.getenv("HOME"),
      PATH = os.getenv("PATH"),
    },
  },
},
```

If `agent` is not found via PATH when Neovim is launched from a GUI, set:

```lua
command = vim.fn.expand("~/.local/bin/agent"),
```

(or whatever path `command -v agent` returns).

Ensure `input.provider = "dressing"` and Copilot dep stay removed (from brief 01).

### 2. Create AI keymap module

Create `lua/config/ai.lua` with roughly:

| Key | Action |
|-----|--------|
| `<leader>aa` | Toggle / focus Avante chat (default OpenRouter workflow) |
| `<leader>ac` | Switch Avante to Cursor ACP provider and open/focus chat |
| `<leader>ao` | Switch Avante provider back to OpenRouter |
| `<leader>am` | Open MCPHub UI (`:MCPHub` or plugin API) |

Implementation notes:

- Use Avante’s public API for provider switching if available (e.g. commands / `require("avante")` helpers). If the API differs by Avante version, inspect `:help avante` / plugin Lua and use the supported switch + toggle.
- Prefer named functions, not anonymous inline soup.
- Register which-key descriptions, e.g. group `<leader>a` → `AI`, and each leaf key with a clear `desc`.

Example shape (adapt to actual Avante APIs):

```lua
local function avante_toggle()
  require("avante.api").toggle()
end

local function use_cursor()
  -- switch provider to cursor ACP, then toggle/open
end

local function use_openrouter()
  -- switch provider to openrouter
end

vim.keymap.set("n", "<leader>aa", avante_toggle, { desc = "AI: Avante toggle" })
vim.keymap.set("n", "<leader>ac", use_cursor, { desc = "AI: Cursor Agent (ACP)" })
vim.keymap.set("n", "<leader>ao", use_openrouter, { desc = "AI: OpenRouter provider" })
vim.keymap.set("n", "<leader>am", "<cmd>MCPHub<cr>", { desc = "AI: MCPHub" })
```

If which-key v3+ needs explicit `add` / spec registration, follow the version already locked in `lazy-lock.json`.

### 3. Load the module

In `init.lua`, after existing config requires:

```lua
require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.ai')
```

### 4. Manual smoke test

1. Open a project in Neovim from a terminal where `agent` works.
2. `<leader>aa` — Avante opens; OpenRouter still responds for a small ask (if API keys present).
3. `<leader>ac` — switches to Cursor ACP; agent can see the repo and propose/edit (uses Cursor quota).
4. `<leader>ao` — back to OpenRouter.
5. `<leader>am` — MCPHub opens.
6. which-key: press `<leader>a` and confirm the AI group labels appear.

## Acceptance criteria

- [ ] `acp_providers.cursor` is configured; default `provider` remains `openrouter`.
- [ ] `<leader>aa`, `<leader>ac`, `<leader>ao`, `<leader>am` work as specified.
- [ ] which-key shows an `AI` group under `<leader>a`.
- [ ] Cursor ACP session works for a real prompt against the current repo (file context / edit) after `agent login`.
- [ ] MCPHub still works for Avante; no new second AI plugin added.
- [ ] No secrets committed; no unofficial Cursor API code.

## Out of scope

- Claude Code ACP / terminal integration ([LATER.md](./LATER.md))
- Shared MCP servers.json across Cursor/Claude/MCPHub
- Full setup-repo README polish beyond optional short notes (brief 04 owns sync + docs)
- Replacing Avante with CodeCompanion or agentic.nvim
