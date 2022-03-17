select
  type || ' ' || name as resource,
  case
    when (arguments -> 'auth_settings') is null then 'alarm'
    when (arguments -> 'auth_settings' ->> 'enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'auth_settings') is null then ' ''auth_settings'' not defined'
    when (arguments -> 'auth_settings' ->> 'enabled')::boolean then ' authentication set'
    else ' authentication not set'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_app_service';