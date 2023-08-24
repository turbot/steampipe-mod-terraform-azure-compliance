locals {
  synapse_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/SynapseAnalytics"
  })
}

benchmark "synapse" {
  title       = "Synapse Analytics"
  description = "This benchmark provides a set of controls that detect Terraform Azure Synapse resources deviating from security best practices."

  children = [
    control.synapse_workspace_data_exfiltration_protection_enabled,
    control.synapse_workspace_encryption_at_rest_using_cmk,
    control.synapse_workspace_private_link_used
  ]

  tags = merge(local.synapse_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "synapse_workspace_private_link_used" {
  title       = "Azure Synapse workspaces should use private link"
  description = "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The Private Link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to Azure Synapse workspace, data leakage risks are reduced."
  query       = query.synapse_workspace_private_link_used

  tags = merge(local.synapse_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "synapse_workspace_encryption_at_rest_using_cmk" {
  title       = "Azure Synapse workspaces should use customer-managed keys to encrypt data at rest"
  description = "Use customer-managed keys to control the encryption at rest of the data stored in Azure Synapse workspaces. Customer-managed keys deliver double encryption by adding a second layer of encryption on top of the default encryption with service-managed keys."
  query       = query.synapse_workspace_encryption_at_rest_using_cmk

  tags = merge(local.synapse_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "synapse_workspace_data_exfiltration_protection_enabled" {
  title       = "Synapse workspaces should have data exfiltration protection enabled"
  description = "This control checks whether Synapse workspace has data exfiltration protection enabled."
  query       = query.synapse_workspace_data_exfiltration_protection_enabled

  tags = merge(local.synapse_compliance_common_tags, {
    other_checks = "true"
  })
}
