select
  type || ' ' || name as resource,
  case
    when (arguments -> 'site_config') is null then 'alarm'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PHP%' then 'ok'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PHP%' then' not using php version'
    when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PHP|8.0' then ' using the latest php version'
    else ' not using latest php version'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_app_service';