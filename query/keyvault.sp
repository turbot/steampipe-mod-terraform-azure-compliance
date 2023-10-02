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
        distinct address a.name
      from
        key_vaults as a,
        jsonb_array_elements(attributes_std -> 'network_acls' -> 'virtual_network_subnet_ids') as id
    )
    select
      a.address as resource,
      case
        when (attributes_std -> 'network_acls' ->> 'default_action')::text <> 'Deny' then 'alarm'
        when s.name is null then 'alarm'
        else 'ok'
      end as status,
      case
        when (attributes_std -> 'network_rule_set' ->> 'default_action')::text <> 'Deny' then ' not configured with virtual service endpoint'
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
        and (attributes_std ->> 'target_resource_id') like '%azurerm_key_vault_managed_hardware_security_module.%'
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
      split_part(a.address, '.', 2) || case
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
      address as resource,
      case
        when (attributes_std ->> 'purge_protection_enabled') is null then 'alarm'
        when (attributes_std ->> 'purge_protection_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'purge_protection_enabled') is null then ' ''purge_protection_enabled'' not set'
        when (attributes_std ->> 'purge_protection_enabled')::boolean then  ' purge protection enabled'
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
        and (attributes_std ->> 'target_resource_id') like '%azurerm_key_vault.%'
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
      split_part(a.address, '.', 2) || case
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
      address as resource,
      case
        when (attributes_std ->> 'purge_protection_enabled') is null then 'alarm'
        when (attributes_std ->> 'purge_protection_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'purge_protection_enabled') is null then ' ''purge_protection_enabled'' not set'
        when (attributes_std ->> 'purge_protection_enabled')::boolean then  ' purge protection enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'network_acls') is null then 'alarm'
        when (attributes_std -> 'network_acls' ->> 'default_action')::text != 'Deny' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'network_acls') is null then ' ''network_acls'' not set'
        when (attributes_std -> 'network_acls' ->> 'default_action')::text != 'Deny' then ' public network access enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'expiration_date') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'expiration_date') is null then ' expiration_date not set'
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
      address as resource,
      case
        when (attributes_std ->> 'resource_type') = 'KeyVaults' and (attributes_std ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'resource_type') = 'KeyVaults' and (attributes_std ->> 'tier') = 'Standard' then ' Azure Defender on for KeyVaults'
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
      address as resource,
      case
        when (attributes_std ->> 'expiration_date') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'expiration_date') is null then ' expiration_date not set'
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

query "keyvault_secret_content_type_set" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'content_type') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'content_type') is null then ' content type not set'
        else ' content type is set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_key_vault_secret';
  EOQ
}
