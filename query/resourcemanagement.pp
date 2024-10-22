query "resource_manager_azure_defender_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'resource_type') = 'Arm' and (attributes_std ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'resource_type') = 'Arm' and (attributes_std ->> 'tier') = 'Standard' then ' Arm azure defender enabled'
        else 'Arm azure defender disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

