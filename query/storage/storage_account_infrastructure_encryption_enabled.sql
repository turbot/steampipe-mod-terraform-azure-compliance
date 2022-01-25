select
  type || ' ' || name as resource,
  case
    when (arguments -> 'infrastructure_encryption_enabled') is null then 'alarm'
    when (arguments -> 'infrastructure_encryption_enabled')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'infrastructure_encryption_enabled') is null then ' ''infrastructure_encryption_enabled'' parameter not defined'
    when (arguments -> 'infrastructure_encryption_enabled')::bool then ' infrastructure encryption enabled'
    else ' infrastructure encryption disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_storage_account';