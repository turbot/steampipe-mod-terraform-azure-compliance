select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encryption' ) is null then 'alarm'
    when (arguments -> 'encryption' ->> 'enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'encryption' ) is null then ' ''encryption'' not defined'
    when (arguments -> 'encryption' ->> 'enabled')::boolean then ' encrypted with CMK'
    else ' not encrypted with CMK'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_container_registry';