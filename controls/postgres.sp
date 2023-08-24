locals {
  postgres_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/PostgreSQL"
  })
}

benchmark "postgres" {
  title       = "PostgreSQL"
  description = "This benchmark provides a set of controls that detect Terraform Azure PostgreSQL resources deviating from security best practices."

  children = [
    control.postgres_db_flexible_server_geo_redundant_backup_enabled,
    control.postgres_db_server_connection_throttling_on,
    control.postgres_db_server_geo_redundant_backup_enabled,
    control.postgres_db_server_log_checkpoints_on,
    control.postgres_db_server_log_connections_on,
    control.postgres_db_server_log_disconnections_on,
    control.postgres_db_server_log_retention_days_3,
    control.postgres_db_server_threat_detection_policy_enabled,
    control.postgresql_server_encrypted_at_rest_using_cmk,
    control.postgresql_server_infrastructure_encryption_enabled,
    control.postgresql_server_public_network_access_disabled,
    control.postgresql_ssl_enabled
  ]

  tags = merge(local.postgres_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "postgres_db_server_geo_redundant_backup_enabled" {
  title       = "Geo-redundant backup should be enabled for Azure Database for PostgreSQL"
  description = "Azure Database for PostgreSQL allows you to choose the redundancy option for your database server. It can be set to a geo-redundant backup storage in which the data is not only stored within the region in which your server is hosted, but is also replicated to a paired region to provide recovery option in case of a region failure. Configuring geo-redundant storage for backup is only allowed during server create."
  query       = query.postgres_db_server_geo_redundant_backup_enabled

  tags = merge(local.postgres_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "postgresql_ssl_enabled" {
  title       = "Enforce SSL connection should be enabled for PostgreSQL database servers"
  description = "Azure Database for PostgreSQL supports connecting your Azure Database for PostgreSQL server to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server"
  query       = query.postgresql_ssl_enabled

  tags = merge(local.postgres_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "postgresql_server_public_network_access_disabled" {
  title       = "Public network access should be disabled for PostgreSQL servers"
  description = "Disable the public network access property to improve security and ensure your Azure Database for PostgreSQL can only be accessed from a private endpoint. This configuration disables access from any public address space outside of Azure IP range, and denies all logins that match IP or virtual network-based firewall rules."
  query       = query.postgresql_server_public_network_access_disabled

  tags = merge(local.postgres_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "postgresql_server_infrastructure_encryption_enabled" {
  title       = "Infrastructure encryption should be enabled for Azure Database for PostgreSQL servers"
  description = "Enable infrastructure encryption for Azure Database for PostgreSQL servers to have higher level of assurance that the data is secure. When infrastructure encryption is enabled, the data at rest is encrypted twice using FIPS 140-2 compliant Microsoft managed keys."
  query       = query.postgresql_server_infrastructure_encryption_enabled

  tags = merge(local.postgres_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "postgresql_server_encrypted_at_rest_using_cmk" {
  title       = "PostgreSQL servers should use customer-managed keys to encrypt data at rest"
  description = "Use customer-managed keys to manage the encryption at rest of your PostgreSQL servers. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  query       = query.postgresql_server_encrypted_at_rest_using_cmk

  tags = merge(local.postgres_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "postgres_db_server_connection_throttling_on" {
  title       = "Enable connection_throttling on PostgreSQL Servers"
  description = "Ensure server parameter 'connection_throttling' is set to 'ON' for PostgreSQL Database Server."
  query       = query.postgres_db_server_connection_throttling_on

  tags = merge(local.postgres_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.3.6"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "postgres_db_server_log_checkpoints_on" {
  title       = "Enable log_checkpoints on PostgreSQL Servers"
  description = "Ensure server parameter 'log_checkpoints' is set to 'ON' for PostgreSQL Database Server."
  query       = query.postgres_db_server_log_checkpoints_on

  tags = merge(local.postgres_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.3.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "postgres_db_server_log_connections_on" {
  title       = "Enable log_connections on PostgreSQL Servers"
  description = "Ensure server parameter 'log_connections' is set to 'ON' for PostgreSQL Database Server."
  query       = query.postgres_db_server_log_connections_on

  tags = merge(local.postgres_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.3.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "postgres_db_server_log_disconnections_on" {
  title       = "Enable log_disconnections on PostgreSQL Servers"
  description = "Ensure server parameter 'log_disconnections' is set to 'ON' for PostgreSQL Database Server."
  query       = query.postgres_db_server_log_disconnections_on

  tags = merge(local.postgres_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.3.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "postgres_db_server_log_retention_days_3" {
  title       = "Enable log_retention_days on PostgreSQL Servers"
  description = "Ensure server parameter 'log_retention_days' is greater than 3 days for PostgreSQL Database Server."
  query       = query.postgres_db_server_log_retention_days_3

  tags = merge(local.postgres_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.3.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "postgres_db_flexible_server_geo_redundant_backup_enabled" {
  title       = "PostgreSQL flexible serves Geo-redundant backup should be enabled"
  description = "Azure Database for PostgreSQL flexible serves allows you to choose the redundancy option for your database server. It can be set to a geo-redundant backup storage in which the data is not only stored within the region in which your server is hosted, but is also replicated to a paired region to provide recovery option in case of a region failure. Configuring geo-redundant storage for backup is only allowed during server create."
  query       = query.postgres_db_flexible_server_geo_redundant_backup_enabled

  tags = local.postgres_compliance_common_tags
}

control "postgres_db_server_threat_detection_policy_enabled" {
  title       = "PostgreSQL Servers threat detection policy should be enabled"
  description = "Ensure that PostgreSQL server threat detection policy is enabled. This control is non-compliant if PostgreSQL server threat detection policy is disabled."
  query       = query.postgres_db_server_threat_detection_policy_enabled

  tags = local.postgres_compliance_common_tags
}
