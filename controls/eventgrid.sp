locals {
  eventgrid_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/EventGrid"
  })
}

benchmark "eventgrid" {
  title       = "Event Grid"
  description = "This benchmark provides a set of controls that detect Terraform Azure Event Grid resources deviating from security best practices."

  children = [
    control.eventgrid_domain_local_auth_disabled,
    control.eventgrid_domain_restrict_public_access,
    control.eventgrid_domain_uses_managed_identity,
    control.eventgrid_topic_local_auth_disabled,
    control.eventgrid_topic_restrict_public_access,
    control.eventgrid_topic_uses_managed_identity
  ]

  tags = merge(local.eventgrid_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "eventgrid_domain_uses_managed_identity" {
  title       = "Event Grid domains should use managed identity"
  description = "Use a managed identity for enhanced authentication security. A managed identity from Azure Active Directory (Azure AD) allows your Event Grid domain to easily access other Azure AD-protected resources such as Azure Key Vault."
  query       = query.eventgrid_domain_uses_managed_identity

  tags = local.eventgrid_compliance_common_tags
}

control "eventgrid_domain_local_auth_disabled" {
  title       = "Event Grid domains should have local authentication disabled"
  description = "Disabling local authentication methods improves security by ensuring that Event Grid domain require Azure Active Directory identities exclusively for authentication."
  query       = query.eventgrid_domain_local_auth_disabled

  tags = local.eventgrid_compliance_common_tags
}

control "eventgrid_topic_local_auth_disabled" {
  title       = "Event Grid topics should have local authentication disabled"
  description = "Disabling local authentication methods improves security by ensuring that Event Grid topic require Azure Active Directory identities exclusively for authentication."
  query       = query.eventgrid_topic_local_auth_disabled

  tags = merge(local.eventgrid_compliance_common_tags, {
    other_checks = "true"
  })
}

control "eventgrid_topic_uses_managed_identity" {
  title       = "Event Grid topics should use managed identity"
  description = "Use a managed identity for enhanced authentication security. A managed identity from Azure Active Directory (Azure AD) allows your Event Grid topic to easily access other Azure AD-protected resources such as Azure Key Vault."
  query       = query.eventgrid_topic_uses_managed_identity

  tags = local.eventgrid_compliance_common_tags
}

control "eventgrid_domain_restrict_public_access" {
  title       = "Event Grid domains should disable public network access"
  description = "Disabling public network access improves security by ensuring that your Event Grid domain is not exposed on the public internet."
  query       = query.eventgrid_domain_restrict_public_access

  tags = merge(local.eventgrid_compliance_common_tags, {
    other_checks = "true"
  })
}

control "eventgrid_topic_restrict_public_access" {
  title       = "Event Grid topics should disable public network access"
  description = "Disabling public network access improves security by ensuring that your Event Grid topic is not exposed on the public internet."
  query       = query.eventgrid_topic_restrict_public_access

  tags = local.eventgrid_compliance_common_tags
}
