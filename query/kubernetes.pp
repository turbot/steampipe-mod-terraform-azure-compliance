query "kubernetes_cluster_os_and_data_disks_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'disk_encryption_set_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'disk_encryption_set_id') is null then ' os and data diska not encrypted with CMK'
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
      address as resource,
      case
        when (attributes_std -> 'default_node_pool' ->> 'enable_host_encryption')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'default_node_pool' ->> 'enable_host_encryption')::boolean then ' encrypted at host'
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
      address as resource,
      case
        when (attributes_std ->> 'private_cluster_enabled') = 'true' then 'ok'
        when (jsonb_array_length(attributes_std -> 'api_server_authorized_ip_ranges') > 0) or (jsonb_array_length(attributes_std -> 'api_server_access_profile' -> 'authorized_ip_ranges') > 0) then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'private_cluster_enabled') = 'true' then ' is private cluster'
        when (jsonb_array_length(attributes_std -> 'api_server_authorized_ip_ranges') > 0) or (jsonb_array_length(attributes_std -> 'api_server_access_profile' -> 'authorized_ip_ranges') > 0 ) then ' authorized IP ranges defined'
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
      address as resource,
      case
        when (attributes_std -> 'addon_profile') is null then 'alarm'
        when (attributes_std -> 'addon_profile' -> 'azure_policy' ->>'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'addon_profile') is null then ' ''addon_profile'' not defined'
        when (attributes_std -> 'addon_profile' -> 'azure_policy' ->>'enabled')::boolean then ' add on azure policy enabled'
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
      address as resource,
      case
        when (attributes_std -> 'role_based_access_control') is null then 'alarm'
        when (attributes_std -> 'role_based_access_control' -> 'azure_active_directory' -> 'azure_rbac_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'role_based_access_control') is null then ' ''role_based_access_control'' not defined'
        when (attributes_std -> 'role_based_access_control' -> 'azure_active_directory' -> 'azure_rbac_enabled')::boolean then ' role based access control enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'resource_type') = 'KubernetesService' and (attributes_std ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'resource_type') = 'KubernetesService' and (attributes_std ->> 'tier') = 'Standard' then ' Azure Defender on for KubernetesService'
        else ' Azure Defender off for KubernetesService'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "kubernetes_cluster_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'private_cluster_enabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'private_cluster_enabled') = 'true' then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_sku_standard" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'sku_tier') = 'Standard' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'sku_tier') = 'Standard' then ' uses standard SKU tier'
        else ' uses free SKU tier'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_local_admin_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'local_account_disabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'local_account_disabled') = 'true' then ' local account disabled'
        else ' local account enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_max_pod_50" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (type = 'azurerm_kubernetes_cluster' and (attributes_std -> 'default_node_pool' -> 'max_pods') is null)
          or (type = 'azurerm_kubernetes_cluster_node_pool' and (attributes_std -> 'max_pods') is null ) then 'alarm'
        when type = 'azurerm_kubernetes_cluster_node_pool' and (attributes_std ->> 'max_pods')::int >= 50 then 'ok'
        when type = 'azurerm_kubernetes_cluster' and (attributes_std -> 'default_node_pool' ->> 'max_pods')::int >= 50 then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when
          (type = 'azurerm_kubernetes_cluster' and (attributes_std -> 'default_node_pool' -> 'max_pods') is null)
          or (type = 'azurerm_kubernetes_cluster_node_pool' and (attributes_std -> 'max_pods') is null ) then ' max pods not defined'
        when type = 'azurerm_kubernetes_cluster_node_pool' then ' has ' || (attributes_std ->> 'max_pods') || ' pods'
        when type = 'azurerm_kubernetes_cluster' then ' has ' || (attributes_std -> 'default_node_pool' ->> 'max_pods') || ' pods'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type  in ('azurerm_kubernetes_cluster', 'azurerm_kubernetes_cluster_node_pool');
  EOQ
}

query "kubernetes_cluster_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'oms_agent' -> 'log_analytics_workspace_id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'oms_agent' -> 'log_analytics_workspace_id') is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_network_policy_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'network_profile' -> 'network_policy') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'network_profile' -> 'network_policy') is not null then ' network policy enabled'
        else ' network policy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_node_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'default_node_pool' ->> 'enable_node_public_ip') = 'true' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'default_node_pool' ->> 'enable_node_public_ip') = 'true' then ' has public node'
        else ' has no public node'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_key_vault_secret_rotation_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'key_vault_secrets_provider' ->> 'secret_rotation_enabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'key_vault_secrets_provider' ->> 'secret_rotation_enabled') = 'true' then ' key vault secret rotation enabled'
        else ' key vault secret rotation disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_upgrade_channel" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'automatic_channel_upgrade') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'automatic_channel_upgrade') is null then ' upgrade channel not configured'
        else ' upgrade channel configured'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_node_pool_type_scale_set" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'default_node_pool' ->> 'type') = 'AvailabilitySet' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'default_node_pool' ->> 'type') = 'AvailabilitySet' then ' is using AvailabilitySet node type'
        else ' is using VirtualMachineScaleSets node type'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_os_disk_ephemeral" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'default_node_pool' ->> 'os_disk_type') = 'Ephemeral' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'default_node_pool' ->> 'os_disk_type') = 'Ephemeral' then ' use ephemeral OS disks'
        else  ' does not use ephemeral OS disks'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}

query "kubernetes_cluster_critical_pods_on_system_nodes" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'default_node_pool' ->> 'only_critical_addons_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'default_node_pool' ->> 'only_critical_addons_enabled')::bool then ' critical addons enabled'
        else  ' critical addons disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_kubernetes_cluster';
  EOQ
}
