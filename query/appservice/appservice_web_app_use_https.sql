select
  type || ' ' || name as resource,
  case
    when (arguments -> 'https_only')::boolean then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'https_only')::boolean then ' redirects all HTTP traffic to HTTPS'
    else ' does not redirect all HTTP traffic to HTTPS'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_app_service';