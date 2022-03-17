select
  type || ' ' || name as resource,
  case
    when (arguments -> 'site_config') is null then 'alarm'
    when (arguments -> 'site_config' ->> 'min_tls_version')::float < 1.2 then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'site_config') is null then ' ''min_tls_version'' not defined'
    when (arguments -> 'site_config' ->> 'min_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
    else ' using the latest version of TLS encryption'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_function_app';