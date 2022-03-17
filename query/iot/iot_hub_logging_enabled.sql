select
  type || ' ' || name as resource,
  case
    when name in (select split_part((arguments ->> 'target_resource_id'), '.', 3) from terraform_resource where type = 'azurerm_monitor_diagnostic_setting' and split_part((arguments ->> 'target_resource_id'), '.', 2) = 'azurerm_iothub')then 'ok'
    else 'alarm'
  end status,
  name || case
    when name in (select split_part((arguments ->> 'target_resource_id'), '.', 3) from terraform_resource where type = 'azurerm_monitor_diagnostic_setting' and split_part((arguments ->> 'target_resource_id'), '.', 2) = 'azurerm_iothub')then ' logging enabled'
    else ' logging disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_iothub';