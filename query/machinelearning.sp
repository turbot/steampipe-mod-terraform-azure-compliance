query "machine_learning_workspace_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'encryption') is null then ' not encrypted with CMK'
        else ' encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_machine_learning_workspace';
  EOQ
}

