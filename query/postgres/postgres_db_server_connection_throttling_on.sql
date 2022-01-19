with postgresql_server as (
  select
    '${azurerm_postgresql_server.' || name || '.name}' as pg_name,
    *
  from
    terraform_resource
  where
    type = 'azurerm_postgresql_server'
), connection_throttling_configuration as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_postgresql_configuration'
    and (arguments ->> 'name') = 'connection_throttling'
    and (arguments ->> 'value') = 'on'
)
select
  -- Required Columns
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'server_name') is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (s.arguments ->> 'server_name') is not null then ' server parameter connection_throttling on'
    else ' server parameter connection_throttling off'
  end || '.' reason,
  a.path
from
  postgresql_server as a
  left join connection_throttling_configuration as s on a.pg_name = ( s.arguments ->> 'server_name');