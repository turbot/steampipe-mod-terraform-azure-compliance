select
  type || ' ' || name as resource,
  case
    when (arguments -> 'identity') is null then 'alarm'
    when (arguments -> 'identity' ->> 'type')::text = 'SystemAssigned' then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'identity') is null then ' ''identity'' not defined'
    when (arguments -> 'identity' ->> 'type')::text = 'SystemAssigned' then ' register with azure active directory enabled'
    else ' register with azure active directory disabled.'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_app_service';