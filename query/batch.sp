query "batch_account_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'key_vault_reference') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'key_vault_reference') is not null  then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_batch_account';
  EOQ
}

query "batch_account_logging_enabled" {
  sql = <<-EOQ
    with batch_accounts as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_batch_account'
    ), diagnostic_setting as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_monitor_diagnostic_setting' and (attributes_std ->> 'target_resource_id') like '%azurerm_batch_account.%'
    ), batch_account_logging as (
      select
        ba.name as ba_name
      from
        batch_accounts as ba
        left join diagnostic_setting as ds on ba.name = (split_part((ds.attributes_std ->> 'target_resource_id'), '.', 2))
      where
        (ds.attributes_std ->> 'storage_account_id') is not null
        and (ds.attributes_std -> 'log' ->> 'enabled')::boolean
        and (ds.attributes_std -> 'log' -> 'retention_policy' ->> 'enabled')::boolean
    )
    select
      type || ' ' || a.name as resource,
      case
        when s.ba_name is null then 'alarm'
        else 'ok'
      end as status,
      split_part(a.address, '.', 2) || case
        when s.ba_name is null then ' logging disabled'
        else ' logging enabled'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      batch_accounts as a
      left join batch_account_logging as s on a.name = s.ba_name;
  EOQ
}

