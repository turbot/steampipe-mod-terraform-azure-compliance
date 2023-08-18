locals {
  appconfiguration_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/AppConfiguration"
  })
}

benchmark "appconfiguration" {
  title       = "App Configuration"
  description = "This benchmark provides a set of controls that detect Terraform Azure App Configuration resources deviating from security best practices."

  children = [
    control.app_configuration_encryption_enabled,
    control.app_configuration_local_auth_disabled,
    control.app_configuration_not_publicly_accessible,
    control.app_configuration_purge_protection_enabled,
    control.app_configuration_sku_standard
  ]

  tags = merge(local.appconfiguration_compliance_common_tags, {
    type    = "Benchmark"
  })

}

control "app_configuration_encryption_enabled" {
  title       = "App Configuration encryption should be enabled"
  description = "Enabling App Configuration encryption helps protect and safeguard your data to meet your organizational security and compliance commitments."
  query       = query.app_configuration_encryption_enabled

  tags = merge(local.appconfiguration_compliance_common_tags, {
    fundamental_security = "true"
  })
}

control "app_configuration_local_auth_disabled" {
  title       = "App Configuration local authentication should be disabled"
  description = "This control checks whether App Configuration local authentication is disabled."
  query       = query.app_configuration_local_auth_disabled

  tags = local.appconfiguration_compliance_common_tags
}

control "app_configuration_not_publicly_accessible" {
  title       = "App Configuration should not be publicly accessible"
  description = "This control checks whether App Configuration is not publicly accessible."
  query       = query.app_configuration_not_publicly_accessible

  tags = local.appconfiguration_compliance_common_tags
}

control "app_configuration_purge_protection_enabled" {
  title       = "App Configuration purge protection should be enabled"
  description = "This control checks whether App Configuration purge protection is enabled."
  query       = query.app_configuration_purge_protection_enabled

  tags = local.appconfiguration_compliance_common_tags
}

control "app_configuration_sku_standard" {
  title       = "App Configuration should use standard SKU"
  description = "Ensure that App Configuration uses standard SKU tier. This control is non-compliant if App Configuration does not use standard SKU."
  query       = query.app_configuration_sku_standard

  tags = merge(local.appconfiguration_compliance_common_tags, {
    fundamental_security = "true"
  })
}
