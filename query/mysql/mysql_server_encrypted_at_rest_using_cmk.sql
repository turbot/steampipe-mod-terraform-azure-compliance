with mysql_server as (
  select
    '${azurerm_mysql_server.' || name || '.id}' as pg_id,
    *
  from
    terraform_resource
  where
    type = 'azurerm_mysql_server'
), server_keys as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_mysql_server_key'
    and (arguments -> 'key_vault_key_id') is not null
)
select
  -- Required Columns
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'server_id') is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (s.arguments ->> 'server_id') is not null then ' encrypted with CMK'
    else ' not encrypted with CMK'
  end || '.' reason,
  a.path
from
  mysql_server as a
  left join server_keys as s on a.pg_id = ( s.arguments ->> 'server_id');