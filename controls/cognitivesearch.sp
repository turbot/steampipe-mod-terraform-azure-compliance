locals {
  cognitivesearch_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/CognitiveSearch"
  })
}

benchmark "cognitivesearch" {
  title       = "Cognitive Search"
  description = "This benchmark provides a set of controls that detect Terraform Azure Cognitive Search resources deviating from security best practices."

  children = [
    control.search_service_public_network_access_disabled,
    control.search_service_replica_count_3,
    control.search_service_uses_managed_identity,
    control.search_service_uses_private_link
  ]

  tags = merge(local.cognitivesearch_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "search_service_public_network_access_disabled" {
  title       = "Azure Cognitive Search services should disable public network access"
  description = "Disabling public network access improves security by ensuring that your Azure Cognitive Search service is not exposed on the public internet. Creating private endpoints can limit exposure of your search service."
  query       = query.search_service_public_network_access_disabled

  tags = merge(local.cognitivesearch_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "search_service_uses_private_link" {
  title       = "Azure Cognitive Search services should use private link"
  description = "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The Private Link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to Azure Cognitive Search, data leakage risks are reduced."
  query       = query.search_service_uses_sku_supporting_private_link

  tags = merge(local.cognitivesearch_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "search_service_uses_managed_identity" {
  title       = "Cognitive Search services should use managed identity"
  description = "Cognitive Search services should use a managed identity for enhanced authentication security."
  query       = query.search_service_uses_managed_identity

  tags = merge(local.cognitivesearch_compliance_common_tags, {
    other_checks = "true"
  })
}

control "search_service_replica_count_3" {
  title       = "Cognitive Search services should maintain SLA for index updates"
  description = "This control checks if Cognitive Search maintains SLA for index updates."
  query       = query.search_service_replica_count_3

  tags = merge(local.cognitivesearch_compliance_common_tags, {
    other_checks = "true"
  })
}
