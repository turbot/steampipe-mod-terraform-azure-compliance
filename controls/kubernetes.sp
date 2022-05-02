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
    control.kubernetes_cluster_authorized_ip_range_defined,
    control.kubernetes_cluster_os_and_data_disks_encrypted_with_cmk,
    control.kubernetes_cluster_temp_disks_and_agent_node_pool_cache_encrypted_at_host,
    control.kubernetes_instance_rbac_enabled
  ]

  tags = merge(local.kubernetes_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "kubernetes_instance_rbac_enabled" {
  title       = "Role-Based Access Control (RBAC) should be used on Kubernetes Services"
  description = "To provide granular filtering on the actions that users can perform, use Role-Based Access Control (RBAC) to manage permissions in Kubernetes Service Clusters and configure relevant authorization policies."
  sql         = query.kubernetes_instance_rbac_enabled.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_azure_defender_enabled" {
  title       = "Azure Defender for Kubernetes should be enabled"
  description = "Azure Defender for Kubernetes provides real-time threat protection for containerized environments and generates alerts for suspicious activities."
  sql         = query.kubernetes_azure_defender_enabled.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_add_on_azure_policy_enabled" {
  title       = "Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters"
  description = "Azure Policy Add-on for Kubernetes service (AKS) extends Gatekeeper v3, an admission controller webhook for Open Policy Agent (OPA), to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner."
  sql         = query.kubernetes_cluster_add_on_azure_policy_enabled.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_authorized_ip_range_defined" {
  title       = "Authorized IP ranges should be defined on Kubernetes Services"
  description = "ARestrict access to the Kubernetes Service Management API by granting API access only to IP addresses in specific ranges. It is recommended to limit access to authorized IP ranges to ensure that only applications from allowed networks can access the cluster."
  sql         = query.kubernetes_cluster_authorized_ip_range_defined.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_os_and_data_disks_encrypted_with_cmk" {
  title       = "Both operating systems and data disks in Azure Kubernetes Service clusters should be encrypted by customer-managed keys"
  description = "Encrypting OS and data disks using customer-managed keys provides more control and greater flexibility in key management. This is a common requirement in many regulatory and industry compliance standards."
  sql         = query.kubernetes_cluster_os_and_data_disks_encrypted_with_cmk.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "kubernetes_cluster_temp_disks_and_agent_node_pool_cache_encrypted_at_host" {
  title       = "Temp disks and cache for agent node pools in Azure Kubernetes Service clusters should be encrypted at host"
  description = "To enhance data security, the data stored on the virtual machine (VM) host of your Azure Kubernetes Service nodes VMs should be encrypted at rest. This is a common requirement in many regulatory and industry compliance standards."
  sql         = query.kubernetes_cluster_temp_disks_and_agent_node_pool_cache_encrypted_at_host.sql

  tags = merge(local.kubernetes_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}



