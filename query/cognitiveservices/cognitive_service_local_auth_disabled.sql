select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'local_auth_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'local_auth_enabled')::boolean then ' account local authentication enabled'
    else ' account local authentication disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_cognitive_account';