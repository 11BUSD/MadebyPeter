create function public.request_account_deletion() returns uuid language plpgsql security definer set search_path='' as $$
declare actor uuid:=auth.uid(); event_id uuid;
begin
  if actor is null then raise exception 'authentication required'; end if;
  insert into public.audit_events(actor_user_id,event_type,resource_type,resource_id,metadata_json)
  values(actor,'account.deletion_requested','profile',actor,jsonb_build_object('status','pending')) returning id into event_id;
  return event_id;
end $$;
revoke all on function public.request_account_deletion() from public,anon;
grant execute on function public.request_account_deletion() to authenticated;
