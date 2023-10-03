query "web_pubsub_sku_with_sla" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku') = 'Free_F1' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku') = 'Free_F1' then ' using SKU tier without SLA'
        else ' using SKU tier with SLA'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_web_pubsub';
  EOQ
}

query "web_pubsub_uses_managed_identity" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'identity') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity') is null then ' identity is not defined'
        else ' uses ' || (attributes_std -> 'identity' ->> 'type') || ' identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_web_pubsub';
  EOQ
}
