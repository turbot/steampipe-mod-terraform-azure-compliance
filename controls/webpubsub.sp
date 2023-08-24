locals {
  webpubsub_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/WebPubSub"
  })
}

benchmark "webpubsub" {
  title       = "Web PubSub"
  description = "This benchmark provides a set of controls that detect Terraform Azure Web PubSub resources deviating from security best practices."

  children = [
    control.web_pubsub_sku_with_sla,
    control.web_pubsub_uses_managed_identity
  ]

  tags = merge(local.webpubsub_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "web_pubsub_sku_with_sla" {
  title       = "Web PubSubs should use SKU with an SLA"
  description = "This control checks if Web PubSubs use SKU with an SLA. This control is considered non-compliant if Web PubSub uses SKUs without an SLA."
  query       = query.web_pubsub_sku_with_sla

  tags = local.webpubsub_compliance_common_tags
}

control "web_pubsub_uses_managed_identity" {
  title       = "Web PubSubs should use managed identity"
  description = "Use a managed identity for enhanced authentication security. A managed identity from Azure Active Directory (Azure AD) allows your Web PubSub to easily access other Azure AD-protected resources such as Azure Key Vault."
  query       = query.web_pubsub_uses_managed_identity

  tags = local.webpubsub_compliance_common_tags
}