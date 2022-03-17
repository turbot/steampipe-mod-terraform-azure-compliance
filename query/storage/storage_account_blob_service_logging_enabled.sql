select
  type || ' ' || name as resource,
  case
    when (arguments -> 'queue_properties') is null or (arguments -> 'queue_properties' -> 'logging') is null then 'alarm'
    when not (arguments -> 'queue_properties' -> 'logging' ->> 'Read')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Write')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Delete')::boolean then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'queue_properties') is null or (arguments -> 'queue_properties' -> 'logging') is null then ' blob service logging not enabled'
    when not (arguments -> 'queue_properties' -> 'logging' ->> 'Read')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Write')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Delete')::boolean then ' blob service logging not enabled'
    else ' blob service logging enabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_storage_account';