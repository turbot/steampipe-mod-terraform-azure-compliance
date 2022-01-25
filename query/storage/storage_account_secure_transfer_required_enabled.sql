select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_https_traffic_only') is null then 'ok'
    when (arguments -> 'enable_https_traffic_only')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'enable_https_traffic_only') is null then ' encryption in transit enabled'
    when (arguments -> 'enable_https_traffic_only')::bool then ' encryption in transit enabled'
    else ' encryption in transit not enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_storage_account';