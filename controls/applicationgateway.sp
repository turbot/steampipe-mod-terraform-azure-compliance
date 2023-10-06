locals {
  application_gateway_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/ApplicationGateway"
  })
}

benchmark "applicationgateway" {
  title       = "Application Gateway"
  description = "This benchmark provides a set of controls that detect Terraform Azure Application Gateway resources deviating from security best practices."

  children = [
    control.application_gateway_restrict_message_lookup_log4j2,
    control.application_gateway_use_secure_ssl_cipher,
    control.application_gateway_uses_https_listener,
    control.application_gateway_waf_enabled
  ]

  tags = merge(local.application_gateway_compliance_common_tags, {
    type = "Benchmark"
  })

}

control "application_gateway_uses_https_listener" {
  title       = "Application Gateway should use HTTPS Listener"
  description = "This control checks whether Application Gateway uses HTTPS Listener."
  query       = query.application_gateway_uses_https_listener

  tags = local.application_gateway_compliance_common_tags
}

control "application_gateway_waf_enabled" {
  title       = "Web Application Firewall (WAF) should be enabled for Application Gateway"
  description = "Deploy Azure Web Application Firewall (WAF) in front of public-facing web applications for additional inspection of incoming traffic. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities such as SQL injections, Cross-Site Scripting, local and remote file executions. You can also restrict access to your web applications by countries, IP address ranges, and other http(s) parameters via custom rules."
  query       = query.application_gateway_waf_enabled

  tags = merge(local.network_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "application_gateway_use_secure_ssl_cipher" {
  title       = "Application Gateway should use secure SSL cipher"
  description = "This control checks whether Application Gateway uses secure SSL cipher."
  query       = query.application_gateway_use_secure_ssl_cipher

  tags = local.application_gateway_compliance_common_tags
}

control "application_gateway_restrict_message_lookup_log4j2" {
  title       = "Application Gateway should restrict message lookup in Log4j2"
  description = "This control checks that Application Gateway restricts message lookup in Log4j2 due to the CVE-2021-44228 vulnerability, also known as log4jshell."
  query       = query.application_gateway_restrict_message_lookup_log4j2

  tags = local.application_gateway_compliance_common_tags
}
