select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'auto_provision') = 'On' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'auto_provision') = 'On' then ' automatic provisioning of monitoring agent is on'
    else ' automatic provisioning of monitoring agent is off'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_security_center_auto_provisioning';