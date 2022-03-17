select
  type || ' ' || name as resource,
  case
    when (arguments -> 'storage_os_disk' ->> 'managed_disk_type') is not null or
    (arguments -> 'storage_os_disk' ->> 'managed_disk_id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'storage_os_disk' ->> 'managed_disk_type') is not null or
    (arguments -> 'storage_os_disk' ->> 'managed_disk_id') is not null  then ' utilizing managed disks'
    else ' not utilizing managed disks'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_virtual_machine';