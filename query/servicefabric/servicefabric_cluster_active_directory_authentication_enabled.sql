select
  type || ' ' || name as resource,
  case
    when (arguments -> 'azure_active_directory') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'azure_active_directory') is null then ' does not use Azure Active Directory for client authentication'
    else ' uses Azure Active Directory for client authentication'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_service_fabric_cluster';