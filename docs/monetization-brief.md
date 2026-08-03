# Monetization Brief: From Ideas to Useful Work

Status: product direction, not a production payment integration
Owner: Made by Peter
Marketplace flag: remains `false`

## Plain-language thesis

Made by Peter should earn money when it helps someone move from a useful idea to a useful outcome. OpenAI does not pay the site for generating tokens. API usage is a cost to the operator, so the product must charge for the surrounding value: organization, trusted context, collaboration, execution help, and distribution.

The clearest loop is:

1. A creator captures an idea privately.
2. The creator publishes only the summary they approve.
3. Other people reference, fork, or remix it with permanent attribution.
4. Optional AI tools help structure a branch, compare evidence, or plan a small test.
5. Revenue comes from subscriptions, paid credits, creator offerings, genuine affiliate recommendations, or a separately contracted build service.

Attribution is not ownership, and lineage is not an automatic promise of payment. Any contributor compensation needs a separate, understandable agreement.

## Recommended revenue ladder

### 1. Creator membership — first

Charge a monthly subscription for private graphs, larger limits, private collaboration, export, version history, and a modest allowance of AI-assisted structure work.

Why first: predictable revenue, easy to explain, and no marketplace or securities mechanics.

### 2. Metered AI credits — first

Include a small monthly allowance, show the estimated cost before running a tool, and sell additional credit packs. Price the feature for the outcome, while keeping a margin above API, storage, moderation, and payment costs.

Controls:

- per-user budgets and hard limits;
- small cost-efficient model by default;
- explicit confirmation before expensive work;
- no unrestricted autonomous agents;
- no claim that unused “tokens” are cash, transferable value, or an investment.

### 3. Paid creator rooms and build sprints — pilot

Let a creator sell access to a private idea room, office hours, a structured research pack, or a fixed-scope build sprint. Made by Peter can charge a platform/service fee. Start with manual approval and external invoicing or checkout, not an open marketplace.

### 4. Sponsored briefs and cash bounties — later

Organizations can post a clear problem and a fixed cash reward. Contributions remain attributed, judging criteria are published, and payment is handled under explicit terms. Avoid equity, tokens, investment contracts, or automated revenue ownership in the MVP.

### 5. Honest affiliate recommendations — pilot

An idea may recommend a tool, book, service, component, course, or product that genuinely helped. The recommendation can use a disclosed affiliate link.

Required behavior:

- set attribution only after a deliberate click;
- place “I may earn a commission if you buy through this link” beside the recommendation;
- label sponsored placement separately;
- do not change search/ranking because an item pays more;
- do not fire affiliate links, pixels, redirects, or cookies on hover, focus, page load, or touch-and-hold;
- minimize click analytics and honor the applicable consent requirements;
- follow each merchant/network’s current program terms.

Hover-based or invisible attribution is cookie stuffing and is excluded from the product.

### 6. A ChatGPT app/plugin — distribution, not guaranteed revenue

A future Made by Peter app can let a ChatGPT user search public graphs, open an idea, or create a private draft through a tightly scoped API. OpenAI’s current app terms allow a developer to link to an external checkout, subject to policies and law, but do not guarantee placement, traffic, revenue share, or publication.

The website remains the system of record and payment boundary. The app must not imply OpenAI endorsement or partnership.

## Suggested plans for testing

These are hypotheses, not final prices:

| Plan | Intended user | Included value |
|---|---|---|
| Free | explorer/new creator | public browsing, limited private capture, manual structure helper |
| Creator | active builder | more private graphs, collaboration, version history, monthly AI allowance |
| Studio | teams/clients | private rooms, permissions, export, audit, higher limits and support |
| Build sprint | founder/client | separately scoped service with milestones and a fixed fee |

Do not publish prices until API cost simulations, payment fees, support time, tax treatment, refund rules, and willingness-to-pay interviews are complete.

## Contributor compensation model

For the first pilot, use one of these explicit arrangements:

1. fixed cash bounty for an accepted contribution;
2. paid contract for a defined deliverable;
3. creator-controlled paid room with a disclosed platform fee;
4. referral commission under written terms.

Do not infer a right to revenue from a reference, fork, remix, like, view, prompt, or token count. Do not automate equity or royalty allocations in the MVP.

## Audos comparison

Audos positions itself as an AI-native venture-building platform: tools, guidance, community, and potential funding help everyday entrepreneurs move from an idea toward a revenue-generating business. The useful lesson is not “generate more ideas”; it is to support the full path from idea, to validation, to launch, to a paying customer.

Made by Peter should stay narrower and more trustworthy:

- provenance-first instead of portfolio automation;
- private working material separated from public summaries;
- small evidence-backed experiments before full builds;
- human approval at every publication and commercial boundary;
- no claim that AI can put a business on autopilot.

## Product phases

### Phase A — current build

- real authenticated capture persistence;
- truthful public empty states;
- sanitized public project showcase;
- no payment code;
- marketplace remains disabled.

### Phase B — revenue validation

- interview 10 potential creators;
- price-test Creator membership and build sprints;
- add cost metering and budgets without charging;
- add one or two disclosed affiliate recommendations by deliberate click;
- measure click-through and completed capture, not vanity impressions.

### Phase C — controlled payments

- legal/tax/privacy review;
- Stripe-hosted checkout and customer portal;
- subscriptions and credit ledger with refunds and spend caps;
- manual creator-room approval;
- no Connect payouts until KYC, disputes, taxes, moderation, and support are operational.

### Phase D — distribution

- publish a scoped ChatGPT app/plugin only after privacy review;
- expose public search and authenticated private-draft tools;
- use external checkout under the then-current OpenAI terms;
- monitor quality, abuse, cost, and conversion.

## Success metrics

- visitor to captured-private-draft conversion;
- percentage of drafts reviewed before publication;
- creator weekly retention;
- branches that reach a documented experiment or artifact;
- gross margin after model, storage, payment, and support costs;
- affiliate clicks and conversions from clearly disclosed recommendations;
- refund, dispute, abuse, and accidental-publication rates.

## Sources reviewed

- [OpenAI API and ChatGPT billing are separate](https://help.openai.com/en/articles/8156019-is-api-usage-included-in-chatgpt-subscriptions-even-if-i-have-a-paid-chatgpt-account)
- [OpenAI API models and token pricing](https://developers.openai.com/api/docs/models)
- [OpenAI App Developer Terms](https://openai.com/policies/developer-apps-terms/)
- [FTC affiliate and endorsement guidance](https://www.ftc.gov/business-guidance/resources/ftcs-endorsement-guides-what-people-are-asking)
- [Amazon Associates Operating Agreement](https://affiliate-program.amazon.com/help/operating/agreement/)
- [Audos public platform](https://mate.audos.com/)

Terms, prices, and program rules can change. Recheck them before implementing payments, affiliates, or a ChatGPT app.
