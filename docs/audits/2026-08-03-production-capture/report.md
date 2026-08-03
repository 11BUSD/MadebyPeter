# Production capture and showcase audit

Date: 2026-08-03
Product: Made by Peter
Viewports: 1440 × 900 desktop; 412 × 915 mobile

## Journey health

1. **Homepage discovery — healthy.** The primary public action now opens the truthful Made Real showcase when no published graph exists. MIRKAB and Ice Pass are visible without suggesting that synthetic demonstrations are live services.
2. **Public project detail — healthy.** `/made-real` explains the evidence-first concepts, their current boundaries, and the next validation step. No Oliver Jewellery partnership or endorsement is claimed.
3. **Mobile capture — healthy.** A visitor can type an idea, review the deterministic draft, select privacy, and reach a clear sign-in-to-save state. The first authenticated save creates a private `My Ideas` graph.
4. **Privacy choice — healthy.** `Only me` is the default. Public visibility stays disabled unless the chosen graph is public, and publishing remains a separate human action.
5. **Authenticated persistence — verified below the UI.** The API requires an authenticated Supabase session, rejects cross-origin writes, validates input, and calls the idempotent database function covered by RLS tests.

## Evidence

- `01-home-desktop.jpg` — truthful homepage empty state at desktop width.
- `02-home-mobile.jpg` — homepage navigation and project cards at mobile width.
- `03-made-real-desktop.jpg` — public project detail and boundary copy.
- `04-capture-sign-in-mobile.jpg` — private-by-default capture before authentication.
- `comparison-home.jpg` — prior homepage and revised homepage shown together at the same viewport.

## Evidence limits

- The screenshots use the local development server and fixture public data. The small circular Next.js developer badge visible at the lower-left of local screenshots is not shipped in the production build.
- The production Supabase migration and authentication URL configuration were applied separately. No production user was created and no private production idea was read for this audit.
- Magic-link email delivery requires an owner-controlled email address and, for dependable production delivery, custom SMTP credentials. Those were not available for an end-to-end inbox test.
- The public project summaries were derived from the selected repositories' own README and policy documents. No unapproved project was inspected or included.

## Visual judgment

The revised page preserves the existing cream, ink, green, and serif design system. Compared side by side, the former dead `Inside the LNG lifecycle` destination is replaced by two balanced, legible project cards with explicit status and boundaries. Mobile copy remains readable, controls meet touch-size expectations, and the primary capture action remains visually dominant.
