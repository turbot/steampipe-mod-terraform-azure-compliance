query "iot_hub_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when name in (select split_part((attributes_std ->> 'target_resource_id'), '.', 3) from terraform_resource where type = 'azurerm_monitor_diagnostic_setting' and split_part((attributes_std ->> 'target_resource_id'), '.', 2) = 'azurerm_iothub')then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when name in (select split_part((attributes_std ->> 'target_resource_id'), '.', 3) from terraform_resource where type = 'azurerm_monitor_diagnostic_setting' and split_part((attributes_std ->> 'target_resource_id'), '.', 2) = 'azurerm_iothub')then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_iothub';
  EOQ
}

query "iot_hub_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'public_network_access_enabled') is null then 'alarm'
        when (attributes_std ->> 'public_network_access_enabled') = 'true' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'public_network_access_enabled') is null then ' public network access not defined'
        when (attributes_std ->> 'public_network_access_enabled') = 'true' then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_iothub';
  EOQ
}
