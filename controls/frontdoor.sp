locals {
  frontdoor_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "Azure/FrontDoor"
  })
}

benchmark "frontdoor" {
  title       = "Front Door"
  description = "This benchmark provides a set of controls that detect Terraform Azure Front Door resources deviating from security best practices."

  children = [
    control.frontdoor_waf_enabled
  ]

  tags = merge(local.frontdoor_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "frontdoor_waf_enabled" {
  title       = "Web Application Firewall (WAF) should be enabled for Azure Front Door Service service"
  description = "Deploy Azure Web Application Firewall (WAF) in front of public facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."
  sql         = query.frontdoor_waf_enabled.sql

  tags = merge(local.frontdoor_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}