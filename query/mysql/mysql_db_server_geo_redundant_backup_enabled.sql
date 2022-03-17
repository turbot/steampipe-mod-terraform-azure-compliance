select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'geo_redundant_backup_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'geo_redundant_backup_enabled')::boolean then ' Geo-redundant backup enabled'
    else ' Geo-redundant backup disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_mysql_server';
