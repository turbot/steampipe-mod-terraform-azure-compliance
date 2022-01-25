select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'AppServices' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'info'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'AppServices' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for AppServices'
    else ' Azure Defender off for AppServices'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';
