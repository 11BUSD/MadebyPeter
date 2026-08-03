import { CaptureFlow } from "@/components/capture-flow";
import { hasSupabase } from "@/lib/env";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export default async function NewIdeaPage({ searchParams }: { searchParams: Promise<{source?: string; build?: string; published?: string; resume?: string}> }) {
  const params = await searchParams;
  const supabase = await createSupabaseServerClient();
  const user = supabase ? (await supabase.auth.getUser()).data.user : null;
  const { data: graphs = [] } = user
    ? await supabase!.from("graphs").select("id,title,visibility").is("deleted_at", null).order("updated_at", { ascending: false })
    : { data: [] };

  return <main id="main" className="narrow">
    <p className="eyebrow">Add an idea</p>
    <h1>Catch it before it disappears.</h1>
    <p className="lede">Three small steps: capture, check, choose who can see it.</p>
    <CaptureFlow
      source={params.source || params.build}
      published={params.published === "demo"}
      configured={hasSupabase}
      authenticated={Boolean(user)}
      resume={params.resume === "1"}
      graphs={graphs || []}
    />
  </main>;
}
