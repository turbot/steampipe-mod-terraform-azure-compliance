select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'VirtualMachines' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'skip'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'VirtualMachines' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Servers'
    else ' Azure Defender off for Servers'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';