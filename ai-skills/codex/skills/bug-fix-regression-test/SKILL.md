---
name: bug-fix-regression-test
description: Use whenever the user asks to fix a bug, regression, incorrect behavior, slow test, or a defect raised in a PR review. For every such fix, add or update a focused automated regression test that captures the faulty behavior and guards against its return. Follow its deterministic time guidance when writing tests involving dates, polling, retries, debounce, or userEvent. It does not require new tests for review-only requests or unrelated feature work.
---

# Bug Fix Regression Test

When correcting a reported defect, leave behind an automated check that would have caught it. This makes the fix verifiable and helps prevent the same behavior from returning.

## Workflow

1. **Understand the failure.** Read the relevant implementation and existing tests. Identify the input or situation that triggers the defect and the observable behavior that should happen instead. Reproduce it locally when practical; don't spend time building a separate reproduction if an existing test can capture it directly.
2. **Add focused regression coverage.** Write or update the smallest useful automated test for the faulty case. Prefer an existing public API or user-visible behavior over implementation details. Follow the package's test conventions and keep the test beside the code it covers.
3. **Confirm the test distinguishes the fix.** When practical, verify the test fails against the buggy behavior and passes with the correction. Avoid weakening assertions or changing unrelated tests just to make the suite pass.
4. **Fix the defect.** Make the narrowest change that produces the expected behavior, then keep the regression test in place.
5. **Report verification accurately.** State which test or command you ran and its result. If you did not run it, say so. Never describe an unrun test as passing.

## Deterministic time and fast tests

Choose the clock behavior from what the test actually verifies:

| Test purpose | Clock setup |
| --- | --- |
| Calendar rules, date formatting, or a deadline cutoff | Freeze only `Date`: `vi.useFakeTimers({ toFake: ["Date"] })`, then `vi.setSystemTime(...)`. Leave timers real so user interactions and React Query notifications run normally. |
| Polling, debounce, tooltip delay, or retry backoff | Install fake timers before the relevant timer is scheduled. Advance the clock explicitly with `vi.advanceTimersByTimeAsync` inside React `act`. |
| Error/retry UI where the backoff duration is irrelevant | Set `retryDelay: 0` on the test's `QueryClient`. Preserve the retry count and assert the expected attempts; production query options stay unchanged. |
| A pending response or out-of-order completion | Use a deferred promise and resolve it at the intended step. Avoid sleeping to approximate network timing. |

For example, a polling test should distinguish the interval boundary:

```tsx
await act(async () => {
  await vi.advanceTimersByTimeAsync(3_999);
});
expect(readTask).toHaveBeenCalledOnce();
await act(async () => {
  await vi.advanceTimersByTimeAsync(1);
});
expect(readTask).toHaveBeenCalledTimes(2);
```

- Do not use `shouldAdvanceTime: true` just to fix today's date. Its automatic clock ticks can turn `userEvent` zero-delay waits into real waits for every character and click.
- When interactions require fake timers, configure `userEvent.setup({ advanceTimers: vi.advanceTimersByTimeAsync })`, or await the interaction inside an `act` block that advances the clock. Explicitly flush the application's pending notifications. Verify compatibility with the installed Testing Library version; `waitFor`/`findBy` may wait on mocked timers. Check pending-submission, double-click, focus, and keyboard assertions when changing scheduling. A faster test that hides or creates a duplicate submission is not equivalent.
- Unmount components before restoring real timers, including when an assertion fails. Clear test query clients when needed to prevent pending requests or cached failures from leaking into another case.
- Keep production polling and retry logic active. Calling `refetch()` manually does not verify automatic polling. Use bounded clock advances instead of `runAllTimers()` for repeating timers.
- Do not add real sleeps for readiness or increase a timeout to accommodate polling/backoff. The `apps/app` default is 3 seconds per case; investigate an overrun before adding an exception.
- Measure the same cases before and after a scheduling change. Separate case execution from imports and setup, retain the existing assertions, and run the affected suite to catch leaked clock state. Use CI measurements when choosing a timeout budget; `slowTestThreshold` reports slow cases but does not fail them.

## Test environment and imports

- In `apps/app`, name tests of pure data transformations `*.node.test.ts`. The Node project runs these without DOM globals or `src/test/setup.tsx`. Keep component, hook, browser API, and global-mock-dependent tests in the DOM project.
- When moving existing tests to Node, keep their assertions and compare the complete discovered file/case set. Do not compensate for a browser dependency by adding browser mocks to the Node project.
- Keep imports proportional to the behavior under test. Inspect transitive dependencies: a small helper imported from a configuration file, barrel, or registry can load entire UI flows, SDKs, and initialization code. File size alone does not establish import cost.
- Keep pure metadata, validation, and filtering functions in modules that do not import their UI renderers or runtime integrations. Let data consumers import those modules directly, and keep component registries with rendering consumers. Preserve the real behavior and assertions exercised by the test when changing these boundaries.
- When imports/collection dominate a slow test, profile that phase before and after the change, separately from setup and case execution. Compare the same cases with the same worker count, runtime, and cache conditions; label cold and warm runs and avoid concurrent benchmark runs on the same machine. Confirm that the affected tests and the full suite still discover the expected files and cases. Do not claim an import improvement from total elapsed time alone.
- For `renderHook` assertions with immediately resolved mocks, consider a smaller file-local `waitFor` interval: hook updates may not trigger a DOM mutation, leaving the default 50 ms polling interval on the critical path. Keep the assertions and timeout; do not change the global interval or mock the hook being tested.
- Measure imports and setup separately from case execution. Keep per-file isolation; do not turn it off to improve a benchmark. Use `APP_TEST_MAX_WORKERS` to compare concurrency on the actual CI runner before changing its default.

## When automated coverage is not practical

Do not silently omit regression coverage. Explain the concrete limitation (for example, the behavior depends on an unavailable external system or cannot be observed by the available test harness) and add the closest meaningful automated check. If no useful automated check is possible, explain why and identify the verification that remains necessary.

## Scope

Use this workflow when the user asks to correct a bug, a regression, incorrect behavior, or a defect called out in a PR finding. A review that only asks for findings does not call for implementing a fix or adding a test. For feature work, add tests as appropriate to the request and project conventions; this skill's regression requirement is specifically for defect fixes.
