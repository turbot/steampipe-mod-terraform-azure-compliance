query "synapse_workspace_encryption_at_rest_using_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'customer_managed_key') is null then 'alarm'
        when (attributes_std -> 'customer_managed_key' -> 'key_versionless_id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'customer_managed_key') is null then ' ''customer_managed_key'' not defined'
        when (attributes_std -> 'customer_managed_key' -> 'key_versionless_id') is not null then ' encrypted with CMK'
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
      a.address as resource,
      case
        when (s.attributes_std ->> 'synapse_workspace_id') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'synapse_workspace_id') is not null then ' uses private link'
        else ' not uses private link'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      synapse_workspaces as a
      left join synapse_workspace_private_link as s on a.sw_id = (s.attributes_std ->> 'synapse_workspace_id');
  EOQ
}

query "synapse_workspace_data_exfiltration_protection_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'data_exfiltration_protection_enabled') is null then 'alarm'
        when (attributes_std ->> 'data_exfiltration_protection_enabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'data_exfiltration_protection_enabled') is null then ' data exfiltration protection not defined'
        when (attributes_std ->> 'data_exfiltration_protection_enabled' ) = 'true' then ' data exfiltration protection enabled'
        else ' data exfiltration protection disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_synapse_workspace';
  EOQ
}

