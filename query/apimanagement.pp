query "apimanagement_service_with_virtual_network" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'virtual_network_type') is null then 'alarm'
        when (attributes_std ->> 'virtual_network_type')::text <> 'None' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'virtual_network_type') is null then ' ''virtual_network_type'' is not set'
        else ' virtual network is set to ' || (attributes_std ->> 'virtual_network_type')
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_api_management';
  EOQ
}

query "apimanagement_backend_uses_https" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'url') like 'https%' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'url') like 'https%' then ' backend uses HTTPS'
        else ' backend does not use HTTPS'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_api_management_backend';
  EOQ
}

query "apimanagement_service_client_certificate_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku_name') like 'Consumption%' and (attributes_std ->> 'client_certificate_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku_name') like 'Consumption%' and (attributes_std ->> 'client_certificate_enabled')::boolean then ' client certificate enabled'
        else ' client certificate disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_api_management';
  EOQ
}

query "apimanagement_service_uses_latest_tls_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'security' ->> 'enable_back_end_ssl30')::boolean then 'alarm'
        when (attributes_std -> 'security' ->> 'enable_backend_tls10')::boolean then 'alarm'
        when (attributes_std -> 'security' ->> 'enable_frontend_ssl30')::boolean then 'alarm'
        when (attributes_std -> 'security' ->> 'enable_frontend_tls10')::boolean then 'alarm'
        when (attributes_std -> 'security' ->> 'enable_frontend_tls11')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'security' ->> 'enable_back_end_ssl30')::boolean then ' TLS version is less than 1.2'
        when (attributes_std -> 'security' ->> 'enable_backend_tls10')::boolean then ' TLS version is less than 1.2'
        when (attributes_std -> 'security' ->> 'enable_frontend_ssl30')::boolean then ' TLS version is less than 1.2'
        when (attributes_std -> 'security' ->> 'enable_frontend_tls10')::boolean then ' TLS version is less than 1.2'
        when (attributes_std -> 'security' ->> 'enable_frontend_tls11')::boolean then ' TLS version is less than 1.2'
        else ' TLS version is set to at least 1.2 or higher'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_api_management';
  EOQ
}

query "apimanagement_service_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled')::boolean or (attributes_std ->> 'public_network_access_enabled') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled')::boolean or (attributes_std ->> 'public_network_access_enabled') is null then ' publicy accessible'
        else ' not publicy accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_api_management';
  EOQ
}
