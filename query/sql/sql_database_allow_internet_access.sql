select
  type || ' ' || name as resource,
  case
    when 
      coalesce(trim(arguments ->> 'start_ip_address'), '') = ''
      or coalesce(trim(arguments ->> 'end_ip_address'), '') = ''
      or (arguments ->> 'end_ip_address' = '0.0.0.0'
        and arguments ->> 'start_ip_address' = '0.0.0.0')
      or (arguments ->> 'end_ip_address' = '0.0.0.0'
        and arguments ->> 'start_ip_address' = '255.255.255.255')
    then 'alarm'
    else 'ok'
  end status,
  name || case
    when  coalesce(trim(arguments ->> 'start_ip_address'), '') = ''
    then ' ''start_ip_address'' is not defined.'
    when  coalesce(trim(arguments ->> 'end_ip_address'), '') = ''
    then ' ''end_ip_address'' is not defined.'
    when (arguments ->> 'end_ip_address' = '0.0.0.0'
        and arguments ->> 'start_ip_address' = '0.0.0.0')
      or (arguments ->> 'end_ip_address' = '0.0.0.0'
        and arguments ->> 'start_ip_address' = '255.255.255.255')
    then ' allows ingress 0.0.0.0/0 or any ip over internet'
    else ' does not allow ingress 0.0.0.0/0 or any ip over internet'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_sql_firewall_rule';