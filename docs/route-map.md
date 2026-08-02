# Route Map

| Route | Access | MVP behavior |
|---|---|---|
| `/` | public | Explore seeded public ideas |
| `/today` | public | Recent/featured public ideas, no paid rank |
| `/search` | public | Query discoverable public ideas |
| `/u/[username]` | public | Creator profile and featured graphs |
| `/u/[username]/graphs` | public | Creator's public graphs |
| `/g/[graphSlugOrId]` | visibility-aware | Story view |
| `/g/[graphSlugOrId]/map` | visibility-aware | Lazy, bounded Map view + list equivalent |
| `/i/[ideaSlugOrId]` | visibility-aware | Idea, media, sources, connections, actions |
| `/i/[ideaSlugOrId]/lineage` | visibility-aware | Sources and derivatives |
| `/i/[ideaSlugOrId]/opengraph-image` | public idea | Dynamic landscape share image |
| `/api/graphs/[graphId]/neighborhood` | visibility-aware | bounded progressive JSON traversal |
| `/api/share/[nodeId]/[format]` | public idea | square/vertical/landscape image |
| `/auth/sign-in`, `/auth/callback` | public | Supabase passwordless/OAuth entry/callback |
| `/new` | authenticated | Three-step capture |
| `/studio`, `/studio/graphs`, `/studio/graphs/[graphId]` | authenticated | creator workspace |
| `/studio/ideas/[nodeId]`, `/studio/branches`, `/studio/agents` | authenticated | edit, lineage history, draft agents |
| `/settings/profile`, `/settings/account`, `/settings/privacy`, `/settings/notifications`, `/settings/connected-accounts` | authenticated | identity, export/deletion, consent/preferences |
| `/made-real`, `/about`, `/terms`, `/privacy`, `/rights`, `/community-guidelines` | public | informational MVP pages |
| `/market`, `/market/[listingSlugOrId]`, `/studio/listings`, `/purchases`, `/settings/billing` | flag-gated | 404 while disabled; non-production boundary only |

Administrative routes are excluded from the MVP UI. Database administration remains explicit through Supabase roles and audit records.
