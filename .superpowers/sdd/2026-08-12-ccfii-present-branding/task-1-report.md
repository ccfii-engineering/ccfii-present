# Task 1 Report: Reusable brand component contract

## Status

DONE

## Changed files

- `lib/claper_web/components/brand_components.ex`
  - Added `ClaperWeb.BrandComponents.logo/1` with validated `:full` and `:mark` variants, defaulting to `:full`.
  - Added `ClaperWeb.BrandComponents.attribution/1` with the upstream Claper URL and safe external-link attributes.
- `test/claper_web/components/brand_components_test.exs`
  - Added focused component tests for the full logo, compact mark, caller class preservation, and attribution link.

## RED

Command:

```text
docker exec ccfii-present-test-runner bash -lc 'cd /app && MIX_ENV=test mix test test/claper_web/components/brand_components_test.exs'
```

The expected failure occurred because `ClaperWeb.BrandComponents` did not exist. ExUnit reported `UndefinedFunctionError` for both `BrandComponents.logo/1` and `BrandComponents.attribution/1`; all 3 tests failed.

## GREEN

Command:

```text
docker exec ccfii-present-test-runner bash -lc 'cd /app && MIX_ENV=test mix test test/claper_web/components/brand_components_test.exs'
```

Result: `3 tests, 0 failures`.

The first post-implementation run exposed a syntax error from one-line heredoc-style documentation strings. Those strings were corrected, then the same focused command passed. Formatting was run with:

```text
docker exec ccfii-present-test-runner bash -lc 'cd /app && mix format lib/claper_web/components/brand_components.ex test/claper_web/components/brand_components_test.exs'
```

## Commit

`24ce9cb8f4317029a6e2828cfaa37dad9486048a`

## Self-review

- Components use only `Phoenix.Component` and keep the branding contract in a small reusable module.
- Logo variants are constrained through `attr` validation and map only to the required static asset paths.
- Caller-provided classes are passed through unchanged.
- Attribution uses the exact upstream URL, visible text, `_blank` target, and `noopener noreferrer` relationship.
- Focused tests pass after formatting; `git diff --check` is clean.

## Concerns

None.

## Fix round 1

### Changed files

- `lib/claper_web/components/brand_components.ex` — added the existing `ClaperWeb.Gettext` backend and localized `CCFII Present` and `Powered by Claper` while preserving their English defaults and component interface.
- `.superpowers/sdd/2026-08-12-ccfii-present-branding/task-1-report.md` — appended this fix-round report.

### Verification

Command:

```text
docker exec ccfii-present-test-runner bash -lc 'cd /app && mix format lib/claper_web/components/brand_components.ex test/claper_web/components/brand_components_test.exs && MIX_ENV=test mix test test/claper_web/components/brand_components_test.exs'
```

Result: `3 tests, 0 failures`.

### Self-review

Both user-facing branding strings now go through Gettext and retain the exact English output asserted by the focused tests. No interface or asset-path changes were introduced.
