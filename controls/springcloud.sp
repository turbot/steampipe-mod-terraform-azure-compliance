locals {
  springcloud_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "springcloud"
  })
}

benchmark "springcloud" {
  title       = "Spring Cloud"
  description = "This benchmark provides a set of controls that detect Terraform Azure Spring Cloud resources deviating from security best practices."

  children = [
    control.spring_cloud_service_network_injection_enabled
  ]
  
  tags = local.springcloud_compliance_common_tags
}

control "spring_cloud_service_network_injection_enabled" {
  title       = "Azure Spring Cloud should use network injection"
  description = "Azure Spring Cloud instances should use virtual network injection for the following purposes: 1. Isolate Azure Spring Cloud from Internet. 2. Enable Azure Spring Cloud to interact with systems in either on premises data centers or Azure service in other virtual networks. 3. Empower customers to control inbound and outbound network communications for Azure Spring Cloud."
  sql         = query.spring_cloud_service_network_injection_enabled.sql

  tags = merge(local.springcloud_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}