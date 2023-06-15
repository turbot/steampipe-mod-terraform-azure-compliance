query "mysql_db_server_geo_redundant_backup_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'geo_redundant_backup_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'geo_redundant_backup_enabled')::boolean then ' Geo-redundant backup enabled'
        else ' Geo-redundant backup disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mysql_server';
  EOQ
}

query "mysql_server_infrastructure_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'infrastructure_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'infrastructure_encryption_enabled')::boolean then ' infrastructure encryption enabled'
        else ' infrastructure encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mysql_server';
  EOQ
}

query "mysql_ssl_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'ssl_enforcement_enabled')::boolean then 'ok'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'ssl_enforcement_enabled')::boolean then ' SSL connection enabled'
        else ' SSL connection disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mysql_server';
  EOQ
}

query "mysql_server_public_network_access_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'public_network_access_enabled')::boolean then ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mysql_server';
  EOQ
}

query "mysql_server_encrypted_at_rest_using_cmk" {
  sql = <<-EOQ
    with mysql_server as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_mysql_server'
    ), server_keys as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_mysql_server_key'
        and (arguments -> 'key_vault_key_id') is not null
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when (s.arguments ->> 'server_id') is not null then 'ok'
        else 'alarm'
      end as status,
      a.name || case
        when (s.arguments ->> 'server_id') is not null then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      mysql_server as a
      left join server_keys as s on a.name = (split_part((s.arguments ->> 'server_id'), '.', 2));
  EOQ
}

