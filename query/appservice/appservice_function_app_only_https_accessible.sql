select
  type || ' ' || name as resource,
  case
    when (arguments -> 'https_only')::boolean then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'https_only')::boolean then ' https-only accessible enabled'
    else ' https-only accessible disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_function_app';