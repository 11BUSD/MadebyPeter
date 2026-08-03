import Link from "next/link";
export function MobileNav(){return <nav className="mobile-nav" aria-label="Mobile navigation"><Link href="/">Explore</Link><Link href="/new" className="add">＋<span>Add</span></Link><Link href="/g/energy-systems">My Graph</Link></nav>}
