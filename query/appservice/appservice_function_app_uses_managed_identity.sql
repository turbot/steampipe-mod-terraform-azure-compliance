select
  type || ' ' || name as resource,
  case
    when (arguments -> 'identity') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'identity') is null then ' ''identity'' is not defined'
    else ' uses ' || (arguments -> 'identity' ->> 'type') || ' identity'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_function_app';