select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'ssl_enforcement_enabled') is null then 'alarm'
    when (arguments ->> 'ssl_enforcement_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
     when (arguments ->> 'ssl_enforcement_enabled') is null then ' ''ssl_enforcement_enabled'' not set'
    when (arguments ->> 'ssl_enforcement_enabled')::boolean then ' SSL connection enabled'
    else ' SSL connection disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_postgresql_server';
