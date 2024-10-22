query "cdn_endpoint_http_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'is_http_allowed') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'is_http_allowed') = 'false' then ' HTTP not allowed'
        else ' HTTP allowed'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cdn_endpoint';
  EOQ
}

query "cdn_endpoint_https_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'is_https_allowed') = 'false' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'is_https_allowed') = 'false' then ' HTTPS not allowed'
        else ' HTTPS allowed'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cdn_endpoint';
  EOQ
}

query "cdn_endpoint_custom_domain_uses_latest_tls_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'cdn_managed_https' ->> 'tls_version') in ('None', 'TLS10') then 'alarm'
        when (attributes_std -> 'user_managed_https' ->> 'tls_version') in ('None', 'TLS10') then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'cdn_managed_https' ->> 'tls_version') in ('None', 'TLS10') then ' not using the latest version of TLS encryption'
        when (attributes_std -> 'user_managed_https' ->> 'tls_version') in ('None', 'TLS10') then ' not using the latest version of TLS encryption'
        else ' using the latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cdn_endpoint_custom_domain';
  EOQ
}
