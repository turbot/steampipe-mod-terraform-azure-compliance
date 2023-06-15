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
        distinct a.name
      from
        eventhub_namespaces as a,
        jsonb_array_elements(arguments -> 'network_rulesets') as rule
      where
        jsonb_typeof(arguments -> 'network_rulesets') ='array'
        and (rule -> 'virtual_network_rule' ->> 'subnet_id') is not null
    )
    select
      type || ' ' || a.name as resource,
      case
        when (arguments -> 'network_rulesets') is null then 'alarm'
        when (s.name is not null) or ((arguments -> 'network_rulesets' -> 'virtual_network_rule' -> 'subnet_id') is not null) then 'ok'
        else 'alarm'
      end as status,
      a.name || case
        when (arguments -> 'network_rulesets') is null then ' ''network_rule_set'' is not defined'
        when (s.name is not null) or ((arguments -> 'network_rulesets' -> 'virtual_network_rule' -> 'subnet_id') is not null) then ' configured with virtual network service endpoint'
        else ' not configured with virtual network service endpoint'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      eventhub_namespaces as a
      left join eventhub_namespaces_subnet as s on (a.name)::text = s.name;
  EOQ
}

query "eventhub_namespace_cmk_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'key_vault_key_ids') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'key_vault_key_ids') is not null then ' CMK encryption enabled'
        else ' CMK encryption disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventhub_namespace_customer_managed_key';
  EOQ
}

