locals {
  kubernetes_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/KubernetesService"
  })
}

benchmark "kubernetes" {
  title       = "Kubernetes Service"
  description = "This benchmark provides a set of controls that detect Terraform Azure Kubernetes Service resources deviating from security best practices."

  children = [
    control.kubernetes_azure_defender_enabled,
    control.kubernetes_cluster_add_on_azure_policy_enabled,
    control.kubernetes_cluster_addon_azure_policy_enabled,
    control.kubernetes_cluster_authorized_ip_range_defined,
    control.kubernetes_cluster_key_vault_secret_rotation_enabled,
    control.kubernetes_cluster_local_admin_disabled,
    control.kubernetes_cluster_logging_enabled,
    control.kubernetes_cluster_max_pod_50,
    control.kubernetes_cluster_network_policy_enabled,
    control.kubernetes_cluster_node_pool_type_scale_set,
    control.kubernetes_cluster_node_restrict_public_access,
    control.kubernetes_cluster_os_and_data_disks_encrypted_with_cmk,
    control.kubernetes_cluster_restrict_public_access,
    control.kubernetes_cluster_sku_standard,
    control.kubernetes_cluster_temp_disks_and_agent_node_pool_cache_encrypted_at_host,
    control.kubernetes_cluster_upgrade_channel,
    control.kubernetes_instance_rbac_enabled,
  ]

  tags = merge(local.kubernetes_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "kubernetes_instance_rbac_enabled" {
  title       = "Role-Based Access Control (RBAC) should be used on Kubernetes Services"
  description = "To provide granular filtering on the actions that users can perform, use Role-Based Access Control (RBAC) to manage permissions in Kubernetes Service Clusters and configure relevant authorization policies."
  query       = query.kubernetes_instance_rbac_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_azure_defender_enabled" {
  title       = "Azure Defender for Kubernetes should be enabled"
  description = "Azure Defender for Kubernetes provides real-time threat protection for containerized environments and generates alerts for suspicious activities."
  query       = query.kubernetes_azure_defender_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_add_on_azure_policy_enabled" {
  title       = "Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters"
  description = "Azure Policy Add-on for Kubernetes service (AKS) extends Gatekeeper v3, an admission controller webhook for Open Policy Agent (OPA), to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner."
  query       = query.kubernetes_cluster_add_on_azure_policy_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_authorized_ip_range_defined" {
  title       = "Authorized IP ranges should be defined on Kubernetes Services"
  description = "ARestrict access to the Kubernetes Service Management API by granting API access only to IP addresses in specific ranges. It is recommended to limit access to authorized IP ranges to ensure that only applications from allowed networks can access the cluster."
  query       = query.kubernetes_cluster_authorized_ip_range_defined

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_os_and_data_disks_encrypted_with_cmk" {
  title       = "Both operating systems and data disks in Azure Kubernetes Service clusters should be encrypted by customer-managed keys"
  description = "Encrypting OS and data disks using customer-managed keys provides more control and greater flexibility in key management. This is a common requirement in many regulatory and industry compliance standards."
  query       = query.kubernetes_cluster_os_and_data_disks_encrypted_with_cmk

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_temp_disks_and_agent_node_pool_cache_encrypted_at_host" {
  title       = "Temp disks and cache for agent node pools in Azure Kubernetes Service clusters should be encrypted at host"
  description = "To enhance data security, the data stored on the virtual machine (VM) host of your Azure Kubernetes Service nodes VMs should be encrypted at rest. This is a common requirement in many regulatory and industry compliance standards."
  query       = query.kubernetes_cluster_temp_disks_and_agent_node_pool_cache_encrypted_at_host

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_restrict_public_access" {
  title       = "Kubernetes cluster should restrict public access"
  description = "Ensure that Kubernetes cluster enables private clusters to restrict public access."
  query       = query.kubernetes_cluster_restrict_public_access

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kubernetes_cluster_sku_standard" {
  title       = "Kubernetes clusters should use standard SKU"
  description = "Ensure that Kubernetes clusters uses standard SKU tier for production workloads. This control is non-compliant if Kubernetes cluster does not use standard SKU."
  query       = query.kubernetes_cluster_sku_standard

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kubernetes_cluster_local_admin_disabled" {
  title       = "Kubernetes clusters local admin should be disabled"
  description = "Ensure that Kubernetes local admin is disabled. This control is non-compliant if Kubernetes local admin is enabled."
  query       = query.kubernetes_cluster_local_admin_disabled

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_logging_enabled" {
  title       = "Kubernetes clusters should have logging enabled"
  description = "This control checks if OMS agent is enabled for Kubernetes cluster."
  query       = query.kubernetes_cluster_logging_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kubernetes_cluster_max_pod_50" {
  title       = "Kubernetes clusters should use a minimum number of 50 pods"
  description = "This control checks if Kubernetes clusters is using a minimum number of 50 pods."
  query       = query.kubernetes_cluster_max_pod_50

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kubernetes_cluster_network_policy_enabled" {
  title       = "Kubernetes clusters should have network policy enabled"
  description = "This control checks if network policy is enabled for Kubernetes cluster."
  query       = query.kubernetes_cluster_network_policy_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kubernetes_cluster_node_restrict_public_access" {
  title       = "Kubernetes cluster nodes should prohibit public access"
  description = "Ensure Kubernetes cluster nodes do not have public IP addresses. This control is non-compliant if Kubernetes cluster nodes have a public IP address assigned."
  query       = query.kubernetes_cluster_node_restrict_public_access

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kubernetes_cluster_key_vault_secret_rotation_enabled" {
  title       = "Kubernetes clusters key vault secret rotation should be enabled"
  description = "This control checks if key vault secret rotation should is enabled for Kubernetes cluster."
  query       = query.kubernetes_cluster_key_vault_secret_rotation_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kubernetes_cluster_upgrade_channel" {
  title       = "Kubernetes clusters upgrade channel should be configured"
  description = "Ensure Kubernetes clusters upgrade channel is configured. This control is non-compliant if Kubernetes clusters upgrade channel is set to none."
  query       = query.kubernetes_cluster_upgrade_channel

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "kubernetes_cluster_node_pool_type_scale_set" {
  title       = "Kubernetes clusters should use scale sets types nodes"
  description = "Ensure Kubernetes clusters uses scale sets types nodes. This control is non-compliant if Kubernetes clusters does not use scale sets types nodes."
  query       = query.kubernetes_cluster_node_pool_type_scale_set

  tags = local.kubernetes_compliance_common_tags
}

control "kubernetes_cluster_addon_azure_policy_enabled" {
  title       = "Kubernetes cluster addon Azure policy should be enabled"
  description = "Ensure that Kubernetes cluster uses Azure Policies Add-on."
  query       = query.kubernetes_cluster_addon_azure_policy_enabled

  tags = merge(local.kubernetes_compliance_common_tags, {
    fundamental_security = "true"
  })
}