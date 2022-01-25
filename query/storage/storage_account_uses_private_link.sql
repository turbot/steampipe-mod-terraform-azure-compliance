select
  type || ' ' || name as resource,
  case
    when (arguments -> 'private_link_access') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'private_link_access') is null then ' does not use private link'
    else ' uses private link'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_storage_account';