query "kubernetes_cluster_os_and_data_disks_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'disk_encryption_set_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'disk_encryption_set_id') is null then ' os and data diska not encrypted with CMK'
        else ' os and data diska encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_temp_disks_and_agent_node_pool_cache_encrypted_at_host" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'default_node_pool' ->> 'enable_host_encryption')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'default_node_pool' ->> 'enable_host_encryption')::boolean then ' encrypted at host'
        else ' not encrypted at host'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_authorized_ip_range_defined" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'api_server_authorized_ip_ranges') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'api_server_authorized_ip_ranges') is null then ' authorized IP ranges not defined'
        else ' authorized IP ranges not defined'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_add_on_azure_policy_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'addon_profile') is null then 'alarm'
        when (arguments -> 'addon_profile' -> 'azure_policy' ->>'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'addon_profile') is null then ' ''addon_profile'' not defined'
        when (arguments -> 'addon_profile' -> 'azure_policy' ->>'enabled')::boolean then ' add on azure policy enabled'
        else ' add on azure policy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_instance_rbac_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'role_based_access_control') is null then 'alarm'
        when (arguments -> 'role_based_access_control' -> 'azure_active_directory' -> 'azure_rbac_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'role_based_access_control') is null then ' ''role_based_access_control'' not defined'
        when (arguments -> 'role_based_access_control' -> 'azure_active_directory' -> 'azure_rbac_enabled')::boolean then ' role based access control enabled'
        else ' role based access control disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_azure_defender_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'KubernetesService' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'KubernetesService' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for KubernetesService'
        else ' Azure Defender off for KubernetesService'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

