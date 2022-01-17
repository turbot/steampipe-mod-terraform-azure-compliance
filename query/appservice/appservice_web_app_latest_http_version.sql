select
  type || ' ' || name as resource,
  case
    when (arguments -> 'site_config') is null then 'alarm'
    when (arguments -> 'site_config' ->> 'http2_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'site_config') is null then ' HTTP version not defined''
    when (arguments -> 'site_config' ->> 'http2_enabled')::boolean then ' HTTP version is latest'
    else ' HTTP version not latest'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_app_service';