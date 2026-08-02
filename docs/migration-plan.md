# Migration Plan

## Sequence

1. Extensions, enums, utility functions, and updated-at triggers.
2. Identity/profile tables and auth-user profile trigger.
3. Graph, member, node, version, edge, position, content, social, consent, audit, and agent tables.
4. Deferred circular foreign keys (`graphs.root_node_id`, `nodes.current_version_id`).
5. Integrity functions: visibility, role checks, cycle detection, immutability, branch transaction.
6. Indexes for owner/slug, public discovery, adjacency, lineage, and full-text search.
7. Enable RLS on every public-schema table and install least-privilege policies.
8. Seed synthetic Peter/LNG data idempotently.

## Environments

- Local/CI: Supabase CLI applies migrations to an empty database, then seed and pgTAP tests.
- Preview: isolated Supabase project or branch; no production service key.
- Production: backup, apply forward migration, run smoke queries, then deploy application.

## Roll-forward strategy

MVP migrations are additive. If a release fails, application code rolls back while schema remains compatible. Destructive changes require a later expand/backfill/contract sequence. Enum removals, column drops, and lineage/version deletion are prohibited in routine rollback.

## Verification queries

- All public tables have RLS enabled and policies expected by the matrix.
- Anonymous can read seeded public records but cannot mutate.
- Two test users exercise owner/editor/viewer/private/unlisted/public cases.
- A `part_of` cycle and lineage update both fail.
- Branch retry with the same idempotency key produces one derivative.
- Public search cannot return unlisted/private rows.

## Production prerequisites

Configure auth redirect allowlists/providers, SMTP, CAPTCHA/rate limits, signed storage buckets/scanning, backups/PITR, log retention, privacy/legal policies, and incident contacts before public accounts are enabled.
