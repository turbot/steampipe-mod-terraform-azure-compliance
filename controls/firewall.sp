locals {
  firewall_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Firewall"
  })
}

benchmark "firewall" {
  title       = "Firewall"
  description = "This benchmark provides a set of controls that detect Terraform Azure Firewall resources deviating from security best practices."

  children = [
    control.firewal_has_firewall_policy_set,
    control.firewal_threat_intel_mode_set_to_deny
  ]

  tags = merge(local.firewall_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "firewal_has_firewall_policy_set" {
  title       = "Firewall has firewall policy set"
  description = "This control checks whether a firewall policy is set for the firewall."
  query       = query.firewal_has_firewall_policy_set

  tags = local.firewall_compliance_common_tags
}

control "firewal_threat_intel_mode_set_to_deny" {
  title       = "Firewall threat intel mode set to deny"
  description = "This control checks whether the firewall threat intel mode is set to deny."
  query       = query.firewal_threat_intel_mode_set_to_deny

  tags = local.firewall_compliance_common_tags
}