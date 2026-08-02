# Data Model

## Principles

Postgres UUID keys, UTC timestamps, strict foreign keys, explicit enums/checks, soft deletion for mutable public records, and append-only versions/audit/lineage. `edges` provide adjacency; presentation coordinates remain in `graph_node_positions`.

## Ownership and visibility

`auth.users` owns one private authentication identity and one public `profiles` record. `graphs.owner_id` is canonical ownership; `graph_members` grants editor/commenter/viewer access. Effective node visibility can only be as permissive as its graph. Public discovery requires graph and node to be public, node published, and neither deleted.

## Canonical tables

| Area | Tables | Integrity notes |
|---|---|---|
| Identity | `profiles`, `social_links`, `email_consents` | usernames normalized case-insensitively; email stays in auth schema |
| Graph | `graphs`, `graph_members`, `nodes`, `edges`, `graph_node_positions` | endpoints must belong to edge graph; `part_of` cycle checked |
| History | `node_versions`, `lineage_links`, `audit_events` | append-only; lineage snapshots source version/creator/licence |
| Content | `artifacts`, `node_artifacts`, `sources`, `node_sources` | embeds allowlisted; private storage uses signed URLs |
| Social | `bookmarks`, `follows` | exactly one follow target |
| Agents | `agent_definitions`, `agent_versions`, `agent_runs` | run scope and source manifest recorded; draft outputs only |

Marketplace records are TypeScript contracts and a documented future migration, not live MVP tables.

## Critical invariants

- Published versions cannot be updated or deleted.
- `nodes.current_version_id` points to a version belonging to the same node.
- Lineage rows cannot be updated/deleted through client roles.
- A derivative never overwrites its source and snapshots the exact source version.
- `part_of` cannot connect a node to itself or create a transitive cycle.
- Fork/remix requests use an owner-scoped idempotency key.
- Unlisted records are accessible by exact identifier but excluded from public search/listing.
- Private reads require ownership or active graph membership.

## Traversal

Neighborhood reads default to depth 1 and 7 visible nodes (focus plus up to 6 neighbors), with hard depth and node-count caps. Traversal filters visibility before returning records and reports truncation/cluster counts rather than sending the whole graph.

## Deletion

Graphs/nodes use soft deletion. Account deletion begins as an auditable request; a later privileged worker performs erasure/anonymization. Public source removal may retain only a policy-approved minimal lineage tombstone. Immutable audit metadata must not contain secrets or raw email addresses.
