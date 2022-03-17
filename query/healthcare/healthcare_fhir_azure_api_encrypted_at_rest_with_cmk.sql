select
  type || ' ' || name as resource,
  case
    when (arguments -> 'cosmosdb_key_vault_key_versionless_id') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'cosmosdb_key_vault_key_versionless_id') is null then ' not encrypted with CMK'
    else ' encrypted with CMK'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_healthcare_service';