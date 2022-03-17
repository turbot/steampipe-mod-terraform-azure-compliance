select
  type || ' ' || name as resource,
  case
    when name in (select split_part((arguments ->> 'server_name'), '.', 2) from terraform_resource where type = 'azurerm_sql_active_directory_administrator') then 'ok'
    else 'alarm'
  end status,
  name || case
    when name in (select split_part((arguments ->> 'server_name'), '.', 2) from terraform_resource where type = 'azurerm_sql_active_directory_administrator') then ' has AzureAD authentication enabled'
    else ' does not have AzureAD authentication enabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_sql_server';