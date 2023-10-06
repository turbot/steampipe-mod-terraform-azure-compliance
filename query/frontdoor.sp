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

query "frontdoor_firewall_policy_restrict_message_lookup_log4j2" {
  sql = <<-EOQ
    with managed_rule as (
      select
        name
      from
        terraform_resource,
        jsonb_array_elements (
          case jsonb_typeof(attributes_std -> 'managed_rule')
            when 'array' then (attributes_std -> 'managed_rule')
            when 'object' then jsonb_build_array(attributes_std -> 'managed_rule')
            else null end
          ) r,
        jsonb_array_elements(
            case jsonb_typeof(r -> 'override')
            when 'array' then (r -> 'override')
            when 'object' then jsonb_build_array(r -> 'override')
            else null end
          ) as o
      where
        type = 'azurerm_frontdoor_firewall_policy'
        and r ->> 'type' in ('DefaultRuleSet', 'Microsoft_DefaultRuleSet')
        and o ->> 'rule_group_name' = 'JAVA'
        and o -> 'rule' ->> 'rule_id' = '944240'
        and (
          o -> 'rule' ->> 'enabled' <> 'true'
          or  o -> 'rule' -> 'enabled' is null
          or not ( (o -> 'rule' ->> 'action') in ('Block', 'Redirect'))
        )
    )
    select
      address as resource,
      case
        when (attributes_std -> 'managed_rule') is null then 'alarm'
        when m.name is not null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'managed_rule') is null then ' managed rule not defined'
        when m.name is not null then ' does not restrict message lookup in Log4j2'
        else ' restrict message lookup in Log4j2'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join managed_rule as m on r.name = m.name
    where
      type = 'azurerm_frontdoor_firewall_policy';
  EOQ
}

