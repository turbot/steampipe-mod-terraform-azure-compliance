with key_vaults as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_key_vault'
), key_vaults_subnet as (
  select
    distinct a.name
  from
    key_vaults as a,
    jsonb_array_elements(arguments -> 'network_acls' -> 'virtual_network_subnet_ids') as id
) 
select
  type || ' ' || a.name as resource,
  case
    when (arguments -> 'network_acls' ->> 'default_action')::text <> 'Deny' then 'alarm'
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
  key_vaults as a
  left join key_vaults_subnet as s on a.name = s.name;

