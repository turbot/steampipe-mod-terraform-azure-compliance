locals {
  compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    plugin = "terraform"
  })
}
