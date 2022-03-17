select
  type || ' ' || name as resource,
  case
    when (arguments -> 'os_profile_windows_config' ->> 'enable_automatic_upgrades')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'os_profile_windows_config' ->> 'enable_automatic_upgrades')::boolean then ' automatic system updates enabled'
    else ' automatic system updates disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_virtual_machine';