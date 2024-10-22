query "cosmosdb_use_virtual_service_endpoint" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'virtual_network_rule') is null then 'alarm'
        when (attributes_std -> 'virtual_network_rule' ->> 'id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'virtual_network_rule') is null then ' ''virtual_network_rule'' not defined'
        when (attributes_std -> 'virtual_network_rule' ->> 'id') is not null then ' configured with virtual network service endpointle'
        else ' not configured with virtual network service endpoint'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cosmosdb_account';
  EOQ
}

query "cosmosdb_account_with_firewall_rules" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled')::boolean
          and (attributes_std ->>  'is_virtual_network_filter_enabled' )::boolean = 'false'
          and (attributes_std ->>  'ip_range_filter') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled')::boolean
          and (attributes_std ->>  'is_virtual_network_filter_enabled' )::boolean = 'false'
          and (attributes_std ->>  'ip_range_filter') is null then  ' not have firewall rules'
        else ' have firewall rules'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cosmosdb_account';
  EOQ
}

query "cosmosdb_account_encryption_at_rest_using_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'key_vault_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'key_vault_key_id') is not null then  ' encrypted at rest using CMK'
        else ' not encrypted at rest using CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cosmosdb_account';
  EOQ
}

query "cosmodb_account_access_key_metadata_writes_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'access_key_metadata_writes_enabled') is null then 'alarm'
        when (attributes_std ->> 'access_key_metadata_writes_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'access_key_metadata_writes_enabled') is null then ' access key metadata writes enabled'
        when (attributes_std ->> 'access_key_metadata_writes_enabled')::boolean then  ' access key metadata writes enabled'
        else ' access key metadata writes disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cosmosdb_account';
  EOQ
}

query "cosmodb_account_public_network_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled') is null then 'alarm'
        when (attributes_std ->> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled') is null then ' public network access enabled'
        when (attributes_std ->> 'public_network_access_enabled')::boolean then  ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cosmosdb_account';
  EOQ
}

query "cosmodb_account_local_authentication_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kind') is not null and (attributes_std ->> 'kind') <> 'GlobalDocumentDB' then 'skip'
        when (attributes_std ->> 'local_authentication_disabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kind') is not null and (attributes_std ->> 'kind') <> 'GlobalDocumentDB' then ' not GlobalDocumentDB'
        when (attributes_std ->> 'local_authentication_disabled')::boolean then  ' local authentication disabled'
        else ' local authentication enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cosmosdb_account';
  EOQ
}

query "cosmodb_account_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then 'ok'
        when (attributes_std ->> 'public_network_access_enabled')::boolean and (attributes_std ->> 'is_virtual_network_filter_enabled')::boolean and ((attributes_std ->> 'virtual_network_rule') is not null or (attributes_std ->> 'ip_range_filter') is not null) then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then 'ok'
        when (attributes_std ->> 'public_network_access_enabled')::boolean and (attributes_std ->> 'is_virtual_network_filter_enabled')::boolean and ((attributes_std ->> 'virtual_network_rule') is not null or (attributes_std ->> 'ip_range_filter') is not null) then  ' with restricted access'
        else ' without restricted access'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cosmosdb_account';
  EOQ
}
