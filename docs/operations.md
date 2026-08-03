# Operations and Release Runbook

## Pre-deploy

1. Create an isolated Supabase preview project and enable backups/PITR appropriate to the environment.
2. Apply all migrations in order and run the seed only outside production.
3. Configure allowed auth redirects, passwordless SMTP, selected OAuth providers, CAPTCHA, and rate limits.
4. Configure private storage buckets, signed URL TTLs, MIME/signature validation, quarantine/virus scanning, and retention.
5. Set environment variables in the deployment platform; verify no service-role key is exposed as `NEXT_PUBLIC_*`.
6. Keep `FEATURE_MARKETPLACE=false`.
7. Run install, typecheck, lint, unit/integration, pgTAP, Playwright/axe, build, and production dependency audit.

## Deploy and smoke test

- Verify `/`, `/u/peter`, `/g/energy-systems`, Map, music idea, search, lineage, auth callback, and marketplace 404.
- Use separate owner/editor/viewer accounts to verify private graph permissions.
- Confirm public JSON/HTML does not contain auth email, member lists, private IDs, or service credentials.
- Check CSP, browser console, API status codes, auth logs, slow queries, and error-monitoring adapter.

## Rollback

Roll back application deployment first; migrations are additive and forward-only. Correct database defects with a new migration—never delete version, lineage, or audit history. Disable affected feature routes server-side while correcting data policies.

## Incidents

For suspected private-data exposure, disable writes/public access at the platform edge, preserve audit logs, rotate affected credentials, identify policy/query scope, notify the privacy/security owner, and follow the approved breach process. Do not place private payloads in tickets or chat.

## Launch blockers

No production launch until legal/privacy text, lineage-versus-erasure policy, abuse reporting, monitoring/alerts, backup restore test, SMTP deliverability, OAuth takeover review, upload scanning, persistent rate limiting, and incident contacts are approved.
