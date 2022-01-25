with sql_server as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_mssql_server'
), server_audit_policy as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_mssql_server_extended_auditing_policy'
    and (arguments ->> 'retention_in_days')::int > 90
)
select
  -- Required Columns
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'server_id') is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (s.arguments ->> 'server_name') is not null then ' audit retention greater than 90 days'
    else ' audit retention less than 90 days'
  end || '.' reason,
  a.path
from
  sql_server as a
  left join server_audit_policy as s on a.name = ( split_part((s.arguments ->> 'server_id'), '.', 2));