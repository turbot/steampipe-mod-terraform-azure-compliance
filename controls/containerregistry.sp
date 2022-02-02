locals {
  containerregistry_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "containerregistry"
  })
}

benchmark "containerregistry" {
  title       = "Container Registry"
  description = "This benchmark provides a set of controls that detect Terraform Azure Container Registry resources deviating from security best practices."

  children = [
    control.container_registry_azure_defender_enabled,
    control.container_registry_encrypted_with_cmk,
    control.container_registry_restrict_public_access,
    control.container_registry_use_virtual_service_endpoint
  ]
  
  tags = local.containerregistry_compliance_common_tags
}

control "container_registry_use_virtual_service_endpoint" {
  title       = "Container Registry should use a virtual network service endpoint"
  description = "This policy audits any Container Registry not configured to use a virtual network service endpoint."
  sql         = query.container_registry_use_virtual_service_endpoint.sql

  tags = merge(local.containerregistry_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "container_registry_azure_defender_enabled" {
  title       = "Azure Defender for container registries should be enabled"
  description = "Azure Defender for container registries provides vulnerability scanning of any images pulled within the last 30 days, pushed to your registry, or imported, and exposes detailed findings per image."
  sql         = query.container_registry_azure_defender_enabled.sql

  tags = merge(local.containerregistry_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "container_registry_restrict_public_access" {
  title       = "Container registries should not allow unrestricted network access"
  description = "Azure container registries by default accept connections over the internet from hosts on any network. To protect your registries from potential threats, allow access from only specific public IP addresses or address ranges. If your registry doesn't have an IP/firewall rule or a configured virtual network, it will appear in the unhealthy resources."
  sql         = query.container_registry_restrict_public_access.sql

  tags = merge(local.containerregistry_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "container_registry_encrypted_with_cmk" {
  title       = "Container registries should be encrypted with a customer-managed key"
  description = "Use customer-managed keys to manage the encryption at rest of the contents of your registries. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  sql         = query.container_registry_encrypted_with_cmk.sql

  tags = merge(local.containerregistry_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}