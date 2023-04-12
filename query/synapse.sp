query "synapse_workspace_encryption_at_rest_using_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'customer_managed_key') is null then 'alarm'
        when (arguments -> 'customer_managed_key' -> 'key_versionless_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'customer_managed_key') is null then ' ''customer_managed_key'' not defined'
        when (arguments -> 'customer_managed_key' -> 'key_versionless_id') is not null then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_synapse_workspace';
  EOQ
}

query "synapse_workspace_private_link_used" {
  sql = <<-EOQ
    with synapse_workspaces as (
      select
        '$${azurerm_synapse_workspace.' || name || '.id}' as sw_id,
        *
      from
        terraform_resource
      where
        type = 'azurerm_synapse_workspace'
    ), synapse_workspace_private_link as (
        select
          *
        from
          terraform_resource
        where
          type = 'azurerm_synapse_managed_private_endpoint'
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when (s.arguments ->> 'synapse_workspace_id') is not null then 'ok'
        else 'alarm'
      end as status,
      a.name || case
        when (s.arguments ->> 'synapse_workspace_id') is not null then ' uses private link'
        else ' not uses private link'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      synapse_workspaces as a
      left join synapse_workspace_private_link as s on a.sw_id = ( s.arguments ->> 'synapse_workspace_id');
  EOQ
}

