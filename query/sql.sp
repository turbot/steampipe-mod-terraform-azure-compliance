query "sql_database_long_term_geo_redundant_backup_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'long_term_retention_policy') is null then 'alarm'
        when (arguments -> 'long_term_retention_policy' ->> 'monthly_retention')::text <>  'PT0S'
          or (arguments -> 'long_term_retention_policy' ->> 'weekly_retention')::text <>  'PT0S'
          or (arguments -> 'long_term_retention_policy' ->> 'yearly_retention')::text <>  'PT0S'
          then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'long_term_retention_policy') is null then ' ''long_term_retention_policy'' is not set'
        when (arguments -> 'long_term_retention_policy' ->> 'monthly_retention')::text <>  'PT0S'
          or (arguments -> 'long_term_retention_policy' ->> 'weekly_retention')::text <>  'PT0S'
          or (arguments -> 'long_term_retention_policy' ->> 'yearly_retention')::text <>  'PT0S'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'SqlServerVirtualMachines' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'SqlServerVirtualMachines' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for SqlServerVirtualMachines'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'threat_detection_policy') is null then 'alarm'
        when (arguments -> 'threat_detection_policy' ->> 'state') = 'Disabled' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'threat_detection_policy') is null then ' does not have ATP enabled'
        when (arguments -> 'threat_detection_policy' ->> 'state') = 'Disabled' then ' does not have ATP enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'tier') = 'Standard' and (arguments ->> 'resource_type') = 'SqlServers' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'tier') = 'Standard' and (arguments ->> 'resource_type') = 'SqlServers' then ' Azure defender enabled for SqlServer(s)'
        else ' Azure defender enabled for ' || (arguments ->> 'resource_type') || ''
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
        and (arguments ->> 'retention_in_days')::int > 90
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when (s.arguments ->> 'server_id') is not null then 'ok'
        else 'alarm'
      end as status,
      a.name || case
        when (s.arguments ->> 'server_name') is not null then ' audit retention greater than 90 days'
        else ' audit retention less than 90 days'
      end || '.' reason,
      a.path || ':' || a.start_line
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
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'server_name'), '.', 2) from terraform_resource where type = 'azurerm_sql_active_directory_administrator') then 'ok'
        else 'alarm'
      end status,
      name || case
        when name in (select split_part((arguments ->> 'server_name'), '.', 2) from terraform_resource where type = 'azurerm_sql_active_directory_administrator') then ' has AzureAD authentication enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'threat_detection_policy') is null then 'alarm'
        when (arguments -> 'threat_detection_policy' ->> 'state') = 'Disabled' then 'alarm'
        when (arguments -> 'threat_detection_policy' ->> 'state') = 'Enabled' and(arguments -> 'threat_detection_policy' -> 'retention_days') is null then 'alarm'
        when (arguments -> 'threat_detection_policy' -> 'retention_days')::integer < 90 then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'threat_detection_policy') is null then ' threat detection policy not enabled'
        when (arguments -> 'threat_detection_policy' ->> 'state') = 'Disabled' then ' threat detection policy disabled'
        when (arguments -> 'threat_detection_policy' ->> 'state') = 'Enabled' and(arguments -> 'threat_detection_policy' -> 'retention_days') is null then ' auditing to storage account destination not configured with 90 days retention or higher'
        when (arguments -> 'threat_detection_policy' -> 'retention_days')::integer < 90 then ' auditing to storage account destination not configured with 90 days retention or higher'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'azuread_administrator') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'azuread_administrator') is null then ' Azure AD authentication not configured.'
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
      type || ' ' || name as resource,
      case
        when 
          coalesce(trim(arguments ->> 'start_ip_address'), '') = ''
          or coalesce(trim(arguments ->> 'end_ip_address'), '') = ''
          or (arguments ->> 'end_ip_address' = '0.0.0.0'
            and arguments ->> 'start_ip_address' = '0.0.0.0')
          or (arguments ->> 'end_ip_address' = '0.0.0.0'
            and arguments ->> 'start_ip_address' = '255.255.255.255')
        then 'alarm'
        else 'ok'
      end status,
      name || case
        when  coalesce(trim(arguments ->> 'start_ip_address'), '') = ''
        then ' ''start_ip_address'' is not defined.'
        when  coalesce(trim(arguments ->> 'end_ip_address'), '') = ''
        then ' ''end_ip_address'' is not defined.'
        when (arguments ->> 'end_ip_address' = '0.0.0.0'
            and arguments ->> 'start_ip_address' = '0.0.0.0')
          or (arguments ->> 'end_ip_address' = '0.0.0.0'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'public_network_access_enabled') is null then 'alarm'
        when (arguments -> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'public_network_access_enabled') is null then ' ''public_network_access_enabled'' not defined'
        when (arguments -> 'public_network_access_enabled')::boolean then ' public network access enabled'
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

