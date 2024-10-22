query "storage_sync_private_link_used" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'incoming_traffic_policy') is null then 'alarm'
        when (attributes_std ->> 'incoming_traffic_policy') = 'AllowAllTraffic' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'incoming_traffic_policy') is null then ' does not use private link'
        when (attributes_std ->> 'incoming_traffic_policy') = 'AllowAllTraffic' then ' uses public networks'
        else ' uses private link'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_sync';
  EOQ
}

