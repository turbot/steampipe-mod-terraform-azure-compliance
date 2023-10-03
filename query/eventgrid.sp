query "eventgrid_domain_uses_managed_identity" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'identity' ->> 'type') = 'SystemAssigned' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity' ->> 'type') = 'SystemAssigned' then ' uses managed identity'
        else ' not uses managed identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventgrid_domain';
  EOQ
}

query "eventgrid_domain_local_auth_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'local_auth_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'local_auth_enabled') = 'false' then ' local authentication disabled'
        else ' local authentication enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventgrid_domain';
  EOQ
}

query "eventgrid_topic_local_auth_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'local_auth_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'local_auth_enabled') = 'false' then ' local authentication disabled'
        else ' local authentication enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventgrid_topic';
  EOQ
}

query "eventgrid_topic_uses_managed_identity" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'identity' ->> 'type') = 'SystemAssigned' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity' ->> 'type') = 'SystemAssigned' then ' uses managed identity'
        else ' not uses managed identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventgrid_topic';
  EOQ
}

query "eventgrid_domain_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventgrid_domain';
  EOQ
}

query "eventgrid_topic_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'public_network_access_enabled') = 'false' then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_eventgrid_topic';
  EOQ
}
