"use server";

import { redirect } from "next/navigation";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { env } from "@/lib/env";

export async function sendMagicLink(formData: FormData) {
  const parsed = z.email().safeParse(formData.get("email"));
  const requestedNext = String(formData.get("next") || "");
  const safeNext = requestedNext.startsWith("/") && !requestedNext.startsWith("//") ? requestedNext : "/studio";
  if (!parsed.success) redirect(`/auth/sign-in?status=check-email&next=${encodeURIComponent(safeNext)}`);
  const supabase = await createSupabaseServerClient();
  if (!supabase) redirect("/auth/sign-in?status=demo");
  const callback = new URL("/auth/callback", env.NEXT_PUBLIC_SITE_URL);
  callback.searchParams.set("next", safeNext);
  await supabase.auth.signInWithOtp({ email: parsed.data, options: { emailRedirectTo: callback.toString() } });
  // Intentionally identical response for registered and unregistered addresses.
  redirect(`/auth/sign-in?status=check-email&next=${encodeURIComponent(safeNext)}`);
}
