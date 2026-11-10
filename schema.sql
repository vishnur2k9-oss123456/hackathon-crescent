-- ResQ AI schema (Supabase / PostgreSQL). Run in Supabase SQL Editor.
create table if not exists profiles (
  id uuid primary key references auth.users on delete cascade,
  full_name text,
  role text not null check (role in ('admin','responder'))
);
create table if not exists teams (
  id text primary key, name text not null,
  type text not null check (type in ('fire','medical','ambulance','rescue','police')),
  status text not null default 'Available' check (status in ('Available','Busy','Offline')),
  lat double precision, lng double precision,
  responder_id uuid references profiles(id), is_demo boolean not null default false,
  updated_at timestamptz not null default now()
);
create table if not exists incidents (
  id text primary key,
  title text not null, description text not null,
  category text not null check (category in ('fire','road','medical','flood','police','disaster','collapse','other')),
  location text, lat double precision, lng double precision, people int not null check (people >= 1),
  contact_name text, contact_phone text,
  severity text not null check (severity in ('Critical','High','Medium','Low')),
  severity_score int, severity_reasons jsonb not null default '[]', priority_source text, sos boolean not null default false,
  status text not null default 'Reported' check (status in ('Reported','Assigned','In Progress','Resolved')),
  team_id text references teams(id), history jsonb not null default '[]',
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index if not exists incidents_created on incidents (created_at desc);
create index if not exists incidents_status on incidents (status);

-- Row Level Security: the browser never gets table access with the anon key.
-- All reads/writes go through the Express API, which uses the service-role key (bypasses RLS) and checks roles itself.
alter table profiles enable row level security;
alter table teams enable row level security;
alter table incidents enable row level security;
create policy "own profile" on profiles for select to authenticated using (id = auth.uid());
-- (No other policies: anon and authenticated browser clients cannot read incidents or teams directly.)

-- DEMO teams (is_demo = true). Delete these rows when you add real teams.
insert into teams (id, name, type, status, lat, lng, is_demo) values
 ('T1','Fire & Rescue – Egmore','fire','Available',13.0732,80.2609,true),
 ('T2','Fire & Rescue – Coimbatore South','fire','Busy',10.9925,76.9614,true),
 ('T3','Medical Team – Anna Nagar','medical','Available',13.085,80.2101,true),
 ('T4','Medical Team – Madurai','medical','Available',9.9252,78.1198,true),
 ('T5','Ambulance A – Adyar','ambulance','Available',13.0067,80.257,true),
 ('T6','Ambulance B – T Nagar','ambulance','Busy',13.0418,80.2341,true),
 ('T7','Ambulance – RS Puram','ambulance','Available',11.0096,76.95,true),
 ('T8','Disaster Rescue – Chennai','rescue','Available',13.05,80.2121,true),
 ('T9','Disaster Rescue – Trichy','rescue','Offline',10.7905,78.7047,true),
 ('T10','Police Support – Sholinganallur','police','Available',12.901,80.2279,true),
 ('T11','Police Support – Krishnagiri','police','Available',12.5186,78.2137,true)
on conflict (id) do nothing;

-- Staff accounts: create users in Supabase Dashboard > Authentication > Users (auto-confirm),
-- then give each a role (replace the emails):
-- insert into profiles (id, full_name, role) select id, 'Admin', 'admin' from auth.users where email = 'admin@yourdomain.com';
-- insert into profiles (id, full_name, role) select id, 'Responder', 'responder' from auth.users where email = 'responder@yourdomain.com';
-- To let a responder manage one team: update teams set responder_id = (select id from profiles where full_name='Responder') where id = 'T5';
