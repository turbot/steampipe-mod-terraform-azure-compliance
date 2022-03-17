select
  type || ' ' || name as resource,
  case
    when (arguments -> 'addon_profile') is null then 'alarm'
    when (arguments -> 'addon_profile' -> 'azure_policy' ->>'enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'addon_profile') is null then ' ''addon_profile'' not defined'
    when (arguments -> 'addon_profile' -> 'azure_policy' ->>'enabled')::boolean then ' add on azure policy enabled'
    else ' add on azure policy disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_kubernetes_cluster';
