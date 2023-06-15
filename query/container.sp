query "container_registry_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption' ) is null then 'alarm'
        when (arguments -> 'encryption' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encryption' ) is null then ' ''encryption'' not defined'
        when (arguments -> 'encryption' ->> 'enabled')::boolean then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_azure_defender_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'AppServices' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'ContainerRegistry' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for ContainerRegistry'
        else ' Azure Defender off for ContainerRegistry'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "container_registry_restrict_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'network_rule_set') is null then 'alarm'
        when (arguments -> 'network_rule_set' ->> 'default_action')::text = 'Deny' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'network_rule_set') is null then ' ''network_rule_set'' not defined'
        when (arguments -> 'network_rule_set' ->> 'default_action')::text = 'Deny' then ' publicly not accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_use_virtual_service_endpoint" {
  sql = <<-EOQ
    with container_registry as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_container_registry'
    ), container_registry_subnet as (
      select
        distinct a.name
      from
        container_registry as a,
        jsonb_array_elements(arguments -> 'network_rule_set' -> 'virtual_network') as rule
    )
    select
      type || ' ' || a.name as resource,
      case
        when (arguments -> 'network_rule_set' ->> 'default_action')::text <> 'Deny' then 'alarm'
        when s.name is null then 'alarm'
        else 'ok'
      end as status,
      case
        when (arguments -> 'network_rule_set' ->> 'default_action')::text <> 'Deny' then ' not configured with virtual service endpoint'
        when s.name is null then  ' not configured with virtual service endpoint'
        else ' configured with virtual service endpoint'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      container_registry as a
      left join container_registry_subnet as s on a.name = s.name;
  EOQ
}

