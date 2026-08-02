import type { PublicEdge } from "./model";

export function wouldCreatePartOfCycle(edges: PublicEdge[], sourceNodeId: string, targetNodeId: string) {
  if (sourceNodeId === targetNodeId) return true;
  const targets = new Map<string, string[]>();
  for (const edge of edges.filter((item) => item.relationType === "part_of")) {
    targets.set(edge.sourceNodeId, [...(targets.get(edge.sourceNodeId) ?? []), edge.targetNodeId]);
  }
  const pending = [targetNodeId];
  const visited = new Set<string>();
  while (pending.length) {
    const current = pending.pop()!;
    if (current === sourceNodeId) return true;
    if (visited.has(current)) continue;
    visited.add(current);
    pending.push(...(targets.get(current) ?? []));
  }
  return false;
}

export function boundedNeighborhood<T extends { id: string }>(items: T[], edges: PublicEdge[], focusId: string, limit = 7) {
  const capped = Math.min(Math.max(limit, 1), 25);
  const adjacent = edges.filter((edge) => edge.sourceNodeId === focusId || edge.targetNodeId === focusId);
  const ids = [focusId, ...adjacent.map((edge) => edge.sourceNodeId === focusId ? edge.targetNodeId : edge.sourceNodeId)];
  const uniqueIds = [...new Set(ids)];
  const visible = uniqueIds.slice(0, capped);
  const idSet = new Set(visible);
  return {
    nodes: visible.map((id) => items.find((item) => item.id === id)).filter((item): item is T => Boolean(item)),
    edges: adjacent.filter((edge) => idSet.has(edge.sourceNodeId) && idSet.has(edge.targetNodeId)),
    truncated: uniqueIds.length > capped,
    totalNeighbors: Math.max(0, uniqueIds.length - 1),
  };
}
