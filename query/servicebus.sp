query "service_bus_namespace_infrastructure_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'customer_managed_key' -> 'infrastructure_encryption_enabled')::bool is true then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'customer_managed_key' -> 'infrastructure_encryption_enabled')::bool is true then ' infrastructure encryption enabled'
        else ' infrastructure encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_servicebus_namespace';
  EOQ
}

query "service_bus_namespace_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'customer_managed_key' -> 'key_vault_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'customer_managed_key' -> 'key_vault_key_id') is not null then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_servicebus_namespace';
  EOQ
}

query "service_bus_namespace_uses_managed_identity" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'identity' ->> 'type') = 'SystemAssigned' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity' ->> 'type') = 'SystemAssigned' then ' uses managed identity'
        else ' not use managed identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_servicebus_namespace';
  EOQ
}

query "service_bus_namespace_local_auth_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'local_auth_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'local_auth_enabled') = 'false' then ' local authentication disabled'
        else ' local authentication enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_servicebus_namespace';
  EOQ
}

query "service_bus_namespace_latest_tls_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'minimum_tls_version')::float < 1.2 then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'minimum_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
        else ' using the latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_servicebus_namespace';
  EOQ
}

query "service_bus_namespace_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_servicebus_namespace';
  EOQ
}
