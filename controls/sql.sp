locals {
  sql_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "sql"
  })
}

benchmark "sql" {
  title       = "SQL"
  description = "This benchmark provides a set of controls that detect Terraform Azure SQL resources deviating from security best practices."

  children = [
    control.sql_database_allow_internet_access,
    control.sql_database_long_term_geo_redundant_backup_enabled,
    control.sql_database_server_azure_defender_enabled,
    control.sql_db_active_directory_admin_configured,
    control.sql_db_public_network_access_disabled,
    control.sql_server_atp_enabled,
    control.sql_server_auditing_storage_account_destination_retention_90_days,
    control.sql_server_azure_ad_authentication_enabled,
    control.sql_server_azure_defender_enabled,
    control.sql_server_vm_azure_defender_enabled
  ]
  
  tags = local.sql_compliance_common_tags
}

control "sql_database_long_term_geo_redundant_backup_enabled" {
  title       = "Long-term geo-redundant backup should be enabled for Azure SQL Databases"
  description = "This policy audits any Azure SQL Database with long-term geo-redundant backup not enabled."
  sql         = query.sql_database_long_term_geo_redundant_backup_enabled.sql

  tags = merge(local.sql_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_database_server_azure_defender_enabled" {
  title       = "Azure Defender for Azure SQL Database servers should be enabled"
  description = "Azure Defender for SQL provides functionality for surfacing and mitigating potential database vulnerabilities, detecting anomalous activities that could indicate threats to SQL databases, and discovering and classifying sensitive data."
  sql         = query.sql_database_server_azure_defender_enabled.sql

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_server_vm_azure_defender_enabled" {
  title       = "Azure Defender for SQL servers on machines should be enabled"
  description = "Azure Defender for SQL provides functionality for surfacing and mitigating potential database vulnerabilities, detecting anomalous activities that could indicate threats to SQL databases, and discovering and classifying sensitive data."
  sql         = query.sql_server_vm_azure_defender_enabled.sql

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_server_azure_defender_enabled" {
  title       = "Azure Defender for SQL should be enabled for unprotected Azure SQL servers"
  description = "Audit SQL servers without Advanced Data Security."
  sql         = query.securitycenter_azure_defender_on_for_sqldb.sql

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_server_azure_ad_authentication_enabled" {
  title       = "An Azure Active Directory administrator should be provisioned for SQL servers"
  description = "Audit provisioning of an Azure Active Directory administrator for your SQL server to enable Azure AD authentication. Azure AD authentication enables simplified permission management and centralized identity management of database users and other Microsoft services."
  sql         = query.sql_server_azure_ad_authentication_enabled.sql

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_db_public_network_access_disabled" {
  title       = "Public network access on Azure SQL Database should be disabled"
  description = "Disabling the public network access property improves security by ensuring your Azure SQL Database can only be accessed from a private endpoint. This configuration denies all logins that match IP or virtual network based firewall rules."
  sql         = query.sql_db_public_network_access_disabled.sql

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_server_auditing_storage_account_destination_retention_90_days" {
  title       = "SQL servers with auditing to storage account destination should be configured with 90 days retention or higher"
  description = "For incident investigation purposes, we recommend setting the data retention for your SQL Server' auditing to storage account destination to at least 90 days. Confirm that you are meeting the necessary retention rules for the regions in which you are operating. This is sometimes required for compliance with regulatory standards."
  sql         = query.sql_server_auditing_storage_account_destination_retention_90_days.sql

  tags = merge(local.sql_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "sql_database_allow_internet_access" {
  title       = "Ensure no SQL Databases allow ingress 0.0.0.0/0 (ANY IP)"
  description = "Ensure no SQL Databases allow ingress 0.0.0.0/0 (ANY IP). SQL Server includes a firewall to block access to unauthorized connections. More granular IP addresses can be defined by referencing the range of addresses available from specific datacenters."
  sql         = query.sql_database_allow_internet_access.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_server_atp_enabled" {
  title       = "Ensure that Advanced Threat Protection (ATP) on a SQL server is set to 'Enabled'"
  description = "Enable 'Azure Defender for SQL' on critical SQL Servers."
  sql         = query.sql_server_atp_enabled.sql

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
  sql         = query.sql_db_active_directory_admin_configured.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "4.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}



