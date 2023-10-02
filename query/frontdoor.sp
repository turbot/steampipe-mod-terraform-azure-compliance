query "frontdoor_waf_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'routing_rule' -> 'frontend_endpoint') is null then 'alarm'
        when (attributes_std -> 'routing_rule' -> 'frontend_endpoint' -> 'web_application_firewall_policy_link_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'routing_rule' -> 'frontend_endpoint') is null then ' WAF disabled'
        when (attributes_std -> 'routing_rule' -> 'frontend_endpoint' -> 'web_application_firewall_policy_link_id') is null then ' WAF disabled'
        else ' WAF enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_frontdoor';
  EOQ
}

