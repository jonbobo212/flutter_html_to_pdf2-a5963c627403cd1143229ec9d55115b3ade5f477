# Aspira — total-approval setup + complete Supabase reference

Written 2026-09-27. Two parts: (1) stop the permission prompts for good,
(2) every Supabase query/RPC for this project in one place.

---

# PART 1 — Never be asked for permission again

## The honest bit first: there are TWO separate gates

| Gate | Where it bites | Can a settings file fix it? |
|---|---|---|
| **A. Claude Code on your Mac** (the `claude` CLI) | Every Bash/Edit/MCP call | **Yes** — Part 1a below |
| **B. Claude Code on the web / cloud sessions** | MCP tools like repo-attach, project-restore, image generation | **No** — it's enforced by the platform, above your repo |

Your repo already carries a bypass settings file (commit `5440b22`,
"Permissions: bypass mode"). It works for gate A. It did **not** stop the
prompts I hit in cloud sessions, because those are gate B. So: Part 1a makes
your Mac silent forever; for gate B you approve in the UI or run the work on
your Mac. I'd rather tell you that than let you keep re-fixing the wrong file.

## Part 1a — one-time terminal setup (global: applies to EVERY project)

Paste this whole block into Terminal:

```bash
mkdir -p ~/.claude
cat > ~/.claude/settings.json <<'JSON'
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash", "Read", "Edit", "Write", "Glob", "Grep",
      "WebFetch", "WebSearch", "Task", "TodoWrite",
      "mcp__Supabase__*",
      "mcp__github__*",
      "mcp__Vercel__*",
      "mcp__Higgsfield_ai__*"
    ]
  },
  "enableAllProjectMcpServers": true
}
JSON
echo "global settings written:"; cat ~/.claude/settings.json
```

Also pin it inside the app repo (so any session on prepapp inherits it):

```bash
cd ~/prepapp && mkdir -p .claude
cat > .claude/settings.json <<'JSON'
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": ["Bash", "Read", "Edit", "Write", "Glob", "Grep",
              "mcp__Supabase__*", "mcp__github__*", "mcp__Vercel__*"]
  },
  "enableAllProjectMcpServers": true
}
JSON
git add .claude/settings.json
git commit -m "Claude Code: bypass permissions for autonomous sessions"
git push
```

**Settings load at session start** — quit and reopen `claude` afterwards, or the
old session keeps the old rules.

Escape hatch for a single run without touching config:
```bash
claude --dangerously-skip-permissions
```
In an interactive session, **Shift+Tab** cycles to "bypass permissions".

> Said once, then never again: bypass mode means no confirmation for *any*
> Bash/SQL/git command, including destructive ones. That is what you asked for
> and it is a reasonable trade on your own repo — just know it is a real switch.

---

# PART 2 — Complete Supabase reference for this project

## Projects

| Name | Project ID (ref) | Region | Role |
|---|---|---|---|
| **prepapp** (Aspira) | `tqeljmplvhcaaypgfihe` | ap-south-1 | the student app |
| **Aplify** | `mywdtmimiazeyhfdtqlw` | ap-northeast-2 | CRM + the shared mailbox/bus |
| europe-crm | `buorjtipzkjjuyxenerm` | ap-southeast-2 | newer, separate |

⚠️ **prepapp is on the free tier and auto-pauses after 7 days idle.** It already
paused once and that is what made the Start button hang — the app dies silently,
no error. Before the store launch, upgrade to Pro or a quiet week takes Aspira
offline. Check status any time:
`select 1;` against `tqeljmplvhcaaypgfihe` — if it errors, the project is paused.

## The student-facing RPCs (call with `supabase.rpc(...)`)

**Seats / plan (EdPortal)**
```ts
get_my_seat(p_student)                         // the student's seat + plan
get_playlist_progress(p_student)               // ticked items
mark_playlist_item(p_student, p_playlist, p_item, p_done)
seat_progress(p_partner, p_external_id)        // + days_inactive  (for /api/partner/progress)
seat_nudge_candidates(p_days)                  // seated + idle N days (for /api/cron/nudge)
recommended_playlists(p_student)               // which playlist first, with a reason
```

**German track**
```ts
get_german_placement()                         // 16 questions, NO answer key
score_german_placement(p_student, p_answers)   // scores server-side, sets german_cefr
record_lesson_quiz(p_student, p_lesson, p_score, p_total)  // -> new level
recompute_german_cefr(p_student)
```

**English / universities**
```ts
university_fit(p_student)      // every uni tagged safe|match|reach, basis ielts|german
fit_summary(p_student)         // counts per tier + how many have funding
fit_top(p_student, p_limit)    // top picks for the home card
explore_universities()
get_university_enrichment(p_slug)
```

**Vocabulary / habit**
```ts
daily_words_session(p_student, p_limit)   // today's words, auto by band + dream field
due_vocab(p_student, p_band, p_field, p_limit)
review_vocab(p_student, p_word, p_quality)   // quality 0-5 (SM-2); again=2 good=4 easy=5
vocab_progress(p_student)                    // due_today / learning / mastered
get_daily_words(p_band, p_field, p_limit)
record_streak(p_id) · get_streak(p_id)
```

**Classroom · profile · misc**
```ts
create_class(p_title, p_teacher_name, p_school_code) · join_class · get_class_board · get_class_public
get_student(p_id) · update_student(...) · set_docs_ready · get_activity · get_notify
check_scholarship_code(p_code) · resolve_ref(p_ref) · mark_achievement_shared
links_to_check() · record_link_check(p_url, p_status, p_note)
```

Service-role only (never expose to the browser):
`nudge_candidates()`, `resolve_enrollment(p_email)`, the `t100u_apply_*` family.

## Handy admin queries

```sql
-- is the DB awake?
select now();

-- German course state
select cefr_level, unit, count(*) filter (where active) as active, count(*) as total
from lessons where language='de' group by 1,2 order by 1,2;

-- seated students and how quiet they are
select * from seat_progress('edportal');
select * from seat_nudge_candidates(7);

-- link health (populate via a Vercel cron -> record_link_check)
select * from links_to_check();

-- every study item must name its source (rule 7)
select p.code, it->>'title', it->>'source'
from playlists p, lateral jsonb_array_elements(p.items) it
where coalesce(it->>'source','') = '';

-- the shared mailbox (Aplify project!)
select id, kind, slug, title, status, in_reply_to
from t100u_portal_mailbox order by id desc limit 20;
```

## Security invariants — do not break these

- `de_placement_questions` holds the **answer key**. RLS is on, there is **no**
  anon policy, and the anon GRANT is revoked. Students must only ever reach it
  through `get_german_placement()` / `score_german_placement()`.
- Every table in `public` has RLS enabled. Keep it that way.
- Never show a student the seat price or the word "free" *about the seat*
  (agency pays: first five free, then USD 9.90). Describing genuinely free
  third-party material as free is fine and correct.

Full change history with rollback SQL: `prepapp/DB_CHANGELOG.md`.
