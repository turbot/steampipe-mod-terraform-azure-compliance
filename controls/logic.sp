locals {
  logic_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Logic"
  })
}

benchmark "logic" {
  title       = "Logic"
  description = "This benchmark provides a set of controls that detect Terraform Azure Logic Apps resources deviating from security best practices."

  children = [
    control.logic_app_workflow_logging_enabled
  ]

  tags = merge(local.logic_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "logic_app_workflow_logging_enabled" {
  title       = "Resource logs in Logic Apps should be enabled"
  description = "Audit enabling of resource logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised."
  sql         = query.logic_app_workflow_logging_enabled.sql

  tags = merge(local.logic_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}
