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

query "container_instance_container_group_secure_environment_variable" {
  sql = <<-EOQ
    with container_group_no_secure_environment as (
      select
        distinct name
      from
        terraform_resource,
        jsonb_array_elements(attributes_std -> 'container') as c
      where
        type = 'azurerm_container_group'
        and c -> 'environment_variables' is not null
    )
    select
      address as resource,
      case
        when e.name is not null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when e.name is not null then ' uses environment variables.'
        else ' does not use environment variables.'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join container_group_no_secure_environment as e on e.name = r.name
    where
      type = 'azurerm_container_group';
  EOQ
}
