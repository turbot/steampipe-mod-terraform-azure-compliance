select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'network_acls') is null then 'alarm'
    when (arguments -> 'network_acls' ->> 'default_action')::text != 'Deny' then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments ->> 'network_acls') is null then ' ''network_acls'' not set'
    when (arguments -> 'network_acls' ->> 'default_action')::text != 'Deny' then ' public network access enabled'
    else ' public network access disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_key_vault';
