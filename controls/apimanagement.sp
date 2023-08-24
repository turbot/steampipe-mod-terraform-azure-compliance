locals {
  apimanagement_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/APIManagement"
  })
}

benchmark "apimanagement" {
  title       = "API Management"
  description = "This benchmark provides a set of controls that detect Terraform Azure API Management resources deviating from security best practices."

  children = [
    control.apimanagement_backend_uses_https,
    control.apimanagement_service_client_certificate_enabled,
    control.apimanagement_service_restrict_public_access,
    control.apimanagement_service_uses_latest_tls_version,
    control.apimanagement_service_with_virtual_network
  ]

  tags = merge(local.apimanagement_compliance_common_tags, {
    type = "Benchmark"
  })

}

control "apimanagement_service_with_virtual_network" {
  title       = "API Management services should use a virtual network"
  description = "Azure Virtual Network deployment provides enhanced security, isolation and allows you to place your API Management service in a non-internet routable network that you control access to. These networks can then be connected to your on-premises networks using various VPN technologies, which enables access to your backend services within the network and/or on-premises. The developer portal and API gateway, can be configured to be accessible either from the Internet or only within the virtual network."
  query       = query.apimanagement_service_with_virtual_network

  tags = merge(local.apimanagement_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "apimanagement_backend_uses_https" {
  title       = "API Management backends should use HTTPS"
  description = "This control checks that the API Management backend is configured to use HTTPS."
  query       = query.apimanagement_backend_uses_https

  tags = local.apimanagement_compliance_common_tags
}

control "apimanagement_service_client_certificate_enabled" {
  title       = "API Management services client certificate should be enabled"
  description = "Ensure API Management client certificate is enabled. This control is non-compliant if API Management client certificate is disabled."
  query       = query.apimanagement_service_client_certificate_enabled

  tags = merge(local.apimanagement_compliance_common_tags, {
    other_checks = "true"
  })
}

control "apimanagement_service_uses_latest_tls_version" {
  title       = "API Management services should use at least TLS 1.2 version"
  description = "This control checks that the API Management service uses at least TLS 1.2 version. This control is non-compliant if API Management service uses older TLS version."
  query       = query.apimanagement_service_uses_latest_tls_version

  tags = local.apimanagement_compliance_common_tags
}

control "apimanagement_service_restrict_public_access" {
  title       = "API Management services should restrict public network access"
  description = "This control checks that the API Management service is not publicly accessible. This control is non-compliant if API Management service is publicly accessible."
  query       = query.apimanagement_service_restrict_public_access

  tags = local.apimanagement_compliance_common_tags
}
