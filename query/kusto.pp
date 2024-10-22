query "kusto_cluster_encrypted_at_rest_with_cmk" {
  sql = <<-EOQ
    with kusto_clusters as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_kusto_cluster'
    ), kusto_cluster_customer_managed_key as (
      select
        split_part((attributes_std ->> 'cluster_id'), '.', 2) as cluster_name
      from
        terraform_resource
      where
        type = 'azurerm_kusto_cluster_customer_managed_key'
        and (attributes_std ->> 'key_vault_id') is not null
        and (attributes_std ->> 'key_name') is not null
        and (attributes_std ->> 'key_version') is not null
    )
    select
      address as resource,
      case
        when s.cluster_name is null then 'alarm'
        else 'ok'
      end as status,
      split_part(a.address, '.', 2) || case
        when s.cluster_name is null then  ' logging disabled'
        else ' logging enabled'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      kusto_clusters as a
      left join kusto_cluster_customer_managed_key as s on a.name = s.cluster_name;
  EOQ
}

query "kusto_cluster_double_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'double_encryption_enabled') is null then 'alarm'
        when (attributes_std ->> 'double_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'double_encryption_enabled') is null then ' ''double_encryption_enabled'' not set'
        when (attributes_std ->> 'double_encryption_enabled')::boolean then ' double encryption enabled'
        else ' double encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kusto_cluster';
  EOQ
}

query "kusto_cluster_disk_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'disk_encryption_enabled') is null then 'alarm'
        when (attributes_std ->> 'disk_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'disk_encryption_enabled') is null then ' ''disk_encryption_enabled'' not set'
        when (attributes_std ->> 'disk_encryption_enabled')::boolean then ' disk encryption enabled'
        else ' disk encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kusto_cluster';
  EOQ
}

query "kusto_cluster_sku_with_sla" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'sku' ->> 'name') in ('Dev(No SLA)_Standard_E2a_v4' , 'Dev(No SLA)_Standard_D11_v2') then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'sku' ->> 'name') in ('Dev(No SLA)_Standard_E2a_v4' , 'Dev(No SLA)_Standard_D11_v2') then ' using SKU tier without SLA'
        else ' using SKU tier with SLA'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kusto_cluster';
  EOQ
}

query "kusto_cluster_uses_managed_identity" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'identity') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity') is null then ' ''identity'' is not defined'
        else ' uses ' || (attributes_std -> 'identity' ->> 'type') || ' identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kusto_cluster';
  EOQ
}
