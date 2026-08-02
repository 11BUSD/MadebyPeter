import "server-only";
import { z } from "zod";

const schema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.url().optional(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(20).optional(),
  NEXT_PUBLIC_SITE_URL: z.url().default("http://localhost:3000"),
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(20).optional(),
  FEATURE_MARKETPLACE: z.enum(["true", "false"]).default("false"),
  NEXT_PUBLIC_DEMO_MODE: z.enum(["true", "false"]).default("true"),
});

export const env = schema.parse({
  NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL || undefined,
  NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || undefined,
  NEXT_PUBLIC_SITE_URL: process.env.NEXT_PUBLIC_SITE_URL,
  SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY || undefined,
  FEATURE_MARKETPLACE: process.env.FEATURE_MARKETPLACE,
  NEXT_PUBLIC_DEMO_MODE: process.env.NEXT_PUBLIC_DEMO_MODE,
});

export const hasSupabase = Boolean(env.NEXT_PUBLIC_SUPABASE_URL && env.NEXT_PUBLIC_SUPABASE_ANON_KEY);
