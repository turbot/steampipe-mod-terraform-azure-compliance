query "container_instance_container_group_in_virtual_network" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'subnet_ids') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'subnet_ids') is null then ' in virtual network.'
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