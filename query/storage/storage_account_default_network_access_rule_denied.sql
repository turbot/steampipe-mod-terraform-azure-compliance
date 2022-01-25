select
  type || ' ' || name as resource,
  case
    when (arguments -> 'network_rules') is null then 'alarm'
    when (arguments -> 'network_rules' ->> 'default_action') = 'Allow' then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'network_rules') is null then ' has no network rules defined'
    when (arguments -> 'network_rules' ->> 'default_action') = 'Allow' then ' allows traffic from specific networks'
    else ' allows network access'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_storage_account';