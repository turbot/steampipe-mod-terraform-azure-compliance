query "cognitive_account_public_network_access_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'public_network_access_enabled')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'public_network_access_enabled')::boolean then ' public network access enabled'
        else ' public network access disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cognitive_account';
  EOQ
}

query "cognitive_account_encrypted_with_cmk" {
  sql = <<-EOQ
    with all_cognitive_account as (
      select
      *
      from
        terraform_resource
      where
        type = 'azurerm_cognitive_account'
    ), cognitive_account_cmk as (
        select
          *
        from
          terraform_resource
        where
          type = 'azurerm_cognitive_account_customer_managed_key'
    )
    select
      c.type || ' ' || c.name as resource,
      case
        when (b.arguments ->> 'cognitive_account_id') is not null then 'ok'
        else 'alarm'
      end as status,
      c.name || case
        when (b.arguments ->> 'cognitive_account_id') is not null then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "c.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "c.")}
    from
      all_cognitive_account as c
      left join cognitive_account_cmk as b on c.name = (split_part((b.arguments ->> 'cognitive_account_id'), '.', 2))
  EOQ
}

query "cognitive_service_local_auth_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'local_auth_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'local_auth_enabled')::boolean then ' account local authentication enabled'
        else ' account local authentication disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cognitive_account';
  EOQ
}

query "cognitive_account_restrict_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'network_acls') is null then 'alarm'
        when (arguments -> 'network_acls' ->> 'default_action') <> 'Deny' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'network_acls') is null then ' ''network_acls'' not defin'
        when (arguments -> 'network_acls' ->> 'default_action') <> 'Deny' then ' publicly accessible.'
        else ' publicly not accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_cognitive_account';
  EOQ
}
