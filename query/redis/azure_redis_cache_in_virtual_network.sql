select
  type || ' ' || name as resource,
  case
    when (arguments -> 'subnet_id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'subnet_id') is not null then ' in virtual network'
    else ' not in virtual network'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_redis_cache';
