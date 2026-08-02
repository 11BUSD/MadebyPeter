# Made by Peter / Idea Graph — Product Brief

## Decision

Build a conditional-go MVP: a public, multi-tenant catalog of branchable ideas whose core trust primitive is immutable, visible lineage. Peter's synthetic LNG catalog seeds discovery; accounts add private/public creation, typed connections, and reference/fork/remix flows. Marketplace transactions and production AI remain disabled.

## Public promise

Capture an idea, show how it connects, and let others grow it without losing where it came from.

## Users and jobs

- Visitors explore understandable stories without an account or graph vocabulary.
- Creators capture, publish, connect, and share ideas from a phone.
- Builders reference, fork, or remix public work with durable attribution.
- Collaborators access only graphs for which membership grants a role.

## MVP outcomes

1. Anonymous visitors can browse Peter's public profile, graph, ideas, music, sources, and lineage.
2. Authenticated users can create graphs and ideas with public, unlisted, or private visibility.
3. Story view is the resilient default; Map view progressively loads a bounded neighborhood and has a list equivalent.
4. Branch operations snapshot source version, creator, licence, mode, and timestamp without modifying the source.
5. Search indexes only discoverable public content.
6. Email consent is optional, explicit, versioned, and reversible.
7. Capture and Structure agents return deterministic, validated drafts and never publish.

## Success signals

- A first-time visitor reaches an idea detail from the home page without instruction.
- A creator publishes and connects an idea in under three capture steps.
- Every derivative has exactly one valid source-version lineage record per operation.
- No unauthorized actor can discover or retrieve private content.
- Primary routes pass keyboard, screen-reader semantics, WCAG AA automated checks, and mobile touch sizing.

## Assumptions

- This is a new repository; no existing application conventions exist to preserve.
- Supabase is the production identity/database/storage boundary; local deterministic fixtures allow development without credentials.
- OAuth providers are shown only when configured in Supabase and are not social-posting permissions.
- External media is embedded from an allowlist; audio is never downloaded or rehosted.
- Product copy is English for MVP.

## Non-goals

- Graph database, whole-graph rendering, model training, autonomous publishing, or unrestricted agents.
- Equity, securities, automated revenue share, live checkout, payouts, seller onboarding, or production Stripe Connect.
- Hidden pay-to-rank, cross-network automatic posting, or claims that mock adapters are live integrations.
- Comments, reactions, notifications, invites, moderation workflows, and native mobile apps.

## Release boundary

The MVP is mergeable when the migration can apply to an empty Supabase project, seed data loads, all static and database-backed checks pass, browser journeys pass at desktop/mobile widths, the production build succeeds, and operating limitations are documented.
