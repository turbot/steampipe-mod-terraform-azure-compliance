query "azure_redis_cache_in_virtual_network" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'subnet_id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'subnet_id') is not null then ' in virtual network'
        else ' not in virtual network'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_redis_cache';
  EOQ
}

query "azure_redis_cache_ssl_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'enable_non_ssl_port')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'enable_non_ssl_port')::boolean then ' secure connections disabled'
        else ' secure connections enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_redis_cache';
  EOQ
}

query "redis_cache_min_tls_1_2" {
  sql = <<-EOQ
    select
      address as resource,
      attributes_std ->> 'minimum_tls_version',
      case
        when (attributes_std -> 'minimum_tls_version') is null then 'alarm'
        when (attributes_std ->> 'minimum_tls_version')::float < 1.2 then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'minimum_tls_version') is null then ' ''min_tls_version'' not defined'
        when (attributes_std ->> 'minimum_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
        else ' using the latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_redis_cache';
  EOQ
}

query "redis_cache_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_redis_cache';
  EOQ
}
