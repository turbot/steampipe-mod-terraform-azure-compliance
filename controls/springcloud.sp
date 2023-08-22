locals {
  springcloud_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/SpringCloud"
  })
}

benchmark "springcloud" {
  title       = "Spring Cloud"
  description = "This benchmark provides a set of controls that detect Terraform Azure Spring Cloud resources deviating from security best practices."

  children = [
    control.spring_cloud_api_https_only_enabled,
    control.spring_cloud_api_public_network_access_disabled,
    control.spring_cloud_service_network_injection_enabled
  ]

  tags = merge(local.springcloud_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "spring_cloud_service_network_injection_enabled" {
  title       = "Azure Spring Cloud should use network injection"
  description = "Azure Spring Cloud instances should use virtual network injection for the following purposes -  1. Isolate Azure Spring Cloud from Internet. 2. Enable Azure Spring Cloud to interact with systems in either on premises data centers or Azure service in other virtual networks. 3. Empower customers to control inbound and outbound network communications for Azure Spring Cloud."
  query       = query.spring_cloud_service_network_injection_enabled

  tags = merge(local.springcloud_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "spring_cloud_api_public_network_access_disabled" {
  title       = "Azure Spring Cloud API should not be publicly accessible"
  description = "This control checks whether the Azure Spring Cloud API is publicly accessible."
  query       = query.spring_cloud_api_public_network_access_disabled

  tags = local.springcloud_compliance_common_tags
}

control "spring_cloud_api_https_only_enabled" {
  title       = "Azure Spring Cloud API should only be accessible over HTTPS"
  description = "This control checks whether the Azure Spring Cloud API is only accessible over HTTPS."
  query       = query.spring_cloud_api_https_only_enabled

  tags = local.springcloud_compliance_common_tags

}