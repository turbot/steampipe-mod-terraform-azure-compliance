query "app_configuration_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption' ->> 'key_vault_key_identifier') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'encryption' ->> 'key_vault_key_identifier') is null then ' encryption disabled'
        else ' encryption enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_configuration';
  EOQ
}

query "app_configuration_local_auth_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'local_auth_enabled') is null or (arguments ->> 'local_auth_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'local_auth_enabled') is null or (arguments ->> 'local_auth_enabled')::boolean then ' local authentication enabled'
        else ' local authentication disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_configuration';
  EOQ
}

query "app_configuration_restrict_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_access') = 'Enabled' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'public_network_access') = 'Enabled' then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_configuration';
  EOQ
}

query "app_configuration_purge_protection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'purge_protection_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'purge_protection_enabled')::boolean then ' purge protection enabled'
        else ' purge protection disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_configuration';
  EOQ
}

query "app_configuration_sku_standard" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'sku') = 'standard' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'sku') = 'standard' then ' use Standard SKU'
        else ' does not use Standard SKU'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_configuration';
  EOQ
}
