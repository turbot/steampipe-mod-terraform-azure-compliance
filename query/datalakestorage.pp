query "datalake_store_account_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'encryption_state') = 'Enabled' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'encryption_state') = 'Enabled' then ' encryption at rest enabled'
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

