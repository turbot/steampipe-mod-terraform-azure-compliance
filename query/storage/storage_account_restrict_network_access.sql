select
  type || ' ' || name as resource,
  case
    when (arguments -> 'network_rules') is null then 'alarm'
    when (arguments -> 'network_rules' ->> 'default_action') = 'Deny' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'network_rules') is null then ' allows network access'
    when (arguments -> 'network_rules' ->> 'default_action') = 'Deny' then ' restricts network access'
    else ' allows network access'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_storage_account';