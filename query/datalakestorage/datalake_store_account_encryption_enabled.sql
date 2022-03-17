select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'encryption_state') = 'Enabled' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'encryption_state') = 'Enabled' then ' encryption at rest enabled'
    else ' encryption at rest disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_data_lake_store';
