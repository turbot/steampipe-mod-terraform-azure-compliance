select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'client_cert_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'client_cert_enabled')::boolean then ' client certificate enabled'
    else ' client certificate disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_app_service';