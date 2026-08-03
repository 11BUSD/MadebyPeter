# Production UX and Readiness Audit

Date: 2026-08-03

Live URL: <https://made-by-peter.vercel.app>

Viewports reviewed: 1440x900 desktop, 768x900 tablet, 412x915 mobile

## General health

**Overall: visually strong, functionally pre-launch.** The site has a distinct, calm editorial identity and a clear privacy-minded capture concept. However, the first visitor journey currently breaks trust: the homepage promises an Idea Graph and a specific LNG story, but the linked graph and profile do not exist in the production database. The public database is empty, while the homepage still uses fixture slugs. The capture flow creates a useful deterministic draft but its final Save action only changes local React state and does not create a canonical idea.

This is suitable for an internal preview. It should not yet be promoted as a working public product.

## Evidence

- [Desktop homepage](01-home-desktop.jpg)
- [Tablet homepage](02-home-tablet.jpg)
- [Missing graph destination](03-graph-missing.jpg)
- [Add-idea entry](04-add-idea-entry.jpg)
- [Draft review](05-capture-draft-review.jpg)
- [Privacy choice](06-capture-privacy.jpg)
- [Mobile homepage](08-home-mobile.jpg)
- [Mobile capture](09-add-idea-mobile.jpg)

The browser review covered the live public homepage, the advertised graph destination, and all three add-idea stages at desktop and mobile widths. It did not include a signed-in production account, cross-account RLS testing, email delivery, upload processing, or assistive-technology testing because those production services/accounts are not configured. Existing local automated tests are useful engineering evidence, but they are not evidence that the current production data and provider configuration are complete.

## What is working well

1. **The visual identity feels intentional.** The cream, forest green, restrained gold accent, editorial serif type, generous spacing, and plain-language copy feel coherent rather than template-like.
2. **The concept is understandable quickly.** “Ideas grow better with their roots intact” communicates provenance and connected thinking without technical graph language.
3. **Mobile is genuinely considered.** The 412px layout is readable, the primary actions remain reachable, and the fixed bottom navigation makes the core destinations obvious.
4. **Capture reduces anxiety.** The three-step structure, editable draft, private-by-default visibility, and explicit statement that publishing is a human action are good trust patterns.
5. **The semantic foundation is promising.** The reviewed DOM includes a skip link, landmarks, labeled controls, heading structure, and a real fieldset for capture type.

## Findings, ordered by severity

### P0 — blocks a credible launch

1. **Homepage calls to action lead to missing production records.** “Explore ideas” and “My Graph” point to `/g/energy-systems`; “Meet Peter” points to `/u/peter`. Those records are absent. The resulting error also says “This idea is not available” after the visitor asked for a graph, which adds confusion.
2. **The homepage advertises content it cannot show.** “Inside the LNG lifecycle” is presented as a real starting story, but the production `nodes` query returns no cards. The shell therefore looks finished while the core product appears empty.
3. **Add idea does not persist.** The final button calls `setSaved(true)`. It does not authenticate the visitor, invoke the canonical create RPC, or survive refresh. The interface must not suggest that an idea has been stored when it has not.
4. **The authenticated production loop is unproven.** Magic-link redirect URLs, SMTP deliverability, owner onboarding, Studio creation, and the return-to-draft flow still need real production verification.
5. **Operational launch gates remain open.** Persistent rate limiting, monitoring/alerts, backup restore evidence, abuse reporting, privacy/legal approval, and incident contacts are documented as required but are not yet complete.

### P1 — needed for a useful creator pilot

1. Make the homepage data-driven. If no public graph exists, show an honest launch/empty state instead of fixture-specific promises.
2. Create Peter’s real public profile, one public graph, and three approved public ideas. Keep all working notes private; publish only short summaries the owner has approved.
3. Preserve an unauthenticated capture locally, ask the visitor to sign in only when saving, then resume and persist the draft after authentication.
4. Give creators a first-run checklist: profile, first graph, first private idea, review privacy, publish one summary.
5. Explain Story, Map, reference, fork, and remix with a small real example. Do not require visitors to infer what the graph does.
6. Distinguish “public summary” from “private working notes” at every edit/publish boundary, with a visible current-state badge and a final preview.
7. Replace generic not-found copy with resource-specific recovery: graph, idea, profile, or private content.

### P2 — after the pilot loop is reliable

1. Add a custom domain, real share-card previews, metadata QA, consent-aware analytics, performance monitoring, and error reporting.
2. Add moderation/abuse intake and a documented response owner before opening public creation broadly.
3. Add real music examples only with owner-approved SoundCloud, Spotify, or Apple Music links. Keep provider fallbacks honest.
4. Keep marketplace, payments, rankings, and Stripe Connect disabled until their separate compliance and operations review is complete.
5. Build the Chat Vault only after the user supplies an official export and approves the private-import design in [the deferred requirement](../../future-work/chat-vault.md).

## Recommended public showcase set

These are safe, high-level drafts derived only from the current project conversation. They are not taken from the user’s other ChatGPT chats, and none should be published without explicit approval.

1. **Made by Peter / Idea Graph** — A provenance-first place to publish connected ideas, show how they changed, and let others reference, fork, or remix them without losing the original lineage.
2. **Private Chat Vault** — A private-by-default tool that turns an official conversation export into reviewable themes and ideas; nothing becomes public without a separate human approval step.
3. **Creator Music Graph** — Connect a song on SoundCloud, Spotify, or Apple Music to the ideas, sources, experiments, and remixes that helped it become real.
4. **Build in public without giving away the blueprint** — Publish a useful summary and visible lineage while keeping sensitive working notes, strategy, and unfinished material private.

The first three are enough for launch. Use synthetic or explicitly approved descriptions only; never import or publish raw conversation content as seed data.

## Production sequence

1. **Make the public shell truthful.** Remove or conditionally replace dead fixture links; add resource-specific 404s; keep the marketplace off.
2. **Establish the owner.** Create the real Peter account/profile, verify production auth, create one graph, and add three owner-approved ideas as private drafts first.
3. **Complete the save loop.** Connect capture to the authenticated canonical create RPC, preserve drafts through sign-in, show an honest success destination, and test refresh/retry/duplicate submission.
4. **Prove privacy with two accounts.** Re-run owner/editor/viewer and anonymous RLS journeys against an isolated preview project, then smoke-test production without exposing private IDs or payloads.
5. **Close operational gates.** Configure SMTP, redirect allowlists, CAPTCHA/rate limiting, monitoring, backups and restore, privacy/support contacts, and abuse handling.
6. **Release a small creator pilot.** Invite a limited set of real users, watch completion/error metrics, and fix the capture-to-publish loop before broader promotion.
7. **Defer private chat import.** Wait for the official export, perform the privacy review, and implement Chat Vault as a separate, feature-flagged project.

## What is needed from the owner now

- The public display name, username, short bio, and optional portrait/logo.
- Approval or edits for three showcase summaries above.
- Any real music links that may be shown publicly.
- A support/privacy contact email. Do not send passwords, access tokens, or service-role keys.
- A preferred custom domain, or confirmation that the Vercel URL is acceptable for the pilot.
- A decision on production email delivery (for example, a domain-backed SMTP provider).

The ChatGPT export is **not needed now**. The assistant cannot browse the user’s full ChatGPT history; only this task and files explicitly provided are available.

## Recommended next engineering task

Implement the truthful-public-shell and persistent-capture slice in one focused branch: data-driven homepage destinations, resource-specific empty/404 states, owner onboarding seed procedure, authenticated capture persistence, sign-in resume, and Playwright coverage for anonymous-to-saved-private-draft.
