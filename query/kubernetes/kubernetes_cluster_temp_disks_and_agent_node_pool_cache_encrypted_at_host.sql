select
  type || ' ' || name as resource,
  case
    when (arguments -> 'default_node_pool' ->> 'enable_host_encryption')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'default_node_pool' ->> 'enable_host_encryption')::boolean then ' encrypted at host'
    else ' not encrypted at host'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_kubernetes_cluster';
