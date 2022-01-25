select
  type || ' ' || name as resource,
  case
    when (arguments -> 'role_based_access_control') is null then 'alarm'
    when (arguments -> 'role_based_access_control' -> 'azure_active_directory' -> 'azure_rbac_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'role_based_access_control') is null then ' ''role_based_access_control'' not defined'
    when (arguments -> 'role_based_access_control' -> 'azure_active_directory' -> 'azure_rbac_enabled')::boolean then ' role based access control enabled'
    else ' role based access control disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_kubernetes_cluster';
