# ADR 0005: Immutable versions and lineage

Status: Accepted

Canonical nodes point to append-only versions. Lineage is a dedicated append-only relation that snapshots source node, exact version, creator, mode, licence, and time. Reference/fork/remix operations run transactionally and idempotently; ordinary edges cannot substitute for lineage.
