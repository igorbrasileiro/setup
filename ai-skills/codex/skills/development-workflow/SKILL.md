---
name: development-workflow
description: Guide feature implementation and bug fixes using Igor's personal development workflow. Use when implementing features, fixing bugs or regressions, or changing UI behavior.
---

# Development workflow

Apply the relevant workflow below alongside the user's instructions and the current repository's rules. For mixed feature and bug work, apply both. Scale the analysis and validation to the change; continue to implementation without waiting for approval unless required.

## Features

1. Understand the goal, current code, constraints, and existing conventions. Explore plausible approaches and expand the idea where useful: identify important use cases, edge cases, tradeoffs, and consequences. Explain a recommendation concisely when a meaningful choice exists; avoid inventing requirements or expanding scope without authorization.
2. Read and apply the personal `ub-mode` skill. Its instructions are subject to higher-priority instructions, the user's authorization, and repository rules; in particular, do not infer permission to commit, push, delete worktrees, delegate, or run destructive tools. Report unavailable tools and any resulting validation gaps.
3. In the prompt or plan, suggest relevant design improvements grounded in the task: cohesive single responsibilities, separation of concerns, clear boundaries and APIs, appropriate design patterns, and readable, maintainable code. Explain tradeoffs and avoid speculative abstractions, unnecessary patterns, and unsolicited scope. Implement the suitable choices within the authorized scope.
4. Implement and validate observable behavior using the project's conventions. If the change affects UI, exercise the affected flows in a running application using the Chrome DevTools MCP, including relevant interactions and visible states. Use existing project instructions for starting the app and test data. If the MCP or application cannot be used, report the concrete blocker and any alternative verification; do not claim browser testing occurred.

## Bug fixes

Read and apply the personal `bug-fix-regression-test` skill. It is a portable copy of the skill from `~/dev/talisman-web/docs/ai/skills/bug-fix-regression-test`; when working in that repository, prefer its current project copy. Apply its general regression workflow across projects and its framework-specific guidance only where relevant. If the skill is unavailable, report that and follow its core workflow: reproduce when practical, add a focused behavioral regression test, verify it fails before the fix when practical, fix the cause, and report verification and limitations.

UI bug fixes also require the browser validation described above.
