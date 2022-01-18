with key_vaults as (
  select
    '${azurerm_key_vault.' || name || '.id}' as id,
    *
  from
    terraform_resource
  where
    type = 'azurerm_key_vault'
), diagnostic_setting as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_monitor_diagnostic_setting'
), key_vaults_logging as (
  select
    kv.name as kv_name
  from
    key_vaults as kv left join  diagnostic_setting as ds on kv.id = (ds.arguments ->> 'target_resource_id')
  where
    (ds.arguments ->> 'storage_account_id') is not null
    and (ds.arguments -> 'log' ->> 'category')::text = 'AuditEvent'
    and  (ds.arguments -> 'log' ->> 'enabled')::boolean
    and  (ds.arguments -> 'log' -> 'retention_policy' ->> 'enabled')::boolean
)
select
  -- Required Columns
  type || ' ' || a.name as resource,
  case
    when s.kv_name is null then 'alarm'
    else 'ok'
  end as status,
  a.name || case
    when s.kv_name is null then  ' logging disabled'
    else ' logging enabled'
  end || '.' reason,
  a.path
from
  key_vaults as a
  left join key_vaults_logging as s on a.name = s.kv_name;