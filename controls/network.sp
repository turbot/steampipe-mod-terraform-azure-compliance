locals {
  network_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "network"
  })
}

benchmark "network" {
  title       = "Virtual Network"
  description = "This benchmark provides a set of controls that detect Terraform Azure Virtual Network resources deviating from security best practices."

  children = [
    control.application_gateway_waf_enabled,
    control.network_security_group_not_configured_gateway_subnets,
    control.network_security_group_subnet_associated
  ]
  
  tags = local.network_compliance_common_tags
}

control "network_security_group_subnet_associated" {
  title       = "Subnets should be associated with a Network Security Group"
  description = "This policy denies if a gateway subnet is configured with a network security group. Assigning a network security group to a gateway subnet will cause the gateway to stop functioning."
  sql         = query.network_security_group_subnet_associated.sql

  tags = merge(local.network_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "network_security_group_not_configured_gateway_subnets" {
  title       = "Gateway subnets should not be configured with a network security group"
  description = "Protect your subnet from potential threats by restricting access to it with a Network Security Group (NSG). NSGs contain a list of Access Control List (ACL) rules that allow or deny network traffic to your subnet."
  sql         = query.network_security_group_not_configured_gateway_subnets.sql

  tags = merge(local.network_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "application_gateway_waf_enabled" {
  title       = "Web Application Firewall (WAF) should be enabled for Application Gateway"
  description = "Deploy Azure Web Application Firewall (WAF) in front of public facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."
  sql         = query.application_gateway_waf_enabled.sql

  tags = merge(local.network_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}
