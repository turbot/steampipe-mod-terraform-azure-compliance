locals {
  dataexplorer_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/DataExplorer"
  })
}

benchmark "dataexplorer" {
  title       = "Data Explorer"
  description = "This benchmark provides a set of controls that detect Terraform Azure Data Explorer resources deviating from security best practices."

  children = [
    control.kusto_cluster_disk_encryption_enabled,
    control.kusto_cluster_double_encryption_enabled,
    control.kusto_cluster_encrypted_at_rest_with_cmk,
    control.kusto_cluster_sku_with_sla,
    control.kusto_cluster_uses_managed_identity
  ]

  tags = merge(local.dataexplorer_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "kusto_cluster_encrypted_at_rest_with_cmk" {
  title       = "Azure Data Explorer encryption at rest should use a customer-managed key"
  description = "Enabling encryption at rest using a customer-managed key on your Azure Data Explorer cluster provides additional control over the key being used by the encryption at rest. This feature is oftentimes applicable to customers with special compliance requirements and requires a Key Vault to managing the keys."
  query       = query.kusto_cluster_encrypted_at_rest_with_cmk

  tags = merge(local.dataexplorer_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kusto_cluster_disk_encryption_enabled" {
  title       = "Disk encryption should be enabled on Azure Data Explorer"
  description = "Enabling disk encryption helps protect and safeguard your data to meet your organizational security and compliance commitments."
  query       = query.kusto_cluster_disk_encryption_enabled

  tags = merge(local.dataexplorer_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kusto_cluster_double_encryption_enabled" {
  title       = "Double encryption should be enabled on Azure Data Explorer"
  description = "Enabling double encryption helps protect and safeguard your data to meet your organizational security and compliance commitments. When double encryption has been enabled, data in the storage account is encrypted twice, once at the service level and once at the infrastructure level, using two different encryption algorithms and two different keys."
  query       = query.kusto_cluster_double_encryption_enabled

  tags = merge(local.dataexplorer_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kusto_cluster_sku_with_sla" {
  title       = "Kusto clusters should use SKU with an SLA"
  description = "This control checks if Kusto clusters use SKU with an SLA. This control is considered non-compliant if Kusto clusters use SKUs without an SLA."
  query       = query.kusto_cluster_sku_with_sla

  tags = merge(local.dataexplorer_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kusto_cluster_uses_managed_identity" {
  title       = "Kusto clusters should use managed identities"
  description = "Use a managed identity for enhanced authentication security."
  query       = query.kusto_cluster_uses_managed_identity

  tags = local.dataexplorer_compliance_common_tags
}
