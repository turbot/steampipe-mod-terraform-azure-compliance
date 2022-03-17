select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'public_network_access_enabled')::boolean
      and (arguments ->>  'is_virtual_network_filter_enabled' )::boolean = 'false'
      and (arguments ->>  'ip_range_filter') is null then 'alarm'
    else 'ok'
  end status,
  name || case
   when (arguments ->> 'public_network_access_enabled')::boolean
      and (arguments ->>  'is_virtual_network_filter_enabled' )::boolean = 'false'
      and (arguments ->>  'ip_range_filter') is null then  ' not have firewall rules'
    else ' have firewall rules'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_cosmosdb_account';