locals {
  signalr_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/SignalR"
  })
}

benchmark "signalr" {
  title       = "SignalR"
  description = "This benchmark provides a set of controls that detect Terraform Azure SignalR resources deviating from security best practices."

  children = [
    control.signalr_services_uses_paid_sku
  ]

  tags = merge(local.signalr_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "signalr_services_uses_paid_sku" {
  title       = "SignalR services should use paid SKU"
  description = "SignalR services should use paid SKU to enable advanced features such as auto-scaling, hybrid connections, and zone redundancy."
  query       = query.signalr_services_uses_paid_sku

  tags = local.signalr_compliance_common_tags
}
