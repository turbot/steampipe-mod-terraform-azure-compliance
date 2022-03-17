select
  type || ' ' || name as resource,
  case
    when (arguments -> 'key_vault_key_ids') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'key_vault_key_ids') is not null then ' CMK encryption enabled'
    else ' CMK encryption disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_eventhub_namespace_customer_managed_key';