select
  type || ' ' || name as resource,
  case
    when (arguments -> 'api_server_authorized_ip_ranges') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'api_server_authorized_ip_ranges') is null then ' authorized IP ranges not defined'
    else ' authorized IP ranges not defined'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_kubernetes_cluster';
