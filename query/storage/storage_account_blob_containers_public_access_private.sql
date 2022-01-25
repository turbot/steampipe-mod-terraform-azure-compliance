select
  type || ' ' || name as resource,
  case
    when (arguments -> 'allow_blob_public_access') is null then 'ok'
    when (arguments -> 'allow_blob_public_access')::bool then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'allow_blob_public_access') is null then ' does not allow public access to the blobs'
    when (arguments -> 'allow_blob_public_access')::bool then ' allows public access to all the blobs'
    else ' does not allow public access to the blobs'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_storage_account';