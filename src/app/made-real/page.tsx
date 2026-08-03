import Link from "next/link";
import { showcaseProjects } from "@/domain/showcase/projects";

export default function MadeReal() {
  return <main id="main" className="shell">
    <section className="hero compact-hero">
      <div><p className="eyebrow">Made real</p><h1>Small proofs, honestly shown.</h1></div>
      <div><p className="lede">Projects move from a question to a synthetic demonstration, then toward a controlled pilot only after the evidence and permissions are ready.</p><Link className="button secondary" href="/new">Capture a related idea</Link></div>
    </section>
    <section className="section project-stack" aria-label="Current projects">
      {showcaseProjects.map(project => <article className="project-detail" id={project.id} key={project.id}>
        <div><p className="eyebrow">{project.category}</p><h2>{project.name}</h2><p className="lede">{project.summary}</p></div>
        <div className="panel stack"><p className="status-line">{project.status}</p><ul>{project.highlights.map(highlight => <li key={highlight}>{highlight}</li>)}</ul><p className="fine"><strong>Boundary:</strong> {project.boundary}</p><Link href={`/new?source=${encodeURIComponent(project.name)}`}>Grow an idea from this →</Link></div>
      </article>)}
    </section>
  </main>;
}
