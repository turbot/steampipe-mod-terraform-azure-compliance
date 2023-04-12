query "storage_sync_private_link_used" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'incoming_traffic_policy') is null then 'alarm'
        when (arguments ->> 'incoming_traffic_policy') = 'AllowAllTraffic' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'incoming_traffic_policy') is null then ' does not use private link'
        when (arguments ->> 'incoming_traffic_policy') = 'AllowAllTraffic' then ' uses public networks'
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

