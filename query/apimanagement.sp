query "apimanagement_service_with_virtual_network" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'virtual_network_type') is null then 'alarm'
        when (arguments ->> 'virtual_network_type')::text <> 'None' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'virtual_network_type') is null then ' ''virtual_network_type'' is not set'
        else ' virtual network is set to ' || (arguments ->> 'virtual_network_type')
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_api_management';
  EOQ
}

