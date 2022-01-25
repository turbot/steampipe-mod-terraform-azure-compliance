select
  type || ' ' || name as resource,
  case
    when (arguments -> 'network') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'network') is null then ' network injection disabled'
    else ' network injection enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_spring_cloud_service';