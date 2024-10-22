query "mysql_db_server_geo_redundant_backup_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'geo_redundant_backup_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'geo_redundant_backup_enabled')::boolean then ' Geo-redundant backup enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'infrastructure_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'infrastructure_encryption_enabled')::boolean then ' infrastructure encryption enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'ssl_enforcement_enabled')::boolean then 'ok'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'ssl_enforcement_enabled')::boolean then ' SSL connection enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled')::boolean then ' public network access enabled'
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
        and (attributes_std -> 'key_vault_key_id') is not null
    )
    select
      a.address as resource,
      case
        when (s.attributes_std ->> 'server_id') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'server_id') is not null then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      mysql_server as a
      left join server_keys as s on a.name = (split_part((s.attributes_std ->> 'server_id'), '.', 2));
  EOQ
}

query "mysql_server_min_tls_1_2" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'ssl_minimal_tls_version_enforced') is null)
          or ((attributes_std ->> 'ssl_minimal_tls_version_enforced') = 'TLS1_2') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'ssl_minimal_tls_version_enforced') is null)
        or ((attributes_std ->> 'ssl_minimal_tls_version_enforced') = 'TLS1_2') then ' not using the latest version of TLS encryption'
        else ' using the latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mysql_server';
  EOQ
}

query "mysql_server_threat_detection_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'threat_detection_policy') is null then 'alarm'
        when (attributes_std -> 'threat_detection_policy' ->> 'enabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'threat_detection_policy') is null then ' threat detection policy not defined'
        when (attributes_std -> 'threat_detection_policy' ->> 'enabled') = 'true' then ' threat detection policy enabled'
        else ' threat detection policy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mysql_server';
  EOQ
}
