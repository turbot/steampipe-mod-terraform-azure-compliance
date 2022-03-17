select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'key_vault_key_id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'key_vault_key_id') is not null then  ' encrypted at rest using CMK'
    else ' not encrypted at rest using CMK'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_cosmosdb_account';