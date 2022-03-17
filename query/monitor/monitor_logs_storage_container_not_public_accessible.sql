select
  type || ' ' || name as resource,
  case
    when (arguments -> 'container_access_type') is null then 'ok'
    when (arguments ->> 'container_access_type') ilike 'Private' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'container_access_type') is null then ' container insights-operational-logs storing activity logs not publicly accessible'
    when (arguments ->> 'container_access_type') ilike 'Private' then ' container insights-operational-logs storing activity logs not publicly accessible'
    else ' container insights-operational-logs storing activity logs publicly accessible'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_storage_container' and (arguments ->> 'name') ilike 'insights-operational-logs';