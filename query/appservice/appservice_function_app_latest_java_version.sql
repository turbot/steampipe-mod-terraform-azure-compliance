select
  type || ' ' || name as resource,
  case
    when (arguments -> 'site_config') is null then 'alarm'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then 'ok'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then' not using JAVA version'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text like '%11' then ' using the latest JAVA version'
    else ' not using latest JAVA version'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_function_app';