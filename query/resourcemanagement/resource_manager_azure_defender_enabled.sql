select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'Arm' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'info'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'Arm' and (arguments ->> 'tier') = 'Standard' then ' Arm azure defender enabled'
    else 'Arm azure defender disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';
