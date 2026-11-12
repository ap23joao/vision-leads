-- VISION LEADS | Estrutura inicial do banco Supabase
-- Execute no SQL Editor do seu projeto Supabase após revisar as regras.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  role text not null default 'seller' check (role in ('admin','seller')),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  phone text not null,
  service text not null,
  source text,
  status text not null default 'Novo'
    check (status in ('Novo','Em atendimento','Venda realizada','Sem interesse')),
  assigned_to uuid references public.profiles(id),
  notes text,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.leads enable row level security;

-- Usuários autenticados podem consultar o próprio perfil.
create policy "profile_read_self" on public.profiles
for select to authenticated using (id = auth.uid());

-- Administradores consultam todos os leads; vendedores apenas os atribuídos a si.
-- Para produção, criar função SECURITY DEFINER para verificar papel admin,
-- evitando políticas recursivas e restringindo também INSERT/UPDATE/DELETE.
create or replace function public.is_admin()
returns boolean language sql stable security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin' and p.active = true
  );
$$;

create policy "leads_read_admin_or_assigned" on public.leads
for select to authenticated
using (public.is_admin() or assigned_to = auth.uid());

create policy "leads_insert_authenticated" on public.leads
for insert to authenticated
with check (public.is_admin() or created_by = auth.uid());

create policy "leads_update_admin_or_assigned" on public.leads
for update to authenticated
using (public.is_admin() or assigned_to = auth.uid())
with check (public.is_admin() or assigned_to = auth.uid());

-- Não habilite cadastro público irrestrito. Crie usuários pelo painel administrativo
-- e atribua role/permissões com procedimento seguro no backend.
