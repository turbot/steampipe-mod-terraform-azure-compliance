select
  type || ' ' || name as resource,
  case
    when (arguments -> 'cluster_setting') is null then 'alarm'
    when
      (arguments -> 'cluster_setting' ->> 'name')::text = 'InternalEncryption'
      and (arguments -> 'cluster_setting' ->> 'value')::text = 'true' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'cluster_setting') is null then ' ''cluster_setting'' not defined'
    when
      (arguments -> 'cluster_setting' ->> 'name')::text = 'InternalEncryption'
      and (arguments -> 'cluster_setting' ->> 'value')::text = 'true' then ' internal encryption enabled'
    else ' internal encryption disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_app_service_environment';