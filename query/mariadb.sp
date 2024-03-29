query "mariadb_server_geo_redundant_backup_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'geo_redundant_backup_enabled') is null then 'alarm'
        when (attributes_std -> 'geo_redundant_backup_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'geo_redundant_backup_enabled') is null then ' geo-redundant backup disabled'
        when (attributes_std -> 'geo_redundant_backup_enabled')::bool then ' geo-redundant backup enabled'
        else ' geo-redundant backup disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mariadb_server';
  EOQ
}

query "mariadb_server_public_network_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'public_network_access_enabled') is null then 'alarm'
        when (attributes_std -> 'public_network_access_enabled')::bool then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'public_network_access_enabled') is null then ' public network access enabled'
        when (attributes_std -> 'public_network_access_enabled')::bool then ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mariadb_server';
  EOQ
}

query "mariadb_server_ssl_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'ssl_enforcement_enabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'ssl_enforcement_enabled') = 'true' then ' SSL connection enabled'
        else ' SSL connection disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mariadb_server';
  EOQ
}

