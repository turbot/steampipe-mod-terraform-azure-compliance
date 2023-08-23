query "azure_redis_cache_in_virtual_network" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'subnet_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'subnet_id') is not null then ' in virtual network'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'enable_non_ssl_port')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'enable_non_ssl_port')::boolean then ' secure connections disabled'
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
      type || ' ' || name as resource,
      arguments  ->> 'minimum_tls_version',
      case
        when (arguments -> 'minimum_tls_version') is null then 'alarm'
        when (arguments  ->> 'minimum_tls_version')::float < 1.2 then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'minimum_tls_version') is null then ' ''min_tls_version'' not defined'
        when (arguments  ->> 'minimum_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_access_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'public_network_access_enabled') = 'false' then ' public network access disabled'
        else ' public network access enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_redis_cache';
  EOQ
}
