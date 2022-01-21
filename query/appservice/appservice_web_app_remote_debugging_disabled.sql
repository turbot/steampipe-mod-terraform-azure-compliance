select
  type || ' ' || name as resource,
  case
    when (arguments -> 'site_config') is null then 'alarm'
    when (arguments -> 'site_config' -> 'remote_debugging_enabled')::boolean then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
    when (arguments -> 'site_config' -> 'remote_debugging_enabled')::boolean then ' remote debugging enabled'
    else ' remote debugging disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_app_service';