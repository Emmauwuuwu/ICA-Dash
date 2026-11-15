-- ICA Dash: song files that come with uploaded levels (Supabase Storage).
-- Run this once on a database that already has schema.sql: Supabase dashboard -> SQL Editor -> New query -> paste -> Run.
-- (schema.sql includes it too, for new setups.)
--
-- Files live in the public "songs" bucket at <player id>/<Newgrounds song id>. Anyone can download them (players need to);
-- you can only add, replace or delete files in your own folder, at most 25 songs and 15 MB each.
-- Moderators (public.admins) can delete any song, e.g. if an artist asks for it to be taken down.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('songs', 'songs', true, 15728640,
        array['audio/mpeg', 'audio/mp3', 'audio/ogg', 'audio/wav', 'audio/x-wav', 'audio/mp4', 'audio/x-m4a', 'audio/aac', 'audio/webm'])
on conflict (id) do nothing;

create policy "songs are public" on storage.objects for select using (bucket_id = 'songs');
create policy "upload songs to your own folder" on storage.objects for insert to authenticated
  with check (bucket_id = 'songs' and (storage.foldername(name))[1] = auth.uid()::text
    and (select count(*) from storage.objects o where o.bucket_id = 'songs' and (storage.foldername(o.name))[1] = auth.uid()::text) < 25);
create policy "replace your own songs" on storage.objects for update to authenticated
  using (bucket_id = 'songs' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'songs' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "delete own songs or moderate" on storage.objects for delete to authenticated
  using (bucket_id = 'songs' and ((storage.foldername(name))[1] = auth.uid()::text
    or exists (select 1 from public.admins a where a.user_id = auth.uid())));
