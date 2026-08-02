# ADR 0007: Marketplace feature boundary

Status: Accepted

Marketplace routes and TypeScript contracts exist behind a server-side disabled-by-default flag. No seller, order, payment, payout, entitlement, equity, or securities operations are implemented. Future Stripe Connect integration must add verified webhooks, seller verification, rights, tax, dispute, and audit migrations before activation.
