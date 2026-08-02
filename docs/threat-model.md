# Threat Model

## Assets and trust boundaries

Protected assets are private/unlisted graphs, authentication identities, provider tokens, private artifacts, immutable lineage/version records, agent scopes, consent history, and audit events. Trust boundaries exist at browser/server actions, server/Supabase RLS, storage, external media, AI/provider adapters, and future payment webhooks.

## Controls

| Threat | Primary control | Verification |
|---|---|---|
| IDOR/private leakage | RLS plus server authorization and visibility-filtered traversal | denied cross-user RLS/integration/E2E cases |
| Unauthorized edit | owner/editor policies; viewer is read-only | role matrix tests |
| Lineage removal/substitution | append-only triggers; transactional server function validates source version | mutation-denied and rollback tests |
| Stored XSS | structured plain-text content; React escaping; URL schemas; CSP | malicious payload tests and browser checks |
| Unsafe embeds | provider allowlist, parsed HTTPS hosts, sandboxed official players | provider validation tests |
| Malicious uploads | signed paths, MIME/signature/size policy, quarantine interface | adapter policy tests; production scanning documented |
| Email exposure/enumeration | auth provider responses, no email in profile/public selects | payload snapshots |
| Username impersonation | normalized unique index and reserved-name policy | database and validation tests |
| Account-link takeover | managed verified linking; no custom token linking | auth configuration review |
| CSRF | same-site auth cookies and origin checks on mutations | cross-origin action tests |
| Rate-limit bypass | server-side identity/IP keyed adapter and mutation idempotency | limiter unit tests |
| Secret exposure | server-only env modules; client env allowlist; secret scan | build/bundle/env review |
| Prompt injection | external input marked untrusted, explicit scopes, allowlisted tools, no secrets | deterministic adversarial agent tests |
| Forged webhooks/entitlement bypass | no live payment surface; future signature boundary | feature-flag and contract tests |
| Admin escalation | no MVP admin mutation UI; future explicit audited role | inaccessible route checks |
| Deceptive consent | unchecked controls, separate records, one-action withdrawal | accessibility/E2E tests |

## Residual risks

Supabase OAuth, email delivery, virus scanning, rate-limit persistence, and abuse moderation depend on production configuration not available locally. The app must fail closed and document these as deployment gates. Legal deletion-versus-lineage policy requires counsel before public launch.

## Security headers

CSP restricts scripts, frames, images, connections, and forms; `frame-ancestors 'none'`, `base-uri 'self'`, `object-src 'none'`, strict referrer policy, nosniff, and permissions policy are configured. SoundCloud/Spotify/Apple frame origins are the only media exceptions.
