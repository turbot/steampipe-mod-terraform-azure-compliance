select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'tier') = 'Standard' and (arguments ->> 'resource_type') = 'SqlServers' then 'ok'
    else 'skip'
  end status,
  name || case
     when (arguments ->> 'tier') = 'Standard' and (arguments ->> 'resource_type') = 'SqlServers' then ' Azure defender enabled for SqlServer(s)'
    else ' Azure defender enabled for ' || (arguments ->> 'resource_type') || ''
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';
