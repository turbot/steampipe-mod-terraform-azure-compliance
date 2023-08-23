query "signalr_services_uses_paid_sku" {
    sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'sku' ->> 'name') = 'Free_F1' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'sku' ->> 'name') = 'Free_F1' then ' is not using paid SKU'
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