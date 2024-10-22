locals {
  machinelearning_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/MachineLearning"
  })
}

benchmark "machinelearning" {
  title       = "Machine Learning"
  description = "This benchmark provides a set of controls that detect Terraform Azure Machine Learning resources deviating from security best practices."

  children = [
    control.machine_learning_compute_cluster_local_auth_disabled,
    control.machine_learning_compute_cluster_minimum_node_zero,
    control.machine_learning_workspace_encrypted_with_cmk,
    control.machine_learning_workspace_restrict_public_access
  ]

  tags = merge(local.machinelearning_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "machine_learning_workspace_encrypted_with_cmk" {
  title       = "Azure Machine Learning workspaces should be encrypted with a customer-managed key"
  description = "Manage encryption at rest of Azure Machine Learning workspace data with customer-managed keys. By default, customer data is encrypted with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  query       = query.machine_learning_workspace_encrypted_with_cmk

  tags = merge(local.machinelearning_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "machine_learning_compute_cluster_local_auth_disabled" {
  title       = "Machine Learning Compute Clusters local authentication should be disabled"
  description = "This control checks whether Machine Learning Compute Cluster local authentication is disabled."
  query       = query.machine_learning_compute_cluster_local_auth_disabled

  tags = local.machinelearning_compliance_common_tags
}

control "machine_learning_compute_cluster_minimum_node_zero" {
  title       = "Machine Learning Compute Clusters minimum node count should be set to zero"
  description = "This control checks whether Machine Learning Compute Cluster minimum node count is set to zero. This control is non-complaint if Machine Learning Compute Cluster minimum node count is not set to zero."
  query       = query.machine_learning_compute_cluster_minimum_node_zero

  tags = local.machinelearning_compliance_common_tags
}

control "machine_learning_workspace_restrict_public_access" {
  title       = "Machine Learning workspaces should restrict public access"
  description = "Disabling public network access improves security by ensuring that Machine Learning workspace isn't exposed on the public internet. Creating private endpoints can limit exposure of Machine Learning workspace."
  query       = query.machine_learning_workspace_restrict_public_access

  tags = local.machinelearning_compliance_common_tags
}
