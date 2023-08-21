query "data_factory_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'customer_managed_key_id') is null then 'alarm'
        when (arguments -> 'customer_managed_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'customer_managed_key_id') is null then ' ''customer_managed_key_id'' not defined'
        when (arguments ->> 'customer_managed_key_id' ) is not null then ' encrypted with CMK'
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

query "data_factory_public_network_access_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'public_network_enabled') = 'false' then ' public network access disabled'
        else ' public network access enabled'
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
      type || ' ' || name as resource,
      case
        when ((arguments -> 'github_configuration') is not null)
          or ((arguments -> 'vsts_configuration') is not null) then 'ok'
        else 'alarm'
      end status,
      name || case
        when ((arguments -> 'github_configuration') is not null)
          or ((arguments -> 'vsts_configuration') is not null)  then ' uses git repository'
        else ' not uses git repository'
      end || '.' reason
      --${local.tag_dimensions_sql}
      --${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_data_factory';
  EOQ
}
