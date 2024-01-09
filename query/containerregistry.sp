query "container_registry_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encryption' ) is null then 'alarm'
        when (attributes_std -> 'encryption' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption' ) is null then ' ''encryption'' not defined'
        when (attributes_std -> 'encryption' ->> 'enabled')::boolean then ' encrypted with CMK'
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
      address as resource,
      case
        when (attributes_std ->> 'resource_type') = 'AppServices' and (attributes_std ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'resource_type') = 'ContainerRegistry' and (attributes_std ->> 'tier') = 'Standard' then ' Azure Defender on for Container Registry'
        else ' Azure Defender off for Container Registry'
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
      address as resource,
      case
        when (attributes_std -> 'network_rule_set') is null then 'alarm'
        when (attributes_std -> 'network_rule_set' ->> 'default_action')::text = 'Deny' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'network_rule_set') is null then ' ''network_rule_set'' not defined'
        when (attributes_std -> 'network_rule_set' ->> 'default_action')::text = 'Deny' then ' not publicly accessible'
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
        distinct address
      from
        container_registry as a,
        jsonb_array_elements(attributes_std -> 'network_rule_set' -> 'virtual_network') as rule
    )
    select
      a.address as resource,
      case
        when (attributes_std -> 'network_rule_set' ->> 'default_action')::text <> 'Deny' then 'alarm'
        when s.address is null then 'alarm'
        else 'ok'
      end as status,
      case
        when (attributes_std -> 'network_rule_set' ->> 'default_action')::text <> 'Deny' then ' not configured with virtual service endpoint'
        when s.address is null then  ' not configured with virtual service endpoint'
        else ' configured with virtual service endpoint'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      container_registry as a
      left join container_registry_subnet as s on a.address = s.address;
  EOQ
}

query "container_registry_admin_user_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'admin_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'admin_enabled')::boolean then ' admin user enabled'
        else ' admin user disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_anonymous_pull_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku') in ('Standard', 'Premium') and (attributes_std ->> 'anonymous_pull_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku') in ('Standard', 'Premium') and (attributes_std ->> 'anonymous_pull_enabled')::boolean then ' anonymous pull enabled'
        else ' anonymous pull disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_image_scan_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku') in ('Standard', 'Premium') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku') in ('Standard', 'Premium') then ' image scan enabled'
        else ' image scan disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_quarantine_policy_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku') = 'Premium' and (attributes_std ->> 'quarantine_policy_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku') = 'Premium' and (attributes_std ->> 'quarantine_policy_enabled')::bool then ' quarantine policy enabled'
        else ' quarantine policy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_retention_policy_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku') = 'Premium' and (attributes_std -> 'retention_policy' ->> 'enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku') = 'Premium' and (attributes_std -> 'retention_policy' ->> 'enabled')::bool then ' retention policy enabled'
        else ' retention policy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_geo_replication_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku') = 'Premium' and (attributes_std ->> 'georeplications') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku') = 'Premium' and (attributes_std ->> 'georeplications') is not null then ' geo-replication enabled'
        else ' geo-replication disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_public_network_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled')::bool or (attributes_std ->> 'public_network_access_enabled') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled')::bool or (attributes_std ->> 'public_network_access_enabled') is null  then ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_trust_policy_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'trust_policy' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'trust_policy' ->> 'enabled')::boolean then ' trust policy enabled'
        else ' trust policy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_registry';
  EOQ
}

query "container_registry_zone_redundant_enabled" {
  sql = <<-EOQ
    with geo_replication_zone_redundant as (
      select
        distinct name
      from
        terraform_resource
      where
        type = 'azurerm_container_registry'
        and
          (not (attributes_std -> 'georeplications' -> 'zone_redundancy_enabled')::bool
          or attributes_std -> 'georeplications' -> 'zone_redundancy_enabled' is null)
    )
    select
      address as resource,
      case
        when (r.attributes_std -> 'georeplications') is null then 'alarm'
        when not (attributes_std -> 'zone_redundancy_enabled')::boolean then 'alarm'
        when g.name is not null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (r.attributes_std -> 'georeplications') is null then ' geo replication not defined'
        when not (attributes_std -> 'zone_redundancy_enabled')::boolean then ' not zone redundant'
        when g.name is not null then ' not zone redundant'
        else ' zone redundant'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join geo_replication_zone_redundant as g on g.name = r.name
    where
      type = 'azurerm_container_registry';
  EOQ
}
