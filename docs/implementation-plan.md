# Implementation Plan

## Architecture slices

1. Foundation: strict Next.js App Router, TypeScript, Tailwind, Supabase clients, validation, security headers, feature flags.
2. Data and identity: SQL schema, immutable triggers, RLS, auth callback, username onboarding, seed and database tests.
3. Public product: Explore, profiles, Story graph, idea detail, sources, music embeds, canonical metadata.
4. Interactive graph: bounded neighborhood API, lazy React Flow canvas, expansion, breadcrumbs, keyboard/list fallback.
5. Creation: three-step capture, media URL validation, draft adapters, graph/idea/edge server actions.
6. Provenance: idempotent transactional reference/fork/remix function and lineage UI.
7. Privacy and utility: public search, consent/settings, export/deletion request, share assets.
8. Quality and release: unit/integration/RLS/accessibility/Playwright suites, CI, dependency review, runbook and handoff.

## Implementation rules

- Server components read; server actions mutate; route handlers serve interoperable APIs/assets.
- Domain services own authorization, lineage integrity, traversal bounds, and provider validation.
- Browser code receives only public or explicitly authorized records and never a service-role key.
- All inputs cross Zod or SQL constraints; all rich content renders as text/structured fields.
- Public content can be cached; authenticated and visibility-sensitive reads are dynamic.
- Every mutation records an audit event in the same transaction where practical.

## Focused commit plan

1. `docs: define product architecture and delivery plan`
2. `feat: add database schema auth boundaries and rls`
3. `feat: add public profiles graphs and ideas`
4. `feat: add story and progressive map exploration`
5. `feat: add mobile capture media and share assets`
6. `feat: add immutable branching and lineage`
7. `feat: add search privacy consent and agent drafts`
8. `test: cover domain security accessibility and journeys`
9. `docs: add operations readme and release handoff`

## Quality gates

| Gate | Command/evidence |
|---|---|
| Reproducible install | `npm ci` |
| Empty database | `supabase db reset` or SQL test harness |
| Seed | `npm run db:seed` |
| Types/lint | `npm run typecheck`, `npm run lint` |
| Unit/integration/RLS | dedicated Vitest and pgTAP scripts |
| Accessibility/E2E | Playwright + axe at desktop and mobile projects |
| Release | `npm run build`, `npm audit --omit=dev` review |
| Browser | screenshots, content/error-overlay/console checks |

## Rollback

- Application rollback is a previous immutable deployment.
- Schema migrations are forward-only in production; corrective migrations reverse additive objects.
- Marketplace remains off by default, providing an immediate kill switch for its route surface.
- Production AI is absent; deterministic adapters can be disabled without affecting canonical content.
