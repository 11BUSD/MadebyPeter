# Made by Peter / Idea Graph

A mobile-first, multi-tenant foundation for publishing connected ideas and letting others reference, fork, or remix them without losing permanent provenance.

The current release is a strict MVP. It includes public browsing, Supabase authentication/RLS, Story and progressive Map views, capture drafts, three music-provider embed adapters, lineage, search, consent/settings, deterministic Capture/Structure agents, and share cards. Marketplace/payment capabilities are disabled and are not production integrations.

## Stack

- Next.js 16.2.12 App Router and React 19.2.8
- strict TypeScript, server components/actions, plain responsive design tokens
- Supabase Postgres/Auth/RLS, adjacency-list graph model
- React Flow loaded only for Map view
- Zod validation, Vitest, pgTAP, Playwright, axe

## Local setup

Prerequisites: Node.js 24+, npm, Docker Desktop for database checks.

```powershell
npm ci
Copy-Item .env.example .env.local
npm run dev -- --port 3100
```

With no Supabase variables, the app runs in an explicitly labeled, read-only fixture mode using synthetic LNG content. It does not pretend to persist accounts or ideas.

For the full local stack:

```powershell
npx supabase start
npx supabase db reset
npx supabase status
```

Copy the local `API_URL` to `NEXT_PUBLIC_SUPABASE_URL` and `ANON_KEY` to `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`. The legacy `NEXT_PUBLIC_SUPABASE_ANON_KEY` name is also supported. Never commit the service-role key.

## Environment variables

| Variable | Exposure | Required | Purpose |
|---|---|---:|---|
| `NEXT_PUBLIC_SUPABASE_URL` | browser-safe project URL | production | Supabase endpoint |
| `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` | browser-safe publishable key | production | RLS-bound client access |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | browser-safe legacy anon key | legacy projects only | fallback for older Supabase projects |
| `NEXT_PUBLIC_SITE_URL` | public | yes | canonical/auth callback base |
| `SUPABASE_SERVICE_ROLE_KEY` | server secret | only privileged workers | future admin/storage operations; unused by public routes |
| `FEATURE_MARKETPLACE` | server | no; default `false` | gates non-production marketplace boundary |
| `NEXT_PUBLIC_DEMO_MODE` | public | no; default `true` | labels fixture behavior |

OAuth providers, SMTP, CAPTCHA/rate limits, storage scanning, backups, and production redirects are configured in Supabase—not as repository secrets.

## Commands

```powershell
npm run typecheck
npm run lint
npm test
npx supabase db reset
npm run test:rls
npm run test:e2e
npm run test:a11y
npm run build
npm audit --omit=dev
```

## Architecture

Public reads use a stateless anonymous Supabase client and are constrained by RLS. Authenticated Studio/settings mutations use the SSR cookie client. SQL RPCs own transactional idea creation, typed connection creation, branching, and deletion requests. UI code never decides authorization or lineage integrity.

Canonical content uses `nodes` + append-only `node_versions`; relationships use indexed `edges`; immutable `lineage_links` are separate from normal edges. Map traversal is depth-one and capped, while Story view remains the accessible default/list equivalent.

See [product brief](docs/product-brief.md), [implementation plan](docs/implementation-plan.md), [data model](docs/data-model.md), [threat model](docs/threat-model.md), [route map](docs/route-map.md), and [ADRs](docs/decisions/).

## Security and privacy

- RLS on every public-schema table; explicit owner/editor/viewer tests
- private nodes excluded from anonymous reads; members not enumerable publicly
- immutable versions, lineage, and audit events
- cycle-checked `part_of`, same-graph edge validation, idempotent branches
- provider-host allowlists, structured text rendering, CSP and security headers
- email remains in managed auth; public profile/social identity is separate
- marketing consent is separate, unchecked, append-only, and reversible
- AI input scope is explicit; local adapters have no tools, secrets, or publish rights

## Known limitations

- Production OAuth/email/storage/virus scanning/rate limiting require deployment configuration and have no fake local success path.
- Capture UI demonstrates approval with deterministic drafts; canonical persistence is through authenticated Studio forms. Voice transcription is not configured.
- Editing a published idea into a second version and a full subgraph-branch UI are service/schema foundations, not polished creator flows.
- Spotify and Apple Music are allowlisted adapters; the synthetic seed uses SoundCloud fallback links only.
- Marketplace, checkout, seller verification, Stripe Connect, orders, entitlements, equity, and revenue sharing are disabled/deferred.
- Admin moderation UI, collaboration invites, comments, notifications, and native apps are out of scope.

## Deployment

Apply migrations to an isolated preview project, run the RLS suite, configure auth redirect allowlists/providers and operational prerequisites, deploy with marketplace disabled, then smoke-test anonymous and authenticated roles. See [operations](docs/operations.md).
