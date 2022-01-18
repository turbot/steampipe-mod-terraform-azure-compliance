select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'customer_managed_key_id') is null then 'alarm'
    when (arguments -> 'customer_managed_key_id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'customer_managed_key_id') is null then ' ''customer_managed_key_id'' not defined'
    when (arguments ->> 'customer_managed_key_id' ) is not null then ' encrypted with CMK'
    else ' not encrypted with CMK'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_data_factory';