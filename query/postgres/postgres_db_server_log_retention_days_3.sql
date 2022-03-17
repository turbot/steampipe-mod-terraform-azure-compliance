with postgresql_server as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_postgresql_server'
), log_disconnections_configuration as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_postgresql_configuration'
    and (arguments ->> 'name') = 'log_retention_days'
    and (arguments ->> 'value')::int > 3
)
select
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'server_name') is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (s.arguments ->> 'server_name') is not null then ' log files are retained for more than 3 days'
    else ' og files are retained for 3 days or lesser'
  end || '.' reason,
  a.path || ':' || a.start_line
from
  postgresql_server as a
  left join log_disconnections_configuration as s on a.name = ( split_part((s.arguments ->> 'server_name'), '.', 2));