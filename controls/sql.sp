locals {
  sql_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/SQL"
  })
}

benchmark "sql" {
  title       = "SQL"
  description = "This benchmark provides a set of controls that detect Terraform Azure SQL resources deviating from security best practices."

  children = [
    control.sql_database_allow_internet_access,
    control.sql_database_ledger_enabled,
    control.sql_database_log_monitoring_enabled,
    control.sql_database_long_term_geo_redundant_backup_enabled,
    control.sql_database_server_azure_defender_enabled,
    control.sql_database_zone_redundant_enabled,
    control.sql_db_active_directory_admin_configured,
    control.sql_db_public_network_access_disabled,
    control.sql_server_admins_email_security_alert_enabled,
    control.sql_server_all_security_alerts_enabled,
    control.sql_server_atp_enabled,
    control.sql_server_auditing_storage_account_destination_retention_90_days,
    control.sql_server_azure_ad_authentication_enabled,
    control.sql_server_azure_defender_enabled,
    control.sql_server_email_security_alert_enabled,
    control.sql_server_uses_latest_tls_version,
    control.sql_server_vm_azure_defender_enabled
  ]

  tags = merge(local.sql_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "sql_database_long_term_geo_redundant_backup_enabled" {
  title       = "Long-term geo-redundant backup should be enabled for Azure SQL Databases"
  description = "This policy audits any Azure SQL Database with long-term geo-redundant backup not enabled."
  query       = query.sql_database_long_term_geo_redundant_backup_enabled

  tags = merge(local.sql_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_database_server_azure_defender_enabled" {
  title       = "Azure Defender for Azure SQL Database servers should be enabled"
  description = "Azure Defender for SQL provides functionality for surfacing and mitigating potential database vulnerabilities, detecting anomalous activities that could indicate threats to SQL databases, and discovering and classifying sensitive data."
  query       = query.sql_database_server_azure_defender_enabled

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_server_vm_azure_defender_enabled" {
  title       = "Azure Defender for SQL servers on machines should be enabled"
  description = "Azure Defender for SQL provides functionality for surfacing and mitigating potential database vulnerabilities, detecting anomalous activities that could indicate threats to SQL databases, and discovering and classifying sensitive data."
  query       = query.sql_server_vm_azure_defender_enabled

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_server_azure_defender_enabled" {
  title       = "Azure Defender for SQL should be enabled for unprotected Azure SQL servers"
  description = "Audit SQL servers without Advanced Data Security."
  query       = query.securitycenter_azure_defender_on_for_sqldb

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_server_azure_ad_authentication_enabled" {
  title       = "An Azure Active Directory administrator should be provisioned for SQL servers"
  description = "Audit provisioning of an Azure Active Directory administrator for your SQL server to enable Azure AD authentication. Azure AD authentication enables simplified permission management and centralized identity management of database users and other Microsoft services."
  query       = query.sql_server_azure_ad_authentication_enabled

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_db_public_network_access_disabled" {
  title       = "Public network access on Azure SQL Database should be disabled"
  description = "Disabling the public network access property improves security by ensuring your Azure SQL Database can only be accessed from a private endpoint. This configuration denies all logins that match IP or virtual network based firewall rules."
  query       = query.sql_db_public_network_access_disabled

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_server_auditing_storage_account_destination_retention_90_days" {
  title       = "SQL servers with auditing to storage account destination should be configured with 90 days retention or higher"
  description = "For incident investigation purposes, we recommend setting the data retention for your SQL Server' auditing to storage account destination to at least 90 days. Confirm that you are meeting the necessary retention rules for the regions in which you are operating. This is sometimes required for compliance with regulatory standards."
  query       = query.sql_server_auditing_storage_account_destination_retention_90_days

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_database_allow_internet_access" {
  title       = "Ensure no SQL Databases allow ingress 0.0.0.0/0 (ANY IP)"
  description = "Ensure no SQL Databases allow ingress 0.0.0.0/0 (ANY IP). SQL Server includes a firewall to block access to unauthorized connections. More granular IP addresses can be defined by referencing the range of addresses available from specific datacenters."
  query       = query.sql_database_allow_internet_access

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_server_atp_enabled" {
  title       = "Ensure that Advanced Threat Protection (ATP) on a SQL server is set to 'Enabled'"
  description = "Enable 'Azure Defender for SQL' on critical SQL Servers. It is recommended to enable Azure Defender for SQL on critical SQL Servers. Azure Defender for SQL is a unified package for advanced security capabilities"
  query       = query.sql_server_atp_enabled

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.2.1"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "sql_db_active_directory_admin_configured" {
  title       = "Ensure that Azure Active Directory Admin is configured"
  description = "Use Azure Active Directory Authentication for authentication with SQL Database."
  query       = query.sql_db_active_directory_admin_configured

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_server_email_security_alert_enabled" {
  title       = "SQL servers should have Email Security Alert enabled"
  description = "Enable Email Security Alert on SQL servers. It is recommended to enable Email Security Alert on SQL servers."
  query       = query.sql_server_email_security_alert_enabled

  tags = local.sql_compliance_common_tags
}

control "sql_server_admins_email_security_alert_enabled" {
  title       = "SQL servers should have Administrator Email Security Alert enabled"
  description = "Enable Email Security Alert on SQL server admins. It is recommended to enable Email Security Alert on SQL server admins."
  query       = query.sql_server_admins_email_security_alert_enabled

  tags = local.sql_compliance_common_tags
}

control "sql_server_all_security_alerts_enabled" {
  title       = "SQL servers should have all Security Alerts enabled"
  description = "Enable all Security Alerts on SQL servers. It is recommended to enable all Security Alerts on SQL servers."
  query       = query.sql_server_all_security_alerts_enabled

  tags = local.sql_compliance_common_tags
}

control "sql_server_uses_latest_tls_version" {
  title       = "SQL servers should use the latest TLS version 1.2"
  description = "SQL servers currently allows user to set TLS version values as Disabled, 1.0, 1.1 and 1.2. It is recommended to use the latest TLS version 1.2."
  query       = query.sql_server_uses_latest_tls_version

  tags = local.sql_compliance_common_tags
}

control "sql_database_log_monitoring_enabled" {
  title       = "SQL databases should have log monitoring enabled"
  description = "Enable audit log monitoring on SQL database. It is recommended to enable Log Monitoring on SQL database."
  query       = query.sql_database_log_monitoring_enabled

  tags = local.sql_compliance_common_tags
}

control "sql_database_zone_redundant_enabled" {
  title       = "SQL databases should be zone redundant"
  description = "This control ensures that SQL database is zone redundant."
  query       = query.sql_database_zone_redundant_enabled

  tags = local.sql_compliance_common_tags
}

control "sql_database_ledger_enabled" {
  title       = "SQL databases ledger should be enabled"
  description = "This control ensures that ledger is enabled for SQL database."
  query       = query.sql_database_ledger_enabled

  tags = local.sql_compliance_common_tags
}
