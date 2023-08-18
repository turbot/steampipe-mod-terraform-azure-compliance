locals {
  containerregistry_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/ContainerRegistry"
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

  tags = merge(local.containerregistry_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "container_registry_use_virtual_service_endpoint" {
  title       = "Container Registry should use a virtual network service endpoint"
  description = "This policy audits any Container Registry not configured to use a virtual network service endpoint."
  query       = query.container_registry_use_virtual_service_endpoint

  tags = merge(local.containerregistry_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "container_registry_azure_defender_enabled" {
  title       = "Azure Defender for container registries should be enabled"
  description = "Azure Defender for container registries provides vulnerability scanning of any images pulled within the last 30 days, pushed to your registry, or imported, and exposes detailed findings per image."
  query       = query.container_registry_azure_defender_enabled

  tags = merge(local.containerregistry_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "container_registry_restrict_public_access" {
  title       = "Container registries should not allow unrestricted network access"
  description = "Azure container registries by default accept connections over the internet from hosts on any network. To protect your registries from potential threats, allow access from only specific public IP addresses or address ranges. If your registry doesn't have an IP/firewall rule or a configured virtual network, it will appear in the unhealthy resources."
  query       = query.container_registry_restrict_public_access

  tags = merge(local.containerregistry_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "container_registry_encrypted_with_cmk" {
  title       = "Container registries should be encrypted with a customer-managed key"
  description = "Use customer-managed keys to manage the encryption at rest of the contents of your registries. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  query       = query.container_registry_encrypted_with_cmk

  tags = merge(local.containerregistry_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "container_registry_admin_user_disabled" {
  title       = "Container registries admin user should be disabled"
  description = "Ensure container registry admin user is disabled. This control is non-compliant if admin user is enabled."
  query       = query.container_registry_admin_user_disabled

  tags = merge(local.containerregistry_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "container_registry_anonymous_pull_disabled" {
  title       = "Container registries anonymous pull should be disabled"
  description = "This control checks whether anonymous pull is disabled. This control is non-compliant if anonymous pull is enabled."
  query       = query.container_registry_anonymous_pull_disabled

  tags = local.containerregistry_compliance_common_tags
}

control "container_registry_image_scan_enabled" {
  title       = "Container registries image scan should be enabled"
  description = "This control checks whether image scan is enabled. This control is non-compliant if image scan is disabled."
  query       = query.container_registry_image_scan_enabled

  tags = local.containerregistry_compliance_common_tags
}

control "container_registry_quarantine_policy_enabled" {
  title       = "Container registries quarantine policy should be enabled"
  description = "Ensure container registry quarantine policy is enabled. This control is non-compliant if quarantine policy is disabled."
  query       = query.container_registry_quarantine_policy_enabled

  tags = merge(local.containerregistry_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "container_registry_retention_policy_enabled" {
  title       = "Container registries retention policy should be enabled"
  description = "Ensure container registry retention policy is enabled. This control is non-compliant if retention policy is disabled."
  query       = query.container_registry_retention_policy_enabled

  tags = merge(local.containerregistry_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "container_registry_geo_replication_enabled" {
  title       = "Container registries should be geo-replicated"
  description = "Ensure that container registries are geo-replicated to align with multi-region container deployments."
  query       = query.container_registry_geo_replication_enabled

  tags = merge(local.containerregistry_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "container_registry_public_network_access_disabled" {
  title       = "Container registries public network access should be disabled"
  description = "Ensure that container registries public network access is disabled."
  query       = query.container_registry_public_network_access_disabled

  tags = merge(local.containerregistry_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "container_registry_trust_policy_enabled" {
  title       = "Container registries trust policy should be enabled"
  description = "Ensure container registry trust policy is enabled. This control is non-compliant if trust policy is disabled."
  query       = query.container_registry_trust_policy_enabled

  tags = merge(local.containerregistry_compliance_common_tags, {
    fundamental_security = "true"
  })
}