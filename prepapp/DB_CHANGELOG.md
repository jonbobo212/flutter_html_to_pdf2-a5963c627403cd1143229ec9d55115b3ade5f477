# Aspira DB changelog

Autonomous, owner-authorized improvement pass. All changes are **additive or
data-quality only** — no student data, pricing, or unreviewed content touched.
Applied directly to the live `prepapp` project (`tqeljmplvhcaaypgfihe`) via SQL.

## 2026-07-28 — improvement pass (10+ items)

### Data quality
1. **Deduped vocabulary** — removed duplicate rows for `analyse` and `hypothesis`
   (vocab 115 → 113 before additions).
2. **Backfilled `opportunities.country_code`** — all 84 null rows filled from the
   country name (incl. `UK`/`United Kingdom` → `uk`, `USA`/`United States` → `us`).
   Explore can now filter by a consistent 2-letter code. 0 nulls remain.

### Performance (indexes on real function query paths)
3. `opportunities_t100u_slug_idx` — for `get_university_enrichment()`.
4. `opportunities_world_rank_idx` — for `explore_universities()` ordering.
5. `opportunities_country_code_idx (country_code, active)` — Explore filtering.
6. `activity_log_student_kind_idx (student_id, kind)` — for the `mock_count`
   subquery in `get_class_board()`.

### Content / feature depth
7. **+35 vocabulary words** (113 → 148), including the first **field-track sets**:
   IT, medicine, business, engineering (with `field_track` set), plus general and
   academic words. All `active`.
8. **+5 writing prompts** (14 → 19): `describe_family`, `describe_favourite_place`,
   `opinion_social_media`, `ielts_t2_environment`, `ps_overcoming_challenge`.
9. **+4 achievement types** (7 → 11): `placement_done`, `first_essay`,
   `mock_master`, `reading_rookie` (en/uz/ru labels).
10. **New RPC `get_daily_words(p_band, p_field, p_limit)`** — daily-stable,
    level-matched, field-aware word selection for the Daily Words game; granted
    to `anon` + `authenticated`. The frontend can adopt it via
    `supabase.rpc('get_daily_words', { p_band, p_field })`.

### Ecosystem
11. Posted consolidated `kind=done` status to `t100u_ecosystem_sync` (id 77) and
    acked outstanding FYIs (ids 42, 46, 57).

### Flagged for owner (not auto-changed)
- `opportunities.country` free text still mixes `UK`/`United Kingdom` and
  `USA`/`United States`. Display text left untouched; `country_code` normalizes
  filtering. Rename later if the UI groups by the text field.
- Achievement types 8–11 only appear once app logic awards them.

---

## Rollback (if ever needed)

```sql
-- content
delete from vocab_words where field_track in ('it','medicine','business','engineering')
  and created_at::date = '2026-07-28';   -- or target the exact words added
delete from writing_prompts where code in
  ('describe_family','describe_favourite_place','opinion_social_media',
   'ielts_t2_environment','ps_overcoming_challenge');
delete from achievement_types where code in
  ('placement_done','first_essay','mock_master','reading_rookie');
drop function if exists public.get_daily_words(numeric, text, integer);

-- indexes
drop index if exists opportunities_t100u_slug_idx;
drop index if exists opportunities_world_rank_idx;
drop index if exists opportunities_country_code_idx;
drop index if exists activity_log_student_kind_idx;

-- country_code backfill (revert to null)
update opportunities set country_code = null;   -- only if you truly want it back

-- dedupe + student data: NOT reversible (duplicates were true duplicates).
```

## 2026-07-28 — feature engines (spaced repetition + chancing meter)

Additive; power the UI motion prototype's Daily Words and university-fit meter.

12. **`vocab_reviews` table** + `vocab_reviews_due_idx` + permissive V1 RLS
    (anon read/insert/update) — spaced-repetition store.
13. **`review_vocab(student, word, quality)`** — SM-2-lite scheduler; sets ease,
    interval, reps, `due_at`; returns next due date.
14. **`due_vocab(student, band, field, limit)`** — words due today, else fresh
    level/field-matched words (drives the SRS queue).
15. **`university_fit(student)`** — every active university tagged
    safe / match / reach with band gap; powers the chancing meter. Verified:
    a band-6.0 student → 5 safe / 101 match / 16 reach.
    All three granted to `anon` + `authenticated`.

Correction: the "84 missing" figure was `world_rank`/`country_code`, not
`min_ielts`. Only 9 active universities lack `min_ielts`, and all 9 are
German-taught programs that already carry `german_min_cefr` (B1/B2) — IELTS
does not apply, so `min_ielts` is correctly null. No data fill needed.

16. **`university_fit()` v2** — now dual-basis: judges by IELTS where required,
    and by the student's German CEFR (`students.german_cefr` vs
    `opportunities.german_min_cefr`) for German-taught programs; returns a
    `basis` column ('ielts' | 'german'). Verified: 113 ielts / 9 german, no
    'unknown'. (Signature changed, so it was dropped + recreated.)

### Rollback
```sql
drop function if exists public.university_fit(uuid);
drop function if exists public.review_vocab(uuid, uuid, integer);
drop function if exists public.due_vocab(uuid, numeric, text, integer);
drop table if exists public.vocab_reviews;
```

## 2026-07-28 — tonight's 3-feature engines

Additive; power the chancing screen + daily-habit loop (verified live).

17. **`fit_summary(student)`** → per-tier counts + scholarship counts
    (verified: safe 5/5, match 92/19, reach 25/14). Powers the meter.
18. **`fit_top(student, limit)`** → ranked top picks (match/safe first, funded
    first). Verified: Imperial, UCL, TUM with funding text.
19. **`daily_words_session(student, limit)`** → one call returns today's due/fresh
    words, auto-using the student's band + current dream field.
20. **`vocab_progress(student)`** → {due_today, learning, mastered, total_seen}
    for a mastery bar.
    All granted to `anon` + `authenticated`.

### Rollback
```sql
drop function if exists public.fit_summary(uuid);
drop function if exists public.fit_top(uuid, integer);
drop function if exists public.daily_words_session(uuid, integer);
drop function if exists public.vocab_progress(uuid);
```

## 2026-09-26 — EdPortal seats brief (mailbox row 50), items 1-7

Worked German-first. Replies posted to `t100u_portal_mailbox` with
`in_reply_to = edportal-seats-2026-09-26` (rows 52-58).

21. **German A1 activated** — all 12 lessons reviewed line by line and set
    `active=true`, stamped `reviewed_by='claude (AI language review...)'`.
    Three content fixes first: duplicated speaker prefixes in the café
    dialogue, "four" question words when six are taught, and missing clock
    time in "Days & telling time".
22. **`lesson_quiz_results`** table (+RLS, `passed` generated at >=70%).
23. **`recompute_german_cefr(student)`** — unit cleared when every active
    lesson passes; level cleared when all its units clear; highest level
    contiguous from A1. Never downgrades; auto-extends when A2+ is authored.
24. **`record_lesson_quiz(student, lesson, score, total)`** — best-score
    upsert, attempt count, `activity_log` kind `lesson_quiz`, re-evaluates level.
25. **German placement** — `de_placement_questions` (16 authored items, A1-B2),
    RLS on with **no anon policy** so the answer key never reaches the client;
    `get_german_placement()` (no answers) + `score_german_placement()` (scores
    server-side, sets `german_cefr` authoritatively).
26. **`trg_sync_current_band`** on `assessments` — placement retakes update
    `students.current_band` structurally, not via client code.
27. **`recommended_playlists(student)`** — seat-plan driven; below 6.0 or
    unplaced starts at `en-ielts-5-6`; German before English when it applies.
28. **Sources filled** — all 37 playlist items had `source=null`; each now
    names its publisher (rule 7).
29. **`link_checks`** + `links_to_check()` + `record_link_check()` — 29 external
    URLs registered so a Vercel cron can verify them from real egress.
30. **`seat_progress(partner, external_id)`** (incl. `days_inactive`) and
    **`seat_nudge_candidates(days)`** — respects `notify_opt_out`.

All verified with throwaway students/seats; every test row deleted.

### Rollback
```sql
drop trigger if exists trg_sync_current_band on public.assessments;
drop function if exists public.sync_current_band();
drop function if exists public.recommended_playlists(uuid);
drop function if exists public.seat_progress(text, text);
drop function if exists public.seat_nudge_candidates(integer);
drop function if exists public.links_to_check();
drop function if exists public.record_link_check(text, integer, text);
drop function if exists public.get_german_placement();
drop function if exists public.score_german_placement(uuid, jsonb);
drop function if exists public.record_lesson_quiz(uuid, uuid, integer, integer);
drop function if exists public.recompute_german_cefr(uuid);
drop table if exists public.link_checks;
drop table if exists public.de_placement_questions;
drop table if exists public.lesson_quiz_results;
-- de-activate A1 again if the AI review is rejected:
-- update lessons set active=false, reviewed_by=null, reviewed_at=null
--   where language='de' and cefr_level='A1';
```
