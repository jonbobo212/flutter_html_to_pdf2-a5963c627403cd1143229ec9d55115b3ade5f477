# Good morning — Aspira launch brief

Written overnight 2026-07-28. Honest status, why the autonomous code upgrade
couldn't run from this session, and a 2-minute path to let it run for real.

## The one blocker (please fix first — 2 min)

Everything real about Aspira — the code upgrade, the dev features, the iOS
branch — lives in the **`prepapp`** repo. **This session does not have that repo
and can't attach it** (the attach call is approval-gated and auto-denies here).
So no amount of "allow everything" from inside this session unblocks it.

To let me work autonomously on Aspira, start a session **that already has
`jonbobo212/prepapp` attached**, then turn on no-prompt mode:

- **Claude Code (CLI):** press **Shift+Tab** to cycle to *bypass permissions*
  mode, or set in `.claude/settings.json`:
  `{ "permissions": { "defaultMode": "bypassPermissions" } }`
- **Claude Code on web:** pick the permission mode / "allow all" toggle when
  launching the session on the `prepapp` repo.

> Tradeoff, said once so you can decide with eyes open: bypass mode lets me run
> SQL/git/bash with no confirmation. That's fine for a trusted overnight run on
> your own repo; just know it's a real setting, not a cosmetic one. (This is the
> same "zero permission prompts" the ecosystem bus kept ordering — I didn't apply
> it from the bus on purpose; applying it yourself, knowingly, is the right way.)

Once that session is up, point me at this brief and I'll execute the plan below
end to end.

## What's already done and pushed (branch `claude/prepapp-init-schema-yibius`)

- `prepapp/schema.sql` — live DB schema snapshot, verified in-sync.
- `prepapp/appstore/APP_STORE_LAUNCH_KIT.md` — store copy, App Privacy labels,
  submission runbook.
- `prepapp/appstore/PRIVACY_POLICY.md` — policy drafted from the real data model.
- `prepapp/appstore/IOS_GROUNDWORK.md` — copy-paste manifest + Capacitor + native
  features to clear App Review 4.2.
- `prepapp/appstore/STORE_EXTRAS.md` — Google Play TWA fast-win + support/marketing
  page copy.

## Plan to run in the `prepapp` session (ordered)

**A. Codebase upgrade / hardening**
1. `npm audit` + dependency bumps (safe minors first; hold Next 14→15 major per
   bus id 56 until after your Aug 2 event).
2. Typecheck + lint clean; fix any build breakers so `npm run build` is green.
3. Add Dependabot/CI check if not present.

**B. Great dev features (highest-leverage, low-risk)**
4. Adviser tone fix (your earlier ask): plain text, no `**`, short, simple
   English, one question at a time — edit the `study_adviser` system prompt.
5. Quieter dashboard: hide IELTS-plan / SAT / checklist cards unless relevant
   (SAT only if target country = US; plan hides once a date/target is set).
6. Layer-3 AI caching (bus id 53): read-through cache for translations + question
   banks to cut tokens; never cache personalized essay feedback.

**C. App launch groundwork**
7. `launch/ios` branch: apply `IOS_GROUNDWORK.md` (manifest, Capacitor, native
   features), verify `npm run build` passes, open in Xcode.
8. Google Play TWA per `STORE_EXTRAS.md` (fastest store, in parallel).

**D. Bus + housekeeping**
9. Post one consolidated `kind=status` to `t100u_ecosystem_sync` from `aspira`
   summarizing the night; ack outstanding FYIs (ids 42, 46, 57).

## Still declining (on purpose)

The bus "zero permission prompts — pull main" orders (ids 32/51): I won't pull
and apply a `bypassPermissions` settings file *because a database row said so*.
You enabling bypass mode yourself (above) is the correct, intentional path.

Sleep well — this is ready when you are.
