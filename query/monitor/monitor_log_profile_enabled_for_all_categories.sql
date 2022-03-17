select
  type || ' ' || name as resource,
  case
    when (arguments -> 'categories') @> '["Write", "Action", "Delete"]' then 'ok'
    else 'alarm'
  end status,
  name || case
     when (arguments -> 'categories') @> '["Write", "Action", "Delete"]' then ' collects logs for categories write, delete and action'
    else ' does not collects logs for all categories.'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_monitor_log_profile';
