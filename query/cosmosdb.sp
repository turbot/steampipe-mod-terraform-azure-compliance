query "cosmosdb_use_virtual_service_endpoint" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'virtual_network_rule') is null then 'alarm'
        when (arguments -> 'virtual_network_rule' ->> 'id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'virtual_network_rule') is null then ' ''virtual_network_rule'' not defined'
        when (arguments -> 'virtual_network_rule' ->> 'id') is not null then ' configured with virtual network service endpointle'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_access_enabled')::boolean
          and (arguments ->>  'is_virtual_network_filter_enabled' )::boolean = 'false'
          and (arguments ->>  'ip_range_filter') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'public_network_access_enabled')::boolean
          and (arguments ->>  'is_virtual_network_filter_enabled' )::boolean = 'false'
          and (arguments ->>  'ip_range_filter') is null then  ' not have firewall rules'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'key_vault_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'key_vault_key_id') is not null then  ' encrypted at rest using CMK'
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

