query "healthcare_fhir_public_network_access_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'public_network_access_enabled') is null then 'alarm'
        when (arguments -> 'public_network_access_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'public_network_access_enabled') is null then ' public access enabled'
        when (arguments -> 'public_network_access_enabled')::bool then ' public access disabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'cosmosdb_key_vault_key_versionless_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'cosmosdb_key_vault_key_versionless_id') is null then ' not encrypted with CMK'
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

