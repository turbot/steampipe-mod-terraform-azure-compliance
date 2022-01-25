select
  type || ' ' || name as resource,
  case
    when (arguments -> 'resource_group_name') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'resource_group_name') is null then ' does not use azure resource group manager'
    else ' uses azure resource group manager'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_storage_account';