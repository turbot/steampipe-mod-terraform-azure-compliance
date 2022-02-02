(select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encryption_at_host_enabled') is null then 'alarm'
    when (arguments -> 'encryption_at_host_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'encryption_at_host_enabled') is null then ' ''encryption_at_host_enabled'' is not defined'
    when (arguments -> 'encryption_at_host_enabled')::boolean then ' encryption at host enabled'
    else ' encryption at host disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_linux_virtual_machine_scale_set' or
   type = 'azurerm_windows_virtual_machine_scale_set'
)
union
(
select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encryption_at_host_enabled') is null then 'alarm'
    when (arguments -> 'encryption_at_host_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'encryption_at_host_enabled') is null then ' ''encryption_at_host_enabled'' is not defined'
    when (arguments -> 'encryption_at_host_enabled')::boolean then ' encryption at host enabled'
    else ' encryption at host disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_windows_virtual_machine' or
  type = 'azurerm_linux_virtual_machine'
)