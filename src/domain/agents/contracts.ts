import {z} from "zod";
import {nodeTypeSchema,visibilitySchema} from "@/domain/graph/model";

export const agentScopeSchema=z.object({graphIds:z.array(z.string()).max(10).default([]),nodeIds:z.array(z.string()).max(50).default([]),includesPrivate:z.boolean().default(false)});
export const captureInputSchema=z.object({kind:z.enum(["text","voice","photo","link","song"]),text:z.string().trim().max(10_000).default(""),url:z.url().optional(),scope:agentScopeSchema});
export const captureOutputSchema=z.object({title:z.string().min(1).max(160),summary:z.string().min(1).max(400),cleanedTranscript:z.string(),suggestedNodeType:nodeTypeSchema,suggestedConnections:z.array(z.object({title:z.string(),relationType:z.string()})).max(6),suggestedVisibility:visibilitySchema,missingQuestions:z.array(z.string()).max(5)});
export const structureOutputSchema=z.object({possibleParent:z.string().nullable(),childIdeas:z.array(z.string()).max(6),relationTypes:z.array(z.string()).max(6),duplicateWarning:z.string().nullable(),tags:z.array(z.string()).max(8),suggestedMaturity:z.enum(["spark","concept","opportunity","blueprint","institutional"])});

export type AgentEnvelope<T>={draftOnly:true;provider:"deterministic-mock";model:"local-rules-v1";status:"completed";estimatedCost:0;sourceManifest:[];output:T};
export interface CaptureAgent{run(input:z.infer<typeof captureInputSchema>):Promise<AgentEnvelope<z.infer<typeof captureOutputSchema>>>}
export interface StructureAgent{run(input:z.infer<typeof captureOutputSchema>):Promise<AgentEnvelope<z.infer<typeof structureOutputSchema>>>}
