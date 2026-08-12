# Accessible CCFII Console Theme Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a cache-safe CCFII dark console and audience join experience whose text, controls, boundaries, and focus states meet WCAG 2.2 AA, then publish and deploy a new immutable private image.

**Architecture:** Keep `assets/css/theme-config.css` as the semantic palette boundary and use DaisyUI base/primary/secondary tokens throughout product chrome. Apply narrowly scoped component classes where upstream templates currently depend on literal purple, cyan, navy, white, or gray. Generate all release asset URLs through Phoenix's static manifest so Railway, Cloudflare, and browsers cannot retain an earlier theme.

**Tech Stack:** Elixir 1.18, Phoenix/LiveView, HEEx, Tailwind CSS 4, DaisyUI 5, ExUnit, Blacksmith GitHub Actions, GHCR, Railway.

## Global Constraints

- Normal text contrast is at least 4.5:1; large text and meaningful non-text boundaries are at least 3:1.
- Primary reading text targets 7:1 where practical.
- Use CCFII maroon `#810E0E`, gold `#FAA739`, warm black `#120A0A`, dark brown `#1E1414`, and off-white `#F7EDED` through semantic tokens.
- Preserve black presentation/fullscreen canvases and event-selected content colors.
- Do not change database schemas, authentication, uploads, presentation behavior, LiveView IDs/hooks, or real-time messaging.
- Do not use opacity for required placeholder or disabled explanatory text.
- Do not overwrite immutable GHCR tags; release the fix under a new `*-ccfii.*` tag.
- Run repository commands through the existing test runner or `./with_env.sh` with `MIX_ENV=test` for tests.

---

### Task 1: Cache-safe release asset URLs

**Files:**
- Modify: `lib/claper_web/templates/layout/root.html.heex`
- Modify: `lib/claper_web/templates/layout/user.html.heex`
- Modify: `lib/claper_web/templates/layout/admin.html.heex`
- Modify: `lib/claper_web/templates/error/404.html.heex`
- Modify: `lib/claper_web/templates/error/500.html.heex`
- Test: `test/claper_web/branding_surface_test.exs`

**Interfaces:**
- Consumes: `static_path(ClaperWeb.Endpoint, logical_path)` supplied by `Phoenix.VerifiedRoutes`.
- Produces: digest-bearing CSS/JS URLs resolved from `priv/static/cache_manifest.json` in production.

- [ ] **Step 1: Preserve the failing regression proof**

Add a test that seeds endpoint static lookups with literal test fingerprints and renders login, root, admin, and error HTML. Assert every surface includes `/assets/app-ccfii-test.css?vsn=d` and `/assets/app-ccfii-test.js?vsn=d`; assert the user/root/error layouts include the custom fingerprint and admin includes the admin fingerprint.

- [ ] **Step 2: Verify RED on the upstream literal paths**

Run:

```bash
docker exec ccfii-present-test-runner bash -lc \
  'cd /app && MIX_ENV=test mix test test/claper_web/branding_surface_test.exs'
```

Expected: the fingerprint test fails because HTML contains `/assets/app.css`.

- [ ] **Step 3: Resolve every release asset through Phoenix**

Use this exact pattern for each CSS and JavaScript reference:

```heex
href={static_path(ClaperWeb.Endpoint, "/assets/app.css")}
src={static_path(ClaperWeb.Endpoint, "/assets/app.js")}
```

- [ ] **Step 4: Verify GREEN**

Run the focused command from Step 2. Expected: 8 tests, 0 failures.

- [ ] **Step 5: Commit**

```bash
git add lib/claper_web/templates test/claper_web/branding_surface_test.exs
git commit -m "fix: fingerprint release assets"
```

### Task 2: Executable contrast contract

**Files:**
- Create: `test/claper_web/accessibility/ccfii_contrast_test.exs`
- Modify: `assets/css/theme-config.css`

**Interfaces:**
- Consumes: literal approved color pairs from the design spec.
- Produces: `contrast_ratio/2 :: String.t(), String.t() -> float()` as a private test helper and an executable WCAG gate.

- [ ] **Step 1: Write a table-driven contrast test**

Define literal pairs and thresholds:

```elixir
@pairs [
  {"white on maroon", "#FFFFFF", "#810E0E", 7.0},
  {"warm black on gold", "#120A0A", "#FAA739", 7.0},
  {"off-white on warm black", "#F7EDED", "#120A0A", 7.0},
  {"muted copy on dark brown", "#B99B9B", "#1E1414", 7.0},
  {"white on info", "#FFFFFF", "#3567FF", 4.5},
  {"white on success", "#FFFFFF", "#147A4C", 4.5},
  {"white on error", "#FFFFFF", "#C12B34", 4.5},
  {"gold focus on warm black", "#FAA739", "#120A0A", 3.0}
]
```

Implement the WCAG sRGB linearization formula in test code and assert each computed ratio is at least its literal threshold. Add assertions that `theme-config.css` maps semantic tokens to these literals.

- [ ] **Step 2: Verify RED catches a known bad pair**

Temporarily include `{"white on gold", "#FFFFFF", "#FAA739", 4.5}` and run:

```bash
docker exec ccfii-present-test-runner bash -lc \
  'cd /app && MIX_ENV=test mix test test/claper_web/accessibility/ccfii_contrast_test.exs'
```

Expected: failure near 1.97:1. Remove only the deliberate bad fixture.

- [ ] **Step 3: Normalize semantic content pairs**

Keep primary content white and secondary content warm black. Ensure base surfaces and content match the approved literals; do not introduce duplicate palette definitions elsewhere.

- [ ] **Step 4: Verify GREEN and commit**

Run the focused test, then:

```bash
git add assets/css/theme-config.css test/claper_web/accessibility/ccfii_contrast_test.exs
git commit -m "test: enforce accessible CCFII contrast"
```

### Task 3: Accessible audience join and mobile input

**Files:**
- Modify: `lib/claper_web/live/event_live/join.html.heex`
- Modify: `assets/css/app.css`
- Test: `test/claper_web/live/event_live_test.exs`

**Interfaces:**
- Produces: stable hooks `ccfii-join-page`, `ccfii-join-menu`, and `join-code-input`; semantic mobile and desktop states.

- [ ] **Step 1: Write failing rendered-state assertions**

Render `/` and assert:

```elixir
assert has_element?(view, ".ccfii-join-page")
assert has_element?(view, "#input.join-code-input")
assert has_element?(view, "#submit.btn-primary")
refute render(view) =~ "cyan-"
refute render(view) =~ "rgba(134, 17, 237"
```

Also assert the input keeps `maxlength="10"`, `required`, autofocus, uppercase styling, and the existing `#form`, `#input`, and `#submit` IDs.

- [ ] **Step 2: Verify RED**

Run the exact event LiveView test file. Expected: missing CCFII page hook and remaining cyan/purple classes.

- [ ] **Step 3: Implement the join theme**

Use scoped CSS with these state values:

```css
.ccfii-join-page { background: linear-gradient(180deg, #1E1414 0%, #120A0A 100%); }
.join-code-input { color: #F7EDED; background: #1E1414; border: 2px solid #FAA739; }
.join-code-input::placeholder { color: #B99B9B; opacity: 1; }
.join-code-input:focus-visible { outline: 2px solid #FAA739; outline-offset: 4px; }
```

Use solid maroon/white for the join button. Use gold/warm-black for the mobile menu. Replace cyan link states with contrast-safe gold tones. Preserve form behavior and route destinations.

- [ ] **Step 4: Verify 320px-safe structure**

Ensure the input uses responsive text/tracking values that fit ten characters at 320 CSS pixels; use a smaller mobile size and retain the desktop `md:` scale. Run the focused test and production CSS build.

- [ ] **Step 5: Commit**

```bash
git add assets/css/app.css lib/claper_web/live/event_live/join.html.heex test/claper_web/live/event_live_test.exs
git commit -m "feat: brand accessible audience join"
```

### Task 4: Dark manager console

**Files:**
- Modify: `lib/claper_web/live/event_live/manage.html.heex`
- Modify: `lib/claper_web/live/event_live/manage_interaction_list_component.ex`
- Modify: `lib/claper_web/live/event_live/manage_presentation_options_component.ex`
- Modify: `lib/claper_web/live/event_live/manage_interaction_options_component.ex`
- Modify: `lib/claper_web/live/event_live/manage_attendees_options_component.ex`
- Modify: `lib/claper_web/live/event_live/manage_audience_responses_component.ex`
- Modify: `lib/claper_web/live/event_live/manage_slide_preview_component.ex`
- Modify: `lib/claper_web/live/event_live/manage_slide_sidebar_component.ex`
- Modify: `lib/claper_web/live/event_live/manage_floating_action_bar.ex`
- Test: `test/claper_web/live/event_live_test.exs`

**Interfaces:**
- Consumes: DaisyUI `base-*`, `base-content`, `primary`, `secondary`, and `info` semantic classes.
- Produces: one dark manager shell without changing LiveView events, IDs, or component assigns.

- [ ] **Step 1: Add failing manager theme coverage**

Create an event fixture, open its manage route, and assert `#manager` has the dark base shell plus semantic panel hooks. Reject visible legacy literals/classes `#140553`, `#f3defa`, `bg-white`, and the manager's decorative `bg-blue-500`.

- [ ] **Step 2: Verify RED**

Run the focused manager tests. Expected: hardcoded light/legacy classes appear.

- [ ] **Step 3: Convert structural surfaces**

Map page background to `bg-base-200`, panels/cards/header to `bg-base-100`, boundaries to `border-base-300`, content to `text-base-content`, selected lavender to `bg-primary/15`, and status blue to `bg-info`. Change hardcoded SVG strokes to `currentColor` where the parent owns semantic color.

- [ ] **Step 4: Preserve functional black canvases**

Confirm no diff changes fullscreen/fallback black rules or black slide/media canvases in presenter/audience views.

- [ ] **Step 5: Verify and commit**

Run event tests and formatter, then commit all manager files with:

```bash
git commit -m "feat: apply CCFII dark manager console"
```

### Task 5: Dark admin and remaining product chrome

**Files:**
- Modify: `lib/claper_web/templates/layout/admin.html.heex`
- Modify: `lib/claper_web/live/admin_live/search_filter_component.ex`
- Modify: `lib/claper_web/live/admin_live/table_actions_component.ex`
- Modify: `lib/claper_web/live/admin_live/table_component.ex`
- Modify: `lib/claper_web/live/admin_live/modal_component.ex`
- Modify: `lib/claper_web/live/event_live/show.html.heex`
- Modify: `lib/claper_web/live/event_live/presenter.html.heex`
- Modify: `assets/css/app.css`
- Test: `test/claper_web/branding_surface_test.exs`
- Test: `test/claper_web/live/admin_live/admin_show_test.exs`

**Interfaces:**
- Produces: explicit `data-theme="ccfii-present"` admin root and semantic dark shared controls.

- [ ] **Step 1: Write failing admin and ancillary surface tests**

Assert admin HTML uses `data-theme="ccfii-present"`, shared table/search/action surfaces use semantic base tokens, and no forced `data-theme="light"` remains. Add targeted assertions for the attendee drawer, attendee composer, and presenter chat cards.

- [ ] **Step 2: Verify RED**

Run branding and admin focused tests. Expected: forced light theme and legacy component classes fail.

- [ ] **Step 3: Implement minimal semantic conversions**

Replace admin indigo with semantic primary/focus classes; white/gray tables and menus with base tokens; modal informational blue with `bg-info/15 text-info`. Convert the attendee drawer and presenter message cards to base surfaces. Change `.attendee-composer` from blue/purple to a maroon/gold semantic treatment while keeping black media regions untouched.

- [ ] **Step 4: Verify and commit**

Run focused tests plus formatter, then:

```bash
git commit -m "feat: complete accessible CCFII product chrome"
```

### Task 6: Integrated build, visual proof, and immutable deployment

**Files:**
- Modify only if required by verification: `.github/workflows/docker-image.yml`
- Append operational evidence: `.superpowers/sdd/2026-08-12-ccfii-present-branding/task-6-report.md`

**Interfaces:**
- Consumes: reviewed main commit, Blacksmith pipeline, private GHCR credentials in Railway.
- Produces: immutable multi-platform image and successful Railway deployment on the exact manifest digest.

- [ ] **Step 1: Run complete local gates**

```bash
docker exec ccfii-present-test-runner bash -lc \
  'cd /app && mix format --check-formatted && MIX_ENV=test mix credo && MIX_ENV=test mix test && MIX_ENV=prod mix assets.deploy'
```

Expected: formatter clean, Credo zero issues, all tests pass, assets build succeeds.

- [ ] **Step 2: Audit compiled assets**

Confirm `cache_manifest.json` contains digested app/custom/admin CSS and app JS names. Confirm compiled CSS contains `#810e0e`, `#faa739`, and the join hooks; reject the scoped legacy purple/cyan values. Render production HTML and verify it points to digest-bearing assets.

- [ ] **Step 3: Review and merge PR #4**

Require Blacksmith CI success, review the diff against this plan, merge into protected `main`, and require the post-merge workflow to pass.

- [ ] **Step 4: Publish a new immutable release**

Create the next available annotated `3.0.0-ccfii.N` tag on the exact reviewed main commit. Wait for Elixir and multi-platform Docker workflows. Record the immutable manifest digest and both `linux/amd64` and `linux/arm64` platforms.

- [ ] **Step 5: Deploy exact private image to Railway**

Update only `claper` service `source.image` to the new tag while retaining encrypted GHCR credentials, one Singapore replica, PostgreSQL, and `/app/uploads`. Watch the deployment until `SUCCESS`; restore `3.0.0-ccfii.2` immediately if pulling or health checks fail.

- [ ] **Step 6: Verify production without cache-busting**

Fetch `https://claper.ccfii.org/` normally, extract the digest-bearing CSS URL, fetch it, and verify CCFII tokens. Verify login HTTP 200, logo HTTP 200, registration GET redirect, branded 404, WebSocket connection logs, custom domain through Cloudflare, and unchanged volume/region/replica settings. Check the join page at desktop and 320px mobile widths and the authenticated manager console.

- [ ] **Step 7: Record rollback and final evidence**

Append commit, tag, workflow run IDs, digest, deployment ID, checks, and exact rollback image to the report. Do not include registry tokens or application secrets.
