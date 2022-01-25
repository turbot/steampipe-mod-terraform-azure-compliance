select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'expiration_date') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments ->> 'expiration_date') is null then ' expiration_date not set'
    else ' expiration_date is set'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_key_vault_key';
