locals {
  frontdoor_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/FrontDoor"
  })
}

benchmark "frontdoor" {
  title       = "Front Door"
  description = "This benchmark provides a set of controls that detect Terraform Azure Front Door resources deviating from security best practices."

  children = [
    control.frontdoor_firewall_policy_restrict_message_lookup_log4j2,
    control.frontdoor_waf_enabled
  ]

  tags = merge(local.frontdoor_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "frontdoor_waf_enabled" {
  title       = "Web Application Firewall (WAF) should be enabled for Azure Front Door Service service"
  description = "Deploy Azure Web Application Firewall (WAF) in front of public-facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."
  query       = query.frontdoor_waf_enabled

  tags = merge(local.frontdoor_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "frontdoor_firewall_policy_restrict_message_lookup_log4j2" {
  title       = "Front Door firewall policy should restricts message lookup in Log4j2"
  description = "This control checks that Front Door firewall policy restricts message lookup in Log4j2 due to the CVE-2021-44228 vulnerability, also known as log4jshell."
  query       = query.frontdoor_firewall_policy_restrict_message_lookup_log4j2

  tags = local.frontdoor_compliance_common_tags
}
