import "server-only";
import {createClient} from "@supabase/supabase-js";
import {env} from "@/lib/env";

export function createPublicSupabaseClient(){
  if(!env.NEXT_PUBLIC_SUPABASE_URL||!env.NEXT_PUBLIC_SUPABASE_ANON_KEY)return null;
  return createClient(env.NEXT_PUBLIC_SUPABASE_URL,env.NEXT_PUBLIC_SUPABASE_ANON_KEY,{auth:{persistSession:false,autoRefreshToken:false,detectSessionInUrl:false}});
}
