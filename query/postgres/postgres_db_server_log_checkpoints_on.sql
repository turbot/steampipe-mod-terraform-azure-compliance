with postgresql_server as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_postgresql_server'
), log_checkpoints_configuration as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_postgresql_configuration'
    and (arguments ->> 'name') = 'log_checkpoints'
    and (arguments ->> 'value') = 'on'
)
select
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'server_name') is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (s.arguments ->> 'server_name') is not null then ' server parameter log_checkpoints on'
    else ' server parameter log_checkpoints off'
  end || '.' reason,
  a.path || ':' || a.start_line
from
  postgresql_server as a
  left join log_checkpoints_configuration as s on a.name = (split_part((s.arguments ->> 'server_name'), '.', 2));
