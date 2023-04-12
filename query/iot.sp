query "iot_hub_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'target_resource_id'), '.', 3) from terraform_resource where type = 'azurerm_monitor_diagnostic_setting' and split_part((arguments ->> 'target_resource_id'), '.', 2) = 'azurerm_iothub')then 'ok'
        else 'alarm'
      end status,
      name || case
        when name in (select split_part((arguments ->> 'target_resource_id'), '.', 3) from terraform_resource where type = 'azurerm_monitor_diagnostic_setting' and split_part((arguments ->> 'target_resource_id'), '.', 2) = 'azurerm_iothub')then ' logging enabled'
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

