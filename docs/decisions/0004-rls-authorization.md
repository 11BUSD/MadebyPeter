# ADR 0004: Authorization and RLS

Status: Accepted

Postgres RLS is the final data boundary, supplemented by server-side domain authorization for clear errors and transaction orchestration. Public, unlisted, private, and graph-member roles have explicit policies. Service-role credentials are server-only and not used to bypass user-facing checks.
