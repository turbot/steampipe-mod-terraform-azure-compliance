select
  type || ' ' || name as resource,
  case
    when (arguments -> 'key_vault_reference') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
     when (arguments -> 'key_vault_reference') is not null  then ' encrypted with CMK'
    else ' not encrypted with CMK'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_batch_account';
