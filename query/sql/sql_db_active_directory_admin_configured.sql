select
  type || ' ' || name as resource,
  case
    when (arguments -> 'azuread_administrator') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'azuread_administrator') is null then ' Azure AD authentication not configured.'
    else ' Azure AD authentication configured'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_mssql_server';
