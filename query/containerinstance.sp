query "container_instance_container_group_in_virtual_network" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'subnet_ids') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'subnet_ids') is null then ' in virtual network.'
        else ' not in virtual network.'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_container_group';
  EOQ
}
