import Link from "next/link";
import type { PublicIdea } from "@/domain/graph/model";

const icons: Record<PublicIdea["type"],string> = {idea:"✦",song:"♫",research:"⌕",question:"?",goal:"↗",product:"□",system:"◎",person:"◯",place:"⌖",event:"◇",artifact:"▧",build:"⚒",collection:"▤"};
export function IdeaCard({idea}: {idea:PublicIdea}) {return <article className="idea-card">
  <div className="idea-meta"><span className="type-icon" aria-hidden="true">{icons[idea.type]}</span><span>{idea.type}</span><span>·</span><span>{idea.maturity}</span>{idea.media&&<span aria-label="Includes media">♫</span>}</div>
  <h3><Link href={`/i/${idea.slug}`}>{idea.title}</Link></h3><p>{idea.summary}</p>
  <div className="card-foot"><span>by {idea.creator.displayName}{idea.branchCount>0&&` · ${idea.branchCount} branches`}</span><Link href={`/i/${idea.slug}`} aria-label={`Open ${idea.title}`}>Open →</Link></div>
  </article>}
