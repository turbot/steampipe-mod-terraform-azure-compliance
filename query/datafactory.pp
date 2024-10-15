query "data_factory_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'customer_managed_key_id') is null then 'alarm'
        when (attributes_std -> 'customer_managed_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'customer_managed_key_id') is null then ' ''customer_managed_key_id'' not defined'
        when (attributes_std ->> 'customer_managed_key_id' ) is not null then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_data_factory';
  EOQ
}

query "data_factory_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_enabled') = 'false' then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_data_factory';
  EOQ
}

query "data_factory_uses_git_repository" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'github_configuration') is not null) or ((attributes_std -> 'vsts_configuration') is not null) then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'github_configuration') is not null) or ((attributes_std -> 'vsts_configuration') is not null) then ' uses git repository'
        else ' not use git repository'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_data_factory';
  EOQ
}
