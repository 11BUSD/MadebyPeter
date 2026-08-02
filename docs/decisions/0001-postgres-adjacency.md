# ADR 0001: Postgres adjacency model

Status: Accepted

Use Postgres `nodes` and indexed `edges` with bounded recursive CTEs. This keeps RLS, transactions, versions, lineage, and search in one system through the first measured scale target. A graph database is deferred until observed query latency or traversal complexity justifies operational duplication.
