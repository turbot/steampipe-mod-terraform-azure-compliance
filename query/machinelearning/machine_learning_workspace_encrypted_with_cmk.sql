select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encryption') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'encryption') is null then ' not encrypted with CMK'
    else ' encrypted with CMK'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_machine_learning_workspace';