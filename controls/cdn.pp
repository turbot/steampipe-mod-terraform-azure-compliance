locals {
  cdn_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/ContentDeliveryNetwork"
  })
}

benchmark "cdn" {
  title       = "Content Delivery Network"
  description = "This benchmark provides a set of controls that detect Terraform Azure Content Delivery Network resources deviating from security best practices."

  children = [
    control.cdn_endpoint_custom_domain_uses_latest_tls_version,
    control.cdn_endpoint_http_disabled,
    control.cdn_endpoint_https_enabled
  ]

  tags = merge(local.cdn_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cdn_endpoint_custom_domain_uses_latest_tls_version" {
  title       = "Content Delivery Network custom domains should use at least TLS 1.2 version"
  description = "This control checks that the Content Delivery Network custom domains uses at least TLS 1.2 version. This control is non-compliant if Content Delivery Network custom domains uses older TLS version."
  query       = query.cdn_endpoint_custom_domain_uses_latest_tls_version

  tags = local.apimanagement_compliance_common_tags
}

control "cdn_endpoint_http_disabled" {
  title       = "Content Delivery Networks HTTP endpoint should be disabled"
  description = "This control checks whether Content Delivery Network HTTP endpoint is disabled."
  query       = query.cdn_endpoint_http_disabled

  tags = local.cdn_compliance_common_tags
}

control "cdn_endpoint_https_enabled" {
  title       = "Content Delivery Networks HTTPS endpoint should be enabled"
  description = "This control checks whether Content Delivery Network HTTPS endpoint is enabled."
  query       = query.cdn_endpoint_https_enabled

  tags = local.cdn_compliance_common_tags
}
