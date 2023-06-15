query "spring_cloud_service_network_injection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'network') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'network') is null then ' network injection disabled'
        else ' network injection enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_spring_cloud_service';
  EOQ
}

