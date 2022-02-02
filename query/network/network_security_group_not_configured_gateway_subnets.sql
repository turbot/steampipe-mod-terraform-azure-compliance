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
    when (a.arguments ->> 'name')::text = 'GatewaySubnet' and (s.arguments ->> 'subnet_id') is not null then 'alarm'
    when (a.arguments ->> 'name')::text = 'GatewaySubnet' and (s.arguments ->> 'subnet_id') is null then 'ok'
    else 'skip'
  end as status,
  a.name || case
    when (a.arguments ->> 'name')::text = 'GatewaySubnet' and (s.arguments ->> 'subnet_id') is not null then ' Gateway subnet configured with network security group'
    when (a.arguments ->> 'name')::text = 'GatewaySubnet' and (s.arguments ->> 'subnet_id') is null then ' Gateway subnet not configured with network security group'
    else ' not of gateway subnet type'
  end || '.' reason,
  a.path
from
  all_subnet as a
  left join network_security_group_association as s on a.name = ( split_part((s.arguments ->> 'subnet_id'), '.', 2));
