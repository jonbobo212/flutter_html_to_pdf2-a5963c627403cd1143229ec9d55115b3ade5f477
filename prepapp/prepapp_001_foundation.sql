-- ============================================================================
-- prepapp_001_foundation.sql
-- Foundation schema for the dream-first English prep PWA (V1).
-- Postgres / Supabase. Implements every table referenced by
-- PREPAPP_ADDENDUM.md. Governing rule (FLEXIBILITY LAW): anything that
-- might change is a row, not code — config tables + jsonb i18n labels
-- ({"en":"...","uz":"...","ru":"..."}) everywhere.
-- ============================================================================

create extension if not exists pgcrypto;

-- ============================================================================
-- STUDENTS & DREAMS
-- ============================================================================

create table students (
  id                  uuid primary key default gen_random_uuid(),
  auth_user_id        uuid unique,                 -- supabase auth.users.id
  name                text,
  ui_language         text not null default 'uz',  -- 'uz' | 'ru' | 'en'
  city                text,
  birth_year          integer,
  privacy_accepted_at timestamptz,                 -- store the acceptance moment
  current_band        numeric(3,1),                -- latest level estimate (e.g. 5.5)
  -- Dormant fields: NEVER shown or asked in any UI (see addendum §9).
  budget_band         text,
  funding_hope        text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

create table dream_paths (
  id             uuid primary key default gen_random_uuid(),
  student_id     uuid not null references students(id) on delete cascade,
  field_track    text,                              -- e.g. 'it', 'medicine'
  dream_text     text,                              -- the student's own words
  target_country text,
  is_current     boolean not null default true,     -- old dreams flip false, never deleted
  created_at     timestamptz not null default now()
);
create index dream_paths_student_idx on dream_paths (student_id, is_current);

-- One row per student: interests + who the dream belongs to + AI bridges.
create table interest_profiles (
  id                uuid primary key default gen_random_uuid(),
  student_id        uuid not null unique references students(id) on delete cascade,
  interests         jsonb not null default '[]',    -- [{"area":"drawing","sub":"digital","strength":"high"}]
  influence_self    boolean not null default false,
  influence_parents boolean not null default false,
  influence_friends boolean not null default false,
  parents_wish      text,
  ai_suggestions    jsonb not null default '[]',    -- [{"program":"Media Design","why":"","fit":0.86}]
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

-- Dream changes = one tap, never judged. Progress never erased.
create table dream_transitions (
  id          uuid primary key default gen_random_uuid(),
  student_id  uuid not null references students(id) on delete cascade,
  from_path   uuid references dream_paths(id),
  to_path     uuid references dream_paths(id),
  reason      text,
  ai_guidance text,                                 -- the supportive bridge message
  created_at  timestamptz not null default now()
);
create index dream_transitions_student_idx on dream_transitions (student_id);

-- ============================================================================
-- ASSESSMENT & WRITING
-- ============================================================================

create table assessments (
  id            uuid primary key default gen_random_uuid(),
  student_id    uuid not null references students(id) on delete cascade,
  kind          text not null default 'placement'   -- 'placement' | 'refresh'
                check (kind in ('placement','refresh')),
  band_estimate numeric(3,1),
  detail        jsonb not null default '{}',        -- per-question answers, timings
  created_at    timestamptz not null default now()
);
create index assessments_student_idx on assessments (student_id, created_at desc);

-- Config: the prompt ladder. describe -> opinion -> ielts_task2 ->
-- personal_statement (band 6+).
create table writing_prompts (
  id          uuid primary key default gen_random_uuid(),
  code        text not null unique,
  kind        text not null
              check (kind in ('describe','opinion','ielts_task2','personal_statement')),
  level_min   numeric(3,1) not null,
  level_max   numeric(3,1) not null,
  prompt_i18n jsonb not null default '{}',
  field_track text,                                 -- optional shelf/track affinity
  active      boolean not null default true,
  created_at  timestamptz not null default now()
);

create table essays (
  id            uuid primary key default gen_random_uuid(),
  student_id    uuid not null references students(id) on delete cascade,
  prompt_id     uuid references writing_prompts(id),
  input_mode    text not null default 'text' check (input_mode in ('text','voice')),
  content       text not null,
  word_count    integer,
  band_estimate numeric(3,1),
  feedback      jsonb not null default '{}',        -- {good[], fixes[](max 3), rewrite_example}
  is_portfolio  boolean not null default false,     -- kept for real applications
  created_at    timestamptz not null default now()
);
create index essays_student_idx on essays (student_id, created_at desc);

-- ============================================================================
-- LIBRARY (config shelves + human-reviewed items)
-- ============================================================================

create table content_shelves (
  code            text primary key,                 -- 'general', 'it', 'heritage', ...
  title_i18n      jsonb not null default '{}',
  kind            text not null
                  check (kind in ('field_track','heritage','wisdom','general')),
  opt_in          boolean not null default false,   -- wisdom = true
  review_required boolean not null default false,   -- wisdom + heritage = true
  sort_order      integer not null default 0,
  active          boolean not null default true,
  created_at      timestamptz not null default now()
);

create table reading_items (
  id            uuid primary key default gen_random_uuid(),
  shelf_code    text not null references content_shelves(code),
  title_i18n    jsonb not null default '{}',
  -- One story, many levels: {"3.0":{"text":...,"questions":[...]},"5.0":{...}}
  levels        jsonb not null default '{}',
  -- REGION-NOT-NATION: city + era only, never modern nationality.
  figure_name   text,
  figure_city   text,
  original_text text,                               -- poems in the original
  reviewed_by   text,
  reviewed_at   timestamptz,
  active        boolean not null default false,     -- FALSE until human-reviewed
  created_at    timestamptz not null default now()
);
create index reading_items_shelf_idx on reading_items (shelf_code, active);

create table exercises (
  id         uuid primary key default gen_random_uuid(),
  kind       text not null,                         -- 'vocab', 'gap_fill', 'listening', ...
  level_min  numeric(3,1) not null,
  level_max  numeric(3,1) not null,
  content    jsonb not null default '{}',
  field_track text,
  active     boolean not null default true,
  created_at timestamptz not null default now()
);

-- Tap-any-word cache: Haiku once, DB forever.
create table translations (
  word        text not null,
  ui_language text not null,
  translation text not null,
  created_at  timestamptz not null default now(),
  primary key (word, ui_language)
);

-- ============================================================================
-- PROGRESS, ACHIEVEMENTS & SHARING
-- ============================================================================

create table streaks (
  student_id     uuid primary key references students(id) on delete cascade,
  current_streak integer not null default 0,
  longest_streak integer not null default 0,
  last_active_on date,
  updated_at     timestamptz not null default now()
);

create table activity_log (
  id         uuid primary key default gen_random_uuid(),
  student_id uuid not null references students(id) on delete cascade,
  kind       text not null,                         -- 'reading', 'exercise', 'essay', ...
  detail     jsonb not null default '{}',
  created_at timestamptz not null default now()
);
create index activity_log_student_idx on activity_log (student_id, created_at desc);

create table achievement_types (
  code       text primary key,                      -- 'streak_7', 'requirement_met', ...
  title_i18n jsonb not null default '{}',
  -- WORDING LAW: card copy says "English requirement: MET — Cambridge",
  -- NEVER "eligible for".
  card_i18n  jsonb not null default '{}',
  active     boolean not null default true,
  created_at timestamptz not null default now()
);

create table achievements (
  id             uuid primary key default gen_random_uuid(),
  student_id     uuid not null references students(id) on delete cascade,
  type_code      text not null references achievement_types(code),
  detail         jsonb not null default '{}',
  shared_to      text[] not null default '{}',      -- 'instagram','tiktok','telegram'
  share_card_url text,                              -- generated 9:16 card
  created_at     timestamptz not null default now()
);
create index achievements_student_idx on achievements (student_id, created_at desc);

-- ============================================================================
-- OPPORTUNITIES & HANDOFF
-- ============================================================================

-- Seeded ONLY from real data provided by Abdulaziz. Never invented.
create table opportunities (
  id          uuid primary key default gen_random_uuid(),
  university  text not null,
  country     text not null,
  funding     text,                                 -- e.g. 'full scholarship', 'tuition waiver'
  min_ielts   numeric(3,1),
  field_track text,
  detail      jsonb not null default '{}',
  active      boolean not null default true,
  created_at  timestamptz not null default now()
);

create table unlocks (
  id             uuid primary key default gen_random_uuid(),
  student_id     uuid not null references students(id) on delete cascade,
  opportunity_id uuid not null references opportunities(id) on delete cascade,
  created_at     timestamptz not null default now(),
  unique (student_id, opportunity_id)
);

create table agencies (
  id         uuid primary key default gen_random_uuid(),
  name       text not null unique,
  contact    jsonb not null default '{}',
  active     boolean not null default true,
  created_at timestamptz not null default now()
);

create table handoff_queue (
  id             uuid primary key default gen_random_uuid(),
  student_id     uuid not null references students(id) on delete cascade,
  opportunity_id uuid references opportunities(id),
  agency_id      uuid references agencies(id),
  status         text not null default 'new'
                 check (status in ('new','contacted','in_progress','done','dropped')),
  note           text,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);
create index handoff_queue_status_idx on handoff_queue (status, created_at);

-- ============================================================================
-- PLANS, SCHOLARSHIPS & SUBSCRIPTIONS
-- ============================================================================

create table plans (
  code             text primary key,                -- 'public_monthly', ...
  title_i18n       jsonb not null default '{}',
  price_usd        numeric(8,2) not null,
  anchor_price_usd numeric(8,2),                    -- strikethrough anchor
  period           text not null check (period in ('monthly','annual')),
  requires_code    boolean not null default false,
  active           boolean not null default true,
  created_at       timestamptz not null default now()
);

-- code = agency name. Entered AFTER placement test. Always "scholarship",
-- never "discount".
create table scholarship_codes (
  code                     text primary key,
  agency_id                uuid references agencies(id),
  plan_code                text not null references plans(code),
  monthly_quota            integer,                 -- scarcity
  requires_placement_test  boolean not null default true,
  active                   boolean not null default true,
  created_at               timestamptz not null default now()
);

-- Manual activation in V1: admin flips status to 'active' in the admin panel.
create table subscriptions (
  id               uuid primary key default gen_random_uuid(),
  student_id       uuid not null references students(id) on delete cascade,
  plan_code        text not null references plans(code),
  scholarship_code text references scholarship_codes(code),
  status           text not null default 'pending'
                   check (status in ('pending','active','expired','cancelled')),
  started_at       timestamptz,
  expires_at       timestamptz,
  activated_by     text,                            -- admin identifier
  created_at       timestamptz not null default now()
);
create index subscriptions_student_idx on subscriptions (student_id, status);

-- ============================================================================
-- AI COST VISIBILITY (from day one)
-- ============================================================================

create table ai_calls (
  id         uuid primary key default gen_random_uuid(),
  student_id uuid references students(id) on delete set null,
  model      text not null,                         -- 'haiku', 'sonnet', ...
  purpose    text not null,                         -- 'translate', 'essay_feedback', ...
  tokens_in  integer not null default 0,
  tokens_out integer not null default 0,
  created_at timestamptz not null default now()
);
create index ai_calls_created_idx on ai_calls (created_at desc);
create index ai_calls_purpose_idx on ai_calls (purpose, model);

-- ============================================================================
-- SEED DATA (config rows only — content stays inactive until human review;
-- opportunities / scholarship codes are BLOCKED on Abdulaziz, never invented)
-- ============================================================================

insert into plans (code, title_i18n, price_usd, anchor_price_usd, period, requires_code) values
  ('public_monthly',     '{"en":"Monthly","uz":"Oylik","ru":"Ежемесячно"}',                       69.00, null,   'monthly', false),
  ('public_annual',      '{"en":"Annual","uz":"Yillik","ru":"Годовой"}',                         499.00, null,   'annual',  false),
  ('agency_scholarship', '{"en":"1-Year Scholarship","uz":"1 yillik stipendiya","ru":"Стипендия на 1 год"}', 99.00, 828.00, 'annual', true);

insert into content_shelves (code, title_i18n, kind, opt_in, review_required, sort_order) values
  ('general',  '{"en":"Essentials","uz":"Asosiy","ru":"Основное"}',            'general',     false, false, 0),
  ('it',       '{"en":"IT & Tech","uz":"IT va texnologiya","ru":"IT и технологии"}', 'field_track', false, false, 1),
  ('medicine', '{"en":"Medicine","uz":"Tibbiyot","ru":"Медицина"}',            'field_track', false, false, 2),
  ('heritage', '{"en":"Our Heritage","uz":"Merosimiz","ru":"Наше наследие"}',  'heritage',    false, true,  3),
  ('wisdom',   '{"en":"Wisdom","uz":"Hikmat","ru":"Мудрость"}',                'wisdom',      true,  true,  4);
-- heritage V1 seed (10 items, 3 level variants each, region-not-nation) is
-- AI-drafted into reading_items with active=false, then reviewed in the
-- admin panel. wisdom ships EMPTY in V1.

insert into achievement_types (code, title_i18n) values
  ('streak_7',        '{"en":"7-Day Streak","uz":"7 kunlik seriya","ru":"Серия 7 дней"}'),
  ('streak_30',       '{"en":"30-Day Streak","uz":"30 kunlik seriya","ru":"Серия 30 дней"}'),
  ('band_level_up',   '{"en":"Level Up","uz":"Yangi daraja","ru":"Новый уровень"}'),
  ('requirement_met', '{"en":"Requirement Met","uz":"Talab bajarildi","ru":"Требование выполнено"}');

insert into writing_prompts (code, kind, level_min, level_max, prompt_i18n) values
  ('describe_hometown',   'describe',           2.0, 4.0, '{"en":"Describe your hometown. What do you love about it?"}'),
  ('describe_best_day',   'describe',           2.5, 4.5, '{"en":"Describe the best day you remember. What made it special?"}'),
  ('opinion_phones',      'opinion',            4.0, 5.5, '{"en":"Should phones be allowed in class? Say what you think and why."}'),
  ('opinion_study_abroad','opinion',            4.5, 6.0, '{"en":"Is it better to study in your own country or abroad? Explain your view."}'),
  ('ielts_t2_technology', 'ielts_task2',        5.0, 7.0, '{"en":"Some people believe technology makes us less social. To what extent do you agree or disagree?"}'),
  ('ielts_t2_education',  'ielts_task2',        5.5, 7.5, '{"en":"Some say university education should be free for everyone. Discuss both views and give your opinion."}'),
  ('ps_why_this_field',   'personal_statement', 6.0, 9.0, '{"en":"Why this field? Tell the story that led you to your dream program."}');
