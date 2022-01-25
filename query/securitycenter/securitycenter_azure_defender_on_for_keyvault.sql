select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'KeyVaults' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'skip'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'KeyVaults' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Key Vaults'
    else ' Azure Defender off for Key Vaults'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';