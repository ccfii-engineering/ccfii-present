# CCFII Present Branding Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a maintainable CCFII-branded Claper v3.0.0 container as `CCFII Present` and deploy it to the existing Railway service without changing stored data or application behavior.

**Architecture:** Keep all internal Claper modules, database identifiers, runtime configuration, and presentation behavior intact. Centralize visible brand markup in one Phoenix function-component module, centralize colors in the existing DaisyUI/Tailwind theme, replace only public assets and product-facing templates, and publish immutable GHCR images from explicit CCFII release tags.

**Tech Stack:** Elixir 1.18, Phoenix 1.7, LiveView 1.0, HEEx, Tailwind CSS 4, DaisyUI, ExUnit/Floki, Docker Buildx, GitHub Actions, GHCR, Railway.

## Global Constraints

- Initial base is the exact upstream `v3.0.0` tag on branch `ccfii/v3.0.0`.
- Product name is exactly `CCFII Present`.
- Canonical logo source is `/Users/solstellar/Documents/ccfii/ccfii-web/public/images/ccfii-logo.png`.
- Core colors are maroon `#810E0E`, gold `#FAA739`, background `#120A0A`, surface `#1E1414`, and focus blue `#3567FF`.
- Keep `Claper` in internal module names, OTP application names, release commands, cookies, database identifiers, and upstream legal notices.
- Do not add database migrations or change authentication, registration, uploads, interaction logic, PubSub, Presence, LiveView, or WebSocket behavior.
- Show “Powered by Claper” on account-access, presenter dashboard, and admin surfaces; do not overlay it on audience or projected presentation surfaces.
- Publish `ghcr.io/ccfii-engineering/ccfii-present:3.0.0-ccfii.2`; Railway must use that immutable tag.
- Preserve `ghcr.io/claperco/claper:3.0.0` as the rollback image.

## File Structure

- `lib/claper_web/components/brand_components.ex`: reusable CCFII logo lockup and upstream-attribution function components.
- `test/claper_web/components/brand_components_test.exs`: component contract tests for accessible names, variants, and attribution URL.
- `test/claper_web/branding_surface_test.exs`: request/LiveView tests proving product titles, required attribution surfaces, and audience exclusions.
- `assets/css/theme-config.css`: centralized CCFII DaisyUI and Tailwind color tokens.
- `assets/css/app.css`: CCFII login texture and focus treatment utilities.
- `assets/css/admin.css`: admin shell theme alignment only where shared tokens are insufficient.
- `assets/images/ccfii-present-logo.png`, `assets/images/ccfii-present-mark.png`: source-controlled optimized brand assets copied into the release by the existing asset pipeline.
- `priv/static/images/ccfii-present-logo.png`, `priv/static/images/ccfii-present-mark.png`, `priv/static/images/favicon.png`, `priv/static/favicon.ico`: runtime static assets.
- `lib/claper_web/templates/layout/{root,user,admin,admin_app,email}.html.heex`: metadata, favicon, admin lockup, and email branding.
- `lib/claper_web/templates/user_session/new.html.heex`, `lib/claper_web/templates/user_reset_password/{new,edit}.html.heex`, `lib/claper_web/templates/user_registration/new.html.heex`: branded account-access shell and attribution.
- `lib/claper_web/live/event_live/index.html.heex`: dashboard attribution.
- `lib/claper_web/live/event_live/manage.html.heex`: presenter-management logo only; no audience attribution.
- `lib/claper_web/templates/layout/_profile_dropdown.html.heex`: compact mark and accessible product name.
- `lib/claper_web/templates/lti/registration/new.html.heex`: product name/logo updates without changing LTI behavior.
- `lib/claper_web/templates/user_notifier/{magic,welcome}.html.heex`: product-facing email copy.
- `.github/workflows/elixir.yml`: CI branch coverage for `ccfii/v3.0.0` and future `ccfii/**` branches.
- `.github/workflows/docker-image.yml`: tag-only immutable GHCR publishing for CCFII Present.
- `README.md`: fork identity, upstream-sync process, local checks, image naming, deployment, and rollback.

---

### Task 1: Add the reusable brand component contract

**Files:**
- Create: `lib/claper_web/components/brand_components.ex`
- Create: `test/claper_web/components/brand_components_test.exs`

**Interfaces:**
- Produces: `<ClaperWeb.BrandComponents.logo variant={:full | :mark} class="..." />`.
- Produces: `<ClaperWeb.BrandComponents.attribution class="..." />` linking to `https://github.com/ClaperCo/Claper`.
- Consumes: static assets under `/images/ccfii-present-logo.png` and `/images/ccfii-present-mark.png`.

- [ ] **Step 1: Write failing component tests**

Create an ExUnit test module using `ClaperWeb.ConnCase` and `Phoenix.LiveViewTest.render_component/2`. Assert that the full logo renders an image with `src="/images/ccfii-present-logo.png"` and `alt="CCFII Present"`, the mark renders `/images/ccfii-present-mark.png`, caller classes are preserved, and attribution renders an external, safe link with the exact text `Powered by Claper`.

```elixir
defmodule ClaperWeb.BrandComponentsTest do
  use ClaperWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias ClaperWeb.BrandComponents

  test "renders the accessible full lockup" do
    html = render_component(&BrandComponents.logo/1, %{variant: :full, class: "h-10"})
    assert html =~ ~s(src="/images/ccfii-present-logo.png")
    assert html =~ ~s(alt="CCFII Present")
    assert html =~ ~s(class="h-10")
  end

  test "renders the compact mark" do
    html = render_component(&BrandComponents.logo/1, %{variant: :mark})
    assert html =~ ~s(src="/images/ccfii-present-mark.png")
  end

  test "renders safe upstream attribution" do
    html = render_component(&BrandComponents.attribution/1, %{})
    assert html =~ "Powered by Claper"
    assert html =~ ~s(href="https://github.com/ClaperCo/Claper")
    assert html =~ ~s(target="_blank")
    assert html =~ ~s(rel="noopener noreferrer")
  end
end
```

- [ ] **Step 2: Run the focused test and verify RED**

Run: `MIX_ENV=test mix test test/claper_web/components/brand_components_test.exs`

Expected: compilation failure because `ClaperWeb.BrandComponents` does not exist.

- [ ] **Step 3: Implement the minimal component module**

Create a Phoenix component module with validated `attr` declarations, defaults of `variant: :full` and `class: nil`, a private mapping from variant to the two asset paths, and an attribution link with the exact URL and safe external-link attributes. Use `Phoenix.Component` only; do not introduce application configuration or a branding context.

- [ ] **Step 4: Run the focused test and verify GREEN**

Run: `MIX_ENV=test mix test test/claper_web/components/brand_components_test.exs`

Expected: 3 tests, 0 failures.

- [ ] **Step 5: Format and commit**

Run: `mix format lib/claper_web/components/brand_components.ex test/claper_web/components/brand_components_test.exs`

Commit:

```bash
git add lib/claper_web/components/brand_components.ex test/claper_web/components/brand_components_test.exs
git commit -m "feat: add CCFII brand components"
```

---

### Task 2: Add optimized CCFII assets and the dark-console theme

**Files:**
- Create: `assets/images/ccfii-present-logo.png`
- Create: `assets/images/ccfii-present-mark.png`
- Create: `priv/static/images/ccfii-present-logo.png`
- Create: `priv/static/images/ccfii-present-mark.png`
- Modify: `priv/static/images/favicon.png`
- Modify: `priv/static/favicon.ico`
- Modify: `assets/css/theme-config.css`
- Modify: `assets/css/app.css`
- Modify: `assets/css/admin.css`
- Test: `test/claper_web/components/brand_components_test.exs`

**Interfaces:**
- Consumes: canonical 650×650 transparent CCFII seal from `ccfii-web/public/images/ccfii-logo.png`.
- Produces: stable runtime paths consumed by `ClaperWeb.BrandComponents`.
- Produces: semantic DaisyUI tokens used by all existing `btn-primary`, `bg-base-*`, `text-primary-*`, status, and focus styles.

- [ ] **Step 1: Extend asset-contract tests**

Add assertions that every referenced runtime asset exists, is non-empty, and starts with the PNG signature. Keep this test independent of ImageMagick so CI validates committed outputs without regenerating them.

- [ ] **Step 2: Run the focused test and verify RED**

Run: `MIX_ENV=test mix test test/claper_web/components/brand_components_test.exs`

Expected: failures for missing `ccfii-present-logo.png` and `ccfii-present-mark.png`.

- [ ] **Step 3: Generate source and runtime assets**

Use ImageMagick against the canonical logo. Trim transparent padding, retain transparency, create a 512×512 seal mark, create a horizontal 1200×320 lockup containing the seal and the words `CCFII Present`, and derive 512, 180, 48, 32, and 16 pixel favicon sizes. Commit deterministic PNG/ICO outputs in both asset locations required by the existing Docker build.

Run representative commands from the repository root:

```bash
magick ../ccfii-web/public/images/ccfii-logo.png -trim -resize 512x512 -strip assets/images/ccfii-present-mark.png
magick assets/images/ccfii-present-mark.png -background none -gravity west -extent 1200x320 -font Montserrat-Bold -pointsize 112 -fill white -annotate +350+16 "CCFII Present" -strip assets/images/ccfii-present-logo.png
cp assets/images/ccfii-present-mark.png priv/static/images/ccfii-present-mark.png
cp assets/images/ccfii-present-logo.png priv/static/images/ccfii-present-logo.png
magick assets/images/ccfii-present-mark.png -resize 512x512 -strip priv/static/images/favicon.png
magick assets/images/ccfii-present-mark.png -define icon:auto-resize=48,32,16 priv/static/favicon.ico
```

If `Montserrat-Bold` is unavailable by that exact ImageMagick name, use the repository’s bundled variable font explicitly with `-font priv/static/fonts/Montserrat/Montserrat-VariableFont_wght.ttf`; do not silently substitute an unrelated typeface.

- [ ] **Step 4: Replace the color system**

Rename the DaisyUI theme from `claper` to `ccfii-present`, set `prefersdark: true` and `color-scheme: dark`, and map semantic tokens to the approved palette. Preserve success/warning/error semantics and ensure their content colors meet contrast requirements.

Use these anchors:

```css
--color-primary: #810E0E;
--color-primary-content: #FFFFFF;
--color-secondary: #FAA739;
--color-secondary-content: #120A0A;
--color-accent: #3567FF;
--color-accent-content: #FFFFFF;
--color-base-100: #1E1414;
--color-base-200: #120A0A;
--color-base-300: #2A1C1C;
--color-base-content: #F7EDED;
```

Replace the primary/secondary/neutral scales consistently rather than overriding individual templates. Update `assets/css/app.css` to select `ccfii-present --default`, change the gradient utility to maroon/gold, add a reusable `.ccfii-auth-backdrop` composed only of CSS radial/linear gradients, and add `:focus-visible` treatment using `#3567FF`. Keep audience fullscreen backgrounds black.

- [ ] **Step 5: Build assets and verify GREEN**

Run:

```bash
npm --prefix assets ci
mix assets.deploy
MIX_ENV=test mix test test/claper_web/components/brand_components_test.exs
```

Expected: asset build exits 0 and focused tests pass.

- [ ] **Step 6: Commit**

```bash
git add assets/images assets/css priv/static/images priv/static/favicon.ico test/claper_web/components/brand_components_test.exs
git commit -m "feat: add CCFII Present visual theme"
```

---

### Task 3: Apply product identity to approved surfaces

**Files:**
- Create: `test/claper_web/branding_surface_test.exs`
- Modify: `lib/claper_web/templates/layout/root.html.heex`
- Modify: `lib/claper_web/templates/layout/user.html.heex`
- Modify: `lib/claper_web/templates/layout/admin.html.heex`
- Modify: `lib/claper_web/templates/layout/admin_app.html.heex`
- Modify: `lib/claper_web/templates/layout/email.html.heex`
- Modify: `lib/claper_web/templates/layout/_profile_dropdown.html.heex`
- Modify: `lib/claper_web/templates/user_session/new.html.heex`
- Modify: `lib/claper_web/templates/user_reset_password/new.html.heex`
- Modify: `lib/claper_web/templates/user_reset_password/edit.html.heex`
- Modify: `lib/claper_web/templates/user_registration/new.html.heex`
- Modify: `lib/claper_web/templates/lti/registration/new.html.heex`
- Modify: `lib/claper_web/templates/user_notifier/magic.html.heex`
- Modify: `lib/claper_web/templates/user_notifier/welcome.html.heex`
- Modify: `lib/claper_web/live/event_live/index.html.heex`
- Modify: `lib/claper_web/live/event_live/manage.html.heex`
- Modify: `lib/claper_web/live/event_live/join.html.heex`
- Modify: `lib/claper_web/live/event_live/show.html.heex`
- Modify: `priv/gettext/en/LC_MESSAGES/default.po`
- Modify: other existing locale PO files generated by Gettext merge.

**Interfaces:**
- Consumes: `ClaperWeb.BrandComponents.logo/1` and `attribution/1`.
- Preserves: all route names, form actions, LiveView IDs, hooks, and auth conditions.

- [ ] **Step 1: Write failing surface tests**

Create request/LiveView tests asserting:

- `GET /users/log_in` contains `CCFII Present`, the canonical logo path, the CSS auth backdrop class, and `Powered by Claper`.
- Password reset contains the same branding and attribution.
- An authenticated `/events` LiveView contains the attribution.
- An authenticated admin page contains the attribution and `CCFII Present Admin` title.
- `GET /` and an attendee presentation surface do not contain `Powered by Claper` in presentation content.
- Layout titles use `CCFII Present`, not the old ` · Claper` suffix.

Use existing account fixtures and login helpers. Test semantic selectors/strings, not utility-class ordering.

- [ ] **Step 2: Run the new tests and verify RED**

Run: `MIX_ENV=test mix test test/claper_web/branding_surface_test.exs`

Expected: failures on missing CCFII metadata, components, and attribution.

- [ ] **Step 3: Replace layout metadata and shared chrome**

Set user/root titles to `CCFII Present`, admin suffix to `CCFII Present Admin`, and reference the new favicon. Replace raw logo `<img>` tags in shared authenticated/admin chrome with `BrandComponents.logo`. Add attribution below the dashboard content and at the bottom of the admin drawer, never inside the attendee presentation body.

- [ ] **Step 4: Brand account-access templates**

Replace the photo-based `client-login.jpg` panels with `.ccfii-auth-backdrop`, render the full inverse logo, retain all existing form actions/fields/errors/OIDC behavior, and add attribution after each account-access form. Change product-facing copy from Claper to CCFII Present only where the text describes this deployment. Keep all new/changed user-facing strings inside `gettext/1`.

- [ ] **Step 5: Brand presenter, audience join, LTI, and email surfaces**

Use the compact mark or full lockup according to available height. Replace old image references and alt text with the brand component where HEEx components are supported. On audience screens, replace the logo/product name but omit the attribution. In emails, use the new static mark and title while preserving reset/magic URLs and tokens.

- [ ] **Step 6: Refresh translations**

Run:

```bash
mix gettext.extract
mix gettext.merge priv/gettext
```

Review the diff so only intended source strings and catalogs change. Do not hand-translate unsupported locales; preserve existing translations and allow new strings to fall back to English until translated.

- [ ] **Step 7: Run focused and adjacent tests**

Run:

```bash
MIX_ENV=test mix test test/claper_web/branding_surface_test.exs
MIX_ENV=test mix test test/claper_web/controllers/user_session_controller_test.exs
MIX_ENV=test mix test test/claper_web/controllers/user_reset_password_controller_test.exs
MIX_ENV=test mix test test/claper_web/controllers/user_registration_controller_test.exs
MIX_ENV=test mix test test/claper_web/live/event_live_test.exs
MIX_ENV=test mix test test/claper_web/live/admin_live/admin_show_test.exs
```

Expected: all commands exit 0.

- [ ] **Step 8: Format and commit**

Run: `mix format`

Commit:

```bash
git add lib/claper_web test/claper_web priv/gettext
git commit -m "feat: apply CCFII Present branding"
```

---

### Task 4: Add CCFII CI and immutable container publishing

**Files:**
- Modify: `.github/workflows/elixir.yml`
- Modify: `.github/workflows/docker-image.yml`
- Modify: `README.md`

**Interfaces:**
- Consumes: Git tag `3.0.0-ccfii.2`.
- Produces: multi-architecture `ghcr.io/ccfii-engineering/ccfii-present:3.0.0-ccfii.2`.
- Produces: optional `production` tag only through an explicitly dispatched promotion job after validation.

- [ ] **Step 1: Add a workflow contract check**

Before editing, use shell assertions that must fail against the upstream workflow:

```bash
rg -q '^  packages: write$' .github/workflows/docker-image.yml
rg -q 'images: ghcr.io/ccfii-engineering/ccfii-present' .github/workflows/docker-image.yml
```

Expected: failure because the workflow still targets `ghcr.io/claperco/claper` and lacks package-write permission.

- [ ] **Step 2: Rewrite image publication around CCFII release tags**

Use current major versions of official actions, grant only `contents: read` and `packages: write`, log in with `${{ github.actor }}` and `${{ secrets.GITHUB_TOKEN }}`, and trigger builds only for tags matching `*-ccfii.*` plus manual dispatch. Generate the immutable tag from the Git ref without semver normalization that would discard the `ccfii` suffix. Do not publish `latest` from branch pushes. Define manual-dispatch inputs `image_tag` (required string) and `promote` (required boolean, default `false`); when `promote` is true, verify the immutable `image_tag` exists and retag that same digest as `production` without rebuilding it.

- [ ] **Step 3: Extend application CI branch coverage**

Run CI on pull requests and pushes for `ccfii/**`, while retaining upstream `main`/`dev` coverage. Keep PostgreSQL 15, formatting, Credo, and full tests intact.

- [ ] **Step 4: Document operations**

Add a concise CCFII Present section to `README.md` covering:

- Public fork and upstream URL.
- `git fetch upstream --tags` upgrade workflow.
- Brand asset source and palette.
- Local verification commands.
- Tag format and GHCR image path.
- Railway immutable-image deployment.
- Rollback to `ghcr.io/claperco/claper:3.0.0`.
- AGPL/upstream attribution expectations.

- [ ] **Step 5: Verify workflows and documentation**

Run:

```bash
npx --yes yaml-lint .github/workflows/elixir.yml .github/workflows/docker-image.yml
rg -q '^  packages: write$' .github/workflows/docker-image.yml
rg -q 'images: ghcr.io/ccfii-engineering/ccfii-present' .github/workflows/docker-image.yml
rg -n 'ghcr.io/ccfii-engineering/ccfii-present|3.0.0-ccfii.2|ClaperCo/Claper' README.md .github/workflows
```

Expected: YAML parses and every required identity/release string is present.

- [ ] **Step 6: Commit**

```bash
git add .github/workflows README.md
git commit -m "ci: publish versioned CCFII Present images"
```

---

### Task 5: Run the complete repository verification gate

**Files:**
- Modify only files needed to fix failures caused by Tasks 1–4.

**Interfaces:**
- Produces: a clean, releasable commit suitable for tag `3.0.0-ccfii.2`.

- [ ] **Step 1: Run formatting and static checks**

```bash
mix format --check-formatted
MIX_ENV=test mix credo
```

Expected: exit 0 with no formatting or Credo failures.

- [ ] **Step 2: Run the complete test suite**

Run: `MIX_ENV=test mix test`

Expected: 0 failures.

- [ ] **Step 3: Build production assets and release container**

```bash
MIX_ENV=prod mix assets.deploy
docker build --platform linux/amd64 -t ccfii-present:3.0.0-ccfii.2 .
```

Expected: both commands exit 0.

- [ ] **Step 4: Inspect the built image for branding and secrets**

Run the container with disposable local PostgreSQL or the repository’s supported Compose test setup, then assert:

```bash
curl -fsS http://localhost:4000/users/log_in | rg 'CCFII Present|Powered by Claper'
curl -fsS http://localhost:4000/images/ccfii-present-logo.png >/dev/null
! docker history --no-trunc ccfii-present:3.0.0-ccfii.2 | rg 'SMTP_PASSWORD|SECRET_KEY_BASE'
```

The final command must return no matching secret names or values embedded by this implementation.

- [ ] **Step 5: Review the requirements diff**

Verify no migration was added, no internal `Claper` modules were renamed, no auth/presentation behavior changed, and `git diff upstream/v3.0.0...HEAD -- priv/repo/migrations lib/claper lib/claper_web` contains only the approved web-branding surface.

- [ ] **Step 6: Commit any verification fixes**

If fixes were required, commit them separately:

```bash
git add lib/claper_web assets/css .github/workflows README.md test/claper_web priv/gettext priv/static/images priv/static/favicon.ico
git commit -m "fix: satisfy CCFII Present release checks"
```

If no fixes were required, do not create an empty commit.

---

### Task 6: Publish and deploy the reversible production release

**Files:**
- No repository files unless verification reveals a release-blocking defect.
- External state: GitHub tag/package and Railway `CCFII Claper` service image.

**Interfaces:**
- Consumes: verified branch commit and existing Railway PostgreSQL, SMTP variables, and `/app/uploads` volume.
- Produces: production service running `ghcr.io/ccfii-engineering/ccfii-present:3.0.0-ccfii.2`.

- [ ] **Step 1: Push the implementation branch and open a pull request**

Push `ccfii/v3.0.0`, open a PR against the fork’s protected production branch, and require the Elixir workflow to pass. Review the file list for unexpected migrations, secrets, generated build products, or internal renames before merging.

- [ ] **Step 2: Tag the reviewed commit**

```bash
git tag -a 3.0.0-ccfii.2 -m "CCFII Present 3.0.0-ccfii.2"
git push origin 3.0.0-ccfii.2
```

Wait for GitHub Actions and verify the GHCR package digest exists for both `linux/amd64` and `linux/arm64`.

- [ ] **Step 3: Record rollback state**

Before changing Railway, record the current service image, successful deployment ID, environment, region, volume mount, and HTTP status. Confirm the rollback image is exactly `ghcr.io/claperco/claper:3.0.0`.

- [ ] **Step 4: Deploy the immutable CCFII image**

Change only the Railway Claper service image to `ghcr.io/ccfii-engineering/ccfii-present:3.0.0-ccfii.2`. Preserve all variables, PostgreSQL references, one Singapore replica, port 4000, and `/app/uploads` mount. Do not recreate the service, database, or volume.

- [ ] **Step 5: Run production smoke and persistence checks**

Verify on Railway’s generated domain and then `https://claper.ccfii.org`:

- HTTP 200 for `/` and `/users/log_in`.
- Browser title and login content say `CCFII Present`.
- Logo and favicon return HTTP 200.
- `GET /users/register` remains disabled by configuration.
- Password reset sends through `ccfii.edit@gmail.com` SMTP.
- Admin and dashboard include `Powered by Claper`.
- Audience/presentation surfaces do not display the attribution overlay.
- Create/upload a small test PDF, open presenter and audience sessions, exercise one poll, and confirm LiveView updates.
- Write a disposable marker in `/app/uploads`, restart the service, confirm it persists, and remove it.
- Confirm deployment metadata still reports one replica in Singapore.

- [ ] **Step 6: Roll back on any release-blocking failure**

If startup, login, uploads, real-time behavior, or persistence fails, immediately restore `ghcr.io/claperco/claper:3.0.0`, redeploy, and verify HTTP 200 plus existing-data access. Preserve failed deployment logs for diagnosis.

- [ ] **Step 7: Promote only after validation**

After all smoke checks pass, manually dispatch the workflow promotion that advances `production` to the verified immutable digest. Keep Railway pinned to `3.0.0-ccfii.2`; the mutable tag is informational and must not drive production automatically.
