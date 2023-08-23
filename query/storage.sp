query "storage_azure_defender_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'tier') = 'Standard' and (arguments ->> 'resource_type') = 'StorageAccounts' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'tier') = 'Standard' and (arguments ->> 'resource_type') = 'StorageAccounts' then ' Azure defender enabled for StorageAccount(s)'
        else ' Azure defender enabled for ' || (arguments ->> 'resource_type') || ''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "storage_account_block_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'allow_blob_public_access') is null then 'ok'
        when (arguments -> 'allow_blob_public_access')::bool then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'allow_blob_public_access') is null then ' does not allow public access to the blobs or containers'
        when (arguments -> 'allow_blob_public_access')::bool then ' allows public access to all the blobs or containers'
        else ' does not allow public access to the blobs or containers'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_queue_services_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'queue_properties') is null or (arguments -> 'queue_properties' -> 'logging') is null then 'alarm'
        when not (arguments -> 'queue_properties' -> 'logging' ->> 'Read')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Write')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Delete')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'queue_properties') is null or (arguments -> 'queue_properties' -> 'logging') is null then ' blob service logging not enabled'
        when not (arguments -> 'queue_properties' -> 'logging' ->> 'Read')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Write')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Delete')::boolean then ' blob service logging not enabled'
        else ' blob service logging enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_use_virtual_service_endpoint" {
  sql = <<-EOQ
    with storage_account_network_rules as (
      select
        name,
        type,
        path,
        start_line,
        split_part((arguments ->> 'storage_account_name'), '.',2) as storage_account_name
      from
        terraform_resource
      where
        type = 'azurerm_storage_account_network_rules'
        and (arguments ->> 'default_action') = 'Deny'
    ), storage_account_name as (
        select
          name,
          type,
          path,
          _ctx,
          start_line
        from
          terraform_resource
        where
          type = 'azurerm_storage_account'
    )
    select
      san.type || ' ' || san.name as resource,
      case
        when sanr.name is null then 'alarm'
        else 'ok'
      end status,
      san.name || case
        when sanr.name is null then ' does not use virtual service endpoint'
        else ' uses virtual service endpoint'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "san.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "san.")}
    from
      storage_account_name as san
      left join storage_account_network_rules as sanr on sanr.storage_account_name = san.name;
  EOQ
}

query "storage_account_encryption_at_rest_using_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'storage_account_id'), '.', 2) from terraform_resource where type = 'azurerm_storage_account_customer_managed_key') then 'ok'
        else 'alarm'
      end status,
      name || case
        when name in (select split_part((arguments ->> 'storage_account_id'), '.', 2) from terraform_resource where type = 'azurerm_storage_account_customer_managed_key') then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_infrastructure_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'infrastructure_encryption_enabled') is null then 'alarm'
        when (arguments -> 'infrastructure_encryption_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'infrastructure_encryption_enabled') is null then ' ''infrastructure_encryption_enabled'' parameter not defined'
        when (arguments -> 'infrastructure_encryption_enabled')::bool then ' infrastructure encryption enabled'
        else ' infrastructure encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_blob_containers_public_access_private" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'allow_blob_public_access') is null then 'ok'
        when (arguments -> 'allow_blob_public_access')::bool then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'allow_blob_public_access') is null then ' does not allow public access to the blobs'
        when (arguments -> 'allow_blob_public_access')::bool then ' allows public access to all the blobs'
        else ' does not allow public access to the blobs'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_default_network_access_rule_denied" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'network_rules') is null then 'alarm'
        when (arguments -> 'network_rules' ->> 'default_action') = 'Allow' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'network_rules') is null then ' has no network rules defined'
        when (arguments -> 'network_rules' ->> 'default_action') = 'Allow' then ' allows traffic from specific networks'
        else ' allows network access'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_trusted_microsoft_services_enabled" {
  sql = <<-EOQ
    with storage_account_network_rules as (
      select
        name,
        type,
        path,
        start_line,
        split_part((arguments ->> 'storage_account_name'), '.',2) as storage_account_name
      from
        terraform_resource
      where
        type = 'azurerm_storage_account_network_rules'
        and (arguments ->> 'bypass') like '%AzureServices%'
    ), storage_account_name as (
        select
          name,
          type,
          path,
          _ctx,
          start_line
        from
          terraform_resource
        where
          type = 'azurerm_storage_account'
    )
    select
      san.type || ' ' || san.name as resource,
      case
        when sanr.name is null then 'alarm'
        else 'ok'
      end status,
      san.name || case
        when sanr.name is null then ' trusted Microsoft services not enabled'
        else ' trusted Microsoft services enabled'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "san.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "san.")}
    from
      storage_account_name as san
      left join storage_account_network_rules as sanr on sanr.storage_account_name = san.name;
  EOQ
}

query "storage_account_blob_service_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'queue_properties') is null or (arguments -> 'queue_properties' -> 'logging') is null then 'alarm'
        when not (arguments -> 'queue_properties' -> 'logging' ->> 'Read')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Write')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Delete')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'queue_properties') is null or (arguments -> 'queue_properties' -> 'logging') is null then ' blob service logging not enabled'
        when not (arguments -> 'queue_properties' -> 'logging' ->> 'Read')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Write')::boolean or not (arguments -> 'queue_properties' -> 'logging' ->> 'Delete')::boolean then ' blob service logging not enabled'
        else ' blob service logging enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_uses_private_link" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'private_link_access') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'private_link_access') is null then ' does not use private link'
        else ' uses private link'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_encryption_scopes_encrypted_at_rest_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'storage_account_id'), '.', 2) from terraform_resource where type = 'azurerm_storage_encryption_scope' and (arguments ->> 'source') = 'Microsoft.KeyVault') then 'ok'
        else 'alarm'
      end status,
      name || case
        when name in (select split_part((arguments ->> 'storage_account_id'), '.', 2) from terraform_resource where type = 'azurerm_storage_encryption_scope' and (arguments ->> 'source') = 'Microsoft.KeyVault') then ' encrypted with CMK'
        else ' not encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_restrict_network_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'network_rules') is null then 'alarm'
        when (arguments -> 'network_rules' ->> 'default_action') = 'Deny' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'network_rules') is null then ' allows network access'
        when (arguments -> 'network_rules' ->> 'default_action') = 'Deny' then ' restricts network access'
        else ' allows network access'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_secure_transfer_required_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enable_https_traffic_only') is null then 'ok'
        when (arguments -> 'enable_https_traffic_only')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'enable_https_traffic_only') is null then ' encryption in transit enabled'
        when (arguments -> 'enable_https_traffic_only')::bool then ' encryption in transit enabled'
        else ' encryption in transit not enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_uses_azure_resource_manager" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'resource_group_name') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'resource_group_name') is null then ' does not use azure resource group manager'
        else ' uses azure resource group manager'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_uses_latest_minimum_tls_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'min_tls_version') in ('TLS1_2', 'TLS1_3') then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'min_tls_version') in ('TLS1_2', 'TLS1_3') then ' use latest version of TLS encryption'
        when (arguments ->> 'min_tls_version') is null then ' version of TLS encryption is not set'
        else ' does not uses latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_account';
  EOQ
}

query "storage_account_replication_type_set" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'account_replication_type') in ('GRS', 'RAGRS', 'GZRS', 'RAGZRS') then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'account_replication_type') in ('GRS', 'RAGRS', 'GZRS', 'RAGZRS') then ' replication type set'
        when (arguments ->> 'account_replication_type') is null then ' replication type not set'
        else ' replication type not set correctly'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
        type = 'azurerm_storage_account';
  EOQ
}

query "storage_container_restrict_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'container_access_type') = 'private' or (arguments ->> 'container_access_type') is null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'container_access_type') = 'private' or (arguments ->> 'container_access_type') is null then ' public access to container disabled'
        else ' public access to container not disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
        type = 'azurerm_storage_container';
  EOQ
}
