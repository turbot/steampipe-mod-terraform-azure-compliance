locals {
  network_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Network"
  })
}

benchmark "network" {
  title       = "Virtual Network"
  description = "This benchmark provides a set of controls that detect Terraform Azure Virtual Network resources deviating from security best practices."

  children = [
    control.network_security_group_not_configured_gateway_subnets,
    control.network_security_group_rdp_access_restricted,
    control.network_security_group_ssh_access_restricted,
    control.network_security_group_subnet_associated,
    control.network_security_group_udp_access_restricted,
    control.network_security_rule_rdp_access_restricted,
    control.network_security_rule_ssh_access_restricted,
    control.network_security_rule_udp_access_restricted,
    control.network_watcher_flow_log_retention_period_90_days
  ]

  tags = merge(local.network_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "network_security_group_subnet_associated" {
  title       = "Subnets should be associated with a Network Security Group"
  description = "This policy denies if a gateway subnet is configured with a network security group. Assigning a network security group to a gateway subnet will cause the gateway to stop functioning."
  query       = query.network_security_group_subnet_associated

  tags = merge(local.network_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "network_security_group_not_configured_gateway_subnets" {
  title       = "Gateway subnets should not be configured with a network security group"
  description = "Protect your subnet from potential threats by restricting access to it with a Network Security Group (NSG). NSGs contain a list of Access Control List (ACL) rules that allow or deny network traffic to your subnet."
  query       = query.network_security_group_not_configured_gateway_subnets

  tags = merge(local.network_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "network_watcher_flow_log_retention_period_90_days" {
  title       = "Network Watcher flow logs should have retention set to 90 days or greater"
  description = "This control is non-compliant if Network Watcher flow log retention is set to less than 90 days."
  query       = query.network_watcher_flow_log_retention_period_90_days

  tags = local.network_compliance_common_tags
}

control "network_security_group_udp_access_restricted" {
  title       = "Network Security Groups UDP Services are restricted from the Internet"
  description = "Disable Internet exposed UDP ports on network security groups."
  query       = query.network_security_group_udp_access_restricted

  tags = local.network_compliance_common_tags
}

control "network_security_rule_udp_access_restricted" {
  title       = "Network Security Rules UDP Services are restricted from the Internet"
  description = "Disable Internet exposed UDP ports on network security rules."
  query       = query.network_security_rule_udp_access_restricted

  tags = local.network_compliance_common_tags
}

control "network_security_rule_rdp_access_restricted" {
  title       = "Network Security Rules RDP Services are restricted from the Internet"
  description = "Disable Internet exposed RDP ports on network security rules."
  query       = query.network_security_rule_rdp_access_restricted

  tags = local.network_compliance_common_tags
}

control "network_security_group_rdp_access_restricted" {
  title       = "Network Security Groups RDP Services are restricted from the Internet"
  description = "Disable Internet exposed RDP ports on network security groups."
  query       = query.network_security_group_rdp_access_restricted

  tags = local.network_compliance_common_tags
}

control "network_security_rule_ssh_access_restricted" {
  title       = "Network Security Rules SSH Services are restricted from the Internet"
  description = "Disable Internet exposed RDP ports on network security rules."
  query       = query.network_security_rule_ssh_access_restricted

  tags = local.network_compliance_common_tags
}

control "network_security_group_ssh_access_restricted" {
  title       = "Network Security Groups SSH Services are restricted from the Internet"
  description = "Disable Internet exposed RDP ports on network security groups."
  query       = query.network_security_group_ssh_access_restricted

  tags = local.network_compliance_common_tags
}

