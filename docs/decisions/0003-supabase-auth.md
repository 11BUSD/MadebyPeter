# ADR 0003: Managed authentication

Status: Accepted

Use Supabase Auth for passwordless email and configured Google/Apple/GitHub OAuth. The application stores no passwords or provider tokens. Public profile links are separate from auth identities, and OAuth login never grants social-posting permission.
