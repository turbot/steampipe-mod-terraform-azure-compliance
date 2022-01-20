select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'ssl_enforcement_enabled')::boolean then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments ->> 'ssl_enforcement_enabled')::boolean then ' SSL connection enabled'
    else ' SSL connection disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_mysql_server';
