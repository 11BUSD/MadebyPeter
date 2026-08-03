import {z} from "zod";
export const mediaUrlSchema=z.url().transform(value=>new URL(value)).refine(url=>url.protocol==="https:","Media links must use HTTPS").refine(url=>["soundcloud.com","www.soundcloud.com","open.spotify.com","music.apple.com"].includes(url.hostname),"Unsupported media provider").transform(url=>({url:url.toString(),provider:url.hostname.includes("soundcloud")?"soundcloud" as const:url.hostname==="open.spotify.com"?"spotify" as const:"apple_music" as const}));
export const audioUploadSchema=z.object({type:z.enum(["audio/mpeg","audio/mp4","audio/wav","audio/webm","audio/ogg"]),size:z.number().int().max(20*1024*1024)});
export const imageUploadSchema=z.object({type:z.enum(["image/jpeg","image/png","image/webp"]),size:z.number().int().max(10*1024*1024)});
