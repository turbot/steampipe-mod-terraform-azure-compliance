query "firewall_has_firewall_policy_set" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'firewall_policy_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'firewall_policy_id') is null then ' firewall policy is not set'
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

query "firewall_threat_intel_mode_set_to_deny" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'threat_intel_mode') = 'Deny' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'threat_intel_mode') = 'Deny' then ' threat intel mode is set to deny'
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

query "firewall_policy_intrusion_detection_mode_set_to_deny" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'intrusion_detection' ->> 'mode') = 'Deny' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'intrusion_detection' ->> 'mode') = 'Deny' then ' intrusion detection mode is set to deny'
        else ' intrusion detection mode is not set to deny'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_firewall_policy';
  EOQ
}
