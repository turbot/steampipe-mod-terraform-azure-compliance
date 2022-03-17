select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'infrastructure_encryption_enabled') is null then 'alarm'
    when (arguments ->> 'infrastructure_encryption_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
     when (arguments ->> 'infrastructure_encryption_enabled') is null then ' ''infrastructure_encryption_enabled'' not set'
    when (arguments ->> 'infrastructure_encryption_enabled')::boolean then ' infrastructure encryption enabled'
    else ' infrastructure encryption disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_postgresql_server';
