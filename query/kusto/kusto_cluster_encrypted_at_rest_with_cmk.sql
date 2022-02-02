with kusto_clusters as (
  select
    *
  from
    terraform_resource
  where
    type = 'azurerm_kusto_cluster'
), kusto_cluster_customer_managed_key as (
  select
    split_part((arguments ->> 'cluster_id'), '.', 2) as cluster_name
  from
    terraform_resource
  where
    type = 'azurerm_kusto_cluster_customer_managed_key'
    and (arguments ->> 'key_vault_id') is not null
    and (arguments ->> 'key_name') is not null
    and (arguments ->> 'key_version') is not null
)
select
  type || ' ' || a.name as resource,
  case
    when s.cluster_name is null then 'alarm'
    else 'ok'
  end as status,
  a.name || case
    when s.cluster_name is null then  ' logging disabled'
    else ' logging enabled'
  end || '.' reason,
  a.path
from
  kusto_clusters as a
  left join kusto_cluster_customer_managed_key as s on a.name = s.cluster_name;