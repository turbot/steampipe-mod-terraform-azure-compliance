locals {
  databricks_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Databricks"
  })
}

benchmark "databricks" {
  title       = "Databricks"
  description = "This benchmark provides a set of controls that detect Terraform Azure Databricks resources deviating from security best practices."

  children = [
    control.databricks_workspace_restrict_public_access
  ]

  tags = merge(local.databricks_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "databricks_workspace_restrict_public_access" {
  title       = "Databricks should disable public network access"
  description = "Disabling public network access improves security by ensuring that your Databricks is not exposed on the public internet. Creating private endpoints can limit exposure of your Databricks."
  query       = query.databricks_workspace_restrict_public_access

  tags = local.databricks_compliance_common_tags
}
