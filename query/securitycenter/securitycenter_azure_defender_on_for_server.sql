select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'VirtualMachines' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'info'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'VirtualMachines' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Servers'
    else ' Azure Defender off for Servers'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';