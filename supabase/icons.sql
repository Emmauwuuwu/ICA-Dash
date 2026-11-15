-- ICA Dash: community icons (custom wave, cube and ship images players share).
-- Run this once on a database that already has schema.sql: Supabase dashboard -> SQL Editor -> New query -> paste -> Run.
-- (schema.sql includes it too, for new setups.)
--
-- A shared icon starts as 'pending'. Only moderators (public.admins) can approve or reject it, and only approved icons are
-- visible to everyone; you always see your own, and moderators see all. At most 10 icons per player.
-- Images are small raster data URLs (PNG, WebP or JPEG, under ~90 KB); SVG isn't allowed.

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

create function public.check_icon_limit() returns trigger language plpgsql as $$
begin
  if (select count(*) from public.community_icons where author = new.author) >= 10 then
    raise exception 'You can share 10 icons. Remove one first.';
  end if;
  return new;
end $$;
create trigger icon_limit before insert on public.community_icons for each row execute function public.check_icon_limit();
