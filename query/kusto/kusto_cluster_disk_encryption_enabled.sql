select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'enable_disk_encryption') is null then 'alarm'
    when (arguments ->> 'enable_disk_encryption')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
     when (arguments ->> 'enable_disk_encryption') is null then ' ''enable_disk_encryption'' not set'
    when (arguments ->> 'enable_disk_encryption')::boolean then ' disk encryption enabled'
    else ' disk encryption disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_kusto_cluster';
