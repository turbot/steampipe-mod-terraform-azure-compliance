select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'Dns' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'skip'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'Dns' and (arguments ->> 'tier') = 'Standard' then ' Dns azure defender enabled'
    else ' Dns azure defender disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';