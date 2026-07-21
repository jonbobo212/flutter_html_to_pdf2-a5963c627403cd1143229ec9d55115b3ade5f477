# PREPAPP_TASK_V1.md — Dream-First English Prep PWA (V1)

> Read together with `PREPAPP_ADDENDUM.md`, which supersedes this file
> where they conflict. This is a completely separate project from
> Aplify/studentapply — different repo, different Supabase project,
> nothing shared.

## 1. What we are building

A premium, dream-first English preparation PWA for top-1% students in
Central Asia (Uzbekistan first). The student doesn't come to "study
English" — they come with a dream ("study Computer Science in Korea",
"become a doctor in Germany") and the app turns that dream into a daily
English habit, a measurable band level, and unlocked real opportunities.

The product is an AI mentor, not a courseware grid: warm,
teenager-respecting, speaks the student's language (uz / ru / en UI),
never clinical, never disappointed. One action per screen. Tap any word
to translate. Easy the way Apple is easy.

Reference device: iPhone Safari. Flawless installable PWA, safe-areas
respected, Apple/Linear/Oura-grade visual quality (whitespace, one
refined accent color, premium type, buttery motion, aspirational
imagery). Palette + type are proposed at checkpoint 1 before any screen
is built.

## 2. Governing law: flexibility

Anything that might change is a DATABASE ROW, not code: content shelves,
achievement types, pricing plans, fields, countries, writing prompts,
opportunities. New idea = new rows + maybe one new component. Never
hardcode a list in a .ts file. Config tables + jsonb i18n labels
(`{"en":"...","uz":"...","ru":"..."}`) everywhere.

## 3. Tech stack

- Next.js (App Router) PWA, installable, offline-tolerant shell
- Supabase: Postgres + Auth + Storage (schema in
  `prepapp_001_foundation.sql`)
- AI: Claude Sonnet for essay feedback / mentor moments / content
  drafting; Claude Haiku for tap-to-translate (cached in `translations`
  — Haiku once, DB forever). Every model call is logged to `ai_calls`
  (model, purpose, tokens in/out) so cost is visible from day one.
- Payments: NONE automated in V1 — manual activation via admin panel.

## 4. Student journey

### 4.1 Onboarding (dream-first, ~2 minutes)
1. Language pick (uz / ru / en) → sets `students.ui_language`.
2. Dream screen: "What's your dream?" → pick/describe a field + target
   country → creates the first `dream_paths` row (`is_current=true`).
3. Interest chips screen: "What do you love?" (drawing, coding, helping
   people, building, debating, science, ...) → `interest_profiles.interests`.
4. Influence screen (one, gentle): "Whose dream is this?" me / my
   parents / together → `influence_*` booleans; if parents are involved,
   softly capture `parents_wish`.
5. About-you screen: name, `birth_year`, city, privacy acceptance
   (`privacy_accepted_at`). NOTHING financial — no budget, no funding
   questions, anywhere. (`budget_band` / `funding_hope` columns exist but
   stay dormant and never appear in UI.)
6. AI mentor bridges interests + career + parents_wish into
   `interest_profiles.ai_suggestions` (e.g. drawing + medicine →
   "biomedical illustration"), shown as encouragement, not a verdict.

Dream changes later are one tap and never judged: old `dream_paths` row
→ `is_current=false`, a `dream_transitions` row records from/to/reason
plus a supportive `ai_guidance` bridge message. Progress is never erased.

### 4.2 Placement test
Short adaptive assessment → `assessments` row with `band_estimate`
(IELTS-style bands, e.g. 3.0–7.5). Result screen speaks mentor language:
where you are, what your dream needs, the path between. This estimate
drives everything: reading level variants, writing prompt ladder,
opportunity distance.

### 4.3 Daily loop
One session a day, a few minutes, one action per screen:
- Reading: an item from the Library at the student's level variant
  (`reading_items.levels` keyed by band), with tap-any-word translation
  and comprehension questions.
- Exercises: short drills from `exercises` matched to level.
- Writing task 2–3×/week (see Writing Studio).
- Streak updates (`streaks`), everything logged to `activity_log`,
  levels silently refreshed as evidence accumulates.

### 4.4 Writing Studio (core section alongside the daily loop)
Prompt ladder by level from `writing_prompts` config: describe →
opinion → IELTS Task 2 → personal statements at band 6+. Text input
primary, voice-transcribe secondary (`essays.input_mode`). Sonnet
feedback in the student's ui_language, always in this shape: good
things FIRST, band estimate, max 3 fixes, one sentence rewrite example
(`essays.feedback` jsonb). Every essay silently refreshes the student's
level. Personal statements can be flagged `is_portfolio` to keep for
real applications. Essay content serves ONLY that student's level and
personalization — never extract family/financial details into profile
fields.

### 4.5 Library
Shelves are config rows (`content_shelves`), items are `reading_items`
with one story at many level variants. V1 seed scope:
- `general` shelf
- 2 field tracks: `it`, `medicine`
- `heritage` shelf — START HERE: 10 items (Ibn Sina, Al-Khwarizmi,
  Ulugh Beg, Navoi, Babur, Al-Biruni, Rudaki, Omar Khayyam, Tomyris,
  Al-Farghani), each at 3 level variants. REGION-NOT-NATION rule:
  figures carry `figure_city` + era only, never a modern nationality.
  `original_text` holds poems where relevant.
- `wisdom` shelf EMPTY in V1: structure only (opt_in=true,
  review_required=true); content ships only after the human review
  process exists.
Content pipeline: AI drafts items → `active=false` → Abdulaziz reviews
in the admin panel → activates. Nothing AI-drafted goes live unreviewed
on review-required shelves.

### 4.6 Achievements & sharing (the viral engine)
Achievement types are config rows. V1 ships: `streak_7`, `streak_30`,
band level-ups, `requirement_met`. On unlock: generate a gorgeous 9:16
share card matching the premium brand, one-tap share to Instagram
Story / TikTok / Telegram, card carries a personal invite link that
lands on the placement test. Track `shared_to` per achievement.
WORDING LAW: cards say "English requirement: MET — Cambridge", NEVER
"eligible for". Referral rewards UI is a later phase (schema ready).

### 4.7 Opportunities & unlocks
`opportunities` (university, country, funding, min IELTS, field track)
are shown relative to the student's dream and level; reaching the bar
creates an `unlocks` row and a `requirement_met` achievement. Students
who want human help go into `handoff_queue` toward partner `agencies`.
Real opportunity data comes from Abdulaziz — never invented.

### 4.8 Trial wall & pricing
Free trial covers onboarding, placement test, and a taste of the daily
loop; then the wall. Pricing display:
- Public plans genuinely purchasable: $69/mo (`public_monthly`),
  $499/yr (`public_annual`).
- Scholarship flow: AFTER completing the placement test, the student
  enters an agency code → "[Agency] grants you a 1-year scholarship:
  $99 instead of $828" with strikethrough anchor. Never the word
  "discount" — always "scholarship". Codes come from
  `scholarship_codes` (code = agency name, monthly_quota for scarcity,
  requires_placement_test=true).
- Payments are manual in V1: student pays out-of-band, admin activates
  the `subscriptions` row (linked to `plan_code`) in the admin panel.

## 5. Admin panel

Minimal, boring, effective:
- Students: search, view level/streak/essays, manual subscription
  activation.
- reading_items review queue: preview each level variant, edit,
  activate (the human-review gate for heritage/wisdom).
- scholarship_codes CRUD (quota, active).
- plans editing (prices, anchors, active).
- opportunities CRUD.
- handoff_queue triage.
- ai_calls cost view (tokens by model/purpose/day).

## 6. Build order & checkpoints

1. Checkpoint 1 — foundation: run `prepapp_001_foundation.sql`, app
   shell + PWA install, propose palette + type (approval before
   screens).
2. Onboarding + placement test.
3. Daily loop + Library (general/it/medicine + heritage seed).
4. Writing Studio.
5. Achievements + share cards.
6. Trial wall + pricing + scholarship codes.
7. Admin panel.

## 7. Blocked on Abdulaziz (ask, never invent)

1. 15–20 real opportunities (university, country, funding, min IELTS)
2. Agency codes to seed as scholarship codes
3. App name + domain
