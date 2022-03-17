select
  type || ' ' || name as resource,
  case
    when (arguments -> 'site_config') is null then 'alarm'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then 'ok'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then' not using python version'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then ' using the latest python version'
    else ' not using latest python version'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_function_app';