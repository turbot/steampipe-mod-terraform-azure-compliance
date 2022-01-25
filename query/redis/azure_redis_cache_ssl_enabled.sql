select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_non_ssl_port')::boolean then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'enable_non_ssl_port')::boolean then ' secure connections disabled'
    else ' secure connections enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_redis_cache';
