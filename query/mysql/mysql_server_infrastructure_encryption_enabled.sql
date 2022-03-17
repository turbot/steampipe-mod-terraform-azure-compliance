select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'infrastructure_encryption_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'infrastructure_encryption_enabled')::boolean then ' infrastructure encryption enabled'
    else ' infrastructure encryption disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_mysql_server';
