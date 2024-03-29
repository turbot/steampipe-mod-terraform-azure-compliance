locals {
  mysql_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/MySQL"
  })
}

benchmark "mysql" {
  title       = "MySQL"
  description = "This benchmark provides a set of controls that detect Terraform Azure MySQL resources deviating from security best practices."

  children = [
    control.mysql_db_server_geo_redundant_backup_enabled,
    control.mysql_server_encrypted_at_rest_using_cmk,
    control.mysql_server_infrastructure_encryption_enabled,
    control.mysql_server_min_tls_1_2,
    control.mysql_server_public_network_access_disabled,
    control.mysql_server_threat_detection_enabled,
    control.mysql_ssl_enabled
  ]

  tags = merge(local.mysql_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "mysql_ssl_enabled" {
  title       = "Enforce SSL connection should be enabled for MySQL database servers"
  description = "Azure Database for MySQL supports connecting your Azure Database for MySQL server to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server."
  query       = query.mysql_ssl_enabled

  tags = merge(local.mysql_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "mysql_db_server_geo_redundant_backup_enabled" {
  title       = "Geo-redundant backup should be enabled for Azure Database for MySQL"
  description = "Azure Database for MySQL allows you to choose the redundancy option for your database server. It can be set to a geo-redundant backup storage in which the data is not only stored within the region in which your server is hosted, but is also replicated to a paired region to provide recovery option in case of a region failure. Configuring geo-redundant storage for backup is only allowed during server create."
  query       = query.mysql_db_server_geo_redundant_backup_enabled

  tags = merge(local.mysql_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "mysql_server_public_network_access_disabled" {
  title       = "Public network access should be disabled for MySQL servers"
  description = "Disable the public network access property to improve security and ensure your Azure Database for MySQL can only be accessed from a private endpoint. This configuration strictly disables access from any public address space outside of Azure IP range, and denies all logins that match IP or virtual network-based firewall rules."
  query       = query.mysql_server_public_network_access_disabled

  tags = merge(local.mysql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "mysql_server_infrastructure_encryption_enabled" {
  title       = "Infrastructure encryption should be enabled for Azure Database for MySQL servers"
  description = "Enable infrastructure encryption for Azure Database for MySQL servers to have higher level of assurance that the data is secure. When infrastructure encryption is enabled, the data at rest is encrypted twice using FIPS 140-2 compliant Microsoft managed keys."
  query       = query.mysql_server_infrastructure_encryption_enabled

  tags = merge(local.mysql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "mysql_server_encrypted_at_rest_using_cmk" {
  title       = "MySQL servers should use customer-managed keys to encrypt data at rest"
  description = "Use customer-managed keys to manage the encryption at rest of your MySQL servers. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  query       = query.mysql_server_encrypted_at_rest_using_cmk

  tags = merge(local.mysql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "mysql_server_min_tls_1_2" {
  title       = "Ensure 'TLS Version' is set to 'TLSV1.2' for MySQL flexible Database Server"
  description = "Ensure TLS version on MySQL flexible servers is set to the default value."
  query       = query.mysql_server_min_tls_1_2

  tags = merge(local.mysql_compliance_common_tags, {
    other_checks = "true"
  })
}

control "mysql_server_threat_detection_enabled" {
  title       = "MySQL servers should have threat detection enabled"
  description = "Ensure MySQL server threat detection policy enabled."
  query       = query.mysql_server_threat_detection_enabled

  tags = local.mysql_compliance_common_tags
}
