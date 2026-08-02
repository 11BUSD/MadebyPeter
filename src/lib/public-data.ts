import { notFound } from "next/navigation";
import { boundedNeighborhood } from "@/domain/graph/algorithms";
import { edges, energyGraph, ideas, peter } from "@/domain/graph/fixtures";

// Local fixtures are explicitly synthetic. A configured deployment may replace this
// repository with Supabase queries without changing route/component contracts.
export async function getFeaturedIdeas() { return ideas.slice(0, 9); }
export async function getProfile(username: string) { if (username.toLowerCase() !== peter.username) notFound(); return peter; }
export async function getCreatorGraphs(username: string) { await getProfile(username); return [energyGraph]; }
export async function getGraph(slug: string) { if (slug !== energyGraph.slug && slug !== energyGraph.id) notFound(); return energyGraph; }
export async function getIdea(slug: string) { const idea=ideas.find((item)=>item.slug===slug||item.id===slug); if(!idea) notFound(); return idea; }
export async function getGraphIdeas(graphId: string) { if(graphId!==energyGraph.id) notFound(); return ideas; }
export async function getConnections(nodeId: string) {
  const connectedEdges=edges.filter((edge)=>edge.sourceNodeId===nodeId||edge.targetNodeId===nodeId);
  return connectedEdges.map((edge)=>({ edge, idea: ideas.find((item)=>item.id===(edge.sourceNodeId===nodeId?edge.targetNodeId:edge.sourceNodeId))! }));
}
export async function getNeighborhood(graphId:string,focusId:string,limit=7) {
  if(graphId!==energyGraph.id) notFound(); const focus=ideas.find((item)=>item.id===focusId); if(!focus) notFound();
  return { focus, ...boundedNeighborhood(ideas,edges,focusId,limit) };
}
export async function searchIdeas(query:string) { const q=query.trim().toLocaleLowerCase(); return q ? ideas.filter((idea)=>`${idea.title} ${idea.summary}`.toLocaleLowerCase().includes(q)).slice(0,20) : []; }
