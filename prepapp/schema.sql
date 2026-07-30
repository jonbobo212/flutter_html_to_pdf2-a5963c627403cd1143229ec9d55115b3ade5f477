-- ============================================================================
-- prepapp — live schema snapshot
-- ----------------------------------------------------------------------------
-- Generated from the live Supabase project `prepapp`
-- (ref tqeljmplvhcaaypgfihe, region ap-south-1) as a version-controlled
-- reflection of the actual database.
--
-- The project evolved mostly through ad-hoc SQL rather than tracked
-- migrations (only prepapp_001_foundation and prepapp_034_classroom are
-- recorded in supabase_migrations.schema_migrations), so this file is the
-- authoritative structural record.
--
-- STRUCTURE ONLY: no table rows are included. The live tables hold real
-- student data (PII) which must never be committed to source control.
--
-- Governing rule (FLEXIBILITY LAW): anything that might change is a row,
-- not code — config tables + jsonb i18n labels ({"en":..,"uz":..,"ru":..}).
-- ============================================================================

create extension if not exists pgcrypto;

-- ============================================================================
-- TABLES
-- ============================================================================

-- --- STUDENTS & DREAMS -------------------------------------------------------

create table students (
  id uuid not null default gen_random_uuid(),
  auth_user_id uuid,
  name text,
  ui_language text not null default 'uz'::text,
  city text,
  birth_year integer,
  privacy_accepted_at timestamptz,
  current_band numeric(3,1),
  budget_band text,
  funding_hope text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  referred_by uuid,
  telegram_id bigint,
  telegram_username text,
  target_language text not null default 'en'::text,
  german_cefr text,
  email text,
  phone text,
  target_university_slug text,
  target_band numeric(3,1),
  source text,
  notify_opt_out boolean not null default false,
  education_stage text,
  study_level text,
  nationality text,
  docs_ready jsonb not null default '{}'::jsonb,
  agency_ref text,
  utm_source text,
  agency_ref_captured_at timestamptz,
  school_code text,
  school_name text,
  english_center_code text,
  english_center_name text,
  primary key (id)
);

create table dream_paths (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  field_track text,
  dream_text text,
  target_country text,
  is_current boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (id)
);

create table interest_profiles (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  interests jsonb not null default '[]'::jsonb,
  influence_self boolean not null default false,
  influence_parents boolean not null default false,
  influence_friends boolean not null default false,
  parents_wish text,
  ai_suggestions jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (id)
);

create table dream_transitions (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  from_path uuid,
  to_path uuid,
  reason text,
  ai_guidance text,
  created_at timestamptz not null default now(),
  primary key (id)
);

-- --- ASSESSMENT & WRITING ----------------------------------------------------

create table assessments (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  kind text not null default 'placement'::text,
  band_estimate numeric(3,1),
  detail jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  primary key (id)
);

create table writing_prompts (
  id uuid not null default gen_random_uuid(),
  code text not null,
  kind text not null,
  level_min numeric(3,1) not null,
  level_max numeric(3,1) not null,
  prompt_i18n jsonb not null default '{}'::jsonb,
  field_track text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (id)
);

create table essays (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  prompt_id uuid,
  input_mode text not null default 'text'::text,
  content text not null,
  word_count integer,
  band_estimate numeric(3,1),
  feedback jsonb not null default '{}'::jsonb,
  is_portfolio boolean not null default false,
  created_at timestamptz not null default now(),
  primary key (id)
);

-- --- LIBRARY -----------------------------------------------------------------

create table content_shelves (
  code text not null,
  title_i18n jsonb not null default '{}'::jsonb,
  kind text not null,
  opt_in boolean not null default false,
  review_required boolean not null default false,
  sort_order integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (code)
);

create table reading_items (
  id uuid not null default gen_random_uuid(),
  shelf_code text not null,
  title_i18n jsonb not null default '{}'::jsonb,
  levels jsonb not null default '{}'::jsonb,
  figure_name text,
  figure_city text,
  original_text text,
  reviewed_by text,
  reviewed_at timestamptz,
  active boolean not null default false,
  created_at timestamptz not null default now(),
  primary key (id)
);

create table exercises (
  id uuid not null default gen_random_uuid(),
  kind text not null,
  level_min numeric(3,1) not null,
  level_max numeric(3,1) not null,
  content jsonb not null default '{}'::jsonb,
  field_track text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (id)
);

-- Tap-any-word cache: Haiku once, DB forever.
create table translations (
  word text not null,
  ui_language text not null,
  translation text not null,
  created_at timestamptz not null default now(),
  primary key (word, ui_language)
);

-- Longer-text translation cache keyed by content hash.
create table content_translations (
  text_hash text not null,
  ui_language text not null,
  source_text text not null,
  translation text not null,
  created_at timestamptz default now(),
  primary key (text_hash, ui_language)
);

-- Level-matched vocabulary game words.
create table vocab_words (
  id uuid not null default gen_random_uuid(),
  word text not null,
  meaning_en text not null,
  example_en text,
  band_min numeric(3,1) not null default 3.0,
  band_max numeric(3,1) not null default 9.0,
  theme text not null default 'general'::text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  field_track text,
  primary key (id)
);

-- German / language-track lesson content (CEFR levels, units).
create table lessons (
  id uuid not null default gen_random_uuid(),
  language text not null default 'de'::text,
  cefr_level text not null,
  unit integer not null default 1,
  lesson_order integer not null default 1,
  kind text not null,
  title_i18n jsonb not null default '{}'::jsonb,
  content jsonb not null default '{}'::jsonb,
  reviewed_by text,
  reviewed_at timestamptz,
  active boolean not null default false,
  created_at timestamptz not null default now(),
  primary key (id)
);

-- --- PROGRESS, ACHIEVEMENTS & SHARING ----------------------------------------

create table streaks (
  student_id uuid not null,
  current_streak integer not null default 0,
  longest_streak integer not null default 0,
  last_active_on date,
  updated_at timestamptz not null default now(),
  primary key (student_id)
);

create table activity_log (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  kind text not null,
  detail jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  primary key (id)
);

create table achievement_types (
  code text not null,
  title_i18n jsonb not null default '{}'::jsonb,
  card_i18n jsonb not null default '{}'::jsonb,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (code)
);

create table achievements (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  type_code text not null,
  detail jsonb not null default '{}'::jsonb,
  shared_to text[] not null default '{}'::text[],
  share_card_url text,
  created_at timestamptz not null default now(),
  primary key (id)
);

-- --- OPPORTUNITIES & HANDOFF -------------------------------------------------

create table opportunities (
  id uuid not null default gen_random_uuid(),
  university text not null,
  country text not null,
  funding text,
  min_ielts numeric(3,1),
  field_track text,
  detail jsonb not null default '{}'::jsonb,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  world_rank integer,
  program text,
  grant_available boolean not null default false,
  grant_min_ielts numeric(3,1),
  intake_2027 text,
  german_min_cefr text,
  founded_year integer,
  grant_value text,
  famous_alumni jsonb not null default '[]'::jsonb,
  notable_stats jsonb not null default '[]'::jsonb,
  image_url text,
  highlight text,
  country_code text,
  t100u_slug text,
  primary key (id)
);

create table unlocks (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  opportunity_id uuid not null,
  created_at timestamptz not null default now(),
  primary key (id)
);

create table agencies (
  id uuid not null default gen_random_uuid(),
  name text not null,
  contact jsonb not null default '{}'::jsonb,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (id)
);

create table handoff_queue (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  opportunity_id uuid,
  agency_id uuid,
  status text not null default 'new'::text,
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (id)
);

-- Countries directory for the Explore-universities experience.
create table countries (
  code text not null,
  name_i18n jsonb not null default '{}'::jsonb,
  flag text,
  blurb_en text,
  post_study_visa text,
  pr_option text,
  living text,
  career text,
  image_url text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (code)
);

-- Student-submitted partner (school / english-center) suggestions.
create table partner_suggestions (
  id uuid not null default gen_random_uuid(),
  student_id uuid,
  type text not null,
  name text not null,
  city text,
  country text,
  status text not null default 'new'::text,
  created_at timestamptz not null default now(),
  primary key (id)
);

-- --- CLASSROOM (teacher-created classes + membership) ------------------------

create table classes (
  id uuid not null default gen_random_uuid(),
  code text not null,
  token text not null,
  title text,
  teacher_name text,
  school_code text,
  created_at timestamptz not null default now(),
  primary key (id)
);

create table class_members (
  class_id uuid not null,
  student_id uuid not null,
  joined_at timestamptz not null default now(),
  primary key (class_id, student_id)
);

-- --- PLANS, SCHOLARSHIPS & SUBSCRIPTIONS -------------------------------------

create table plans (
  code text not null,
  title_i18n jsonb not null default '{}'::jsonb,
  price_usd numeric(8,2) not null,
  anchor_price_usd numeric(8,2),
  period text not null,
  requires_code boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (code)
);

create table scholarship_codes (
  code text not null,
  agency_id uuid,
  plan_code text not null,
  monthly_quota integer,
  requires_placement_test boolean not null default true,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (code)
);

create table subscriptions (
  id uuid not null default gen_random_uuid(),
  student_id uuid not null,
  plan_code text not null,
  scholarship_code text,
  status text not null default 'pending'::text,
  started_at timestamptz,
  expires_at timestamptz,
  activated_by text,
  created_at timestamptz not null default now(),
  primary key (id)
);

-- --- AI COST VISIBILITY ------------------------------------------------------

create table ai_calls (
  id uuid not null default gen_random_uuid(),
  student_id uuid,
  model text not null,
  purpose text not null,
  tokens_in integer not null default 0,
  tokens_out integer not null default 0,
  created_at timestamptz not null default now(),
  primary key (id)
);

-- ============================================================================
-- UNIQUE & CHECK CONSTRAINTS
-- ============================================================================

alter table agencies          add constraint agencies_name_key unique (name);
alter table classes           add constraint classes_code_key unique (code);
alter table interest_profiles add constraint interest_profiles_student_id_key unique (student_id);
alter table students          add constraint students_auth_user_id_key unique (auth_user_id);
alter table students          add constraint students_telegram_id_key unique (telegram_id);
alter table unlocks           add constraint unlocks_student_id_opportunity_id_key unique (student_id, opportunity_id);
alter table writing_prompts   add constraint writing_prompts_code_key unique (code);

alter table assessments     add constraint assessments_kind_check check (kind = any (array['placement'::text, 'refresh'::text]));
alter table content_shelves add constraint content_shelves_kind_check check (kind = any (array['field_track'::text, 'heritage'::text, 'wisdom'::text, 'general'::text]));
alter table essays          add constraint essays_input_mode_check check (input_mode = any (array['text'::text, 'voice'::text]));
alter table handoff_queue   add constraint handoff_queue_status_check check (status = any (array['new'::text, 'contacted'::text, 'in_progress'::text, 'done'::text, 'dropped'::text]));
alter table plans           add constraint plans_period_check check (period = any (array['monthly'::text, 'annual'::text]));
alter table subscriptions   add constraint subscriptions_status_check check (status = any (array['pending'::text, 'active'::text, 'expired'::text, 'cancelled'::text]));
alter table writing_prompts add constraint writing_prompts_kind_check check (kind = any (array['describe'::text, 'opinion'::text, 'ielts_task2'::text, 'personal_statement'::text]));

-- ============================================================================
-- FOREIGN KEYS
-- ============================================================================

alter table achievements      add constraint achievements_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table achievements      add constraint achievements_type_code_fkey foreign key (type_code) references achievement_types(code);
alter table activity_log      add constraint activity_log_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table ai_calls          add constraint ai_calls_student_id_fkey foreign key (student_id) references students(id) on delete set null;
alter table assessments       add constraint assessments_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table class_members     add constraint class_members_class_id_fkey foreign key (class_id) references classes(id) on delete cascade;
alter table dream_paths       add constraint dream_paths_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table dream_transitions add constraint dream_transitions_from_path_fkey foreign key (from_path) references dream_paths(id);
alter table dream_transitions add constraint dream_transitions_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table dream_transitions add constraint dream_transitions_to_path_fkey foreign key (to_path) references dream_paths(id);
alter table essays            add constraint essays_prompt_id_fkey foreign key (prompt_id) references writing_prompts(id);
alter table essays            add constraint essays_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table handoff_queue     add constraint handoff_queue_agency_id_fkey foreign key (agency_id) references agencies(id);
alter table handoff_queue     add constraint handoff_queue_opportunity_id_fkey foreign key (opportunity_id) references opportunities(id);
alter table handoff_queue     add constraint handoff_queue_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table interest_profiles add constraint interest_profiles_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table reading_items     add constraint reading_items_shelf_code_fkey foreign key (shelf_code) references content_shelves(code);
alter table scholarship_codes add constraint scholarship_codes_agency_id_fkey foreign key (agency_id) references agencies(id);
alter table scholarship_codes add constraint scholarship_codes_plan_code_fkey foreign key (plan_code) references plans(code);
alter table streaks           add constraint streaks_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table students          add constraint students_referred_by_fkey foreign key (referred_by) references students(id);
alter table subscriptions     add constraint subscriptions_plan_code_fkey foreign key (plan_code) references plans(code);
alter table subscriptions     add constraint subscriptions_scholarship_code_fkey foreign key (scholarship_code) references scholarship_codes(code);
alter table subscriptions     add constraint subscriptions_student_id_fkey foreign key (student_id) references students(id) on delete cascade;
alter table unlocks           add constraint unlocks_opportunity_id_fkey foreign key (opportunity_id) references opportunities(id) on delete cascade;
alter table unlocks           add constraint unlocks_student_id_fkey foreign key (student_id) references students(id) on delete cascade;

-- ============================================================================
-- INDEXES
-- ============================================================================

create index achievements_student_idx on public.achievements using btree (student_id, created_at desc);
create index achievements_type_code_idx on public.achievements using btree (type_code);
create index activity_log_student_idx on public.activity_log using btree (student_id, created_at desc);
create index activity_log_student_kind_idx on public.activity_log using btree (student_id, kind);
create index opportunities_t100u_slug_idx on public.opportunities using btree (t100u_slug) where (t100u_slug is not null);
create index opportunities_world_rank_idx on public.opportunities using btree (world_rank) where (world_rank is not null);
create index opportunities_country_code_idx on public.opportunities using btree (country_code, active);
create index ai_calls_created_idx on public.ai_calls using btree (created_at desc);
create index ai_calls_purpose_idx on public.ai_calls using btree (purpose, model);
create index ai_calls_student_id_idx on public.ai_calls using btree (student_id);
create index assessments_student_idx on public.assessments using btree (student_id, created_at desc);
create index class_members_class_idx on public.class_members using btree (class_id);
create index dream_paths_student_idx on public.dream_paths using btree (student_id, is_current);
create index dream_transitions_from_path_idx on public.dream_transitions using btree (from_path);
create index dream_transitions_student_idx on public.dream_transitions using btree (student_id);
create index dream_transitions_to_path_idx on public.dream_transitions using btree (to_path);
create index essays_prompt_id_idx on public.essays using btree (prompt_id);
create index essays_student_idx on public.essays using btree (student_id, created_at desc);
create index handoff_queue_agency_id_idx on public.handoff_queue using btree (agency_id);
create index handoff_queue_opportunity_id_idx on public.handoff_queue using btree (opportunity_id);
create index handoff_queue_status_idx on public.handoff_queue using btree (status, created_at);
create index handoff_queue_student_id_idx on public.handoff_queue using btree (student_id);
create index lessons_lookup_idx on public.lessons using btree (language, cefr_level, unit, lesson_order);
create index reading_items_shelf_idx on public.reading_items using btree (shelf_code, active);
create index scholarship_codes_agency_id_idx on public.scholarship_codes using btree (agency_id);
create index scholarship_codes_plan_code_idx on public.scholarship_codes using btree (plan_code);
create unique index students_email_uidx on public.students using btree (lower(email)) where (email is not null);
create index students_referred_by_idx on public.students using btree (referred_by);
create index subscriptions_plan_code_idx on public.subscriptions using btree (plan_code);
create index subscriptions_scholarship_code_idx on public.subscriptions using btree (scholarship_code);
create index subscriptions_student_idx on public.subscriptions using btree (student_id, status);
create index unlocks_opportunity_id_idx on public.unlocks using btree (opportunity_id);
create index vocab_band_idx on public.vocab_words using btree (band_min, band_max, active);
create index vocab_words_field_idx on public.vocab_words using btree (field_track) where (field_track is not null);

-- ============================================================================
-- FUNCTIONS (all SECURITY DEFINER, search_path = public)
-- ============================================================================

create or replace function public.check_scholarship_code(p_code text)
 returns table(agency_name text, plan_code text, price_usd numeric, anchor_price_usd numeric)
 language sql security definer set search_path to 'public'
as $function$
  select
    coalesce(a.name, sc.code) as agency_name,
    p.code                    as plan_code,
    p.price_usd,
    p.anchor_price_usd
  from scholarship_codes sc
  join plans p on p.code = sc.plan_code and p.active
  left join agencies a on a.id = sc.agency_id
  where lower(sc.code) = lower(trim(p_code))
    and sc.active
    and (
      sc.monthly_quota is null
      or (
        select count(*) from subscriptions s
        where s.scholarship_code = sc.code
          and s.created_at >= date_trunc('month', now())
      ) < sc.monthly_quota
    );
$function$;

create or replace function public.create_class(p_title text, p_teacher_name text, p_school_code text default null::text)
 returns table(code text, token text)
 language plpgsql security definer set search_path to 'public'
as $function$
declare
  v_code  text;
  v_token text := replace(gen_random_uuid()::text, '-', '');
  v_alpha text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  i int; tries int := 0;
begin
  loop
    v_code := '';
    for i in 1..6 loop
      v_code := v_code || substr(v_alpha, 1 + floor(random()*length(v_alpha))::int, 1);
    end loop;
    exit when not exists (select 1 from classes c where c.code = v_code);
    tries := tries + 1;
    if tries > 30 then raise exception 'could not allocate class code'; end if;
  end loop;
  insert into classes (code, token, title, teacher_name, school_code)
    values (v_code, v_token, p_title, p_teacher_name, p_school_code);
  return query select v_code, v_token;
end; $function$;

create or replace function public.explore_universities()
 returns setof opportunities
 language sql security definer set search_path to 'public'
as $function$
  select * from opportunities where world_rank is not null order by world_rank;
$function$;

create or replace function public.get_activity(p_id uuid, p_today boolean default false)
 returns table(kind text, detail jsonb, created_at timestamp with time zone)
 language sql security definer set search_path to 'public'
as $function$
  select a.kind, a.detail, a.created_at
  from activity_log a
  where a.student_id = p_id
    and (not p_today or a.created_at >= date_trunc('day', now()));
$function$;

create or replace function public.get_class_board(p_code text, p_token text)
 returns json
 language plpgsql security definer set search_path to 'public'
as $function$
declare v_class classes%rowtype; v json;
begin
  select * into v_class from classes where code = upper(p_code);
  if not found or v_class.token <> p_token then return null; end if;
  select json_build_object(
    'code', v_class.code, 'title', v_class.title,
    'teacher_name', v_class.teacher_name, 'school_code', v_class.school_code,
    'members', coalesce((
      select json_agg(json_build_object(
        'name', s.name, 'city', s.city,
        'current_band', s.current_band, 'target_band', s.target_band,
        'target_university_slug', s.target_university_slug,
        'streak', coalesce(st.current_streak, 0),
        'last_active', st.last_active_on,
        'activity_count', (select count(*) from activity_log a where a.student_id = s.id),
        'mock_count', (select count(*) from activity_log a
                        where a.student_id = s.id and a.kind in
                        ('mock_reading','mock_listening','mock_writing','mock_speaking','sat_practice')),
        'joined_at', m.joined_at
      ) order by m.joined_at)
      from class_members m
      join students s on s.id = m.student_id
      left join streaks st on st.student_id = s.id
      where m.class_id = v_class.id
    ), '[]'::json)
  ) into v;
  return v;
end; $function$;

create or replace function public.get_class_public(p_code text)
 returns json
 language plpgsql security definer set search_path to 'public'
as $function$
declare v json;
begin
  select json_build_object(
    'code', c.code, 'title', c.title, 'teacher_name', c.teacher_name,
    'school_code', c.school_code,
    'member_count', (select count(*) from class_members m where m.class_id = c.id)
  ) into v from classes c where c.code = upper(p_code);
  return v;
end; $function$;

create or replace function public.get_notify(p_id uuid)
 returns boolean
 language sql security definer set search_path to 'public'
as $function$
  select coalesce(notify_opt_out, false) from students where id = p_id;
$function$;

create or replace function public.get_streak(p_id uuid)
 returns table(current_streak integer, longest_streak integer, last_active_on date)
 language sql security definer set search_path to 'public'
as $function$
  select current_streak, longest_streak, last_active_on
  from streaks where student_id = p_id;
$function$;

create or replace function public.get_student(p_id uuid)
 returns table(current_band numeric, name text, ui_language text, telegram_username text)
 language sql security definer set search_path to 'public'
as $function$
  select current_band, name, ui_language, telegram_username
  from students where id = p_id;
$function$;

create or replace function public.get_university_enrichment(p_slug text)
 returns table(min_ielts numeric, german_min_cefr text, grant_value text, founded_year integer, famous_alumni jsonb, notable_stats jsonb, intake_2027 text)
 language sql security definer set search_path to 'public'
as $function$
  select min_ielts, german_min_cefr, grant_value, founded_year,
         famous_alumni, notable_stats, intake_2027
  from opportunities where t100u_slug = p_slug limit 1;
$function$;

create or replace function public.join_class(p_code text, p_student uuid)
 returns boolean
 language plpgsql security definer set search_path to 'public'
as $function$
declare v_id uuid;
begin
  select id into v_id from classes where code = upper(p_code);
  if v_id is null then return false; end if;
  insert into class_members (class_id, student_id) values (v_id, p_student)
    on conflict (class_id, student_id) do nothing;
  return true;
end; $function$;

create or replace function public.mark_achievement_shared(p_id uuid, p_channel text)
 returns void
 language sql security definer set search_path to 'public'
as $function$
  update achievements
  set shared_to = (
    select array(select distinct e from unnest(coalesce(shared_to, '{}'::text[]) || array[p_channel]) e)
  )
  where id = p_id;
$function$;

create or replace function public.nudge_candidates()
 returns table(student_id uuid, telegram_id bigint, name text, ui_language text, streak integer, docs_ready boolean, target_slug text)
 language sql security definer set search_path to 'public'
as $function$
  select s.id, s.telegram_id, s.name, s.ui_language, coalesce(st.current_streak, 0),
         (coalesce((s.docs_ready->>'ielts')::boolean,false)
          and coalesce((s.docs_ready->>'transcript')::boolean,false)
          and coalesce((s.docs_ready->>'statement')::boolean,false)
          and coalesce((s.docs_ready->>'recommendation')::boolean,false)) as docs_ready,
         s.target_university_slug as target_slug
  from students s
  left join streaks st on st.student_id = s.id
  where s.telegram_id is not null
    and coalesce(s.notify_opt_out, false) = false
    and not exists (
      select 1 from activity_log a
      where a.student_id = s.id and a.created_at >= date_trunc('day', now())
    );
$function$;

create or replace function public.record_streak(p_id uuid)
 returns integer
 language plpgsql security definer set search_path to 'public'
as $function$
declare r streaks%rowtype; today date := current_date; nextv int;
begin
  select * into r from streaks where student_id = p_id;
  if not found then
    insert into streaks (student_id, current_streak, longest_streak, last_active_on)
      values (p_id, 1, 1, today)
      on conflict (student_id) do nothing;
    return 1;
  end if;
  if r.last_active_on = today then return r.current_streak; end if;
  if r.last_active_on = today - 1 then nextv := r.current_streak + 1; else nextv := 1; end if;
  update streaks set current_streak = nextv,
    longest_streak = greatest(nextv, r.longest_streak),
    last_active_on = today, updated_at = now()
  where student_id = p_id;
  return nextv;
end; $function$;

create or replace function public.resolve_enrollment(p_email text)
 returns table(id uuid, target_university_slug text, target_band numeric, target_language text, ui_language text)
 language sql security definer set search_path to 'public'
as $function$
  select id, target_university_slug, target_band, target_language, ui_language
  from students where lower(email) = lower(trim(p_email)) limit 1;
$function$;

create or replace function public.resolve_ref(p_ref text)
 returns uuid
 language sql security definer set search_path to 'public'
as $function$
  select id from students
  where left(id::text, 8) = lower(p_ref)
  order by created_at
  limit 1;
$function$;

create or replace function public.retire_current_dream(p_id uuid)
 returns void
 language sql security definer set search_path to 'public'
as $function$
  update dream_paths set is_current = false
  where student_id = p_id and is_current = true;
$function$;

create or replace function public.save_interest_profile(p_student_id uuid, p_interests jsonb, p_influence_self boolean, p_influence_parents boolean, p_parents_wish text)
 returns void
 language sql security definer set search_path to 'public'
as $function$
  insert into interest_profiles (student_id, interests, influence_self, influence_parents, parents_wish)
  values (p_student_id, p_interests, p_influence_self, p_influence_parents, p_parents_wish)
  on conflict (student_id) do update set
    interests = excluded.interests,
    influence_self = excluded.influence_self,
    influence_parents = excluded.influence_parents,
    parents_wish = excluded.parents_wish,
    updated_at = now();
$function$;

create or replace function public.set_docs_ready(p_id uuid, p_docs jsonb)
 returns void
 language sql security definer set search_path to 'public'
as $function$
  update students set docs_ready = coalesce(p_docs, '{}'::jsonb), updated_at = now()
  where id = p_id;
$function$;

create or replace function public.set_essay_portfolio(p_id uuid, p_on boolean)
 returns void
 language sql security definer set search_path to 'public'
as $function$
  update essays set is_portfolio = p_on where id = p_id;
$function$;

create or replace function public.stamp_agency_ref_captured_at()
 returns trigger
 language plpgsql
as $function$
begin
  -- First time a row carries an agency_ref without a capture time, stamp the
  -- server clock. Never overwritten afterwards (first-touch on our side).
  if new.agency_ref is not null and new.agency_ref_captured_at is null then
    new.agency_ref_captured_at := now();
  end if;
  return new;
end;
$function$;

create or replace function public.update_student(p_id uuid, p_current_band numeric default null::numeric, p_education_stage text default null::text, p_study_level text default null::text, p_ui_language text default null::text, p_target_language text default null::text, p_german_cefr text default null::text, p_target_university_slug text default null::text, p_notify_opt_out boolean default null::boolean, p_name text default null::text, p_birth_year integer default null::integer, p_city text default null::text, p_target_band numeric default null::numeric, p_nationality text default null::text)
 returns void
 language plpgsql security definer set search_path to 'public'
as $function$
begin
  update students set
    current_band = coalesce(p_current_band, current_band),
    education_stage = coalesce(p_education_stage, education_stage),
    study_level = coalesce(p_study_level, study_level),
    ui_language = coalesce(p_ui_language, ui_language),
    target_language = coalesce(p_target_language, target_language),
    german_cefr = coalesce(p_german_cefr, german_cefr),
    target_university_slug = coalesce(p_target_university_slug, target_university_slug),
    notify_opt_out = coalesce(p_notify_opt_out, notify_opt_out),
    name = coalesce(p_name, name),
    birth_year = coalesce(p_birth_year, birth_year),
    city = coalesce(p_city, city),
    target_band = coalesce(p_target_band, target_band),
    nationality = coalesce(p_nationality, nationality),
    updated_at = now()
  where id = p_id;
end; $function$;

create or replace function public.get_daily_words(p_band numeric default 5.0, p_field text default null::text, p_limit integer default 10)
 returns setof vocab_words
 language sql security definer set search_path to 'public'
as $function$
  select * from vocab_words
  where active
    and p_band between band_min and band_max
    and (p_field is null or field_track is null or field_track = p_field)
  order by md5(id::text || current_date::text)
  limit greatest(1, least(coalesce(p_limit,10), 50));
$function$;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

create trigger trg_stamp_agency_ref
  before insert or update on public.students
  for each row execute function stamp_agency_ref_captured_at();

-- ============================================================================
-- ROW LEVEL SECURITY
-- ----------------------------------------------------------------------------
-- RLS is enabled on every table. The public client uses the `anon` key, so
-- policies grant the minimum the PWA needs: config tables are read-only
-- (active rows only); student-owned tables allow anon insert/update (the app
-- scopes rows by id client-side, V1). Tables with RLS enabled and NO policy
-- (ai_calls, agencies, scholarship_codes, content_translations, classes,
-- class_members) are reachable only via SECURITY DEFINER functions or the
-- service role.
-- ============================================================================

alter table achievement_types    enable row level security;
alter table achievements         enable row level security;
alter table activity_log         enable row level security;
alter table agencies             enable row level security;
alter table ai_calls             enable row level security;
alter table assessments          enable row level security;
alter table class_members        enable row level security;
alter table classes              enable row level security;
alter table content_shelves      enable row level security;
alter table content_translations enable row level security;
alter table countries            enable row level security;
alter table dream_paths          enable row level security;
alter table dream_transitions    enable row level security;
alter table essays               enable row level security;
alter table exercises            enable row level security;
alter table handoff_queue        enable row level security;
alter table interest_profiles    enable row level security;
alter table lessons              enable row level security;
alter table opportunities        enable row level security;
alter table partner_suggestions  enable row level security;
alter table plans                enable row level security;
alter table reading_items        enable row level security;
alter table scholarship_codes    enable row level security;
alter table streaks              enable row level security;
alter table students             enable row level security;
alter table subscriptions        enable row level security;
alter table translations         enable row level security;
alter table unlocks              enable row level security;
alter table vocab_words          enable row level security;
alter table writing_prompts      enable row level security;

-- Config tables: anon may read active rows.
create policy anon_read on achievement_types for select to anon using (active);
create policy anon_read on content_shelves   for select to anon using (active);
create policy anon_read on countries         for select to anon using (active);
create policy anon_read on exercises         for select to anon using (active);
create policy anon_read on lessons           for select to anon using (active);
create policy anon_read on opportunities     for select to anon using (active);
create policy anon_read on plans             for select to anon using (active);
create policy anon_read on reading_items     for select to anon using (active);
create policy anon_read on vocab_words       for select to anon using (active);
create policy anon_read on writing_prompts   for select to anon using (active);
create policy anon_read on translations      for select to anon using (true);

-- Student-owned tables.
create policy anon_insert on achievements      for insert to anon with check (true);
create policy anon_read   on achievements      for select to anon using (true);
create policy anon_update on achievements      for update to anon using (true) with check (true);
create policy anon_insert on activity_log      for insert to anon with check (true);
create policy anon_insert on assessments       for insert to anon with check (true);
create policy anon_insert on dream_paths       for insert to anon with check (true);
create policy anon_update on dream_paths       for update to anon using (true) with check (true);
create policy anon_insert on dream_transitions for insert to anon with check (true);
create policy anon_insert on essays            for insert to anon with check (true);
create policy anon_insert on interest_profiles for insert to anon with check (true);
create policy anon_update on interest_profiles for update to anon using (true) with check (true);
create policy anon_insert on streaks           for insert to anon with check (true);
create policy anon_update on streaks           for update to anon using (true) with check (true);
create policy anon_insert on students          for insert to anon with check (true);
create policy anon_update on students          for update to anon using (true) with check (true);
create policy anon_insert on unlocks           for insert to anon with check (true);
create policy anon_read   on unlocks           for select to anon using (true);

-- Guarded inserts (status pinned to the safe initial value).
create policy anon_insert_new     on handoff_queue for insert to anon with check (status = 'new'::text);
create policy anon_insert_pending on subscriptions for insert to anon with check (status = 'pending'::text);

-- Partner suggestions: any client may submit.
create policy partner_suggestions_insert on partner_suggestions for insert to public with check (true);

-- ============================================================================
-- 2026-07-28 FEATURE ADDITIONS (spaced repetition + university fit)
-- ============================================================================

create table vocab_reviews (
  student_id    uuid not null references students(id) on delete cascade,
  word_id       uuid not null references vocab_words(id) on delete cascade,
  ease          numeric(4,2) not null default 2.5,
  interval_days integer not null default 0,
  reps          integer not null default 0,
  due_at        date not null default current_date,
  last_result   text,
  updated_at    timestamptz not null default now(),
  primary key (student_id, word_id)
);
create index vocab_reviews_due_idx on public.vocab_reviews (student_id, due_at);
alter table vocab_reviews enable row level security;
create policy anon_read   on vocab_reviews for select to anon using (true);
create policy anon_insert on vocab_reviews for insert to anon with check (true);
create policy anon_update on vocab_reviews for update to anon using (true) with check (true);

-- university_fit(student) -> each active university tagged safe/match/reach (chancing meter)
-- review_vocab(student, word, quality) -> SM-2 lite scheduler, returns next due date
-- due_vocab(student, band, field, limit) -> words due today, else fresh level/field-matched
-- (full bodies applied live; see DB_CHANGELOG.md 2026-07-28 for definitions)
