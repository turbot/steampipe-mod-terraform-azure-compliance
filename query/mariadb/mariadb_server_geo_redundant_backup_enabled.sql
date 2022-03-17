select
  type || ' ' || name as resource,
  case
    when (arguments -> 'geo_redundant_backup_enabled') is null then 'alarm'
    when (arguments -> 'geo_redundant_backup_enabled')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'geo_redundant_backup_enabled') is null then ' geo-redundant backup disabled'
    when (arguments -> 'geo_redundant_backup_enabled')::bool then ' geo-redundant backup enabled'
    else ' geo-redundant backup disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_mariadb_server';