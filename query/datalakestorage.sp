query "datalake_store_account_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'encryption_state') = 'Enabled' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'encryption_state') = 'Enabled' then ' encryption at rest enabled'
        else ' encryption at rest disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_data_lake_store';
  EOQ
}

