query "web_pubsub_sku_with_sla" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'sku') = 'Free_F1' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'sku') = 'Free_F1' then ' using SKU tier without SLA'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'identity') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'identity') is null then ' identity is not defined'
        else ' uses ' || (arguments -> 'identity' ->> 'type') || ' identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_web_pubsub';
  EOQ
}
