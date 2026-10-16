-- Ejecutar en el SQL Editor de Supabase.
-- Reemplaza el correo por el correo REAL de tu cuenta propietaria ANTES de ejecutar.
create table if not exists public.movements (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null default auth.uid() references auth.users(id),
 date date not null,
 type text not null check(type in ('income','expense','conversion')),
 amount_usd numeric(18,4) not null default 0,
 note text not null default '',
 details jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create index if not exists movements_owner_date_idx on public.movements(owner_id,date);
alter table public.movements enable row level security;
-- Sustituye propietario@ejemplo.com por tu email en las cuatro políticas.
create policy "owner_select" on public.movements for select to authenticated using (owner_id=auth.uid() and (auth.jwt()->>'email')='propietario@ejemplo.com');
create policy "owner_insert" on public.movements for insert to authenticated with check (owner_id=auth.uid() and (auth.jwt()->>'email')='propietario@ejemplo.com');
create policy "owner_delete" on public.movements for delete to authenticated using (owner_id=auth.uid() and (auth.jwt()->>'email')='propietario@ejemplo.com');
create policy "owner_update" on public.movements for update to authenticated using (owner_id=auth.uid() and (auth.jwt()->>'email')='propietario@ejemplo.com') with check (owner_id=auth.uid() and (auth.jwt()->>'email')='propietario@ejemplo.com');
