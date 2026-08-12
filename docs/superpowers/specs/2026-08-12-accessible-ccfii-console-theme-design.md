# Accessible CCFII Console Theme Design

## Status

Approved in conversation on 2026-08-12. This specification extends the existing CCFII Present branding design with an accessible, consistently dark application theme and a branded mobile join experience.

## Problem

The released source contains the intended CCFII palette, but production HTML referenced unversioned CSS and JavaScript paths. Railway, Cloudflare, and browsers could therefore continue serving the previous Claper purple bundle after a deployment. A cache-busting request proves that the current image contains the new bundle.

Even after the correct bundle loads, some views still contain hardcoded legacy purple, cyan, navy, translucent white, and light gray styles. These bypass the semantic theme tokens. The audience join page is the clearest example: its background gradients, join button, low-opacity helper text, and mobile code input still express the upstream visual system and include weak-contrast states.

## Goals

- Present one recognizable CCFII system across authenticated presenter, management, admin, and audience entry surfaces.
- Use CCFII maroon, gold, warm-black, and off-white as semantic colors rather than mechanically replacing every literal color.
- Meet WCAG 2.2 AA contrast for text, controls, focus indicators, and meaningful boundaries; reach AAA for primary reading text where practical.
- Give the mobile join-code input an unmistakably CCFII appearance with readable placeholder, entry, focus, error, autofill, and disabled states.
- Ensure every release references fingerprinted static assets so an earlier theme cannot survive a deployment through caching.
- Preserve black presentation/fullscreen canvases where black is functional rather than decorative.

## Non-goals

- Redesigning presentation interaction behavior, navigation structure, or information architecture.
- Replacing the CCFII seal or approved lockup.
- Changing event-selected colors used as presentation data.
- Rewriting every template solely to remove neutral Tailwind classes when a scoped semantic rule provides the correct behavior.
- Altering database schemas, authentication, uploads, or real-time messaging.

## Design Approach

### Semantic palette

The existing CCFII theme remains the source of truth:

- Primary: CCFII maroon.
- Secondary: CCFII gold.
- Base surfaces: warm black and dark brown.
- Primary text: warm off-white.
- Accent blue remains available only for informational states where it has a semantic purpose; it is not a decorative replacement for the old cyan.
- Success, warning, and error colors retain their meanings and must use contrast-safe content colors.

Components consume semantic tokens or narrowly scoped CCFII surface classes. Legacy purple, cyan, and navy literals are removed from product chrome. A literal is permitted only when it represents content data or an intentionally preserved functional canvas.

### Console surfaces

Presenter, event-management, and admin chrome use a layered dark-console hierarchy:

1. Warm-black page background.
2. Slightly lighter panels and cards.
3. Subtle warm neutral borders for separation.
4. Off-white primary text and lighter neutral secondary text.
5. Maroon for primary actions and selected states when white text remains AA compliant.
6. Gold for focus, active emphasis, badges, and small high-salience details when paired with dark content.

Hardcoded white panels and gray text that defeat this hierarchy are corrected through the smallest stable scope. Presentation slide canvases and fullscreen display areas remain black.

The initial correction explicitly covers:

- The admin layout's forced light theme.
- The manager shell, header, sidebars, option panels, audience-response panels, slide sidebar, preview controls, and floating action bar.
- Shared admin search, table, action-menu, pagination, modal, and form-control surfaces.
- Presenter overlay message cards.
- The attendee side drawer and attendee composer gradient.

The audience room's black media/chat environment and every presentation fullscreen/fallback canvas remain unchanged.

### Audience join and mobile input

The join page uses a warm-black-to-maroon background treatment without upstream purple or cyan. The join-code control becomes a visible input rather than a nearly invisible underline:

- Warm dark filled surface.
- Gold boundary and focus indicator with at least a 3:1 adjacent-color contrast.
- Off-white entered code.
- Contrast-safe neutral placeholder and helper text.
- Maroon primary button with white text, with gold used for hover/focus emphasis.
- Autofill preserves the same foreground and surface treatment.
- Error state uses the semantic error color plus readable text and does not rely on color alone.
- Mobile sizing keeps the code readable without clipping at 320 CSS pixels and supports zoom/text enlargement.

Desktop and mobile share the same semantic states; responsive rules adjust spacing and type size, not brand identity.

The mobile menu overlay uses solid gold with warm-black content. It must not place white text or icons on gold. The primary join control does not use the existing cyan-to-purple or maroon-to-gold text-bearing gradient because no single label color maintains AA contrast across those gradients.

### Static asset delivery

All root, user, admin, and error layouts resolve CSS and JavaScript through `Phoenix.VerifiedRoutes.static_path/2`. In production, Phoenix maps these logical names to digest-bearing filenames from `cache_manifest.json`. The application must not emit literal `/assets/app.css`, `/assets/admin.css`, `/assets/custom.css`, or `/assets/app.js` references.

## Accessibility Contract

- Normal text: contrast ratio at least 4.5:1.
- Large text: contrast ratio at least 3:1.
- Primary reading text: target 7:1 where practical.
- Meaningful component boundaries and focus indicators: at least 3:1 against adjacent colors.
- Placeholder and disabled explanatory text remain readable; opacity alone may not reduce them below the applicable target.
- Interactive states remain distinguishable without color alone through border, outline, weight, icon, label, or shape.
- Keyboard focus is visible on all join-page and console controls.

Ratios are calculated using WCAG relative luminance after alpha colors are composited onto their actual background. Tests use literal, independently calculated expected results rather than deriving expectations from production helpers.

Audited anchor combinations are:

- White on maroon `#810E0E`: 10.49:1.
- Warm black `#120A0A` on gold `#FAA739`: 9.92:1.
- Off-white `#F7EDED` on dark brown `#1E1414`: 15.70:1.
- Off-white `#F7EDED` on warm black `#120A0A`: 17.04:1.
- Off-white `#F7EDED` on panel brown `#2A1C1C`: 14.28:1.
- Muted neutral `#B99B9B` on dark brown `#1E1414`: 7.06:1.
- White on informational blue `#3567FF`: 4.63:1, so this pair is AA-only and is reserved for informational controls rather than primary reading text.
- White on semantic green `#147A4C`: 5.36:1.
- White on semantic red `#C12B34`: 5.73:1.

The join input uses `#F7EDED` entered text and `#B99B9B` placeholder text on `#1E1414` or `#120A0A`, with a two-pixel `#FAA739` focus indicator. Disabled explanatory states use an explicit contrast-safe foreground instead of an opacity utility.

## Testing Strategy

- A layout regression test seeds known Phoenix static fingerprints and verifies root, login, admin, and error HTML emits them. Reverting a layout to a literal static path must fail this test.
- A palette contrast test evaluates the approved foreground/background pairs and fails when any pair drops below its required WCAG threshold.
- Join-page LiveView tests verify semantic classes or stable state hooks for the branded input, button, helper text, and error/focus treatment.
- The production asset build must produce digest-bearing filenames and a compiled bundle containing CCFII maroon/gold tokens without legacy purple/cyan decorative values in the scoped surfaces.
- Run formatter, Credo, focused web tests, the complete ExUnit suite, and `MIX_ENV=prod mix assets.deploy` before release.
- After deployment, fetch the HTML without cache-busting parameters, follow its fingerprinted CSS URL, verify the expected CCFII tokens, and spot-check desktop and mobile join/presenter surfaces.

## Rollout and Recovery

Ship the correction as a new immutable CCFII image tag rather than overwriting `3.0.0-ccfii.2`. Deploy the exact new digest to Railway with the existing private GHCR credentials, one Singapore replica, PostgreSQL service, and `/app/uploads` volume unchanged. Confirm health, registration policy, WebSocket connectivity, branding, and fingerprinted assets. If health or presentation behavior regresses, restore the recorded upstream image or the successful `.2` image while retaining database and upload volumes.

## Success Criteria

- A normal load of `https://claper.ccfii.org/` and authenticated console views uses the current fingerprinted CSS without a hard reload.
- No decorative upstream purple/cyan remains in the reviewed application chrome.
- The mobile join code control is clearly branded, keyboard accessible, readable, and unclipped.
- Every audited foreground/background and focus pair meets its stated WCAG threshold.
- Full automated and production-build verification passes.
- Railway continues serving the private immutable CCFII image with existing persistent data intact.
