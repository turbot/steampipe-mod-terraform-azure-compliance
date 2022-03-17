select
  type || ' ' || name as resource,
  case
    when (arguments -> 'network_acls') is null then 'alarm'
    when (arguments -> 'network_acls' ->> 'default_action') <> 'Deny' then 'alarm'
    else 'ok'
  end status,
  name || case
     when (arguments -> 'network_acls') is null then ' ''network_acls'' not defin'
    when (arguments -> 'network_acls' ->> 'default_action') <> 'Deny' then ' publicly accessible.'
    else ' publicly not accessible'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_cognitive_account';