query "firewal_has_firewall_policy_set" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'firewall_policy_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'firewall_policy_id') is null then ' firewall policy is not set'
        else ' firewall policy is set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_firewall';
  EOQ 
}

query "firewal_threat_intel_mode_set_to_deny" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'threat_intel_mode') = 'Deny' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'threat_intel_mode') = 'Deny' then ' threat intel mode is set to deny'
        else ' threat intel mode is not set to deny'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_firewall';
  EOQ 
}