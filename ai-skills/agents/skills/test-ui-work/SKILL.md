---
name: test-ui-work
description: Test implemented UI changes in a running web app. Use whenever the user asks to test, verify, validate, or review UI behavior, visual changes, accessibility, or responsive behavior. Always use the Chrome DevTools MCP for browser inspection and interaction, and delegate browser testing to the lightweight UI tester subagent.
---

# Test UI work

Verify the actual running interface with Chrome DevTools MCP after a UI change. Do not treat source inspection or a successful build as evidence that the UI works in the browser.

## Workflow

1. Identify the changed UI, its route, the intended behavior, and the app's local development instructions. Read the relevant `AGENTS.md` and any nested instructions.
2. Start or reuse the project's development server as needed. Use existing scripts and honor the repository's instructions. Do not invent test credentials or bypass authentication.
3. Delegate the browser verification to the `ui-tester` subagent defined in `agents/ui-tester.md`. Use model `gpt-6.1-luna` with `reasoning_effort: low` (or the closest currently available Luna model at the lowest reasoning setting if that exact model is unavailable).
4. The subagent must use the Chrome DevTools MCP for every browser-based inspection and interaction. Do not substitute another browser automation tool or a browser UI skill. If Chrome DevTools MCP is unavailable, report that blocker and do not claim browser verification.
5. Give the subagent the route, expected behavior, changed areas, relevant acceptance criteria, and any available test account or setup instructions. Ask it to test the rendered UI, not to edit files.
6. Review the subagent's evidence. If it finds a reproducible issue, fix it in the main task and ask the same subagent to verify the fix.
7. Report what was checked, viewport sizes and interaction paths exercised, console or accessibility findings, and any limits caused by unavailable routes, data, or credentials. Distinguish observed results from assumptions.

## Browser checks

Use Chrome DevTools MCP throughout:

- Call `list_pages` to find the running app, or `new_page` to open its URL. Use the requested/project URL rather than guessing a production URL.
- Use `take_snapshot` first to inspect the accessibility tree and available controls. Use `take_screenshot` when visual layout, clipping, spacing, or responsive appearance needs evidence.
- Exercise the primary interaction path, including keyboard navigation when controls or forms changed. Check loading, empty, error, and success states when reachable and relevant.
- Inspect at a desktop viewport and at a narrow viewport when the change could affect responsive behavior. Use `resize_page` or `emulate` as appropriate.
- Check `list_console_messages` for errors after exercising the changed UI. Inspect network requests only when they help explain a visible failure.
- Use `get_css_styles` or `evaluate_script` only to investigate a concrete visual or DOM issue. Prefer user-visible evidence over implementation detail.
- Run a Lighthouse accessibility audit when it adds useful coverage; interpret its findings in the context of the changed UI.

Do not claim a check passed unless the subagent observed it in Chrome DevTools. Avoid broad performance audits for small visual changes unless the user asks or the change affects runtime performance.

## Report format

Return a concise report with:

- **Result:** verified, issues found, or blocked.
- **Coverage:** route, viewport(s), and user interactions checked.
- **Findings:** reproducible issues with steps and observed evidence; say “none” when clear.
- **Limits:** any relevant state or scenario that could not be reached.
