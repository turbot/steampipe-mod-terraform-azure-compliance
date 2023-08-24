query "iam_no_custom_subscription_owner_roles_created" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'permissions' -> 'actions') @> '["*"]' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'permissions' -> 'actions') @> '["*"]' then 'has custom owner roles'
        else ' does not have custom owner roles'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_role_definition';
  EOQ 
}