import Link from "next/link";
import { IdeaCard } from "@/components/idea-card";
import { showcaseProjects } from "@/domain/showcase/projects";
import { getFeaturedGraph, getFeaturedIdeas } from "@/lib/public-data";

export default async function Home() {
  const [featured, featuredGraph] = await Promise.all([getFeaturedIdeas(), getFeaturedGraph()]);
  const exploreHref = featuredGraph ? `/g/${featuredGraph.slug}` : "/made-real";

  return <main id="main"><div className="shell">
    <section className="hero">
      <div><p className="eyebrow">A branchable record of ideas</p><h1>Ideas grow better with their roots intact.</h1></div>
      <div><p className="lede">Explore what Peter is learning, making, and leaving open for someone else to grow.</p><div className="actions"><Link className="button" href={exploreHref}>{featuredGraph ? "Explore ideas" : "See what’s being built"}</Link><Link className="button secondary" href="/new">Add an idea</Link></div></div>
    </section>
    {featuredGraph && featured.length > 0 ? <section className="section" aria-labelledby="featured">
      <div className="section-head"><div><p className="eyebrow">Start with a story</p><h2 id="featured">{featuredGraph.title}</h2></div><Link href={`/u/${featuredGraph.owner.username}`}>Meet {featuredGraph.owner.displayName} →</Link></div>
      <div className="idea-grid">{featured.map(idea => <IdeaCard key={idea.id} idea={idea} />)}</div>
    </section> : <section className="section" aria-labelledby="building-now">
      <div className="section-head"><div><p className="eyebrow">Building now</p><h2 id="building-now">Proof before promises.</h2></div><Link href="/made-real">See the projects →</Link></div>
      <div className="project-grid">{showcaseProjects.map(project => <article className="project-card" key={project.id}><p className="eyebrow">{project.category}</p><h3><Link href={`/made-real#${project.id}`}>{project.name}</Link></h3><p>{project.summary}</p><p className="status-line">{project.status}</p></article>)}</div>
    </section>}
  </div></main>;
}
