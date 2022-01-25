-- Check NSGs do not have any of the following security rules deviations
-- "destinationPortRange" : "3389" or "*" or "[port range containing 3389]"
-- "access" : "Allow"
-- "sourceAddressPrefix" : "*" or "0.0.0.0" or "/0" or "/0" or "internet" or "any"
-- "protocol" : "TCP"
-- "direction" : "Inbound"
select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when (arguments ->> 'destinationPortRange') in ('22','*') or ((arguments ->> 'destinationPortRange') like '%-%' and split_part(arguments ->> 'destinationPortRange', '-', 1):: integer <= 3389 and split_part(arguments ->> 'destinationPortRange', '-', 2):: integer >= 3389)
    and (arguments ->> 'access') = 'Allow'
    and (arguments ->> 'source_address_prefix') in ( '*', 'any', 'internet', '0.0.0.0/0','<nw>/0','0.0.0.0')
    and (arguments ->> 'protocol') ilike 'Tcp' and (arguments ->> 'direction') = 'inbound' then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments ->> 'destinationPortRange') in  ('22','*') or ((arguments ->> 'destinationPortRange') like '%-%' and split_part(arguments ->> 'destinationPortRange', '-', 1) :: integer <= 22 and split_part(arguments ->> 'destinationPortRange', '-', 2) :: integer >= 22
    and (arguments ->> 'access') = 'Allow'
    and  (arguments ->> 'source_address_prefix') in ( '*', 'any', 'internet', '0.0.0.0/0','<nw>/0','0.0.0.0')
    and (arguments ->> 'protocol') ilike 'Tcp' and (arguments ->> 'direction') = 'inbound' then ' restricts SSH access from internet'
    else ' allows SSH access from internet'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_network_security_rule';

-- SAMPLE FOR TESTING

-- select
-- (arguments ->> 'access') as access,
-- (arguments ->> 'destinationPortRange') as destinationPortRange,
-- (arguments ->> 'source_address_prefix') as source_address_prefix,
-- (arguments ->> 'protocol') as protocol,
-- (arguments ->> 'direction') as direction
-- from terraform_resource where name='network_sec_rule_example'

-- select * from terraform_resource where name='network_sec_rule_example'
-- select * from terraform_resource where type = 'azurerm_network_security_rule'