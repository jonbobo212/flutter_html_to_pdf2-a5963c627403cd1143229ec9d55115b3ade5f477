# PREPAPP_ADDENDUM.md — supersedes PREPAPP_TASK_V1.md where they conflict

## FLEXIBILITY LAW (governs everything)
Anything that might change is a DATABASE ROW, not code: content shelves,
achievement types, pricing plans, fields, countries, prompts, opportunities.
New idea = new rows + maybe one new component. If you're hardcoding a list
in a .ts file, stop. Config tables + jsonb i18n labels everywhere.

## SCHEMA ADDITIONS (run after prepapp_001_foundation.sql)
1. interest_profiles: student_id unique FK, interests jsonb
   ([{"area":"drawing","sub":"digital","strength":"high"}]),
   influence_self/parents/friends booleans, parents_wish text,
   ai_suggestions jsonb ([{"program":"Media Design","why":"","fit":0.86}]).
2. dream_transitions: from_path, to_path, reason, ai_guidance (the
   supportive bridge message). Dream changes = one tap, never judged;
   old dream_paths row -> is_current=false, progress never erased.
3. essays: student_id, prompt_id, input_mode text|voice, content,
   word_count, band_estimate, feedback jsonb {good[],fixes[](max 3),
   rewrite_example}, is_portfolio bool. + writing_prompts config table
   (level_min/max, kind: describe|opinion|ielts_task2|personal_statement,
   prompt_i18n jsonb, field_track).
4. content_shelves config: code, title_i18n, kind field_track|heritage|
   wisdom|general, opt_in bool (wisdom=true), review_required bool
   (wisdom+heritage=true). reading_items: shelf_code, title_i18n,
   levels jsonb {"3.0":{text,questions},"5.0":{...}} (one story, many
   levels), figure_name, figure_city (REGION-NOT-NATION: city+era only,
   never modern nationality), original_text (poems), reviewed_by/at,
   active default FALSE until human-reviewed.
5. achievement_types config + achievements: type_code, detail jsonb,
   shared_to text[], share_card_url. WORDING LAW: cards say
   "English requirement: MET — Cambridge", NEVER "eligible for".
6. plans config (public_monthly $69, public_annual $499,
   agency_scholarship $99 anchor $828, requires_code=true) +
   scholarship_codes (code=agency name, monthly_quota for scarcity,
   requires_placement_test=true) + link subscriptions to plan_code.
7. translations cache table (word+ui_language pk) — Haiku once, DB forever.
8. ai_calls log: model, purpose, tokens in/out — cost visible from day one.
9. Remove budget_band/funding_hope from ALL UI. Fields stay dormant.
   Add students.birth_year + privacy_accepted_at (store policy). No other
   personal/financial questions anywhere. Essay content serves ONLY that
   student's level/personalization — never extract family/financial
   details into profile fields.

## PREMIUM REPOSITIONING (replaces "cheap Android" framing)
Audience: top-1% students with iPhones. Apple-grade design: think
Apple/Linear/Oura — whitespace, one refined accent, premium type,
buttery motion, aspirational imagery. iPhone Safari = reference device;
flawless installable PWA, safe-areas respected. Still one action per
screen, tap-any-word translation — easy the way Apple is easy.
Propose palette + type at checkpoint 1 before building screens.

## ONBOARDING ADDITIONS (between dream-field and about-you screens)
+ Interest chips screen: "What do you love?" (drawing, coding, helping
  people, building, debating, science...) -> interest_profiles.
+ One gentle influence screen: "Whose dream is this?" me / my parents /
  together -> if parents, capture parents_wish softly.
AI mentor tone everywhere: warm, teenager-respecting, in their language,
never clinical or disappointed. Bridges interest+career+parents_wish in
ai_suggestions (drawing+medicine -> "biomedical illustration").

## WRITING STUDIO (new core section, alongside daily loop)
Prompt ladder by level (describe -> opinion -> IELTS Task 2 ->
personal statements at 6+). Text primary, voice-transcribe secondary.
Sonnet feedback: good things FIRST, band estimate, max 3 fixes,
one sentence rewrite example, all in ui_language. Every essay
silently refreshes their level. Portfolio flag for statements they
keep for real applications. Daily loop gains a writing task 2-3x/week.

## ACHIEVEMENT SHARING (the viral engine)
On achievement: generate a gorgeous 9:16 share card (matches premium
brand), one-tap share to Instagram Story / TikTok / Telegram, card
carries personal invite link -> lands on placement test. Track
shared_to. V1 ships: streak_7/30, band level-ups, requirement_met
cards. Referral rewards UI = later phase (schema ready).

## PRICING DISPLAY
Public $69/mo · $499/yr genuinely purchasable. Scholarship flow:
enter agency code AFTER completing placement test -> "[Agency] grants
you a 1-year scholarship: $99 instead of $828" with strikethrough.
Never the word "discount" — always "scholarship". Payments still
manual-activation in V1 via admin panel.

## LIBRARY V1 SCOPE
Seed shelves: general + 2 field tracks (it, medicine) + heritage
(START HERE: 10 items — Ibn Sina, Al-Khwarizmi, Ulugh Beg, Navoi,
Babur, Al-Biruni, Rudaki, Omar Khayyam, Tomyris, Al-Farghani; each
at 3 level variants; figure_city per region-not-nation rule) +
wisdom shelf EMPTY in V1 (structure only; content ships after human
review process exists). AI drafts all items -> active=false ->
Abdulaziz reviews in admin panel -> activates. Admin panel gains:
reading_items review queue, scholarship_codes CRUD, plans editing.

## STILL BLOCKED ON ABDULAZIZ (ask, never invent)
1. 15-20 real opportunities (university, country, funding, min IELTS)
2. Agency codes to seed as scholarship codes
3. App name + domain
