# 04 — Sync setup repo + docs

## Goal

Mirror the live Neovim AI / LSP fixes from briefs 01–03 into `~/dev/setup`, and update README + verify so a fresh machine can reproduce the stack.

## Depends on

- **01**, **02**, and **03** completed on the live machine (`~/.config/nvim` is the source of truth for Lua changes; CLI/scripts may already live in the setup repo from brief 02).

## Context

- Setup repo: `/Users/igor.brasileiro/dev/setup`
- Live nvim: `/Users/igor.brasileiro/.config/nvim`
- `setup_nvim.sh` copies or links (`LINK_MODE=link`) `nvim/` → `~/.config/nvim`
- Secrets must stay out of git: `mcphub/servers.json`, `~/.zshrc.local`, API keys

As of discovery, live and repo nvim trees were mostly in sync except `lazy-lock.json` and any new files from 01–03 (`lua/config/ai.lua`, avante/lsp/treesitter edits).

## Constraints

- Do **not** invent new AI features beyond documenting/syncing what 01–03 implemented.
- Do **not** commit `mcphub/servers.json`, `.zshrc.local`, or auth tokens.
- Prefer documenting `LINK_MODE=link ./setup_nvim.sh` for future live edits.
- Keep README accurate and concise; match existing README tone.

## Files to touch

| File / path | Change |
|-------------|--------|
| `/Users/igor.brasileiro/dev/setup/nvim/**` | Mirror changed/new files from `~/.config/nvim` |
| `/Users/igor.brasileiro/dev/setup/nvim/lazy-lock.json` | Update if Lazy lock changed after plugin dep removals |
| `/Users/igor.brasileiro/dev/setup/README.md` | Document AI keymaps, Cursor Agent CLI, login, LINK_MODE, stabilize notes |
| `/Users/igor.brasileiro/dev/setup/verify_setup.sh` | Ensure checks for nvim config + `agent` (from 02) remain correct |
| `/Users/igor.brasileiro/dev/setup/docs/nvim-ai/README.md` | Optional: mark briefs as implemented / link back from main README |

Do **not** copy:

- `~/.config/mcphub/servers.json` into git (example file only)
- Plugin state under `~/.local/share/nvim`

## Concrete steps

### 1. Diff live vs repo

```bash
diff -rq ~/.config/nvim /Users/igor.brasileiro/dev/setup/nvim
```

Copy/update every intentional config difference (Lua plugins, `init.lua`, `lazy-lock.json`, new `config/ai.lua`).

Suggested approach:

```bash
# review first, then sync specific files — avoid blindly wiping repo-only files
rsync -av --delete \
  --exclude '.git' \
  ~/.config/nvim/ /Users/igor.brasileiro/dev/setup/nvim/
```

Only use `--delete` if you are sure the live tree is complete and intentional.

### 2. README updates

Add or extend a **Neovim AI** subsection covering:

1. Avante (OpenRouter) for quick edits — API keys in `~/.zshrc.local`
2. Cursor Agent via ACP — requires `agent` CLI + `agent login` (brief 02 / setup script)
3. Keymaps:

   | Key | Action |
   |-----|--------|
   | `<leader>aa` | Avante toggle |
   | `<leader>ac` | Cursor Agent (ACP) |
   | `<leader>ao` | Switch to OpenRouter |
   | `<leader>am` | MCPHub |

4. `LINK_MODE=link ./setup_nvim.sh` for symlink workflow
5. Pointer to `docs/nvim-ai/` for the migration briefs

### 3. Verify script

Confirm `verify_setup.sh` checks at least:

- Neovim config present (`~/.config/nvim/init.lua`)
- Cursor Agent CLI (`command -v agent`) — added in brief 02

Optionally add a soft check that `lua/config/ai.lua` exists in the linked/copied config (nice-to-have, not required).

### 4. Security pass

```bash
cd /Users/igor.brasileiro/dev/setup
./scripts/check-secrets.sh
git status
```

Ensure no credential files are staged. Do **not** commit unless the human asks.

### 5. Sanity

From the setup repo README instructions, a reader should understand:

- How to install nvim config
- How to install/login Cursor Agent CLI
- How to use the AI keymaps
- Where secrets live

## Acceptance criteria

- [ ] `diff -rq ~/.config/nvim ~/dev/setup/nvim` shows no unexpected config drift (ignore trivial noise only if documented).
- [ ] `~/dev/setup/nvim/lua/config/ai.lua` exists if live has it; avante/lsp/treesitter changes are mirrored.
- [ ] README documents AI keymaps, Cursor CLI + login, and LINK_MODE.
- [ ] `verify_setup.sh` still passes (or fails only on unrelated pre-existing issues); `agent` check present.
- [ ] `./scripts/check-secrets.sh` clean; no secrets staged.
- [ ] No new AI behavior beyond sync/docs.

## Out of scope

- Implementing Claude / shared MCP ([LATER.md](./LATER.md))
- Creating a git commit / PR unless the human explicitly requests it
- Re-running full machine bootstrap
