import Link from "next/link";

export function SiteHeader() {
  return <header className="site-header">
    <Link href="/" className="brand" aria-label="Made by Peter home"><span aria-hidden="true">●</span> Made by Peter</Link>
    <nav aria-label="Primary navigation" className="desktop-nav">
      <Link href="/">Explore</Link><Link href="/g/energy-systems">My Graph</Link><Link href="/made-real">Made Real</Link><Link href="/search">Search</Link><Link className="button small" href="/new">Add idea</Link>
    </nav>
  </header>;
}
