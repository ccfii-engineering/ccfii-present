---
status: accepted
---

# Enable self-service presenter registration on CCFII Present

The CCFII Present branding spec and plan (`docs/superpowers/specs/2026-08-12-ccfii-present-branding-design.md`, `docs/superpowers/plans/2026-08-12-ccfii-present-branding.md`) explicitly required presenter self-registration (`/users/register`, gated by the `ENABLE_ACCOUNT_CREATION` config) to remain disabled in production, matching the deployment's existing configuration at the time.

While fixing the join page's "About" and "Start creating for free" links — which redirected to the upstream Claper marketing site instead of anywhere in CCFII Present — we decided to open self-service registration instead of keeping presenter accounts admin-provisioned only, matching upstream Claper's stock join-page behavior rather than treating CCFII Present as an invite-only internal tool.

This reverses the branding spec's registration constraint. Consequence: the production `ENABLE_ACCOUNT_CREATION` environment variable must be confirmed/set to `true` on Railway (previously required to stay off), and anyone who reaches the join page can create a presenter account without admin approval.

**Considered option:** keep registration closed and have an admin provision presenter accounts via `/admin/users/new`. Rejected in favor of matching upstream Claper's default UX.
