query "servicefabric_cluster_protection_level_as_encrypt_and_sign" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'fabric_settings') is null then 'alarm'
        when (arguments -> 'fabric_settings' -> 'parameters') is null then 'alarm'
        when (arguments -> 'fabric_settings' ->> 'parameters') like '%EncryptAndSign%' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'fabric_settings') is null then ' Cluster Protection Level not set'
        when (arguments -> 'fabric_settings' -> 'parameters') is null then ' Cluster Protection Level not set to EncryptAndSign'
        when (arguments -> 'fabric_settings' ->> 'parameters') like '%EncryptAndSign%' then ' Cluster Protection Level set to EncryptAndSign'
        else ' Cluster Protection Level not set to EncryptAndSign'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_service_fabric_cluster';
  EOQ
}

query "servicefabric_cluster_active_directory_authentication_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'azure_active_directory') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'azure_active_directory') is null then ' does not use Azure Active Directory for client authentication'
        else ' uses Azure Active Directory for client authentication'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_service_fabric_cluster';
  EOQ
}

