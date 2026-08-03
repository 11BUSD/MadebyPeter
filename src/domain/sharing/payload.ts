import {z} from "zod";
const inputSchema=z.object({title:z.string().min(1),summary:z.string().min(1),creator:z.string().min(1),canonicalUrl:z.url()});
export function createSharePayload(raw:z.input<typeof inputSchema>){const input=inputSchema.parse(raw);return{title:input.title,text:`${input.summary} — by @${input.creator}`,url:input.canonicalUrl,shortCaption:`${input.title}: ${input.summary}`.slice(0,280),longCaption:`${input.title}\n\n${input.summary}\n\nBy @${input.creator}\n${input.canonicalUrl}`}}
