select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'AppServices' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'info'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'ContainerRegistry' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for ContainerRegistry'
    else ' Azure Defender off for ContainerRegistry'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';
