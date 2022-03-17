select
  type || ' ' || name as resource,
  case
    when (arguments -> 'threat_detection_policy') is null then 'alarm'
    when (arguments -> 'threat_detection_policy' ->> 'state') = 'Disabled' then 'alarm'
    when (arguments -> 'threat_detection_policy' ->> 'state') = 'Enabled' and(arguments -> 'threat_detection_policy' -> 'retention_days') is null then 'alarm'
    when (arguments -> 'threat_detection_policy' -> 'retention_days')::integer < 90 then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'threat_detection_policy') is null then ' threat detection policy not enabled'
    when (arguments -> 'threat_detection_policy' ->> 'state') = 'Disabled' then ' threat detection policy disabled'
    when (arguments -> 'threat_detection_policy' ->> 'state') = 'Enabled' and(arguments -> 'threat_detection_policy' -> 'retention_days') is null then ' auditing to storage account destination not configured with 90 days retention or higher'
    when (arguments -> 'threat_detection_policy' -> 'retention_days')::integer < 90 then ' auditing to storage account destination not configured with 90 days retention or higher'
    else ' auditing to storage account destination configured with 90 days retention or higher'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_sql_server';