query "logic_app_workflow_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'target_resource_id'), '.', 3) from terraform_resource where type = 'azurerm_monitor_diagnostic_setting' and split_part((arguments ->> 'target_resource_id'), '.', 2) = 'azurerm_logic_app_workflow')then 'ok'
        else 'alarm'
      end status,
      name || case
        when name in (select split_part((arguments ->> 'target_resource_id'), '.', 3) from terraform_resource where type = 'azurerm_monitor_diagnostic_setting' and split_part((arguments ->> 'target_resource_id'), '.', 2) = 'azurerm_logic_app_workflow')then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_logic_app_workflow';
  EOQ
}

