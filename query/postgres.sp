query "postgres_db_server_log_retention_days_3" {
  sql = <<-EOQ
    with postgresql_server as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_server'
    ), log_disconnections_configuration as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_configuration'
        and (attributes_std ->> 'name') = 'log_retention_days'
        and (attributes_std ->> 'value')::int > 3
    )
    select
      a.address as resource,
      case
        when (s.attributes_std ->> 'server_name') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'server_name') is not null then ' log files are retained for more than 3 days'
        else ' og files are retained for 3 days or lesser'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      postgresql_server as a
      left join log_disconnections_configuration as s on a.name = ( split_part((s.attributes_std ->> 'server_name'), '.', 2));
  EOQ
}

query "postgres_db_server_connection_throttling_on" {
  sql = <<-EOQ
    with postgresql_server as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_server'
    ), connection_throttling_configuration as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_configuration'
        and (attributes_std ->> 'name') = 'connection_throttling'
        and (attributes_std ->> 'value') = 'on'
    )
    select
      a.address as resource,
      case
        when (s.attributes_std ->> 'server_name') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'server_name') is not null then ' server parameter connection_throttling on'
        else ' server parameter connection_throttling off'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      postgresql_server as a
      left join connection_throttling_configuration as s on a.name = ( split_part((s.attributes_std ->> 'server_name'), '.', 2));
  EOQ
}

query "postgresql_server_infrastructure_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'infrastructure_encryption_enabled') is null then 'alarm'
        when (attributes_std ->> 'infrastructure_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'infrastructure_encryption_enabled') is null then ' ''infrastructure_encryption_enabled'' not set'
        when (attributes_std ->> 'infrastructure_encryption_enabled')::boolean then ' infrastructure encryption enabled'
        else ' infrastructure encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_postgresql_server';
  EOQ
}

query "postgres_db_server_geo_redundant_backup_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'geo_redundant_backup_enabled') is null then 'alarm'
        when (attributes_std ->> 'geo_redundant_backup_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'geo_redundant_backup_enabled') is null then ' ''geo_redundant_backup_enabled'' not set'
        when (attributes_std ->> 'geo_redundant_backup_enabled')::boolean then ' Geo-redundant backup enabled'
        else ' Geo-redundant backup disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_postgresql_server';
  EOQ
}

query "postgresql_server_encrypted_at_rest_using_cmk" {
  sql = <<-EOQ
    with postgresql_server as (
      select
        '$${azurerm_postgresql_server.' || name || '.id}' as pg_id,
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_server'
    ), server_keys as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_server_key'
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
      postgresql_server as a
      left join server_keys as s on a.pg_id = ( s.attributes_std ->> 'server_id');
  EOQ
}

query "postgres_db_server_log_checkpoints_on" {
  sql = <<-EOQ
    with postgresql_server as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_server'
    ), log_checkpoints_configuration as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_configuration'
        and (attributes_std ->> 'name') = 'log_checkpoints'
        and (attributes_std ->> 'value') = 'on'
    )
    select
      a.address as resource,
      case
        when (s.attributes_std ->> 'server_name') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'server_name') is not null then ' server parameter log_checkpoints on'
        else ' server parameter log_checkpoints off'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      postgresql_server as a
      left join log_checkpoints_configuration as s on a.name = (split_part((s.attributes_std ->> 'server_name'), '.', 2));
  EOQ
}

query "postgres_db_server_log_connections_on" {
  sql = <<-EOQ
    with postgresql_server as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_server'
    ), log_connections_configuration as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_configuration'
        and (attributes_std ->> 'name') = 'log_connections'
        and (attributes_std ->> 'value') = 'on'
    )
    select
      a.address as resource,
      case
        when (s.attributes_std ->> 'server_name') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'server_name') is not null then ' server parameter log_connections on'
        else ' server parameter log_connections off'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      postgresql_server as a
      left join log_connections_configuration as s on a.name = (split_part((s.attributes_std ->> 'server_name'), '.', 2));
  EOQ
}

query "postgresql_server_public_network_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled') is null then 'alarm'
        when (attributes_std ->> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled') is null then ' ''public_network_access_enabled'' not set'
        when (attributes_std ->> 'public_network_access_enabled')::boolean then ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_postgresql_server';
  EOQ
}

query "postgres_db_server_log_disconnections_on" {
  sql = <<-EOQ
    with postgresql_server as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_server'
    ), log_disconnections_configuration as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_postgresql_configuration'
        and (attributes_std ->> 'name') = 'log_disconnections'
        and (attributes_std ->> 'value') = 'on'
    )
    select
      a.address as resource,
      case
        when (s.attributes_std ->> 'server_name') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'server_name') is not null then ' server parameter log_disconnections on'
        else ' server parameter log_disconnections off'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      postgresql_server as a
      left join log_disconnections_configuration as s on a.name = (split_part((s.attributes_std ->> 'server_name'), '.', 2));
  EOQ
}

query "postgresql_ssl_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'ssl_enforcement_enabled') is null then 'alarm'
        when (attributes_std ->> 'ssl_enforcement_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'ssl_enforcement_enabled') is null then ' ''ssl_enforcement_enabled'' not set'
        when (attributes_std ->> 'ssl_enforcement_enabled')::boolean then ' SSL connection enabled'
        else ' SSL connection disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_postgresql_server';
  EOQ
}

query "postgres_db_flexible_server_geo_redundant_backup_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'geo_redundant_backup_enabled') is null then 'alarm'
        when (attributes_std ->> 'geo_redundant_backup_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'geo_redundant_backup_enabled') is null then ' ''geo_redundant_backup_enabled'' not set'
        when (attributes_std ->> 'geo_redundant_backup_enabled')::boolean then ' geo-redundant backup enabled'
        else ' geo-redundant backup disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_postgresql_flexible_server';
  EOQ
}

query "postgres_db_server_threat_detection_policy_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'threat_detection_policy') is null then 'alarm'
        when (attributes_std -> 'threat_detection_policy' ->> 'enabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'threat_detection_policy') is null then ' threat detection policy not set'
        when (attributes_std -> 'threat_detection_policy' ->> 'enabled') = 'true' then ' threat detection policy enabled'
        else ' threat detection policy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_postgresql_server';
  EOQ
}

query "postgres_db_server_latest_tls_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'ssl_minimal_tls_version_enforced') is null or (attributes_std ->> 'ssl_minimal_tls_version_enforced') = 'TLS1_2' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when  (attributes_std ->> 'ssl_minimal_tls_version_enforced') is null or (attributes_std ->> 'ssl_minimal_tls_version_enforced') = 'TLS1_2' then ' using the latest version of TLS encryption'
        else ' not using the latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_postgresql_server';
  EOQ
}
