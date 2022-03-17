select
  type || ' ' || name as resource,
  case
    when (arguments -> 'site_config') is null then 'alarm'
    when (arguments -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
    when (arguments -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then ' CORS allow all domains to access the application'
    else ' CORS does not all domains to access the application'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_function_app';