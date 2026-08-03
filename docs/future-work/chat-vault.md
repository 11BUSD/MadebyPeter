# Future Work: Private Chat Vault

Status: **deferred**

Trigger: the owner receives and locally provides an official ChatGPT export

Production claim: none

## Goal

Let the owner turn an official conversation export into organized, reviewable ideas without exposing raw chats, private reasoning, personal data, or unpublished strategy.

This is not a direct ChatGPT-account integration. The application and coding assistant do not have access to the owner’s complete ChatGPT history. Work begins only when the owner supplies an export file through an approved local/private import flow. Credentials or session cookies must never be requested.

## Privacy contract

1. Imports are private by default and belong only to the importing account.
2. Raw exports are never committed to Git, bundled into a deployment, logged, used as public seed data, or sent to an unspecified model/provider.
3. Extraction creates reviewable candidates, not published ideas.
4. Publishing requires a separate human preview and explicit confirmation for each summary.
5. Hidden UI is not a security boundary. Private content requires database authorization/RLS; sensitive raw archives should also use private encrypted storage and short-lived signed access.
6. The owner can delete the raw import, derived candidates, or both, and can export an audit of what was retained or published.
7. Public pages contain no raw chat excerpts, private identifiers, model metadata, or links back to the source conversation unless the owner explicitly approves them.

## Proposed flow

1. Select the official export ZIP locally.
2. Show file scope, approximate conversation count, date range, and privacy notice before processing.
3. Parse into a quarantined private import with content hashes for deduplication.
4. Let the owner exclude conversations and mark sensitive groups before any AI-assisted work.
5. Produce deterministic/high-level clusters and candidate summaries with source pointers visible only to the owner.
6. Review, edit, merge, discard, or keep each candidate private.
7. Publish only an approved summary into a selected graph; preserve an internal audit record without exposing the raw source.
8. Delete or retain the raw import according to the owner’s chosen policy.

## Required design and engineering work

- Threat model for export ZIPs, HTML/JSON parsing, archive bombs, malicious attachments, prompt injection, cross-tenant access, and accidental publication.
- Strict size/count limits, MIME and archive validation, quarantine, malware scanning, and safe text extraction.
- Private import, conversation, candidate, source-pointer, retention, consent, and audit tables with complete RLS tests.
- Feature flag and owner-only pilot; no broad rollout until deletion/restore and incident paths are tested.
- Provider decision and data-processing disclosure before any remote AI use. Prefer local/deterministic processing for classification that does not require a model.
- Redaction assistance for emails, phone numbers, addresses, secrets, credentials, and third-party personal data.
- Two-step publication preview that clearly separates a public summary from private source material.
- Unit, integration, RLS, accessibility, large-import, malformed-archive, deduplication, deletion, and Playwright tests.

## Acceptance gates

- A second account cannot enumerate, read, search, or infer another user’s imports or candidates.
- Anonymous/public clients receive no import metadata.
- Refresh/retry is idempotent and does not duplicate conversations or candidates.
- Deleting the raw import removes access according to the documented retention policy without silently deleting already approved public ideas.
- Every public idea created from an import has an explicit owner approval event.
- A security/privacy review and a backup/restore exercise pass before the feature is enabled beyond the owner account.

## Inputs needed later

- The official export ZIP as a local file path, not uploaded to Git or pasted into chat.
- The owner’s retention choice: delete raw chats after extraction or keep encrypted for a stated period.
- The owner’s provider choice, if remote AI processing is desired.
- A short list of conversations or topics that must always be excluded.
- Approval of the final public-summary workflow and disclosure language.
