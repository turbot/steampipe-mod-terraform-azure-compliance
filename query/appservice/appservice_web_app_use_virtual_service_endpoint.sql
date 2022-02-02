with app_service as (
  select
    '${azurerm_app_service.' || name || '.id}' as id,
    *
  from
    terraform_resource
  where
    type = 'azurerm_app_service'
), app_service_vnet as (
    select
      *
    from
      terraform_resource
    where
      type = 'azurerm_app_service_slot_virtual_network_swift_connection'
      and (arguments ->> 'subnet_id') is not null
)
select
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'app_service_id') is null then 'alarm'
    else 'ok'
  end as status,
  a.name || case
    when (s.arguments ->> 'app_service_id') is null then  ' not configured with virtual network service endpoint'
    else ' configured with virtual network service endpoint'
  end || '.' reason,
  a.path
from
  app_service as a
  left join app_service_vnet as s on a.id = (s.arguments ->> 'app_service_id');