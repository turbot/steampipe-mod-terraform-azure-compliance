locals {
  eventhub_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/EventHub"
  })
}

benchmark "eventhub" {
  title       = "Event Hubs"
  description = "This benchmark provides a set of controls that detect Terraform Azure Event Hub resources deviating from security best practices."

  children = [
    control.eventhub_namespace_cmk_encryption_enabled,
    control.eventhub_namespace_use_virtual_service_endpoint
  ]

  tags = merge(local.eventhub_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "eventhub_namespace_use_virtual_service_endpoint" {
  title       = "Event Hub should use a virtual network service endpoint"
  description = "This policy audits any Event Hub not configured to use a virtual network service endpoint."
  query       = query.eventhub_namespace_use_virtual_service_endpoint

  tags = merge(local.eventhub_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "eventhub_namespace_cmk_encryption_enabled" {
  title       = "Event Hub namespaces should be encrypted"
  description = "Azure Event Hub namespaces should be encrypted with an Azure Customer Managed Key."
  query       = query.eventhub_namespace_cmk_encryption_enabled

  tags = local.eventhub_compliance_common_tags
}

