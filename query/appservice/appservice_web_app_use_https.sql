select
  type || ' ' || name as resource,
  case
    when (arguments -> 'https_only') is null then 'alarm'
    when (arguments -> 'https_only')::boolean then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'https_only') is null then ' ''https_only'' not defined'
    when (arguments -> 'https_only')::boolean then 'redirects all HTTP traffic to HTTPS'
    else ' does not redirect all HTTP traffic to HTTPS'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_app_service';