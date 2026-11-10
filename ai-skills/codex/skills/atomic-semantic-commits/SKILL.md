---
name: atomic-semantic-commits
description: Organize Igor's authorized commits into small English semantic commits and plan PR splits within his size limits. Use when committing work, preparing a PR, or discussing how to split changes for review.
---

# Atomic semantic commits

## Personal preference

Igor prefers small, semantic commits. Each commit must do one thing and be easy to review or revert independently. Size follows responsibility, not a fixed line limit.

Always write commit messages in English, including the subject and body. Use Conventional Commits with a concrete description:

- `refactor(preview): extract authentication into a service`
- `fix(admin): wait for readiness before authenticating the iframe`
- `feat(editor): add data previews`
- `test(preview): cover message validation`
- `docs(preview): document the iframe handshake`

## Workflow

1. Inspect the branch, staged changes, working tree, and relevant commit history. Identify which edits belong to the requested work; preserve unrelated or pre-existing edits.
2. Group changes by purpose. Separate unrelated fixes, features, refactors, and formatting. Include regression tests with the fix they protect. Keep coupled cross-package changes together when separating them would break the contract.
3. Order commits so dependencies are introduced before callers. Every intermediate commit must work using its committed source, installed dependencies, and required generated artifacts. Verify relevant type checks and tests on isolated committed snapshots; checking only the final working tree does not validate earlier commits. Do not rely on later commits or uncommitted changes. State any verification limitation accurately. Use selective staging when one file contains several responsibilities; do not manufacture empty or cosmetic commits to increase the count.
4. Inspect the staged diff before every commit. Stage explicit paths or hunks, never all files indiscriminately. Run the repository's commit hooks normally; investigate failures instead of bypassing them.
5. Commit only when the user has authorized committing. Follow the repository's validation rules and report checks accurately. This skill does not independently authorize extra tests, amending existing commits, rebasing, pushing, or publishing.
6. Report the created hashes and purposes concisely, and mention relevant work that remains uncommitted.

## Pull request size

- Aim for at most **500 added lines and 500 removed lines per PR**.
- The maximum is **800 added lines and 800 removed lines per PR**, measured independently. Do not subtract removals from additions or use the net line count.
- Measure the actual diff against the PR's base branch, including tests, documentation, and generated files shown in that diff. For a stack, measure each PR against its own immediate base.
- Check size when planning the work and again before preparing or publishing a PR. Proactively tell Igor when the diff exceeds the ideal size, propose concrete coherent splits, and ask for his preference when the split has meaningful tradeoffs.
- If either maximum would be exceeded, prepare a reviewable split plan and ask Igor to choose the split or explicitly authorize an exception before publishing an oversized PR. A large task or commit authorization does not imply an exception.
- Split by responsibility and dependency order. Each PR must work on top of its declared base without needing a later PR. Keep the regression coverage with its fix. Do not split solely by an arbitrary number of files or move tests elsewhere to hide size.
- Suggest a stack of PRs when changes depend on one another. Planning a split does not authorize creating, pushing, or rewriting branches and PRs by itself.

## Scope of this preference

Keep this skill in Igor's personal agent setup. Do not add or modify repository skills, AGENTS.md, hooks, or project configuration to record this preference unless he explicitly asks for a repository change.
