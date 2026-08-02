import { z } from "zod";

export const visibilitySchema = z.enum(["public", "unlisted", "private"]);
export const nodeTypeSchema = z.enum(["idea","song","research","question","goal","product","system","person","place","event","artifact","build","collection"]);
export const relationTypeSchema = z.enum(["part_of","related_to","expands","requires","enables","explains","supports","challenges","contradicts","soundtrack_for","built_by","builds_on","produces","derived_from"]);

export const ideaInputSchema = z.object({
  title: z.string().trim().min(1).max(160),
  summary: z.string().trim().min(1).max(400),
  description: z.string().trim().max(10_000).default(""),
  nodeType: nodeTypeSchema.default("idea"),
  visibility: visibilitySchema.default("private"),
  mediaUrl: z.url().optional(),
});

export type Visibility = z.infer<typeof visibilitySchema>;
export type NodeType = z.infer<typeof nodeTypeSchema>;
export type RelationType = z.infer<typeof relationTypeSchema>;

export type PublicProfile = { id: string; username: string; displayName: string; bio: string };
export type PublicGraph = { id: string; slug: string; title: string; description: string; owner: PublicProfile; rootNodeId: string };
export type PublicIdea = {
  id: string; slug: string; graphId: string; title: string; summary: string; description: string;
  type: NodeType; maturity: string; creator: PublicProfile; publishedAt: string; branchCount: number;
  media?: { provider: "soundcloud" | "spotify" | "apple_music"; url: string; title: string };
  sources?: { title: string; url: string; publisher: string }[];
};
export type PublicEdge = { id: string; sourceNodeId: string; targetNodeId: string; relationType: RelationType };
export type Neighborhood = { focus: PublicIdea; nodes: PublicIdea[]; edges: PublicEdge[]; truncated: boolean; totalNeighbors: number };
