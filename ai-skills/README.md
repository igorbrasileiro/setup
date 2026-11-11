# Portable agent skills

This directory is a snapshot of personal skills installed on the source machine.
It excludes Codex's `.system` skills, which are managed by Codex itself.

- `agents/skills/` mirrors `~/.agents/skills/` and includes its skill lockfile.
- `codex/skills/` contains personal skills from `~/.codex/skills/`.
- `test-ui-work/` is the Talisman UI testing skill and its `ui-tester` subagent.

The setup repository receives the same layout under `ai-skills/`. Its
`setup_agent_skills.sh` installer creates links for skills that are not already
installed. Existing same-named skills are left alone and reported, so install
does not silently replace local versions.

`development-workflow` orchestrates feature and bug-fix work using `ub-mode`,
Chrome DevTools MCP for UI validation, and `bug-fix-regression-test`. The latter
is a portable snapshot from `talisman-web/docs/ai/skills/bug-fix-regression-test`;
update it when the upstream workflow changes. UI validation requires a configured
Chrome DevTools MCP and a runnable application; the skill installer does not
install or configure the MCP. The `ub-mode` tools have their own prerequisites.
