with mysql_server as (
  select
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
  left join server_keys as s on a.name = (split_part((s.arguments ->> 'server_id'), '.', 2));
