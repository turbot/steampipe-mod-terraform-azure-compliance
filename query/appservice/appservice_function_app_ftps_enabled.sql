select
  type || ' ' || name as resource,
  case
    when (arguments -> 'site_config') is null then 'alarm'
    when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
    when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
    else '  FTPS disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_function_app';