query "search_service_public_network_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku')::text = 'free' then ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_search_service';
  EOQ
}

query "search_service_uses_sku_supporting_private_link" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku')::text = 'free' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku')::text = 'free' then ' SKU does not supports private link'
        else ' SKU supports private link'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_search_service';
  EOQ
}

query "search_service_uses_managed_identity" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'identity' ->> 'type')::text = 'SystemAssigned' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity' ->> 'type')::text = 'SystemAssigned' then ' uses managed identity'
        else ' not uses managed identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_search_service';
  EOQ
}

query "search_service_replica_count_3" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'replica_count')::int > 3 then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'replica_count')::int > 3 then ' replica count is greater than 3'
        else ' replica count is greater than 3'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_search_service';
  EOQ
}

query "search_service_public_allowed_ip_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'allowed_ips') @> '["0.0.0.0/0"]' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'allowed_ips') @> '["0.0.0.0/0"]' then ' allowed IPS does not restrict public access'
        else ' allowed IPS restrict public access'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_search_service';
  EOQ
}
