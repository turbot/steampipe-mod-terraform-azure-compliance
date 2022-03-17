select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'double_encryption_enabled') is null then 'alarm'
    when (arguments ->> 'double_encryption_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'double_encryption_enabled') is null then ' ''double_encryption_enabled'' not set'
    when (arguments ->> 'double_encryption_enabled')::boolean then ' double encryption enabled'
    else ' double encryption disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_kusto_cluster';
