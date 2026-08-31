# Solari Evidence Factory

**A browser → sandbox → desktop research pipeline that turns a URL into a verifiable evidence artifact.**

Built as a real Solari use case: not a chatbot wrapper, not a scripted screenshot. The pipeline captures public web evidence in a cloud browser, builds a hash-addressed diligence artifact inside an isolated Solari sandbox, exposes it as a preview, then opens that preview on a Solari desktop for visual QA and captures proof.

## Why this exists

Research agents usually fail at the handoff between **seeing**, **building**, and **verifying**. Evidence Factory makes that handoff explicit:

```text
Target URL
   │
   ▼
Solari Browser ── capture page structure + links + provenance
   │
   ▼
SHA-256 evidence manifest
   │
   ▼
Solari Sandbox ── build isolated HTML dossier + public preview
   │
   ▼
Solari Desktop ── open GUI, visually QA result, capture screenshot
   │
   ▼
artifacts/{evidence.json, report.html, desktop-proof.png}
```

This is useful for vendor diligence, investment research, compliance evidence collection, QA of agent-generated sites, and any workflow where an agent must leave a human-inspectable audit trail.

## What it demonstrates

- **Cloud Browser:** real Playwright-compatible navigation and extraction on Solari infrastructure.
- **Sandbox:** isolated artifact generation and a live preview URL.
- **Desktop:** real GUI/computer-use validation with a screenshot as proof.
- **Provenance:** every capture gets a deterministic SHA-256 fingerprint.
- **Cleanup discipline:** browser client closes, sandbox is killed, desktop is destroyed.
- **Testability:** pure report logic has unit tests; live infrastructure is kept out of CI secrets.

## Run it

Prerequisites: Node 22+, Python 3.11+, and one Solari API key.

```bash
npm install
python3 -m pip install -r requirements.txt
export SOLARI_API_KEY=slr_live_...
./run_demo.sh https://example.com
```

The desktop step runs while the sandbox preview is alive. Watch the live desktop using the `streamUrl` printed to your terminal.

## Outputs

`artifacts/evidence.json` is the structured capture, `artifacts/report.html` is the generated diligence page, `artifacts/preview-url.txt` is the ephemeral Solari preview, and `artifacts/desktop-proof.png` is the GUI verification screenshot.

## Engineering choices

The browser capture intentionally gathers a compact, deterministic evidence surface instead of dumping full page HTML. That keeps the report inspectable and makes the hash meaningful. Untrusted page text is HTML-escaped before report generation. The sandbox owns the generated site and server process; the desktop is a separate verification boundary.

The demo also encodes the lifecycle details that matter in production: close the Node browser client so the event loop exits, explicitly `kill()` the sandbox VM, and `destroy()` the desktop session rather than merely dropping the local connection.

## Extend it into a software factory

The next layer is a queue of targets plus policy modules. Each job can run browser collectors, sandbox builders/tests, then desktop QA. Replace the fixed extractor with pluggable recipes (`company-diligence`, `release-smoke-test`, `procurement-evidence`, `web-regression`) and store manifests in object storage. The important invariant stays the same: **every autonomous action produces evidence a human can replay.**

## Safety / scope

This demo only visits URLs explicitly supplied by the operator and captures public page metadata/links. It does not bypass authentication, CAPTCHAs, rate limits, or access controls.

## Built with Solari

Solari Cookbook: https://github.com/solari-sdk/solari-cookbook

The cookbook describes one API key spanning cloud browsers, sandboxes, and desktops. This project composes all three into one end-to-end workflow.
