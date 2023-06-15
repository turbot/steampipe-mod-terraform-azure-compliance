query "keyvault_vault_use_virtual_service_endpoint" {
  sql = <<-EOQ
    with key_vaults as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_key_vault'
    ), key_vaults_subnet as (
      select
        distinct a.name
      from
        key_vaults as a,
        jsonb_array_elements(arguments -> 'network_acls' -> 'virtual_network_subnet_ids') as id
    )
    select
      type || ' ' || a.name as resource,
      case
        when (arguments -> 'network_acls' ->> 'default_action')::text <> 'Deny' then 'alarm'
        when s.name is null then 'alarm'
        else 'ok'
      end as status,
      case
        when (arguments -> 'network_rule_set' ->> 'default_action')::text <> 'Deny' then ' not configured with virtual service endpoint'
        when s.name is null then  ' not configured with virtual service endpoint'
        else ' configured with virtual service endpoint'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      key_vaults as a
      left join key_vaults_subnet as s on a.name = s.name;
  EOQ
}

query "keyvault_managed_hms_logging_enabled" {
  sql = <<-EOQ
    with hsm_key_vaults as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_key_vault_managed_hardware_security_module'
    ), diagnostic_setting as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_monitor_diagnostic_setting'
        and (arguments ->> 'target_resource_id') like '%azurerm_key_vault_managed_hardware_security_module.%'
    ), hsm_key_vaults_logging as (
      select
        kv.name as kv_name
      from
        hsm_key_vaults as kv
        left join  diagnostic_setting as ds on kv.name = (split_part((ds.arguments ->> 'target_resource_id'), '.', 2))
      where
        (ds.arguments ->> 'storage_account_id') is not null
        and (ds.arguments -> 'log' ->> 'category')::text = 'AuditEvent'
        and (ds.arguments -> 'log' ->> 'enabled')::boolean
        and (ds.arguments -> 'log' -> 'retention_policy' ->> 'enabled')::boolean
    )
    select
      type || ' ' || a.name as resource,
      case
        when s.kv_name is null then 'alarm'
        else 'ok'
      end as status,
      a.name || case
        when s.kv_name is null then  ' logging disabled'
        else ' logging enabled'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      hsm_key_vaults as a
      left join hsm_key_vaults_logging as s on a.name = s.kv_name;
  EOQ
}

query "keyvault_managed_hms_purge_protection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'purge_protection_enabled') is null then 'alarm'
        when (arguments ->> 'purge_protection_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'purge_protection_enabled') is null then ' ''purge_protection_enabled'' not set'
        when (arguments ->> 'purge_protection_enabled')::boolean then  ' purge protection enabled'
        else ' purge protection disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_key_vault_managed_hardware_security_module';
  EOQ
}

query "keyvault_logging_enabled" {
  sql = <<-EOQ
    with key_vaults as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_key_vault'
    ), diagnostic_setting as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_monitor_diagnostic_setting'
        and (arguments ->> 'target_resource_id') like '%azurerm_key_vault.%'
    ), key_vaults_logging as (
      select
        kv.name as kv_name,
        ds.arguments
      from
        key_vaults as kv
        left join diagnostic_setting as ds on kv.name = (split_part((ds.arguments ->> 'target_resource_id'), '.', 2))
      where
        (ds.arguments ->> 'storage_account_id') is not null
        and (ds.arguments -> 'log' ->> 'category')::text = 'AuditEvent'
        and (ds.arguments -> 'log' ->> 'enabled')::boolean
        and (ds.arguments -> 'log' -> 'retention_policy' ->> 'enabled')::boolean
    )
    select
      type || ' ' || a.name as resource,
      case
        when s.kv_name is null then 'alarm'
        else 'ok'
      end as status,
      a.name || case
        when s.kv_name is null then  ' logging disabled'
        else ' logging enabled'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      key_vaults as a
      left join key_vaults_logging as s on a.name = s.kv_name;
  EOQ
}

query "keyvault_purge_protection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'purge_protection_enabled') is null then 'alarm'
        when (arguments ->> 'purge_protection_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'purge_protection_enabled') is null then ' ''purge_protection_enabled'' not set'
        when (arguments ->> 'purge_protection_enabled')::boolean then  ' purge protection enabled'
        else ' purge protection disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_key_vault';
  EOQ
}

query "keyvault_vault_public_network_access_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'network_acls') is null then 'alarm'
        when (arguments -> 'network_acls' ->> 'default_action')::text != 'Deny' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'network_acls') is null then ' ''network_acls'' not set'
        when (arguments -> 'network_acls' ->> 'default_action')::text != 'Deny' then ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_key_vault';
  EOQ
}

query "keyvault_key_expiration_set" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'expiration_date') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'expiration_date') is null then ' expiration_date not set'
        else ' expiration_date is set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_key_vault_key';
  EOQ
}

query "keyvault_azure_defender_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'KeyVaults' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'KeyVaults' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for KeyVaults'
        else ' Azure Defender off for KeyVaults'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "keyvault_secret_expiration_set" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'expiration_date') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'expiration_date') is null then ' expiration_date not set'
        else ' expiration_date is set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_key_vault_secret';
  EOQ
}

