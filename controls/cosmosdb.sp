locals {
  cosmosdb_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/CosmosDB"
  })
}

benchmark "cosmosdb" {
  title       = "Cosmos DB"
  description = "This benchmark provides a set of controls that detect Terraform Azure Cosmos DB resources deviating from security best practices."

  children = [
    control.cosmosdb_account_encryption_at_rest_using_cmk,
    control.cosmosdb_account_with_firewall_rules,
    control.cosmosdb_use_virtual_service_endpoint
  ]

  tags = merge(local.cosmosdb_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cosmosdb_use_virtual_service_endpoint" {
  title       = "Cosmos DB should use a virtual network service endpoint"
  description = "This policy audits any Cosmos DB not configured to use a virtual network service endpoint."
  query       = query.cosmosdb_use_virtual_service_endpoint

  tags = merge(local.cosmosdb_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "cosmosdb_account_with_firewall_rules" {
  title       = "Azure Cosmos DB accounts should have firewall rules"
  description = "Firewall rules should be defined on your Azure Cosmos DB accounts to prevent traffic from unauthorized sources. Accounts that have at least one IP rule defined with the virtual network filter enabled are deemed compliant. Accounts disabling public access are also deemed compliant."
  query       = query.cosmosdb_account_with_firewall_rules

  tags = merge(local.cosmosdb_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "cosmosdb_account_encryption_at_rest_using_cmk" {
  title       = "Azure Cosmos DB accounts should use customer-managed keys to encrypt data at rest"
  description = "Use customer-managed keys to manage the encryption at rest of your Azure Cosmos DB. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  query       = query.cosmosdb_account_encryption_at_rest_using_cmk

  tags = merge(local.cosmosdb_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "cosmodb_account_access_key_metadata_writes_disabled" {
  title       = "Azure Cosmos DB accounts should have access key metadata writes disabled"
  description = "Disable access key metadata writes on your Azure Cosmos DB accounts to prevent the access key from being overwritten. This prevents the access key from being overwritten by a user or application."
  query       = query.cosmodb_account_access_key_metadata_writes_disabled

  tags = local.cosmosdb_compliance_common_tags
}

control "cosmodb_account_public_network_access_disabled" {
  title       = "Azure Cosmos DB accounts should have public network access disabled"
  description = "Disable public network access on your Azure Cosmos DB accounts to prevent the account from being accessed from the public internet. This prevents the account from being accessed from the public internet."
  query       = query.cosmodb_account_public_network_access_disabled

  tags = local.cosmosdb_compliance_common_tags
}

control "cosmodb_account_local_authentication_disabled" {
  title       = "Azure Cosmos DB accounts should have local authentication disabled"
  description = "Ensure that Local Authentication is disabled on CosmosDB."
  query       = query.cosmodb_account_local_authentication_disabled

  tags = local.cosmosdb_compliance_common_tags
}

control "cosmodb_account_with_restricted_access" {
  title       = "Azure Cosmos DB accounts should have restricted access"
  description = "Ensure that Azure Cosmos DB accounts have restricted access."
  query       = query.cosmodb_account_with_restricted_access

  tags = local.cosmosdb_compliance_common_tags
}