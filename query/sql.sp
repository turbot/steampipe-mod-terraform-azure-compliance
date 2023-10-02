query "sql_database_long_term_geo_redundant_backup_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'long_term_retention_policy') is null then 'alarm'
        when (attributes_std -> 'long_term_retention_policy' ->> 'monthly_retention')::text <>  'PT0S'
          or (attributes_std -> 'long_term_retention_policy' ->> 'weekly_retention')::text <>  'PT0S'
          or (attributes_std -> 'long_term_retention_policy' ->> 'yearly_retention')::text <>  'PT0S'
          then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'long_term_retention_policy') is null then ' ''long_term_retention_policy'' is not set'
        when (attributes_std -> 'long_term_retention_policy' ->> 'monthly_retention')::text <>  'PT0S'
          or (attributes_std -> 'long_term_retention_policy' ->> 'weekly_retention')::text <>  'PT0S'
          or (attributes_std -> 'long_term_retention_policy' ->> 'yearly_retention')::text <>  'PT0S'
          then ' long-term geo-redundant backup enabled'
        else ' long-term geo-redundant backup disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mssql_database';
  EOQ
}

query "sql_server_vm_azure_defender_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'resource_type') = 'SqlServerVirtualMachines' and (attributes_std ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'resource_type') = 'SqlServerVirtualMachines' and (attributes_std ->> 'tier') = 'Standard' then ' Azure Defender on for SqlServerVirtualMachines'
        else ' Azure Defender off for SqlServerVirtualMachines'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "sql_server_atp_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'threat_detection_policy') is null then 'alarm'
        when (attributes_std -> 'threat_detection_policy' ->> 'state') = 'Disabled' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'threat_detection_policy') is null then ' does not have ATP enabled'
        when (attributes_std -> 'threat_detection_policy' ->> 'state') = 'Disabled' then ' does not have ATP enabled'
        else ' has ATP enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_sql_server';
  EOQ
}

query "sql_database_server_azure_defender_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'tier') = 'Standard' and (attributes_std ->> 'resource_type') = 'SqlServers' then 'ok'
        else 'skip'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'tier') = 'Standard' and (attributes_std ->> 'resource_type') = 'SqlServers' then ' Azure defender enabled for SqlServer(s)'
        else ' Azure defender enabled for ' || (attributes_std ->> 'resource_type') || ''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "sql_server_audting_retention_period_90" {
  sql = <<-EOQ
    with sql_server as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_mssql_server'
    ), server_audit_policy as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_mssql_server_extended_auditing_policy'
        and (attributes_std ->> 'retention_in_days')::int > 90
    )
    select
      address as resource,
      case
        when (s.arguments ->> 'server_id') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.arguments ->> 'server_name') is not null then ' audit retention greater than 90 days'
        else ' audit retention less than 90 days'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      sql_server as a
      left join server_audit_policy as s on a.name = ( split_part((s.arguments ->> 'server_id'), '.', 2));
  EOQ
}

query "sql_server_azure_ad_authentication_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when name in (select split_part((attributes_std ->> 'server_name'), '.', 2) from terraform_resource where type = 'azurerm_sql_active_directory_administrator') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when name in (select split_part((attributes_std ->> 'server_name'), '.', 2) from terraform_resource where type = 'azurerm_sql_active_directory_administrator') then ' has AzureAD authentication enabled'
        else ' does not have AzureAD authentication enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_sql_server';
  EOQ
}

query "sql_server_auditing_storage_account_destination_retention_90_days" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'threat_detection_policy') is null then 'alarm'
        when (attributes_std -> 'threat_detection_policy' ->> 'state') = 'Disabled' then 'alarm'
        when (attributes_std -> 'threat_detection_policy' ->> 'state') = 'Enabled' and(attributes_std -> 'threat_detection_policy' -> 'retention_days') is null then 'alarm'
        when (attributes_std -> 'threat_detection_policy' -> 'retention_days')::integer < 90 then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'threat_detection_policy') is null then ' threat detection policy not enabled'
        when (attributes_std -> 'threat_detection_policy' ->> 'state') = 'Disabled' then ' threat detection policy disabled'
        when (attributes_std -> 'threat_detection_policy' ->> 'state') = 'Enabled' and(attributes_std -> 'threat_detection_policy' -> 'retention_days') is null then ' auditing to storage account destination not configured with 90 days retention or higher'
        when (attributes_std -> 'threat_detection_policy' -> 'retention_days')::integer < 90 then ' auditing to storage account destination not configured with 90 days retention or higher'
        else ' auditing to storage account destination configured with 90 days retention or higher'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_sql_server';
  EOQ
}

query "sql_db_active_directory_admin_configured" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'azuread_administrator') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'azuread_administrator') is null then ' Azure AD authentication not configured.'
        else ' Azure AD authentication configured'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mssql_server';
  EOQ
}

query "sql_database_allow_internet_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when
          coalesce(trim(attributes_std ->> 'start_ip_address'), '') = ''
          or coalesce(trim(attributes_std ->> 'end_ip_address'), '') = ''
          or (attributes_std ->> 'end_ip_address' = '0.0.0.0'
            and arguments ->> 'start_ip_address' = '0.0.0.0')
          or (attributes_std ->> 'end_ip_address' = '0.0.0.0'
            and arguments ->> 'start_ip_address' = '255.255.255.255')
        then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when  coalesce(trim(attributes_std ->> 'start_ip_address'), '') = ''
        then ' ''start_ip_address'' is not defined.'
        when  coalesce(trim(attributes_std ->> 'end_ip_address'), '') = ''
        then ' ''end_ip_address'' is not defined.'
        when (attributes_std ->> 'end_ip_address' = '0.0.0.0'
            and arguments ->> 'start_ip_address' = '0.0.0.0')
          or (attributes_std ->> 'end_ip_address' = '0.0.0.0'
            and arguments ->> 'start_ip_address' = '255.255.255.255')
        then ' allows ingress 0.0.0.0/0 or any ip over internet'
        else ' does not allow ingress 0.0.0.0/0 or any ip over internet'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_sql_firewall_rule';
  EOQ
}

query "sql_db_public_network_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'public_network_access_enabled') is null then 'alarm'
        when (attributes_std -> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'public_network_access_enabled') is null then ' ''public_network_access_enabled'' not defined'
        when (attributes_std -> 'public_network_access_enabled')::boolean then ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mssql_server';
  EOQ
}

query "sql_server_email_security_alert_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'email_addresses') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'email_addresses') is null then ' email security alert disabled'
        else ' email security alert enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mssql_server_security_alert_policy';
  EOQ
}

query "sql_server_admins_email_security_alert_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'email_account_admins')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'email_account_admins')::boolean then ' account administrators email security alert enabled'
        else ' account administrators email security alert disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mssql_server_security_alert_policy';
  EOQ
}

query "sql_server_all_security_alerts_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'disabled_alerts') is not null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'disabled_alerts') is not null then ' some security alerts disabled'
        else ' all security alerts enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mssql_server_security_alert_policy';
  EOQ
}

query "sql_server_uses_latest_tls_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'minimum_tls_version') is null then 'ok'
        when (attributes_std ->> 'minimum_tls_version')::text = '1.2' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'minimum_tls_version') is null then ' TLS version not defined by default uses 1.2'
        when (attributes_std ->> 'minimum_tls_version')::text = '1.2' then ' TLS version 1.2'
        else ' TLS version not 1.2'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mssql_server';
  EOQ
}

query "sql_database_log_monitoring_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'log_monitoring_enabled') is null then 'ok'
        when (attributes_std -> 'log_monitoring_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'log_monitoring_enabled') is null then ' log monitoring enabled'
        when (attributes_std -> 'log_monitoring_enabled')::boolean then ' log monitoring enabled'
        else ' log monitoring disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_mssql_database_extended_auditing_policy';
  EOQ
}
