query "automation_account_variables_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'encrypted') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'encrypted') = 'true' then ' encryption enabled'
        else ' encryption disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_automation_variable_bool', 'azurerm_automation_variable_string', 'azurerm_automation_variable_int', 'azurerm_automation_variable_datetime');
  EOQ
}