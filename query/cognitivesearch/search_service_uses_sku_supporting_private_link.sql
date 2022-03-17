select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'sku')::text = 'free' then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments ->> 'sku')::text = 'free' then ' SKU does not supports private link'
    else ' SKU supports private link'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_search_service';
