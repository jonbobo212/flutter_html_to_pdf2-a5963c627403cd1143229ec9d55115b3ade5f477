# Aspira Web — multi-tenant partner-sites platform (bus code: vitrina)

One Next.js app serves every gifted partner site: `{slug}.aspira.study` →
`src/proxy.ts` rewrites to `/t/{slug}/{locale}/…` → tenant row in the shared
Supabase (`mywdtmimiazeyhfdtqlw`, tables prefixed `vitrina_`) picks template,
brand, and content. Full spec: t100u repo `docs/SITE_FACTORY.md`; build plan:
`docs/ASPIRA_WEB_PLAN.md` (repo root).

NOTE: this code temporarily lives in a host repo; it is written to be
extracted 1:1 into the real `aspira-web` repo once the owner creates it
(GitHub integration here cannot create repos).

## Stack
- Next.js 16 (App Router) + React 19 + TypeScript, Tailwind v4
- No next-intl: tenant locales are dynamic per market (uz/tg/ky + ru + en).
  URL scheme: default locale unprefixed, others `/{locale}/…`. `_` is the
  internal "tenant default" segment — never expose it in links (use
  `localePath()` from `src/lib/tenant.ts`).
- Data access server-side only via service role (`src/lib/db.ts`, lazy
  constructor — NEVER construct SDK clients at module scope; that failure
  mode broke Aplify preview builds). Browser-facing writes go through server
  actions; RLS on `vitrina_*` is the backstop.

## Hard rules (owner, inherited via sync bus rows #39–#44)
1. **Honest content only** — render only partner-provided or verified facts;
   the AI pipeline must never invent stats. Testimonials carry `source_note`.
2. **No legal entity names on any public surface** — framing is
   "international education platform … all rights reserved".
3. Markets: Uzbekistan, Tajikistan, Kyrgyzstan only. Commissions/commercial
   terms never public.
4. Everything partner-facing is trilingual (local/RU/EN). Content model:
   jsonb `{locale: text}` + `machine_locales` flags — human edits are never
   overwritten by re-translation.
5. **The badge is the payment**: every tenant footer renders
   "Powered by Aspira" → gateway on aspira.study (`src/lib/badge.ts` holds the
   URL contract, `?ref={partner_code}` attribution). Never remove it.
6. Aspira positioning in all partner copy: free assessment/prep toolkit +
   partner NETWORK that routes leads to centers/teachers — connect, never
   compete.

## Sync bus
`public.t100u_ecosystem_sync` in the shared Supabase; this app's code is
`vitrina` (internal only, never public). Sync on start of substantive work,
ack processed rows, post status after significant work with ref=commit.

## Current state (Phase 0 walking skeleton)
- Schema migration `vitrina_core_schema` applied (tenants/sections/posts/
  media/staff/courses/testimonials/admins/intakes/leads + RLS).
- Tenant runtime: hostname routing, brand CSS vars, School template v0
  (home/news/news-detail/contact + lead form → vitrina_leads).
- NOT YET: template design sprint (the craft pass), admin CMS,
  translate-on-save, AI intake pipeline, Aplify lead forwarding, Aspira
  classroom/T100U blocks, Vercel project + wildcard DNS (blocked on owner).
