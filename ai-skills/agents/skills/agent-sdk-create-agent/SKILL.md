---
name: agent-sdk-create-agent
description: >-
  Scaffold a new Agent SDK agent: short AskQuestion interview, then verify a
  turn and hand off to hillclimb. Use to build or create a new bot or agent with
  the agent-sdk, the Agent SDK, `@grok/agent-sdk`, or BDK. Ask only what the
  invoking message left open.
environments:
  - cloud
  - local
---
# Create an Agent SDK agent

1. **Sign in.** `npx --yes "@grok/agent-sdk@0.6.0" whoami`. Run `npx --yes "@grok/agent-sdk@0.6.0" login` only
   when it reports no credential.
2. **Interview.** Two `AskQuestion` rounds, then a plan gate.
3. **Scaffold.** `npx --yes "@grok/agent-sdk@0.6.0" init`, then shape the files.
4. **Verify.** `validate` / `info` / `tool call`, then a model turn.
5. **Channels.** Slack, GitHub, webhook, or schedule as chosen.
6. **Report.** What it does, how to test it, how to deploy it.
7. **Hillclimb.** `~/.cursor/skills-cursor/agent-sdk-hillclimb/SKILL.md`.

Read `~/.cursor/skills-cursor/agent-sdk-framework-map/SKILL.md` if you have not. CLI is
`agent-sdk`. Public docs:
`https://cursor.com/docs/bdk`.

If a linked skill is not available, read its docs page instead:

- `agent-sdk-framework-map`: https://cursor.com/docs/agent-sdk/reference/project-layout
- `agent-sdk-hillclimb`: https://cursor.com/docs/agent-sdk/hillclimbing
- `agent-sdk-evals`: https://cursor.com/docs/agent-sdk/evals
- `agent-sdk-setup-slack`: https://cursor.com/docs/agent-sdk/guides/slack
- `agent-sdk-github`: https://cursor.com/docs/agent-sdk/guides/github

## Interview

`AskQuestion`: batched, recommended option first and labeled
`(recommended)`.

- Mine the invoking message. Target: two rounds, then files.
- Round 1 is identity. Round 2 is the surface, tailored by round 1.
- Multi-select for channels, MCP, capabilities. Other where a
  custom answer is plausible.
- Ask decisions, not how to build it. File layout, tool names,
  env prefix, and eval shape are yours.
- If `AskQuestion` is missing or the user skips, state defaults
  in one list and proceed.

<!-- interview:start (generated from the npx --yes "@grok/agent-sdk@0.6.0" init questions; do not edit by hand) -->
### Round 1: identity

| Question | Options | Guidance |
| --- | --- | --- |
| **Purpose** | chat assistant · PR / repo automation · domain assistant over APIs/tools · scheduled reporter · Other |  |
| **Name** | 2–3 slugs from the purpose + Other | Directory: `[A-Za-z0-9][A-Za-z0-9_-]*`, not `v1`/`playground`/`docs` |
| **Location** | `./<slug>` (default) · another directory |  |

### Round 2: surface

| Question | Options | Guidance |
| --- | --- | --- |
| **Model** | `grok-4.7` + `reasoning_effort=high`, `fast=true` · Other id | Params, not id suffixes: `{ id: "grok-4.7", params: [{ id: "reasoning_effort", value: "high" }, { id: "fast", value: "true" }] }` |
| **Channels** (multi) | playground + HTTP (always on) · Slack · GitHub · custom webhook · schedule | Slack: `~/.cursor/skills-cursor/agent-sdk-setup-slack/SKILL.md`. GitHub: `~/.cursor/skills-cursor/agent-sdk-github/SKILL.md`. No Discord/Teams pack; offer custom webhook. |
| **MCP** (multi) | none · remote URL · local stdio · Codex account connectors · Other | One file under `bot/mcp-connections/`. Account file is `account.ts`, never `cursor.ts`. Named local tools need `advertiseTools: true`. Privileged servers go in `bot/host-connections/`. |
| **Capabilities** (multi) | server tools · agent tools · skills · subagents · hooks · sandbox seeds · evals (recommend) | Always recommend one smoke eval. |
<!-- interview:end -->

Location: inside a git checkout, recommend a new folder outside
it. `init` runs `npm install`, which breaks a pnpm or yarn
workspace.

Close with the plan and file tree, then "Scaffold it" / "Adjust
something". Write files only after approval.

## Fill the blanks

| Purpose | Shape |
| --- | --- |
| Slack chat | `slackChannel({ envPrefix })` + suggested prompts. `npx --yes "@grok/agent-sdk@0.6.0" slack create` mints the bot. Prefix: `~/.cursor/skills-cursor/agent-sdk-setup-slack/SKILL.md` |
| PR review with host prep | Channel `callTool` into a trimmed workspace `pr/` tree |
| GitHub automation | `githubChannel()` hooks, replay fixtures |
| Domain assistant | Server tools + one MCP connection + a skill |
| Wrap an existing pipeline | GitHub `{ task }` over a thin `bot/lib/` loop |

Defaults:

- Instructions + 1–2 tools + chosen channels + one smoke eval.
- `local.cwd` stays outside a monorepo checkout (default: a cache
  directory under `~/.cache`) unless the agent must inherit that
  tree.
- `bot/instructions.md`: identity, when to use which tool,
  output shape.
- One tool per file. Prefer `execution: "server"` + zod
  `inputSchema`. Declare `effect: "read"`, `"write"`, or `"idempotent"`
  on each tool. `"idempotent"` may mutate, and the same arguments have
  no additional effect. It is not a read and it is not non-destructive.
- Long prompts: `prompt\`…\`` / `prompt.lines\`…\`` from
  `@grok/agent-sdk`.
- Host prep is for evidence (`callTool`, `workspaceFiles`), not
  judgment, formatting, or replies.
- Remembered state is `ctx.host.kv`. On Codex hosting, a later
  event can run in a new process, where a module `Map` starts empty.
  File bytes that must outlive the process go in `ctx.host.files`.
  See `~/.cursor/skills-cursor/agent-sdk-framework-map/SKILL.md`.

### Deterministic-path budget

Default to instructions and skills. Promote to TypeScript only
when it earns the left column:

| Code owns | Model owns |
| --- | --- |
| Side-effect gates (approve, deploy, post) | Human-facing output to a stated shape |
| Dedupe of external writes (`ctx.host.kv`) | Summarizing, classifying, wording |
| Auth and signature checks | What to do next from ground truth |
| Evidence seeding | Soft-failure retries |
| Hard API caps | Formatting under those caps |

Smells: prose builders in `.ts` (write `.md`); `bot/lib/` +
`tools/` dwarfing instructions + skills on a first cut.

## Scaffold

```bash
npx --yes "@grok/agent-sdk@0.6.0" init ./<slug>
```

`init` writes the project, runs `npm install`, and may wait on
`login`. Then shape it:

1. `defineAgent` with the chosen model.
2. Real `instructions.md`. Replace `echo.ts`.
3. Chosen `channels/`, `mcp-connections/`, `skills/`,
   `subagents/<id>/` (needs `description`), `schedules/`, `hooks/`.
   Slack: `npx --yes "@grok/agent-sdk@0.6.0" slack create --dir ./<slug> --name "<Name>"`,
   not a hand-written channel. Manual Slack app:
   `npx --yes "@grok/agent-sdk@0.6.0" slack init --manual` (Slack CLI, or paste at
   api.slack.com).
4. Blank init writes `evals/evals.config.ts` (`maxConcurrency: 20`,
   cap 200) and `evals/smoke.eval.ts`. The smoke case uses `echo`
   and asserts `t.succeeded()` and `t.calledTool("echo")`. Replace
   that case when you replace the tool. API: `~/.cursor/skills-cursor/agent-sdk-evals/SKILL.md`.

Stay on deps the Agent SDK already ships (`zod`,
`@modelcontextprotocol/sdk`, `tsx`).

## Verify

```bash
npx --yes "@grok/agent-sdk@0.6.0" validate --dir ./<slug>
npx --yes "@grok/agent-sdk@0.6.0" info --dir ./<slug> --json
npx --yes "@grok/agent-sdk@0.6.0" tool call <tool> --dir ./<slug> --input '{…}'
npx --yes "@grok/agent-sdk@0.6.0" eval --dir ./<slug> --list
npx tsc --noEmit -p ./<slug>
```

tsx does not typecheck. Tool `execute` must return JSON-shaped
values: object literals or `type` aliases, not `interface` types.

Model turns need a Codex credential (`CURSOR_API_KEY`, then `CURSOR_API_KEY_FILE`, then `CURSOR_SERVICE_ACCOUNT_KEY`, then `npx --yes "@grok/agent-sdk@0.6.0" login`). Without one, finish the
key-free checks, confirm `run` fails with only the API-key error,
and hand these over:

```bash
npx --yes "@grok/agent-sdk@0.6.0" run --dir ./<slug> --message "<fixture prompt>"
npx --yes "@grok/agent-sdk@0.6.0" serve --dir ./<slug> --mode single --dev
# http://127.0.0.1:3000/playground
npx --yes "@grok/agent-sdk@0.6.0" eval --dir ./<slug>
```

Serve only this agent's directory. Session files land in the
project state directory (`--state-root`). That is not harness cwd.

Finish gate. Before the report, these pass. Fix each error first:

```bash
npx --yes "@grok/agent-sdk@0.6.0" validate --dir ./<slug>
npx tsc --noEmit -p ./<slug>
npx --yes "@grok/agent-sdk@0.6.0" run --dir ./<slug> --message "<realistic first message>"
```

Show the reply word for word. Without a credential, `run` may fail
with only the API-key error. Then write the report anyway, and put
the hand-over commands above in "Test it locally".

## Channel setup

- **Slack.** `~/.cursor/skills-cursor/agent-sdk-setup-slack/SKILL.md`
- **GitHub.** `~/.cursor/skills-cursor/agent-sdk-github/SKILL.md`
- **Custom webhook.** `POST /v1/channels/<id>/<route>`.
  Loopback-only until you add `bearerAuth(...)`. Hosted callers
  get an empty `202` before the handler runs, so return
  `new Response(null, { status: 202 })` and deliver results from
  the channel's `events`.
- **Schedules.** Never auto-fire under `--dev`.
  `POST /v1/dev/schedules/<id>`.

## Report

End with this report. Write it in ASD-STE100 Simplified Technical
English: short sentences, active voice, one instruction per step.
Fill in the real slug, env prefix, and commands.

```markdown
## What the agent does

- 3 to 5 short bullets.

## Test it locally

Commands for `npx --yes "@grok/agent-sdk@0.6.0" dev ./<slug>` (playground URL) and
`npx --yes "@grok/agent-sdk@0.6.0" eval --dir ./<slug>`, and what the person sees.

## Deploy it

1. If the project is not in a git repository, create one and
   add a remote.
2. Commit the project and push it to a branch.
3. Slack only: run `npx --yes "@grok/agent-sdk@0.6.0" slack create --dir ./<slug> --env prod`.
4. Run `npx --yes "@grok/agent-sdk@0.6.0" validate --dir ./<slug>`, then
   `npx --yes "@grok/agent-sdk@0.6.0" deploy --dir ./<slug> --dry-run`.
5. Run `npx --yes "@grok/agent-sdk@0.6.0" deploy --dir ./<slug>` in your own terminal.
   The first deploy prints an alias token one time. Save it in
   a password manager.
6. Run `npx --yes "@grok/agent-sdk@0.6.0" session create --slug <slug> --message "<test>" --wait`.
7. Manage the agent at https://cursor.com/dashboard/deployed-agents.
```

Do not deploy, push, or create the prod Slack app unless the
person asks. Hand the first deploy to the person, so the alias
token stays out of your transcript.

## Hillclimb handoff

Once a smoke turn passes, agree fixtures, success criteria, and a
freeze line, then follow `~/.cursor/skills-cursor/agent-sdk-hillclimb/SKILL.md`. Seed from
the smoke session under the project state directory. GitHub:
snapshot `npx --yes "@grok/agent-sdk@0.6.0" github replay ... --dry-run --fixtures-dir fixtures/github`.

Do not deploy or post to real Slack/GitHub beyond the smoke the
user asked for. If the plan grows past ~10 files, cut scope.
Re-check the budget at hand-off.
