# Ideas from competitors → make Aspira more useful for 11th-year smart students

Written 2026-07-28. Synthesized from the study-abroad / test-prep / edtech
landscape (Duolingo, ELSA, Crimson, Yocket, Leverage Edu, ApplyBoard, Magoosh,
Quizlet/Anki, Polygence, Unifrog, official SAT/DET). Not a live scrape.

**Who this is for:** in Aspira's markets, 11th grade is often the *final* school
year, so it's two students at once — the **urgent applicant** (needs IELTS + a
university + a scholarship *this cycle*) and the **ambitious top-tier** kid
(wants a real shot at global top-50). Rank ideas by how well they serve both.

---

## Top 5 to build first (highest leverage for this segment)

1. **Admit-fit "chancing" meter** — turn the data you already have into the
   killer feature.
2. **Personalized application timeline** — deadlines that count down to *their*
   intake.
3. **DET track + honest score predictor** — the fast, cheap route to a real cert.
4. **Spaced-repetition vocab + weekly leagues** — retention for grinders.
5. **Opportunity radar** (competitions / programs) — profile building for the
   top tier.

---

## The full set (competitor → idea → why it fits → size)

### A. Get certified faster & cheaper — biggest lever for final-years
- **DET track** *(Duolingo English Test)* — DET is ~$65 vs IELTS ~$250, taken
  from home, results in ~2 days, and accepted by a growing list of universities.
  For cost-sensitive students this is enormous. Add a DET-format practice mode and
  tag which of *their* target universities accept DET. **Med** (reuse mock engine).
- **Honest score predictor** *(Magoosh/DET)* — after mocks, show a predicted IELTS
  band + a clear "ready / not ready to book" signal so students don't burn a
  ~$250 exam fee too early. **Med.** (Seeded: `mock_band6`, `exam_ready` badges.)

### B. Turn scores into admissions — what smart students actually want
- **Admit-fit / "chancing" meter** *(Crimson, Yocket)* — given band + grades +
  budget, sort target universities into **safe / match / reach** and surface the
  scholarships they realistically qualify for. You already have `opportunities`,
  `min_ielts`, `world_rank`, funding. Honest tiers > hype. **Med — highest value.**
- **Personalized application timeline** *(CommonApp/Crimson)* — a real countdown:
  "book IELTS by X, transcript by Y, apply by Z" tied to their target intake.
  This is your existing test-plan card grown into a planner. **Med.**
- **Per-university document checklist** *(ApplyBoard)* — your generic checklist,
  but per target uni with live status (IELTS ✓, transcript ✓, SOP draft…).
  **Quick–Med.** (Seeded application-essay prompts: `sop_why_university`,
  `scholarship_motivation`, `study_plan_statement`.)

### C. Profile building — for the ambitious top tier
- **Opportunity radar** *(Polygence, Pioneer, Unifrog)* — curated competitions,
  olympiads, summer/research programs by dream field and region. Top unis want
  more than grades; final-year smart kids need this *now*. **Content-driven.**
- **Extracurricular/impact suggestions** *(Crimson)* — the adviser proposes 3
  concrete, doable profile boosters for their field. **Quick** (reuses adviser).

### D. Study smarter, stick longer — retention
- **Spaced-repetition vocabulary** *(Anki/Quizlet)* — replace random daily words
  with SRS review scheduling (due dates, ease). Smart students love measurable
  mastery. Your new `get_daily_words()` is step 1; add a `vocab_reviews` table.
  **Med.**
- **Weekly leagues / class leaderboards** *(Duolingo leagues)* — you already
  track class members + mock counts in `get_class_board()`. Add ranks/leagues;
  competition motivates high-achievers. **Quick–Med.**
- **AI pronunciation scoring** *(ELSA Speak)* — you have TTS + a speaking-mock
  recorder; add phoneme/fluency feedback. Differentiating. **Big.**

### E. Trust & social proof
- **"Students like you got in"** *(Yocket community)* — real paths: band → uni →
  scholarship. Powerful motivation and conversion for cautious families. **Med.**
- **Peer Q&A / mentor chat** *(Yocket, Leverage Edu)* — async community or a
  counselor thread. **Big.**

### F. Honesty & calm UX (already on your list)
- Adviser: plain, short, one step at a time; dashboard shows cards only when
  relevant (SAT only for US-bound, hide plan once set). Ties to earlier asks.

---

## DB groundwork seeded now (safe, additive)

- 3 application-essay prompts (SOP / scholarship motivation / study plan).
- 4 milestone achievement types (`exam_ready`, `mock_band6`, `app_submitted`,
  `scholarship_unlocked`).

## Proposed next (need a migration or app work — not auto-applied)

- `vocab_reviews` table for spaced repetition
  (`student_id, word_id, ease, interval_days, due_at, last_result`).
- An "Opportunity radar" content type (competitions/programs) — needs a new
  `content_shelves.kind` value or a dedicated `programs` table, plus reviewed
  content.
- A `university_fit(student_id)` RPC powering the chancing meter from
  `opportunities` + the student's band/budget.

Say the word and I'll draft the `vocab_reviews` migration + the `university_fit`
RPC (both DB-only, so I can apply them here); the UI for any of these needs the
`prepapp` app repo attached.
