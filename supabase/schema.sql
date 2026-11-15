-- ICA Dash online database (Supabase / Postgres).
-- Run this once: Supabase dashboard -> SQL Editor -> New query -> paste all of it -> Run.
--
-- Security model: the website only ever uses the public "anon" key. Every table has Row Level Security, so what a player can
-- read or change is decided here, on the server, not by the game's code:
--   profiles  everyone reads; you create and edit only your own
--   levels    everyone reads; you add, edit and delete only your own (admins can delete any, for moderation)
--   likes     everyone reads; you add and remove only your own
--   saves     only you can read or write your save
-- Passwords are handled by Supabase Auth (bcrypt-hashed); the game never stores them.

create table public.profiles (
  id         uuid primary key references auth.users on delete cascade,
  username   text not null unique check (char_length(username) between 3 and 20 and username ~ '^[A-Za-z0-9_]+$'),
  icon       jsonb not null default '{}'::jsonb check (pg_column_size(icon) < 2000),
  created_at timestamptz not null default now()
);

create table public.levels (
  id         uuid primary key default gen_random_uuid(),
  author     uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  local_id   text check (char_length(local_id) <= 40), -- the level's id in the uploader's editor, so re-uploading updates it
  name       text not null check (char_length(name) between 1 and 40),
  code       text not null check (char_length(code) between 10 and 60000 and code like 'ICA2;%'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index levels_created_idx on public.levels (created_at desc);
create unique index levels_author_local_idx on public.levels (author, local_id);

create table public.likes (
  user_id  uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  level_id uuid not null references public.levels (id) on delete cascade,
  primary key (user_id, level_id)
);

create table public.saves (
  user_id    uuid primary key default auth.uid() references auth.users on delete cascade,
  data       text not null check (char_length(data) < 300000), -- plain JSON, or an AES-GCM blob if the player set a passphrase
  updated_at timestamptz not null default now()
);

-- Moderators. Add yourself after signing up in the game:
--   insert into public.admins (user_id) select id from public.profiles where username = 'YOUR_USERNAME';
create table public.admins (
  user_id uuid primary key references auth.users on delete cascade
);

alter table public.profiles enable row level security;
alter table public.levels   enable row level security;
alter table public.likes    enable row level security;
alter table public.saves    enable row level security;
alter table public.admins   enable row level security;

create policy "profiles are public"     on public.profiles for select using (true);
create policy "create own profile"      on public.profiles for insert with check (id = auth.uid());
create policy "edit own profile"        on public.profiles for update using (id = auth.uid()) with check (id = auth.uid());

create policy "levels are public"       on public.levels for select using (true);
create policy "upload own levels"       on public.levels for insert with check (author = auth.uid());
create policy "edit own levels"         on public.levels for update using (author = auth.uid()) with check (author = auth.uid());
create policy "delete own or moderate"  on public.levels for delete
  using (author = auth.uid() or exists (select 1 from public.admins a where a.user_id = auth.uid()));

create policy "likes are public"        on public.likes for select using (true);
create policy "like as yourself"        on public.likes for insert with check (user_id = auth.uid());
create policy "unlike as yourself"      on public.likes for delete using (user_id = auth.uid());

create policy "only you see your save"  on public.saves for select using (user_id = auth.uid());
create policy "only you create a save"  on public.saves for insert with check (user_id = auth.uid());
create policy "only you update a save"  on public.saves for update using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "see if you are an admin" on public.admins for select using (user_id = auth.uid());

-- At most 25 uploaded levels per player.
create function public.check_level_limit() returns trigger language plpgsql as $$
begin
  if (select count(*) from public.levels where author = new.author) >= 25 then
    raise exception 'You can have 25 levels online. Remove one first.';
  end if;
  return new;
end $$;
create trigger level_limit before insert on public.levels for each row execute function public.check_level_limit();

-- The level browser reads this: each level with its author's name and like count.
create view public.level_list with (security_invoker = true) as
  select l.id, l.name, l.code, l.created_at, l.author, p.username, p.icon,
         (select count(*) from public.likes k where k.level_id = l.id) as likes
  from public.levels l join public.profiles p on p.id = l.author;


-- Community icons (also in icons.sql, for databases set up before it existed).
create table public.community_icons (
  id         uuid primary key default gen_random_uuid(),
  author     uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  kind       text not null check (kind in ('wave', 'cube', 'ship')),
  name       text not null check (char_length(name) between 1 and 24),
  image      text not null check (char_length(image) < 120000 and image ~ '^data:image/(png|webp|jpeg);base64,[A-Za-z0-9+/=]+$'),
  status     text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now()
);
create index community_icons_status_idx on public.community_icons (status, created_at desc);

alter table public.community_icons enable row level security;

create policy "approved icons are public; your own and moderators see all" on public.community_icons for select
  using (status = 'approved' or author = auth.uid() or exists (select 1 from public.admins a where a.user_id = auth.uid()));
create policy "share your own icon, waiting for approval" on public.community_icons for insert to authenticated
  with check (author = auth.uid() and status = 'pending');
create policy "moderators approve or reject" on public.community_icons for update to authenticated
  using (exists (select 1 from public.admins a where a.user_id = auth.uid()))
  with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));
create policy "remove your own or moderate" on public.community_icons for delete to authenticated
  using (author = auth.uid() or exists (select 1 from public.admins a where a.user_id = auth.uid()));

