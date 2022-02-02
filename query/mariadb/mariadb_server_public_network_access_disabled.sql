select
  type || ' ' || name as resource,
  case
    when (arguments -> 'public_network_access_enabled') is null then 'alarm'
    when (arguments -> 'public_network_access_enabled')::bool then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'public_network_access_enabled') is null then ' public network access enabled'
    when (arguments -> 'public_network_access_enabled')::bool then ' public network access enabled'
    else ' public network access disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_mariadb_server';