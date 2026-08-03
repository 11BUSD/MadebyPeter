"use client";

import { useEffect, useState, type FormEvent } from "react";
import type { z } from "zod";
import { captureOutputSchema } from "@/domain/agents/contracts";
import type { Visibility } from "@/domain/graph/model";
import { mediaUrlSchema } from "@/domain/media/providers";

type Draft = z.infer<typeof captureOutputSchema>;
type Kind = "text" | "voice" | "photo" | "link" | "song";
type GraphOption = { id: string; title: string; visibility: Visibility };
type StoredCapture = {
  version: 1;
  draft: Draft;
  kind: Kind;
  url: string;
  graphId: string;
  visibility: Visibility;
  publish: boolean;
  idempotencyKey: string;
};

const draftStorageKey = "made-by-peter.capture-draft.v1";

export function CaptureFlow({
  source,
  published,
  configured,
  authenticated,
  resume,
  graphs,
}: {
  source?: string;
  published: boolean;
  configured: boolean;
  authenticated: boolean;
  resume: boolean;
  graphs: GraphOption[];
}) {
  const [step, setStep] = useState<1 | 2 | 3>(1);
  const [kind, setKind] = useState<Kind>("text");
  const [text, setText] = useState(source ? `A new direction growing from ${source}` : "");
  const [url, setUrl] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [draft, setDraft] = useState<Draft | null>(null);
  const [graphId, setGraphId] = useState(graphs[0]?.id || "");
  const [visibility, setVisibility] = useState<Visibility>("private");
  const [publish, setPublish] = useState(false);
  const [idempotencyKey, setIdempotencyKey] = useState(() => crypto.randomUUID());
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [saved, setSaved] = useState(published);

  useEffect(() => {
    if (!resume) return;
    const timer = window.setTimeout(() => {
      try {
        const stored = JSON.parse(sessionStorage.getItem(draftStorageKey) || "null") as Partial<StoredCapture> | null;
        const parsedDraft = captureOutputSchema.safeParse(stored?.draft);
        if (!stored || stored.version !== 1 || !parsedDraft.success) return;
        setDraft(parsedDraft.data);
        setKind(stored.kind || "text");
        setUrl(typeof stored.url === "string" ? stored.url : "");
        setGraphId(typeof stored.graphId === "string" && graphs.some(graph => graph.id === stored.graphId) ? stored.graphId : graphs[0]?.id || "");
        setVisibility(stored.visibility === "public" || stored.visibility === "unlisted" ? stored.visibility : "private");
        setPublish(Boolean(stored.publish));
        if (typeof stored.idempotencyKey === "string") setIdempotencyKey(stored.idempotencyKey);
        setStep(3);
      } catch {
        sessionStorage.removeItem(draftStorageKey);
      }
    }, 0);
    return () => window.clearTimeout(timer);
  }, [graphs, resume]);

  async function createDraft(event: FormEvent) {
    event.preventDefault();
    setBusy(true);
    setError("");
    try {
      if (kind === "song" && url && !mediaUrlSchema.safeParse(url).success) {
        throw new Error("Use a public SoundCloud, Spotify, or Apple Music HTTPS link.");
      }
      const form = new FormData();
      form.set("kind", kind);
      form.set("text", text);
      if (url) form.set("url", url);
      if (file) form.set("file", file);
      const response = await fetch("/api/agents/capture", { method: "POST", body: form });
      const body = await response.json();
      if (!response.ok) throw new Error(body.error);
      setDraft(body.output);
      setStep(2);
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "Could not prepare the draft.");
    } finally {
      setBusy(false);
    }
  }

  function rememberForSignIn() {
    if (!draft) return;
    const stored: StoredCapture = { version: 1, draft, kind, url, graphId, visibility, publish, idempotencyKey };
    sessionStorage.setItem(draftStorageKey, JSON.stringify(stored));
    window.location.assign(`/auth/sign-in?next=${encodeURIComponent("/new?resume=1")}`);
  }

  async function saveIdea() {
    if (!draft) return;
    if (!configured) {
      setSaved(true);
      return;
    }
    if (!authenticated) {
      rememberForSignIn();
      return;
    }

    setBusy(true);
    setError("");
    try {
      const description = [draft.cleanedTranscript, url ? `Source link: ${url}` : ""].filter(Boolean).join("\n\n");
      const response = await fetch("/api/ideas", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          graphId: graphId || null,
          title: draft.title,
          summary: draft.summary,
          description,
          nodeType: draft.suggestedNodeType,
          visibility,
          publish,
          idempotencyKey,
        }),
      });
      if (response.status === 401) {
        rememberForSignIn();
        return;
      }
      const body = await response.json();
      if (!response.ok) throw new Error(body.error || "The idea could not be saved.");
      sessionStorage.removeItem(draftStorageKey);
      window.location.assign(`/studio/ideas/${body.nodeId}?status=saved`);
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "The idea could not be saved.");
    } finally {
      setBusy(false);
    }
  }

  if (saved) return <section className="panel stack" aria-live="polite">
    <p className="eyebrow">Saved locally for review</p>
    <h2>Your draft is ready.</h2>
    <p>Fixture mode does not persist accounts or ideas. Configure Supabase and sign in to publish canonical content.</p>
    <button onClick={() => { setSaved(false); setStep(1); setIdempotencyKey(crypto.randomUUID()); }}>Add another</button>
  </section>;

  const selectedGraph = graphs.find(graph => graph.id === graphId);
  const publicAllowed = selectedGraph?.visibility === "public";

  return <section className="capture panel stack" aria-label={`Capture step ${step} of 3`}>
    <p className="fine">Step {step} of 3 · deterministic draft helper</p>
    {step === 1 && <form onSubmit={createDraft} className="stack">
      <fieldset>
        <legend>How do you want to start?</legend>
        <div className="capture-kinds">
          {(["text", "voice", "photo", "link", "song"] as Kind[]).map(value => <label key={value} className={kind === value ? "selected" : ""}>
            <input type="radio" name="kind" value={value} checked={kind === value} onChange={() => setKind(value)} />
            <span>{value === "text" ? "Type" : value === "voice" ? "Speak" : value === "photo" ? "Photo" : value === "link" ? "Link" : "Song"}</span>
          </label>)}
        </div>
      </fieldset>
      {kind === "voice" && <>
        <label htmlFor="voice">Voice note</label>
        <input id="voice" type="file" accept="audio/mpeg,audio/mp4,audio/wav,audio/webm,audio/ogg" onChange={event => setFile(event.target.files?.[0] || null)} />
        <p className="fine">Maximum 20 MB. The local adapter does not transcribe audio.</p>
      </>}
      {kind === "photo" && <>
        <label htmlFor="photo">Photo</label>
        <input id="photo" type="file" accept="image/jpeg,image/png,image/webp" onChange={event => setFile(event.target.files?.[0] || null)} />
      </>}
      {(kind === "link" || kind === "song") && <>
        <label htmlFor="capture-url">{kind === "song" ? "SoundCloud, Spotify, or Apple Music link" : "Public HTTPS link"}</label>
        <input id="capture-url" type="url" value={url} onChange={event => setUrl(event.target.value)} required />
      </>}
      <label htmlFor="capture-text">{kind === "text" ? "What is the idea?" : "Add a short note"}</label>
      <textarea id="capture-text" value={text} onChange={event => setText(event.target.value)} rows={5} required={kind !== "voice"} maxLength={10_000} />
      {error && <p role="alert" className="error">{error}</p>}
      <button disabled={busy}>{busy ? "Preparing…" : "Prepare my draft"}</button>
    </form>}
    {step === 2 && draft && <div className="stack">
      <p className="eyebrow">Draft for your approval</p>
      <label htmlFor="draft-title">Is this title right?</label>
      <input id="draft-title" value={draft.title} onChange={event => setDraft({ ...draft, title: event.target.value })} maxLength={160} />
      <label htmlFor="draft-summary">One-sentence idea</label>
      <textarea id="draft-summary" value={draft.summary} onChange={event => setDraft({ ...draft, summary: event.target.value })} rows={3} maxLength={400} />
      {draft.missingQuestions.map(question => <p className="notice" key={question}>{question}</p>)}
      <p className="fine">Draft-only · local-rules-v1 · no sources used · estimated cost $0</p>
      <div className="actions">
        <button className="secondary" onClick={() => setStep(1)}>Back</button>
        <button onClick={() => setStep(3)}>Looks right</button>
      </div>
    </div>}
    {step === 3 && draft && <div className="stack">
      <p className="eyebrow">Ready when you are</p>
      <h2>{draft.title}</h2>
      {graphs.length > 0 ? <>
        <label htmlFor="capture-graph">Add to graph</label>
        <select id="capture-graph" value={graphId} onChange={event => { setGraphId(event.target.value); setVisibility("private"); setPublish(false); }}>
          {graphs.map(graph => <option value={graph.id} key={graph.id}>{graph.title} · {graph.visibility}</option>)}
        </select>
      </> : <p className="notice">Your first save will create a private graph called “My Ideas.”</p>}
      <label htmlFor="visibility">Who can see it?</label>
      <select id="visibility" value={visibility} onChange={event => { setVisibility(event.target.value as Visibility); if (event.target.value === "private") setPublish(false); }}>
        <option value="private">Only me</option>
        <option value="unlisted">Anyone with the link</option>
        <option value="public" disabled={!publicAllowed}>Everyone{!publicAllowed ? " · requires a public graph" : ""}</option>
      </select>
      <label className="check"><input type="checkbox" checked={publish} onChange={event => setPublish(event.target.checked)} /> Publish now (otherwise keep as a draft)</label>
      <p className="fine">Publishing is a human action. The draft helper cannot publish for you.</p>
      {!authenticated && configured && <p className="notice">We will hold this draft only in this browser while you sign in.</p>}
      {error && <p role="alert" className="error">{error}</p>}
      <div className="actions">
        <button className="secondary" onClick={() => setStep(2)}>Back</button>
        <button onClick={saveIdea} disabled={busy}>{busy ? "Saving…" : authenticated || !configured ? "Save idea" : "Sign in to save"}</button>
      </div>
    </div>}
  </section>;
}
