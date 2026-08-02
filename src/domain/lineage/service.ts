import {z} from "zod";
export const branchRequestSchema=z.object({sourceNodeId:z.uuid(),targetGraphId:z.uuid(),mode:z.enum(["reference","fork","remix"]),idempotencyKey:z.string().min(8).max(120),title:z.string().trim().min(1).max(160).optional()});
export type LineageSnapshot={sourceNodeId:string;sourceVersionId:string;sourceCreatorId:string;mode:"reference"|"fork"|"remix";licenseSnapshot:Record<string,unknown>;createdAt:string};
export function mapLineageSnapshot(input:LineageSnapshot){return Object.freeze({...input,licenseSnapshot:Object.freeze({...input.licenseSnapshot})})}
