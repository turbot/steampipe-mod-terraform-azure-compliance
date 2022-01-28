locals {
  cognitivesearch_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "cognitivesearch"
  })
}

benchmark "cognitivesearch" {
  title       = "Cognitive Search"
  description = "This benchmark provides a set of controls that detect Terraform Azure Cognitive Search resources deviating from security best practices."

  children = [
    control.search_service_public_network_access_disabled,
    control.search_service_uses_private_link
  ]
  
  tags = local.cognitivesearch_compliance_common_tags
}

control "search_service_public_network_access_disabled" {
  title       = "Azure Cognitive Search services should disable public network access"
  description = "Disabling public network access improves security by ensuring that your Azure Cognitive Search service is not exposed on the public internet. Creating private endpoints can limit exposure of your search service."
  sql         = query.search_service_public_network_access_disabled.sql

  tags = merge(local.cognitivesearch_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "search_service_uses_private_link" {
  title       = "Azure Cognitive Search services should use private link"
  description = "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The Private Link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to Azure Cognitive Search, data leakage risks are reduced."
  sql         = query.search_service_uses_sku_supporting_private_link.sql

  tags = merge(local.cognitivesearch_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}
