select
  type || ' ' || name as resource,
  case
    when name in (select split_part((arguments ->> 'storage_account_id'), '.', 2) from terraform_resource where type = 'azurerm_storage_account_customer_managed_key') then 'ok'
    else 'alarm'
  end status,
  name || case
    when name in (select split_part((arguments ->> 'storage_account_id'), '.', 2) from terraform_resource where type = 'azurerm_storage_account_customer_managed_key') then ' encrypted with CMK'
    else ' not encrypted with CMK'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_storage_account';