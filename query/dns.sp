query "dns_azure_defender_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'Dns' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'Dns' and (arguments ->> 'tier') = 'Standard' then ' Dns azure defender enabled'
        else ' Dns azure defender disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}
