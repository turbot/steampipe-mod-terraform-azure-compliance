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

