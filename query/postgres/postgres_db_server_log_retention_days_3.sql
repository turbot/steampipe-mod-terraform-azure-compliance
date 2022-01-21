with postgresql_server as (
  select
    '${azurerm_postgresql_server.' || name || '.name}' as pg_name,
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
  -- Required Columns
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'server_name') is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (s.arguments ->> 'server_name') is not null then ' log files are retained for more than 3 days'
    else ' og files are retained for 3 days or lesser'
  end || '.' reason,
  a.path
from
  postgresql_server as a
  left join log_disconnections_configuration as s on a.pg_name = ( s.arguments ->> 'server_name');