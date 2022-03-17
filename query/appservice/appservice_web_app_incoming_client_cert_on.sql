select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'client_cert_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'client_cert_enabled')::boolean then ' incoming client certificates set to on'
    else ' incoming client certificates set to off'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_app_service';