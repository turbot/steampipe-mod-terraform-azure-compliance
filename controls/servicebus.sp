locals {
  servicebus_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/ServiceBus"
  })
}

benchmark "servicebus" {
  title       = "Service Bus"
  description = "This benchmark provides a set of controls that detect Terraform Azure Service Bus resources deviating from security best practices."

  children = [
    control.service_bus_namespace_encrypted_with_cmk,
    control.service_bus_namespace_infrastructure_encryption_enabled,
    control.service_bus_namespace_latest_tls_version,
    control.service_bus_namespace_local_auth_disabled,
    control.service_bus_namespace_public_network_access_disabled,
    control.service_bus_namespace_uses_managed_identity
  ]

  tags = merge(local.servicebus_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "service_bus_namespace_encrypted_with_cmk" {
  title       = "Service Bus namespaces should use a customer-managed key for encryption"
  description = "Azure Service Bus supports the option of encrypting data at rest with either Microsoft-managed keys (default) or customer-managed keys. Choosing to encrypt data using customer-managed keys enables you to assign, rotate, disable, and revoke access to the keys that Service Bus will use to encrypt data in your namespace."
  query       = query.service_bus_namespace_encrypted_with_cmk

  tags = local.servicebus_compliance_common_tags
}

control "service_bus_namespace_infrastructure_encryption_enabled" {
  title       = "Service Bus namespaces should have infrastructure encryption enabled"
  description = "Ensure Service Bus namespace infrastructure encryption is enabled. This control is non-complaint if namespace infrastructure encryption is disabled."
  query       = query.service_bus_namespace_infrastructure_encryption_enabled

  tags = local.servicebus_compliance_common_tags
}

control "service_bus_namespace_uses_managed_identity" {
  title       = "Service bus namespaces should use managed identity"
  description = "Use a managed identity for enhanced authentication security. A managed identity from Azure Active Directory (Azure AD) allows your namespace to easily access other Azure AD-protected resources such as Azure Key Vault. The identity is managed by the Azure platform and does not require you to provision or rotate any secrets."
  query       = query.service_bus_namespace_uses_managed_identity

  tags = local.servicebus_compliance_common_tags
}

control "service_bus_namespace_local_auth_disabled" {
  title       = "Service bus namespaces should have local authentication disabled"
  description = "Disabling local authentication methods improves security by ensuring that Service bus namespaces require Azure Active Directory identities exclusively for authentication."
  query       = query.service_bus_namespace_local_auth_disabled

  tags = local.servicebus_compliance_common_tags
}

control "service_bus_namespace_latest_tls_version" {
  title       = "Service bus namespaces should use the latest TLS version"
  description = "It is highly recommended to use the latest TLS 1.2 version for Service bus namespaces secure connections."
  query       = query.service_bus_namespace_latest_tls_version

  tags = local.servicebus_compliance_common_tags
}

control "service_bus_namespace_public_network_access_disabled" {
  title       = "Service bus namespaces should disable public network access"
  description = "Disabling public network access improves security by ensuring that your Service bus namespace is not exposed on the public internet."
  query       = query.service_bus_namespace_public_network_access_disabled

  tags = local.servicebus_compliance_common_tags
}
