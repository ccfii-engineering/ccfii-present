# CCFII Present Branding Design

## Objective

Create a maintainable CCFII-branded distribution of Claper named **CCFII Present** and deploy it to the existing Railway production infrastructure without changing application behavior or stored data.

## Repository and Upstream Strategy

- Maintain the public fork at `ccfii-engineering/ccfii-present`.
- Preserve `ClaperCo/Claper` as the `upstream` Git remote.
- Base the initial branded release on the exact upstream `v3.0.0` tag.
- Keep branding changes narrowly scoped so later upstream release tags can be merged deliberately.
- Retain upstream copyright, license notices, and a visible “Powered by Claper” attribution.

## Product Identity

- Product name: **CCFII Present**.
- Canonical logo source: `ccfii-web/public/images/ccfii-logo.png` from the existing CCFII website repository.
- Derive web-optimized header, compact, favicon, and touch-icon assets from the canonical source.
- Replace visible Claper product naming in browser metadata, login, dashboard, admin, and email presentation where it denotes the deployed product.
- Do not rename Elixir modules, database objects, cookies, internal APIs, or other implementation identifiers merely for branding.

## Visual System

Use a dark presentation-console aesthetic aligned with existing CCFII products:

- Deep charcoal and navy application surfaces.
- CCFII maroon for primary actions and selected navigation.
- Restrained gold for emphasis and important presentation states.
- Royal blue for focus rings, links, and informational states.
- White and soft-gray text with accessible contrast.
- A charcoal-to-navy login background with a subtle maroon glow and faint gold radial rays inspired by the seal.

Keep Claper’s layouts, information architecture, responsive behavior, and interaction patterns intact. This is a focused visual theme, not a functional redesign.

## Attribution

Display a discreet **Powered by Claper** link to `https://github.com/ClaperCo/Claper` on:

- Login and account-access screens.
- Presenter dashboard screens.
- Administrative screens.

Do not place the attribution over audience presentation screens, projected slides, or other presentation-critical surfaces.

## Change Boundaries

Expected changes are limited to:

- Logo, favicon, and related brand assets.
- Shared theme tokens and application styles.
- Product-name metadata and suitable visible copy.
- Email sender display name and branded email presentation where supported.
- Upstream attribution.
- Container publishing and release automation.

The branding release must not intentionally change:

- Database schemas or migrations.
- Authentication, registration, or authorization behavior.
- Presentation creation or upload processing.
- Polling, quizzes, forms, posts, or audience interaction logic.
- Phoenix PubSub, Presence, LiveView, or WebSocket behavior.

## Build and Release Architecture

- GitHub Actions builds a production container from approved repository tags.
- Publish immutable images as `ghcr.io/ccfii-engineering/ccfii-present:<version>`.
- Initial version: `3.0.0-ccfii.1`.
- A mutable `production` tag may be advanced only after the immutable image passes validation.
- Railway deploys an exact immutable image tag, never an unreviewed branch head or `latest`.
- Preserve the official `ghcr.io/claperco/claper:3.0.0` image reference as the rollback target.

## Railway Rollout

The existing `CCFII Claper` Railway project remains the production platform. Its PostgreSQL service, environment variables, and `/app/uploads` volume stay in place.

Rollout sequence:

1. Build and publish `ghcr.io/ccfii-engineering/ccfii-present:3.0.0-ccfii.1`.
2. Validate the image against the existing configuration using Railway’s generated domain.
3. Confirm database migrations introduce no unexpected changes.
4. Switch the Claper service image to the exact branded tag.
5. Verify production behavior before considering the release complete.
6. Roll back to `ghcr.io/claperco/claper:3.0.0` if a release-blocking regression appears.

No data migration or volume replacement is part of this work.

## Validation Requirements

Before production sign-off, verify:

- The container image builds successfully from a clean checkout.
- The application starts against the existing PostgreSQL database.
- The home page and login page return successful HTTP responses.
- `ccfii.edit@gmail.com` can authenticate through the password-reset flow.
- Presenter registration remains disabled according to the existing production configuration.
- A PDF or PowerPoint presentation can be uploaded and converted.
- Generated presentation files remain available after an application restart.
- Presenter and audience real-time views connect and update normally.
- Login, presenter dashboard, admin, and audience layouts remain readable on desktop and mobile.
- Logo, favicon, colors, metadata, and attribution appear in their specified surfaces.
- No secrets or environment-specific credentials are present in the repository or container layers.
- The official Claper image rollback procedure remains available.

## Maintenance Policy

- Track stable upstream release tags rather than the upstream `dev` branch for production.
- Review upstream release notes and merge each upgrade intentionally.
- Resolve theme conflicts within the branding layer instead of broadening the fork.
- Publish a new immutable CCFII image tag for every approved upstream or branding release.
- Perform production upgrades only when no presentation is live.

