query "signalr_services_uses_paid_sku" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'sku' ->> 'name') = 'Free_F1' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'sku' ->> 'name') = 'Free_F1' then ' is not using paid SKU'
        else ' is using paid SKU'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_signalr_service';
  EOQ
}
