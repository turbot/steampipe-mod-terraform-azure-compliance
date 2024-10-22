query "dns_azure_defender_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'resource_type') = 'Dns' and (attributes_std ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'resource_type') = 'Dns' and (attributes_std ->> 'tier') = 'Standard' then ' Dns azure defender enabled'
        else ' Dns azure defender disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

