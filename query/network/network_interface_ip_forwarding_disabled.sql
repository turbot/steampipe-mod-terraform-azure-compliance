select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'enable_ip_forwarding')::boolean then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments ->> 'enable_ip_forwarding')::boolean then ' network interface enabled with IP forwarding'
    else ' network interface disabled with IP forwarding'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_network_interface'