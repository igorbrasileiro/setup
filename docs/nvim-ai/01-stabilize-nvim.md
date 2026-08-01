# 01 — Stabilize Neovim init

## Goal

Eliminate known Neovim startup / LSP errors so Avante and the later Cursor ACP work sit on a clean base.

## Depends on

None.

## Context

Live config: `~/.config/nvim` (Lazy.nvim). Setup mirror: `~/dev/setup/nvim`.

Observed issues (2026-08-01):

| Symptom | Cause |
|---------|--------|
| `invalid "oxlint" config` / `oxc_language_server is not executable` | Installed `nvim-lspconfig` still uses `cmd = { "oxc_language_server" }`, but Mason’s `oxlint` package only ships `oxlint` (modern entrypoint: `oxlint --lsp`) |
| `[Copilot.lua] Copilot auth file could not be read` | Avante lists `zbirenbaum/copilot.lua` as a dependency even though the default provider is OpenRouter |
| `Native input provider doesn't support concealed input` | Avante password prompts use the native input provider; `dressing.nvim` is already a dependency |
| Fragile TS LSP setup | Custom `ts_go` registration plus an early `return` when `tsgo` is missing can short-circuit the rest of LSP config logic |
| `<leader>a` / `<leader>A` claimed | Treesitter textobject **swap** uses these keys; brief 03 needs `<leader>a` as the AI namespace |

Mason already installs `oxlint`, `tsgo`, `biome`, etc. under `~/.local/share/nvim/mason/bin/` (injected into Neovim PATH by mason.nvim).

## Constraints

- Do **not** install Cursor Agent CLI or wire ACP (briefs 02 / 03).
- Do **not** add CodeCompanion, agentic.nvim, or Claude.
- Do **not** commit secrets or rewrite MCP server credentials.
- Prefer minimal diffs; match existing Lua style in the config.
- Edit **live** `~/.config/nvim` first. Optionally mirror the same files into `~/dev/setup/nvim` in this brief, or leave mirroring to brief 04 — either is fine if acceptance passes on live config.
- Keep Avante + MCPHub working with OpenRouter.

## Files to touch

| File | Change |
|------|--------|
| `/Users/igor.brasileiro/.config/nvim/lua/plugins/lsp.lua` | Oxlint cmd override; clean tsgo; nil-guard biome; no aborting early return |
| `/Users/igor.brasileiro/.config/nvim/lua/plugins/avante.lua` | Remove Copilot dep; set dressing input; optional pcall around MCPHub hooks |
| `/Users/igor.brasileiro/.config/nvim/lua/plugins/treesitter.lua` | Move swap keys off `<leader>a` / `<leader>A` |
| Optional: same paths under `/Users/igor.brasileiro/dev/setup/nvim/` | Keep repo in sync if you mirror now |

## Concrete steps

### 1. Fix oxlint LSP command

In `lsp.lua`, when mason-lspconfig sets up `oxlint`, override the command so it does not look for `oxc_language_server`:

```lua
-- inside mason-lspconfig handlers, special-case oxlint:
["oxlint"] = function()
  require("lspconfig").oxlint.setup({
    capabilities = capabilities,
    settings = servers.oxlint or {},
    cmd = { "oxlint", "--lsp" },
  })
end,
```

Keep a default handler for other servers. Ensure Mason has already run so `oxlint` is on Neovim’s PATH.

### 2. Clean TypeScript / tsgo setup

- Keep `tsgo = {}` in the `servers` / `ensure_installed` table so Mason installs it.
- **Remove** the custom `configs.ts_go` / `lspconfig.ts_go` block and the early `return` when `tsgo` is missing.
- Let mason-lspconfig’s default handler set up `tsgo` like other servers.
- If you need a missing-binary warning, notify without aborting the rest of the config function.

### 3. Nil-guard biome BufWritePre

Where biome format-on-save is attached on `LspAttach`, guard:

```lua
local client = vim.lsp.get_client_by_id(event.data.client_id)
if client and client.name == "biome" then
  -- existing BufWritePre fixAll logic
end
```

### 4. Quiet Avante startup

In `avante.lua`:

1. Remove `"zbirenbaum/copilot.lua"` from `dependencies` (you are not using `providers = "copilot"`).
2. Add input provider (dressing is already a dependency):

```lua
input = {
  provider = "dressing",
},
```

3. Harden MCPHub integration so Avante still loads if MCPHub is unavailable:

```lua
system_prompt = function()
  local ok, hub = pcall(function()
    return require("mcphub").get_hub_instance()
  end)
  if ok and hub then
    return hub:get_active_servers_prompt()
  end
  return ""
end,

custom_tools = function()
  local ok, mcphub_ext = pcall(require, "mcphub.extensions.avante")
  if ok then
    return { mcphub_ext.mcp_tool() }
  end
  return {}
end,
```

Do **not** add Cursor `acp_providers` here (brief 03).

### 5. Free `<leader>a` for AI keymaps

In `treesitter.lua` textobjects `swap`:

```lua
swap_next = {
  ["<leader>xa"] = "@parameter.inner",
},
swap_previous = {
  ["<leader>xA"] = "@parameter.inner",
},
```

### 6. Verify

Run the acceptance commands below. Fix any remaining related errors before claiming done.

## Acceptance criteria

- [ ] Headless Neovim starts without Copilot auth errors and without the Native input / dressing warning:

```bash
nvim --headless "+lua vim.defer_fn(function() vim.cmd('qa!') end, 2500)" 2>&1 | rg -i 'copilot|native input|oxc_language_server|invalid \"oxlint\"' || true
# expect: no matches
```

- [ ] Opening a TS/JS buffer does not log `oxc_language_server is not executable` / invalid oxlint config (check `~/.local/state/nvim/lsp.log` after a fresh open, or `:LspInfo` interactively).
- [ ] Avante still loads (`:Lazy` shows avante.nvim; toggling Avante still works).
- [ ] Treesitter swap no longer binds `<leader>a` / `<leader>A` (those keys are free for brief 03).
- [ ] No Cursor CLI / ACP / new AI plugins introduced.

## Out of scope

- Installing `agent` / `agent login`
- Avante `acp_providers`
- AI which-key namespace (`<leader>aa`, etc.)
- Claude Code
- Full `~/dev/setup` README / verify updates (brief 04), unless you only mirror the three Lua files you changed
