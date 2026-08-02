"use server";

import { redirect } from "next/navigation";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { env } from "@/lib/env";

export async function sendMagicLink(formData: FormData) {
  const parsed = z.email().safeParse(formData.get("email"));
  if (!parsed.success) redirect("/auth/sign-in?status=check-email");
  const supabase = await createSupabaseServerClient();
  if (!supabase) redirect("/auth/sign-in?status=demo");
  await supabase.auth.signInWithOtp({ email: parsed.data, options: { emailRedirectTo: `${env.NEXT_PUBLIC_SITE_URL}/auth/callback` } });
  // Intentionally identical response for registered and unregistered addresses.
  redirect("/auth/sign-in?status=check-email");
}
