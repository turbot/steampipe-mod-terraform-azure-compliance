query "eventgrid_domain_uses_managed_identity" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'identity' ->> 'type') = 'SystemAssigned' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'identity' ->> 'type') = 'SystemAssigned' then ' uses managed identity'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'local_auth_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'local_auth_enabled') = 'false' then ' local authentication disabled'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'local_auth_enabled') = 'false' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'local_auth_enabled') = 'false' then ' local authentication disabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'identity' ->> 'type') = 'SystemAssigned' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'identity' ->> 'type') = 'SystemAssigned' then ' uses managed identity'
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

query "eventgrid_domain_public_network_access_disabled" {
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
      type = 'azurerm_eventgrid_domain';
  EOQ
}

query "eventgrid_topic_public_network_access_disabled" {
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
      type = 'azurerm_eventgrid_topic';
  EOQ
}
