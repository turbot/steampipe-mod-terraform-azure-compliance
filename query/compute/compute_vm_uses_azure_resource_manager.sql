select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_group_name') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'resource_group_name') is not null then ' uses azure resource manager'
    else ' uses azure resource manager'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_virtual_machine';