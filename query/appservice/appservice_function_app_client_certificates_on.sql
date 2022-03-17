select
  type || ' ' || name as resource,
  case
    when (arguments -> 'client_cert_mode') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'client_cert_mode') is not null then ' cilient certificate enabled'
    else ' client certificate disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_function_app';