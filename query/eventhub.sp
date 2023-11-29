query "eventhub_namespace_use_virtual_service_endpoint" {
  sql = <<-EOQ
    with eventhub_namespaces as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_eventhub_namespace'
    ), eventhub_namespaces_subnet as (
      select
        distinct address
      from
        eventhub_namespaces as a,
        jsonb_array_elements(attributes_std -> 'network_rulesets') as rule
      where
        jsonb_typeof(attributes_std -> 'network_rulesets') ='array'
        and (rule -> 'virtual_network_rule' ->> 'subnet_id') is not null
    )
    select
      a.address as resource,
      case
        when (attributes_std -> 'network_rulesets') is null then 'alarm'
        when (s.address is not null) or ((attributes_std -> 'network_rulesets' -> 'virtual_network_rule' -> 'subnet_id') is not null) then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (attributes_std -> 'network_rulesets') is null then ' ''network_rule_set'' is not defined'
        when (s.address is not null) or ((attributes_std -> 'network_rulesets' -> 'virtual_network_rule' -> 'subnet_id') is not null) then ' configured with virtual network service endpoint'
        else ' not configured with virtual network service endpoint'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      eventhub_namespaces as a
      left join eventhub_namespaces_subnet as s on a.address = s.address;
  EOQ
}

query "eventhub_namespace_cmk_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'key_vault_key_ids') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'key_vault_key_ids') is not null then ' CMK encryption enabled'
        else ' CMK encryption disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventhub_namespace_customer_managed_key';
  EOQ
}

query "eventhub_namespace_uses_latest_tls_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'minimum_tls_version') is null then 'ok'
        when (attributes_std ->> 'minimum_tls_version')::text = '1.2' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'minimum_tls_version') is null then ' TLS version not defined by default uses 1.2'
        when (attributes_std ->> 'minimum_tls_version')::text = '1.2' then ' use TLS version 1.2'
        else ' does not use TLS version 1.2'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventhub_namespace';
  EOQ
}

query "eventhub_namespace_zone_redundant" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'zone_redundant')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'zone_redundant')::bool then ' zone redundant'
        else ' not zone redundant'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventhub_namespace';
  EOQ
}

