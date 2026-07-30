# Tonight's build — 3 features, ready to wire

All three ship to web + iOS + Android at once (one shared app at aspira.study).
The **database engines are already live** (built + verified this session). What's
left is UI + the adviser prompt, in the `prepapp` repo. Apply on your Mac:
`git pull` first, then the pieces below, then `git push` (Appflow/Vercel deploy).

---

## Live engines you can call now (Supabase RPC)

```ts
// Feature 1 — chancing
const { data: summary } = await supabase.rpc('fit_summary',  { p_student });      // [{tier, n, scholarships}]
const { data: picks }   = await supabase.rpc('fit_top',      { p_student, p_limit: 6 });
const { data: all }     = await supabase.rpc('university_fit',{ p_student });      // full list, tier + basis

// Feature 3 — daily habit
const { data: words }   = await supabase.rpc('daily_words_session', { p_student, p_limit: 12 });
await supabase.rpc('review_vocab', { p_student, p_word, p_quality });  // quality 0..5 (SM-2)
const { data: prog }    = await supabase.rpc('vocab_progress', { p_student }); // {due_today, learning, mastered, total_seen}
const { data: streak }  = await supabase.rpc('record_streak', { p_id: p_student }); // returns current streak
```
`basis` is `'ielts'` or `'german'` so the UI can show the right requirement.

---

## Feature 1 — "Universities that fit you" (chancing)

**Screen:** a meter (Safe / Match / Reach) + a list of top picks with a scholarship chip.

```tsx
// map fit_summary to the three bars
const total = summary.reduce((s, r) => s + r.n, 0);
const row = (t) => summary.find(r => r.tier === t) ?? { n: 0, scholarships: 0 };
// bar width = row(t).n / total; label = `${row(t).n} unis · ${row(t).scholarships} with funding`

// list from fit_top: each card shows university, country flag (country_code),
// a tier pill (Safe=teal, Match=gold, Reach=rose), and if funding -> "🎓 scholarship".
```
Tone: honest, encouraging. Header copy: *"Where you fit right now"* (not "eligible").

## Feature 2 — human adviser + calm home

**2a. Adviser system prompt.** Replace the `study_adviser` edge function's system
prompt with this (fixes the robotic, markdown-heavy replies):

```
You are Aspira's study adviser — a calm, kind mentor for students, many of them
young and still learning English.
- Plain text only. Never use *, **, #, tables, or bullet lists.
- Keep replies to 2–4 short sentences. Only go longer if the student asks.
- Simple English. Short words, short sentences.
- Ask at most ONE question at a time.
- Do not push IELTS dates, the SAT, checklists, or upgrades unless the student
  raises them or clearly wants that step.
- University facts are AI-drafted — tell them to confirm on the official page.
  Never invent numbers.
- Warm and human, not a brochure.
```

**2b. Calm home — show cards only when relevant:**

```ts
const country = currentDream?.target_country?.toLowerCase() ?? '';
const isUS = ['us','usa','united states','america'].some(x => country.includes(x));

showSAT       = isUS;                                  // hide unless US-bound
showTestPlan  = !(student.target_band || student.ielts_date || dismissed.testPlan);
showChecklist = route === '/application';             // not on home by default
```
Give each hideable card a small "Not now" that sets a `dismissed` flag (localStorage
or a `students.ui_prefs` jsonb) so it never nags again.

## Feature 3 — daily habit (spaced-repetition words + streak)

**Screen:** a swipe/flip word card fed by `daily_words_session`; after each word the
student taps "Again / Good / Easy" → map to quality (Again=2, Good=4, Easy=5) →
`review_vocab`. On finishing a session call `record_streak`. Show `vocab_progress`
as a mastery bar ("12 learning · 40 mastered · 3 due today").

```tsx
const grade = { again: 2, good: 4, easy: 5 };
async function answer(wordId, choice) {
  await supabase.rpc('review_vocab', { p_student, p_word: wordId, p_quality: grade[choice] });
}
async function finishSession() {
  const { data } = await supabase.rpc('record_streak', { p_id: p_student });
  setStreak(data); // celebrate: confetti + "🔥 {data}-day streak"
}
```
The motion for all of this (flip card, streak flame, confetti, chancing bars) is in
the published UI prototype + `UI_UX_KIT.md`.

---

## What's done vs. what's yours

- ✅ **Live now (DB, verified):** `university_fit` (dual IELTS/German), `fit_summary`,
  `fit_top`, `due_vocab`, `daily_words_session`, `review_vocab`, `vocab_progress`,
  `get_daily_words`; `vocab_reviews` table; +35 words, +8 prompts, +8 badges.
- ⏳ **Yours to apply in `prepapp`:** the 3 screens above + the adviser prompt swap.
  I can't attach the repo from this session; if you enable repo access I'll commit
  these directly, otherwise paste them in on your Mac and `git push`.
