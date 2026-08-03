import {createHash} from "node:crypto";
export function versionHash(input:{title:string;summary:string;content:unknown}){return createHash("sha256").update(`${input.title}\n${input.summary}\n${JSON.stringify(input.content)}`).digest("hex")}
