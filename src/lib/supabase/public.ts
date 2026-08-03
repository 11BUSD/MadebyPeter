import "server-only";
import {createClient} from "@supabase/supabase-js";
import {env, supabasePublishableKey} from "@/lib/env";

export function createPublicSupabaseClient(){
  if(!env.NEXT_PUBLIC_SUPABASE_URL||!supabasePublishableKey)return null;
  return createClient(env.NEXT_PUBLIC_SUPABASE_URL,supabasePublishableKey,{auth:{persistSession:false,autoRefreshToken:false,detectSessionInUrl:false}});
}
