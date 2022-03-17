select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'KeyVaults' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'info'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'KeyVaults' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for KeyVaults'
    else ' Azure Defender off for KeyVaults'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';
