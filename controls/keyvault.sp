locals {
  keyvault_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/KeyVault"
  })
}

benchmark "keyvault" {
  title       = "Key Vault"
  description = "This benchmark provides a set of controls that detect Terraform Azure Key Vault resources deviating from security best practices."

  children = [
    control.keyvault_azure_defender_enabled,
    control.keyvault_key_expiration_set,
    control.keyvault_logging_enabled,
    control.keyvault_managed_hms_logging_enabled,
    control.keyvault_managed_hms_purge_protection_enabled,
    control.keyvault_purge_protection_enabled,
    control.keyvault_secret_expiration_set,
    control.keyvault_vault_public_network_access_disabled,
    control.keyvault_vault_use_virtual_service_endpoint
  ]

  tags = merge(local.keyvault_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "keyvault_purge_protection_enabled" {
  title       = "Key vaults should have purge protection enabled"
  description = "Malicious deletion of a key vault can lead to permanent data loss. A malicious insider in your organization can potentially delete and purge key vaults. Purge protection protects you from insider attacks by enforcing a mandatory retention period for soft deleted key vaults. No one inside your organization or Microsoft will be able to purge your key vaults during the soft delete retention period."
  query       = query.keyvault_purge_protection_enabled

  tags = merge(local.keyvault_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "keyvault_logging_enabled" {
  title       = "Resource logs in Key Vault should be enabled"
  description = "Audit enabling of resource logs. This enables you to recreate activity trails to use for investigation purposes when a security incident occurs or when your network is compromised."
  query       = query.keyvault_logging_enabled

  tags = merge(local.keyvault_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "keyvault_vault_use_virtual_service_endpoint" {
  title       = "Key Vault should use a virtual network service endpoint"
  description = "This policy audits any Key Vault not configured to use a virtual network service endpoint."
  query       = query.keyvault_vault_use_virtual_service_endpoint

  tags = merge(local.keyvault_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "keyvault_managed_hms_purge_protection_enabled" {
  title       = "Azure Key Vault Managed HSM should have purge protection enabled"
  description = "Malicious deletion of an Azure Key Vault Managed HSM can lead to permanent data loss. A malicious insider in your organization can potentially delete and purge Azure Key Vault Managed HSM. Purge protection protects you from insider attacks by enforcing a mandatory retention period for soft deleted Azure Key Vault Managed HSM. No one inside your organization or Microsoft will be able to purge your Azure Key Vault Managed HSM during the soft delete retention period."
  query       = query.keyvault_managed_hms_purge_protection_enabled

  tags = merge(local.keyvault_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "keyvault_managed_hms_logging_enabled" {
  title       = "Resource logs in Azure Key Vault Managed HSM should be enabled"
  description = "To recreate activity trails for investigation purposes when a security incident occurs or when your network is compromised, you may want to audit by enabling resource logs on Managed HSMs."
  query       = query.keyvault_managed_hms_logging_enabled

  tags = merge(local.keyvault_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "keyvault_azure_defender_enabled" {
  title       = "Azure Defender for Key Vault should be enabled"
  description = "Azure Defender for Key Vault provides an additional layer of protection and security intelligence by detecting unusual and potentially harmful attempts to access or exploit key vault accounts."
  query       = query.keyvault_azure_defender_enabled

  tags = merge(local.keyvault_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "keyvault_vault_public_network_access_disabled" {
  title       = "Azure Key Vault should disable public network access"
  description = "Disable public network access for your key vault so that it's not accessible over the public internet. This can reduce data leakage risks."
  query       = query.keyvault_vault_public_network_access_disabled

  tags = merge(local.keyvault_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "keyvault_key_expiration_set" {
  title       = "Key Vault keys should have an expiration date"
  description = "Cryptographic keys should have a defined expiration date and not be permanent. Keys that are valid forever provide a potential attacker with more time to compromise the key. It is a recommended security practice to set expiration dates on cryptographic keys."
  query       = query.keyvault_key_expiration_set

  tags = merge(local.keyvault_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "keyvault_secret_expiration_set" {
  title       = "Key Vault secrets should have an expiration date"
  description = "Secrets should have a defined expiration date and not be permanent. Secrets that are valid forever provide a potential attacker with more time to compromise them. It is a recommended security practice to set expiration dates on secrets."
  query       = query.keyvault_secret_expiration_set

  tags = merge(local.keyvault_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "keyvault_secret_content_type_set" {
  title       = "Key Vault secrets should have a content type"
  description = "Secrets should have a defined content type. Secrets that are valid forever provide a potential attacker with more time to compromise them. It is a recommended security practice to set content types on secrets."
  query       = query.keyvault_secret_content_type_set

  tags = local.keyvault_compliance_common_tags
}