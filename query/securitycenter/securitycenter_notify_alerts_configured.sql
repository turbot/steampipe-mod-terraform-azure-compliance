select
  type || ' ' || name as resource,
  case
    when (arguments -> 'alert_notifications')::bool is true then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'alert_notifications')::bool is true then ' notify alerts configured'
    else ' notify alerts not configured'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_contact';