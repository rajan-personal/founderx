
create table
  founderx_days (
    id bigint generated by default as identity,
    description text null,
    created_at timestamp with time zone not null default now(),
    primary key (id)
  );


--  id, user, day, note, created_at
create table
  founderx_notes (
    id bigint generated by default as identity,
    user_id uuid not null references auth.users on delete cascade,
    day_id bigint not null references founderx_days on delete cascade,
    note text not null,
    created_at timestamp with time zone not null default now(),
    primary key (id)
  );

create table
  founderx_profiles (
    id UUID UNIQUE DEFAULT uuid_generate_v4(),
    email text not null,
    created_at timestamp with time zone not null default now(),
    primary key (id)
  );

-- inserts a row into public.profiles
create function public.handle_new_user_founderx()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.founderx_profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$;

-- trigger the function every time a user is created
create trigger on_auth_user_created_founderx
  after insert on auth.users
  for each row execute procedure public.handle_new_user_founderx();