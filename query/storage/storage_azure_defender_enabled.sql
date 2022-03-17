select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'tier') = 'Standard' and (arguments ->> 'resource_type') = 'StorageAccounts' then 'ok'
    else 'skip'
  end status,
  name || case
     when (arguments ->> 'tier') = 'Standard' and (arguments ->> 'resource_type') = 'StorageAccounts' then ' Azure defender enabled for StorageAccount(s)'
    else ' Azure defender enabled for ' || (arguments ->> 'resource_type') || ''
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';