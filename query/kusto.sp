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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'double_encryption_enabled') is null then 'alarm'
        when (arguments ->> 'double_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'double_encryption_enabled') is null then ' ''double_encryption_enabled'' not set'
        when (arguments ->> 'double_encryption_enabled')::boolean then ' double encryption enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'enable_disk_encryption') is null then 'alarm'
        when (arguments ->> 'enable_disk_encryption')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'enable_disk_encryption') is null then ' ''enable_disk_encryption'' not set'
        when (arguments ->> 'enable_disk_encryption')::boolean then ' disk encryption enabled'
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

