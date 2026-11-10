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
