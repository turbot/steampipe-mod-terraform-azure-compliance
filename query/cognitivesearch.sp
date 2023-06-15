query "search_service_public_network_access_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'sku')::text = 'free' then ' public network access enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'sku')::text = 'free' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'sku')::text = 'free' then ' SKU does not supports private link'
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