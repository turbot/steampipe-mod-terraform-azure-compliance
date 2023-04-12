query "data_factory_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'customer_managed_key_id') is null then 'alarm'
        when (arguments -> 'customer_managed_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'customer_managed_key_id') is null then ' ''customer_managed_key_id'' not defined'
        when (arguments ->> 'customer_managed_key_id' ) is not null then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_data_factory';
  EOQ
}

