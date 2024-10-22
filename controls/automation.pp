locals {
  automation_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Automation"
  })
}

benchmark "automation" {
  title       = "Automation"
  description = "This benchmark provides a set of controls that detect Terraform Azure Automation resources deviating from security best practices."

  children = [
    control.automation_account_variables_encryption_enabled
  ]

  tags = merge(local.automation_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "automation_account_variables_encryption_enabled" {
  title       = "Automation account variables encryption should be enabled"
  description = "Enabling Automation account variables encryption helps protect and safeguard your data to meet your organizational security and compliance commitments."
  query       = query.automation_account_variables_encryption_enabled

  tags = local.automation_compliance_common_tags
}
