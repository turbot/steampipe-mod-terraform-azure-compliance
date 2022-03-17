select
  type || ' ' || name as resource,
  case
    when (arguments -> 'waf_configuration') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'waf_configuration') is not null then ' WAF enabled'
    else ' WAF disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_application_gateway';
