query "apimanagement_service_with_virtual_network" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'virtual_network_type') is null then 'alarm'
        when (arguments ->> 'virtual_network_type')::text <> 'None' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'virtual_network_type') is null then ' ''virtual_network_type'' is not set'
        else ' virtual network is set to ' || (arguments ->> 'virtual_network_type')
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'url') like 'https%' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'url') like 'https%' then ' backend uses https'
        else ' backend does not use https'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'sku_name') like 'Consumption%' and (arguments ->> 'client_certificate_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'sku_name') like 'Consumption%' and (arguments ->> 'client_certificate_enabled')::boolean then ' client certificate is enabled'
        else ' client certificate is disabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'security' ->> 'enable_back_end_ssl30')::boolean then 'alarm'
        when (arguments -> 'security' ->> 'enable_backend_tls10')::boolean then 'alarm'
        when (arguments -> 'security' ->> 'enable_frontend_ssl30')::boolean then 'alarm'
        when (arguments -> 'security' ->> 'enable_frontend_tls10')::boolean then 'alarm'
        when (arguments -> 'security' ->> 'enable_frontend_tls11')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'security' ->> 'enable_back_end_ssl30')::boolean then ' TLS version is less than 1.2'
        when (arguments -> 'security' ->> 'enable_backend_tls10')::boolean then ' TLS version is less than 1.2'
        when (arguments -> 'security' ->> 'enable_frontend_ssl30')::boolean then ' TLS version is less than 1.2'
        when (arguments -> 'security' ->> 'enable_frontend_tls10')::boolean then ' TLS version is less than 1.2'
        when (arguments -> 'security' ->> 'enable_frontend_tls11')::boolean then ' TLS version is less than 1.2'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_access_enabled')::boolean or (arguments ->> 'public_network_access_enabled') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'public_network_access_enabled')::boolean or (arguments ->> 'public_network_access_enabled') is null then ' public access is enabled'
        else ' public access is disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_api_management';
  EOQ
}