with kusto_clusters as (
  select
    '${azurerm_kusto_cluster.' || name || '.id}' as id,
    *
  from
    terraform_resource
  where
    type = 'azurerm_kusto_cluster'
), kusto_cluster_customer_managed_key as (
  select
    (arguments ->> 'cluster_id') as cluster_id
  from
    terraform_resource
  where
    type = 'azurerm_kusto_cluster_customer_managed_key'
    and  (arguments ->> 'key_vault_id') is not null
    and (arguments ->> 'key_name') is not null
    and (arguments ->> 'key_version') is not null
)
select
  -- Required Columns
  type || ' ' || a.name as resource,
  case
    when s.cluster_id is null then 'alarm'
    else 'ok'
  end as status,
  a.name || case
    when s.cluster_id is null then  ' logging disabled'
    else ' logging enabled'
  end || '.' reason,
  a.path
from
  kusto_clusters as a
  left join kusto_cluster_customer_managed_key as s on a.id = s.cluster_id;