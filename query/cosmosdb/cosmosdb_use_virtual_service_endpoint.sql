select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'virtual_network_rule') is null then 'alarm'
    when (arguments -> 'virtual_network_rule' ->> 'id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'virtual_network_rule') is null then ' ''virtual_network_rule'' not defined'
    when (arguments -> 'virtual_network_rule' ->> 'id') is not null then ' configured with virtual network service endpointle'
    else ' not configured with virtual network service endpoint'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_cosmosdb_account';