# Risk and Test Matrix

| Risk | Severity | Probability | Preventive control | Required evidence | Owner |
|---|---:|---:|---|---|---|
| Private content leaks | critical | medium | RLS + visibility-filtered queries | RLS, integration, E2E denied paths | Backend/Security |
| Lineage can be forged/removed | critical | medium | append-only table + transactional function | SQL and domain tests | Backend |
| Branch partially commits | high | low | single transaction + idempotency | rollback/retry integration tests | Backend |
| `part_of` cycle | medium | medium | recursive constraint trigger | unit + SQL tests | Backend |
| Unsafe media/embed | high | medium | HTTPS provider allowlist + sandbox | URL property tests/browser CSP | Security |
| Mock described as production | high | medium | explicit adapter metadata/UI labels | contract/copy tests | Product/QA |
| Graph overwhelms browser | high | medium | hard traversal caps + lazy Map | large fixture/performance E2E | Frontend |
| Map excludes disabled users | high | medium | Story default + list equivalent | keyboard/axe/mobile tests | Accessibility |
| Consent is bundled/deceptive | high | low | separate unchecked controls/history | E2E + state transition tests | Privacy |
| Email or secret in payload | critical | low | server-only env and curated selects | payload/bundle/secret review | Security |
| Search reveals unlisted data | critical | medium | public predicate in SQL | integration/RLS tests | Backend |
| OAuth linking takeover | critical | low | managed verified identities only | configuration checklist | Identity |
| Dependency vulnerability | high | medium | pinned lockfile/audit review | `npm audit` report | Release |
| External provider outage | medium | medium | fallback links and adapter errors | browser/provider failure tests | Frontend |
| Feature-flag bypass | high | low | server-side flag evaluation/404 | route and build tests | Backend |

The release manager owns closure of every evidence column; unresolved critical risks block production launch.
