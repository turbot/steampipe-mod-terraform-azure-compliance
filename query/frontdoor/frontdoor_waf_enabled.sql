select
  type || ' ' || name as resource,
  case
    when (arguments -> 'routing_rule' -> 'frontend_endpoint') is null then 'alarm'
    when (arguments -> 'routing_rule' -> 'frontend_endpoint' -> 'web_application_firewall_policy_link_id') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'routing_rule' -> 'frontend_endpoint') is null then ' WAF disabled'
    when (arguments -> 'routing_rule' -> 'frontend_endpoint' -> 'web_application_firewall_policy_link_id') is null then ' WAF disabled'
    else ' WAF enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_frontdoor';