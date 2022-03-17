select
  type || ' ' || name as resource,
  case
    when (arguments -> 'long_term_retention_policy') is null then 'alarm'
    when (arguments -> 'long_term_retention_policy' ->> 'monthly_retention')::text <>  'PT0S'
      or (arguments -> 'long_term_retention_policy' ->> 'weekly_retention')::text <>  'PT0S'
      or (arguments -> 'long_term_retention_policy' ->> 'yearly_retention')::text <>  'PT0S'
      then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'long_term_retention_policy') is null then ' ''long_term_retention_policy'' is not set'
    when (arguments -> 'long_term_retention_policy' ->> 'monthly_retention')::text <>  'PT0S'
      or (arguments -> 'long_term_retention_policy' ->> 'weekly_retention')::text <>  'PT0S'
      or (arguments -> 'long_term_retention_policy' ->> 'yearly_retention')::text <>  'PT0S'
      then ' long-term geo-redundant backup enabled'
    else ' long-term geo-redundant backup disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_mssql_database';
