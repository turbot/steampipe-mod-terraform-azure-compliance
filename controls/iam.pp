locals {
  iam_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/IAM"
  })
}

benchmark "iam" {
  title       = "IAM"
  description = "This benchmark provides a set of controls that detect Terraform Azure IAM resources deviating from security best practices."

  children = [
    control.iam_no_custom_subscription_owner_roles_created
  ]

  tags = merge(local.iam_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "iam_no_custom_subscription_owner_roles_created" {
  title       = "Custom subscription administrator roles should not exist"
  description = "The principle of least privilege should be followed and only necessary privileges should be assigned instead of allowing full administrative access."
  query       = query.iam_no_custom_subscription_owner_roles_created

  tags = local.iam_compliance_common_tags
}
