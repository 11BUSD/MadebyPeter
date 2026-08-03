import { NextResponse } from "next/server";
import { z } from "zod";
import { nodeTypeSchema, visibilitySchema } from "@/domain/graph/model";
import { createSupabaseServerClient } from "@/lib/supabase/server";

const requestSchema = z.object({
  graphId: z.uuid().nullable(),
  title: z.string().trim().min(1).max(160),
  summary: z.string().trim().min(1).max(400),
  description: z.string().trim().max(10_000).default(""),
  nodeType: nodeTypeSchema,
  visibility: visibilitySchema,
  publish: z.boolean(),
  idempotencyKey: z.string().min(8).max(120),
});

export async function POST(request: Request) {
  const origin = request.headers.get("origin");
  if (origin && origin !== new URL(request.url).origin) {
    return NextResponse.json({ error: "Cross-origin request blocked" }, { status: 403 });
  }

  const parsed = requestSchema.safeParse(await request.json().catch(() => null));
  if (!parsed.success) return NextResponse.json({ error: "Invalid idea" }, { status: 400 });

  const supabase = await createSupabaseServerClient();
  if (!supabase) {
    return NextResponse.json({ error: "Supabase is not configured" }, { status: 503 });
  }

  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return NextResponse.json({ error: "Authentication required" }, { status: 401 });

  const { data, error } = await supabase.rpc("capture_idea", {
    p_graph_id: parsed.data.graphId,
    p_title: parsed.data.title,
    p_summary: parsed.data.summary,
    p_description: parsed.data.description,
    p_node_type: parsed.data.nodeType,
    p_visibility: parsed.data.visibility,
    p_publish: parsed.data.publish,
    p_idempotency_key: parsed.data.idempotencyKey,
  });

  if (error || !data) {
    console.error(JSON.stringify({ event: "capture.persist_failed", code: error?.code }));
    return NextResponse.json({ error: "The idea could not be saved" }, { status: 400 });
  }

  return NextResponse.json(data, { status: 201, headers: { "Cache-Control": "no-store" } });
}
