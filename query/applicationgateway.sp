query "application_gateway_uses_https_listener" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'http_listener' ->> 'protocol') = 'Https' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'http_listener' ->> 'protocol') = 'Https' then ' uses HTTPS listener'
        else ' does not use HTTPS listener'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_application_gateway';
  EOQ
}

query "application_gateway_waf_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'waf_configuration') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'waf_configuration') is not null then ' WAF enabled'
        else ' WAF disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_application_gateway';
  EOQ
}