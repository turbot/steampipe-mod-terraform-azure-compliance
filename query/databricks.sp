query "databricks_workspace_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_databricks_workspace';
  EOQ
}
