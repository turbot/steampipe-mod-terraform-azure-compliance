select
  type || ' ' || name as resource,
  case
    when (arguments -> 'disk_encryption_set_id') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'disk_encryption_set_id') is null then ' os and data diska not encrypted with CMK'
    else ' os and data diska encrypted with CMK'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_kubernetes_cluster';
