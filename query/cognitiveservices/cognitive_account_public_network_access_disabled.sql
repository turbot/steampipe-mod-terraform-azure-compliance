select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'public_network_access_enabled')::boolean then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments ->> 'public_network_access_enabled')::boolean then ' public network access enabled'
    else ' public network access disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_cognitive_account';