select
  type || ' ' || name as resource,
  case
    when (arguments -> 'alerts_to_admins')::bool is true and (arguments -> 'alert_notifications')::bool is true then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'alerts_to_admins')::bool is true and (arguments -> 'alert_notifications')::bool is true then ' notify alerts to admins configured'
    else ' notify alerts to admin not configured'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_contact';