select
  type || ' ' || name as resource,
  case
    when (arguments -> 'public_network_access_enabled') is null then 'alarm'
    when (arguments -> 'public_network_access_enabled')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'public_network_access_enabled') is null then ' public access enabled'
    when (arguments -> 'public_network_access_enabled')::bool then ' public access disabled'
    else ' public access enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_healthcare_service';