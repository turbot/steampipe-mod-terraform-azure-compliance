with container_registry as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_container_registry'
), container_registry_subnet as (
  select
    distinct a.name
  from
    container_registry as a,
    jsonb_array_elements(arguments -> 'network_rule_set' -> 'virtual_network') as rule
)
select
  type || ' ' || a.name as resource,
  case
    when (arguments -> 'network_rule_set' ->> 'default_action')::text <> 'Deny' then 'alarm'
    when s.name is null then 'alarm'
    else 'ok'
  end as status,
  case
    when (arguments -> 'network_rule_set' ->> 'default_action')::text <> 'Deny' then ' not configured with virtual service endpoint'
    when s.name is null then  ' not configured with virtual service endpoint'
    else ' configured with virtual service endpoint'
  end || '.' reason,
  path || ':' || start_line
from
  container_registry as a
  left join container_registry_subnet as s on a.name = s.name;

