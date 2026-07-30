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
