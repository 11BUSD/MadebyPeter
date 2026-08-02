export type ConsentEvent={status:"granted"|"withdrawn";capturedAt:string;withdrawnAt:string|null};
export function transitionConsent(current:ConsentEvent|undefined,granted:boolean,now:string):ConsentEvent{if(current&&(current.status==="granted")===granted)return current;return granted?{status:"granted",capturedAt:now,withdrawnAt:null}:{status:"withdrawn",capturedAt:now,withdrawnAt:now}}
