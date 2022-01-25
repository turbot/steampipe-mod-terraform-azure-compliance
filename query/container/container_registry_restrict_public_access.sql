select
  type || ' ' || name as resource,
  case
    when (arguments -> 'network_rule_set') is null then 'alarm'
    when (arguments -> 'network_rule_set' ->> 'default_action')::text = 'Deny' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'network_rule_set') is null then ' ''network_rule_set'' not defined'
    when (arguments -> 'network_rule_set' ->> 'default_action')::text = 'Deny' then ' publicly not accessible'
    else ' publicly accessible'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_container_registry';