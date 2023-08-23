query "machine_learning_workspace_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'encryption') is null then ' not encrypted with CMK'
        else ' encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_machine_learning_workspace';
  EOQ
}

query "machine_learning_compute_cluster_local_auth_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'local_auth_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'local_auth_enabled') = 'false'  then ' local authentication disabled'
        else ' local authentication enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_machine_learning_compute_cluster';
  EOQ
}

query "machine_learning_compute_cluster_minimum_node_zero" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'scale_settings' ->> 'min_node_count')::int = 0 then 'ok'
        else 'alarm'
      end status,
      name ||  ' minimum node count set to ' || (arguments -> 'scale_settings' ->> 'min_node_count') || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_machine_learning_compute_cluster';
  EOQ
}

query "machine_learning_workspace_restrict_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_access_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'public_network_access_enabled') = 'false' then ' public network access disabled'
        else ' public network access enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_machine_learning_workspace';
  EOQ
}
