select
  type || ' ' || name as resource,
  case
    when (arguments -> 'email') is not null and (arguments -> 'alert_notifications')::bool is true then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'email') is not null and (arguments -> 'alert_notifications')::bool is true then ' additional email & alert notifications configured'
    else ' additional email & alert notifications not configured'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_security_center_contact';