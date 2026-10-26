-- Thaara initial schema.
-- Every table is owner-only via row-level security. Deleting the auth user
-- cascades to all of their data (used by the delete-account function).

create table public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  locale      text not null default 'en' check (locale in ('en', 'ml')),
  created_at  timestamptz not null default now()
);

create table public.readings (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  spread_id    text not null,
  question     text not null default '' check (char_length(question) <= 500),
  question_key text not null default '',          -- normalised, for the same-question limit
  situation    text not null default '' check (char_length(situation) <= 1000),
  locale       text not null default 'en',
  cards        jsonb not null,
  result       jsonb not null,
  safety_flag  boolean not null default false,
  created_at   timestamptz not null default now()
);

create index readings_user_created_idx on public.readings (user_id, created_at desc);

create table public.journal_entries (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users (id) on delete cascade,
  reading_id  uuid references public.readings (id) on delete set null,
  mood        smallint check (mood between 0 and 4),
  body        text not null check (char_length(body) between 1 and 5000),
  created_at  timestamptz not null default now()
);

create index journal_user_created_idx on public.journal_entries (user_id, created_at desc);

-- Row-level security -------------------------------------------------------

alter table public.profiles        enable row level security;
alter table public.readings        enable row level security;
alter table public.journal_entries enable row level security;

create policy "own profile: read"   on public.profiles for select using (auth.uid() = id);
create policy "own profile: update" on public.profiles for update using (auth.uid() = id);

-- Readings are created only by the `reading` edge function (service role),
-- so clients can read their own but never insert or edit them directly.
create policy "own readings: read"   on public.readings for select using (auth.uid() = user_id);
create policy "own readings: delete" on public.readings for delete using (auth.uid() = user_id);

create policy "own journal: read"   on public.journal_entries for select using (auth.uid() = user_id);
create policy "own journal: insert" on public.journal_entries for insert with check (auth.uid() = user_id);
create policy "own journal: update" on public.journal_entries for update using (auth.uid() = user_id);
create policy "own journal: delete" on public.journal_entries for delete using (auth.uid() = user_id);

-- Auto-create a profile for every new user (including anonymous ones) ------

create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id) values (new.id) on conflict do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
