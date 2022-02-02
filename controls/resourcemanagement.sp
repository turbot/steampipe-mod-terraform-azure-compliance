locals {
  resourcemanagement_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "resourcemanagement"
  })
}

benchmark "resourcemanagement" {
  title       = "Resource Manager"
  description = "This benchmark provides a set of controls that detect Terraform Azure Resource Manager resources deviating from security best practices."

  children = [
    control.resource_manager_azure_defender_enabled
  ]
  
  tags = local.resourcemanagement_compliance_common_tags
}

control "resource_manager_azure_defender_enabled" {
  title       = "Azure Defender for Resource Manager should be enabled"
  description = "Azure Defender for Resource Manager automatically monitors the resource management operations in your organization. Azure Defender detects threats and alerts you about suspicious activity."
  sql         = query.resource_manager_azure_defender_enabled.sql

  tags = merge(local.resourcemanagement_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}