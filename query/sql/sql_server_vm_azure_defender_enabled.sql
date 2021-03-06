select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'SqlServerVirtualMachines' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'info'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'SqlServerVirtualMachines' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for SqlServerVirtualMachines'
    else ' Azure Defender off for SqlServerVirtualMachines'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';
