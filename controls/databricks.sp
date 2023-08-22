locals {
  databricks_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Databricks"
  })
}

benchmark "databricks" {
  title       = "Databricks"
  description = "This benchmark provides a set of controls that detect Terraform Azure Cognitive Search resources deviating from security best practices."

  children = [
    control.databricks_workspace_public_network_access_disabled
  ]

  tags = merge(local.databricks_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "databricks_workspace_public_network_access_disabled" {
  title       = "Databricks should disable public network access"
  description = "Disabling public network access improves security by ensuring that your Databricks is not exposed on the public internet. Creating private endpoints can limit exposure of your Databricks."
  query       = query.databricks_workspace_public_network_access_disabled

  tags = local.databricks_compliance_common_tags
}
