locals {
  storage_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Storage"
  })
}

benchmark "storage" {
  title       = "Storage"
  description = "This benchmark provides a set of controls that detect Terraform Azure Storage resources deviating from security best practices."

  children = [
    control.storage_account_blob_containers_public_access_private,
    control.storage_account_blob_service_logging_enabled,
    control.storage_account_block_public_access,
    control.storage_account_default_network_access_rule_denied,
    control.storage_account_encryption_at_rest_using_cmk,
    control.storage_account_encryption_scopes_encrypted_at_rest_with_cmk,
    control.storage_account_infrastructure_encryption_enabled,
    control.storage_account_queue_services_logging_enabled,
    control.storage_account_replication_type_set,
    control.storage_account_restrict_network_access,
    control.storage_account_secure_transfer_required_enabled,
    control.storage_account_trusted_microsoft_services_enabled,
    control.storage_account_use_virtual_service_endpoint,
    control.storage_account_uses_azure_resource_manager,
    control.storage_account_uses_latest_minimum_tls_version,
    control.storage_account_uses_private_link,
    control.storage_azure_defender_enabled,
    control.storage_container_restrict_public_access
  ]

  tags = merge(local.storage_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "storage_account_secure_transfer_required_enabled" {
  title       = "Secure transfer to storage accounts should be enabled"
  description = "Audit requirement of Secure transfer in your storage account. Secure transfer is an option that forces your storage account to accept requests only from secure connections (HTTPS). Use of HTTPS ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking."
  query       = query.storage_account_secure_transfer_required_enabled

  tags = merge(local.storage_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_default_network_access_rule_denied" {
  title       = "Storage accounts should restrict network access"
  description = "Network access to storage accounts should be restricted. Configure network rules so only applications from allowed networks can access the storage account. To allow connections from specific internet or on-premises clients, access can be granted to traffic from specific Azure virtual networks or to public internet IP address ranges."
  query       = query.storage_account_default_network_access_rule_denied

  tags = merge(local.storage_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_use_virtual_service_endpoint" {
  title       = "Storage Accounts should use a virtual network service endpoint"
  description = "This policy audits any Storage Account not configured to use a virtual network service endpoint."
  query       = query.storage_account_use_virtual_service_endpoint

  tags = merge(local.storage_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "storage_azure_defender_enabled" {
  title       = "Azure Defender for Storage should be enabled"
  description = "Azure Defender for Storage provides detections of unusual and potentially harmful attempts to access or exploit storage accounts."
  query       = query.storage_azure_defender_enabled

  tags = merge(local.storage_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_uses_private_link" {
  title       = "Storage accounts should use private link"
  description = "Azure Private Link lets you connect your virtual network to Azure services without a public IP address at the source or destination. The Private Link platform handles the connectivity between the consumer and services over the Azure backbone network. By mapping private endpoints to your storage account, data leakage risks are reduced."
  query       = query.storage_account_uses_private_link

  tags = merge(local.storage_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_infrastructure_encryption_enabled" {
  title       = "Storage accounts should have infrastructure encryption"
  description = "Enable infrastructure encryption for higher level of assurance that the data is secure. When infrastructure encryption is enabled, data in a storage account is encrypted twice."
  query       = query.storage_account_infrastructure_encryption_enabled

  tags = merge(local.storage_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_block_public_access" {
  title       = "Storage account public access should be disallowed"
  description = "Anonymous public read access to containers and blobs in Azure Storage is a convenient way to share data but might present security risks. To prevent data breaches caused by undesired anonymous access, Microsoft recommends preventing public access to a storage account unless your scenario requires it."
  query       = query.storage_account_block_public_access

  tags = merge(local.storage_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_restrict_network_access" {
  title       = "Storage accounts should restrict network access using virtual network rules"
  description = "Protect your storage accounts from potential threats using virtual network rules as a preferred method instead of IP-based filtering. Disabling IP-based filtering prevents public IPs from accessing your storage accounts."
  query       = query.storage_account_restrict_network_access

  tags = merge(local.storage_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_encryption_at_rest_using_cmk" {
  title       = "Storage accounts should use customer-managed key for encryption"
  description = "Secure your storage account with greater flexibility using customer-managed keys. When you specify a customer-managed key, that key is used to protect and control access to the key that encrypts your data. Using customer-managed keys provides additional capabilities to control rotation of the key encryption key or cryptographically erase data."
  query       = query.storage_account_encryption_at_rest_using_cmk

  tags = merge(local.storage_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_uses_azure_resource_manager" {
  title       = "Storage accounts should be migrated to new Azure Resource Manager resources"
  description = "Use new Azure Resource Manager for your storage accounts to provide security enhancements such as: stronger access control (RBAC), better auditing, Azure Resource Manager based deployment and governance, access to managed identities, access to key vault for secrets, Azure AD-based authentication and support for tags and resource groups for easier security management."
  query       = query.storage_account_uses_azure_resource_manager

  tags = merge(local.storage_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_encryption_scopes_encrypted_at_rest_with_cmk" {
  title       = "Storage account encryption scopes should use customer-managed keys to encrypt data at rest"
  description = "Use customer-managed keys to manage the encryption at rest of your storage account encryption scopes. Customer-managed keys enable the data to be encrypted with an Azure key-vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  query       = query.storage_account_encryption_scopes_encrypted_at_rest_with_cmk

  tags = merge(local.storage_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "storage_account_blob_service_logging_enabled" {
  title       = "Ensure Storage logging is enabled for Blob service for read, write, and delete requests"
  description = "The Storage Blob service provides scalable, cost-efficient objective storage in the cloud. Storage Logging happens server-side and allows details for both successful and failed requests to be recorded in the storage account. These logs allow users to see the details of read, write, and delete operations against the blobs. Storage Logging log entries contain the following information about individual requests: Timing information such as start time, end-to-end latency, and server latency, authentication details , concurrency information and the sizes of the request and response messages."
  query       = query.storage_account_blob_service_logging_enabled

  tags = merge(local.storage_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "3.10"
    cis_level   = "2"
    cis_type    = "manual"
  })
}

control "storage_account_queue_services_logging_enabled" {
  title       = "Ensure Storage logging is enabled for Queue service for read, write, and delete requests"
  description = "The Storage Queue service stores messages that may be read by any client who has access to the storage account. A queue can contain an unlimited number of messages, each of which can be up to 64KB in size using version 2011-08-18 or newer. Storage Logging happens server-side and allows details for both successful and failed requests to be recorded in the storage account. These logs allow users to see the details of read, write, and delete operations against the queues. Storage Logging log entries contain the following information about individual requests: Timing information such as start time, end-to-end latency, and server latency, authentication details , concurrency information and the sizes of the request and response messages."
  query       = query.storage_account_queue_services_logging_enabled

  tags = merge(local.storage_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "3.3"
    cis_level   = "2"
    cis_type    = "manual"
  })
}

control "storage_account_trusted_microsoft_services_enabled" {
  title       = "Ensure 'Trusted Microsoft Services' is enabled for Storage Account access"
  description = "Some Microsoft services that interact with storage accounts operate from networks that can't be granted access through network rules. To help this type of service work as intended, allow the set of trusted Microsoft services to bypass the network rules. These services will then use strong authentication to access the storage account. If the Allow trusted Microsoft services exception is enabled, the following services: Azure Backup, Azure Site Recovery, Azure DevTest Labs, Azure Event Grid, Azure Event Hubs, Azure Networking, Azure Monitor and Azure SQL Data Warehouse (when registered in the subscription), are granted access to the storage account."
  query       = query.storage_account_trusted_microsoft_services_enabled

  tags = merge(local.storage_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "3.7"
    cis_level   = "2"
    cis_type    = "manual"
  })
}

control "storage_account_blob_containers_public_access_private" {
  title       = "Ensure that 'Public access level' is set to Private for blob containers"
  description = "Disable anonymous access to blob containers and disallow blob public access on storage account."
  query       = query.storage_account_blob_containers_public_access_private

  tags = merge(local.storage_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "3.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "storage_account_uses_latest_minimum_tls_version" {
  title       = "Storage accounts should use latest minimum TLS version"
  description = "Use the latest minimum TLS version for your storage accounts to ensure that your data is encrypted in transit."
  query       = query.storage_account_uses_latest_minimum_tls_version
}

control "storage_account_replication_type_set" {
  title       = "Storage accounts should have replication type set"
  description = "This control checks whether the replication type is set to GRS or RAGRS or GZRS or RAGZRS for the storage account."
  query       = query.storage_account_replication_type_set
}

control "storage_container_restrict_public_access" {
  title       = "Storage container public access should be disabled"
  description = "This control checks whether the public access level is set to private for the storage container."
  query       = query.storage_container_restrict_public_access
}
