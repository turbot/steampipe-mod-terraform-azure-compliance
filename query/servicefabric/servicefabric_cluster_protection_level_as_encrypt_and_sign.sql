select
  type || ' ' || name as resource,
  case
    when (arguments -> 'fabric_settings') is null then 'alarm'
    when (arguments -> 'fabric_settings' -> 'parameters') is null then 'alarm'
    when (arguments -> 'fabric_settings' ->> 'parameters') like '%EncryptAndSign%' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'fabric_settings') is null then ' Cluster Protection Level not set'
    when (arguments -> 'fabric_settings' -> 'parameters') is null then ' Cluster Protection Level not set to EncryptAndSign'
    when (arguments -> 'fabric_settings' ->> 'parameters') like '%EncryptAndSign%' then ' Cluster Protection Level set to EncryptAndSign'
    else ' Cluster Protection Level not set to EncryptAndSign'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_service_fabric_cluster';