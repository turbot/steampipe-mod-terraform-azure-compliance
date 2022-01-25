select
  type || ' ' || name as resource,
  case
    when (arguments -> 'threat_detection_policy') is null then 'alarm'
    when (arguments -> 'threat_detection_policy' ->> 'state') = 'Disabled' then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'threat_detection_policy') is null then ' does not have ATP enabled'
    when (arguments -> 'threat_detection_policy' ->> 'state') = 'Disabled' then ' does not have ATP enabled'
    else ' has ATP enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_sql_server';