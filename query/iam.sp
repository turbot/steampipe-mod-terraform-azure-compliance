query "iam_no_custom_subscription_owner_roles_created" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'permissions' -> 'actions') @> '["*"]' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'permissions' -> 'actions') @> '["*"]' then 'has custom owner roles'
        else ' does not have custom owner roles'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_role_definition';
  EOQ
}
