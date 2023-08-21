locals {
  application_gateway_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/ApplicationGateway"
  })
}

benchmark "application_gateway" {
  title       = "Application Gateway"
  description = "This benchmark provides a set of controls that detect Terraform Azure Application Gateway resources deviating from security best practices."

  children = [
    control.application_gateway_uses_https_listener
  ]

  tags = merge(local.application_gateway_compliance_common_tags, {
    type = "Benchmark"
  })

}

control "application_gateway_uses_https_listener" {
  title       = "Application Gateway uses HTTPS Listener"
  description = "This control checks whether Application Gateway uses HTTPS Listener."
  query       = query.application_gateway_uses_https_listener

  tags = local.application_gateway_compliance_common_tags
}