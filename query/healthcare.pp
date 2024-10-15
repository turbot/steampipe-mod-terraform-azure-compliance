query "healthcare_fhir_public_network_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'public_network_access_enabled') is null then 'alarm'
        when (attributes_std -> 'public_network_access_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'public_network_access_enabled') is null then ' public access enabled'
        when (attributes_std -> 'public_network_access_enabled')::bool then ' public access disabled'
        else ' public access enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_healthcare_service';
  EOQ
}

query "healthcare_fhir_azure_api_encrypted_at_rest_with_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'cosmosdb_key_vault_key_versionless_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'cosmosdb_key_vault_key_versionless_id') is null then ' not encrypted with CMK'
        else ' encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_healthcare_service';
  EOQ
}

