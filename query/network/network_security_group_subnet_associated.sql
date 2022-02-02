with all_subnet as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_subnet'
), network_security_group_association as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_subnet_network_security_group_association'
)
select
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'subnet_id') is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (s.arguments ->> 'subnet_id') is not null then ' associated with subnet'
    else ' not associated with subnet'
  end || '.' reason,
  a.path
from
  all_subnet as a
  left join network_security_group_association as s on a.name = ( split_part((s.arguments ->> 'subnet_id'), '.', 2));