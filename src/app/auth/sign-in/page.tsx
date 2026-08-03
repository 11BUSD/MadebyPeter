import Link from "next/link";
import { sendMagicLink } from "./actions";

export default async function SignInPage({ searchParams }: { searchParams: Promise<{status?: string; error?: string; next?: string}> }) {
  const state = await searchParams;
  const safeNext = state.next?.startsWith("/") && !state.next.startsWith("//") ? state.next : "/studio";
  return <main className="narrow stack">
    <Link href="/" className="eyebrow">← Made by Peter</Link>
    <h1>Sign in to grow ideas</h1>
    <p className="lede">Use a private magic link. Signing in never gives us permission to post to another network.</p>
    {state.status === "check-email" && <p role="status" className="notice">If that address can receive mail, a sign-in link is on its way.</p>}
    {state.status === "demo" && <p role="status" className="notice">Local fixture mode: email delivery is not configured.</p>}
    {state.error && <p role="alert" className="error">That link could not be completed. Please try again.</p>}
    <form action={sendMagicLink} className="panel stack">
      <input type="hidden" name="next" value={safeNext} />
      <label htmlFor="email">Email address</label>
      <input id="email" name="email" type="email" autoComplete="email" required />
      <button type="submit">Email me a sign-in link</button>
      <p className="fine">Marketing email is separate and off by default.</p>
    </form>
  </main>;
}
