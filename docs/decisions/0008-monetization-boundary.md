# ADR 0008: Monetization Is Explicit, Outcome-Based, and Disabled by Default

## Status

Accepted for product planning; payment implementation deferred.

## Decision

The MVP may document interfaces for subscriptions, usage credits, creator rooms, bounties, affiliate recommendations, and external checkout, but it will not enable a marketplace or payment flow until the existing launch gates and a separate commercial review pass.

OpenAI API usage is treated as an operating cost. The product may charge for a service or allowance that uses the API, but will not describe API tokens as user property, cash, a security, or guaranteed earnings.

Affiliate attribution requires an intentional click and a clear nearby commission disclosure. Hover, focus, page-load, invisible-image, forced-redirect, or touch-and-hold attribution is prohibited.

Idea references, forks, and remixes preserve attribution and lineage but do not create automatic equity, royalties, ownership, or revenue rights. Contributor payments require a separate explicit agreement.

## Consequences

- `FEATURE_MARKETPLACE` stays `false`.
- No hidden pay-to-rank mechanism is allowed.
- Initial revenue validation focuses on creator subscriptions, cost-controlled AI allowances, and separately contracted build services.
- Stripe Connect, payouts, tax reporting, KYC, disputes, entitlements, and order ledgers remain future interfaces only.
- A future ChatGPT app is a distribution channel and cannot imply OpenAI endorsement or guaranteed revenue.
