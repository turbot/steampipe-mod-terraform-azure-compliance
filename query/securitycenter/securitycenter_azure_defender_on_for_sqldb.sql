select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'SqlServers' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'skip'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'SqlServers' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for SQL database servers'
    else ' Azure Defender off for SQL database servers'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';