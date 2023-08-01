locals {
  securitycenter_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/SecurityCenter"
  })
}

benchmark "securitycenter" {
  title       = "Security Center"
  description = "This benchmark provides a set of controls that detect Terraform Azure Security Center resources deviating from security best practices."

  children = [
    control.securitycenter_automatic_provisioning_monitoring_agent_on,
    control.securitycenter_azure_defender_on_for_appservice,
    control.securitycenter_azure_defender_on_for_containerregistry,
    control.securitycenter_azure_defender_on_for_k8s,
    control.securitycenter_azure_defender_on_for_keyvault,
    control.securitycenter_azure_defender_on_for_server,
    control.securitycenter_azure_defender_on_for_sqldb,
    control.securitycenter_azure_defender_on_for_sqlservervm,
    control.securitycenter_azure_defender_on_for_storage,
    control.securitycenter_email_configured,
    control.securitycenter_notify_alerts_configured,
    control.securitycenter_security_alerts_to_owner_enabled
  ]

  tags = merge(local.securitycenter_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "securitycenter_automatic_provisioning_monitoring_agent_on" {
  title       = "Auto provisioning of the Log Analytics agent should be enabled on your subscription"
  description = "To monitor for security vulnerabilities and threats, Azure Security Center collects data from your Azure virtual machines. Data is collected by the Log Analytics agent, formerly known as the Microsoft Monitoring Agent (MMA), which reads various security-related configurations and event logs from the machine and copies the data to your Log Analytics workspace for analysis. We recommend enabling auto provisioning to automatically deploy the agent to all supported Azure VMs and any new ones that are created."
  query       = query.securitycenter_automatic_provisioning_monitoring_agent_on

  tags = merge(local.securitycenter_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "securitycenter_notify_alerts_configured" {
  title       = "Email notification for high severity alerts should be enabled"
  description = "To ensure the relevant people in your organization are notified when there is a potential security breach in one of your subscriptions, enable email notifications for high severity alerts in Security Center."
  query       = query.securitycenter_notify_alerts_configured

  tags = merge(local.securitycenter_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "securitycenter_security_alerts_to_owner_enabled" {
  title       = "Email notification to subscription owner for high severity alerts should be enabled"
  description = "To ensure your subscription owners are notified when there is a potential security breach in their subscription, set email notifications to subscription owners for high severity alerts in Security Center."
  query       = query.securitycenter_security_alerts_to_owner_enabled

  tags = merge(local.securitycenter_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "securitycenter_email_configured" {
  title       = "Subscriptions should have a contact email address for security issues"
  description = "To ensure the relevant people in your organization are notified when there is a potential security breach in one of your subscriptions, set a security contact to receive email notifications from Security Center."
  query       = query.securitycenter_email_configured

  tags = merge(local.securitycenter_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "securitycenter_azure_defender_on_for_sqlservervm" {
  title       = "Azure Defender for SQL should be enabled for unprotected SQL Managed Instances"
  description = "Audit each SQL Managed Instance without advanced data security. Turning on Azure Defender enables threat detection for SQL Managed Instance, providing threat intelligence, anomaly detection, and behavior analytics in the Azure Security Center"
  query       = query.securitycenter_azure_defender_on_for_sqlservervm

  tags = merge(local.securitycenter_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "securitycenter_azure_defender_on_for_appservice" {
  title       = "Ensure that Azure Defender is set to On for App Service"
  description = "Turning on Azure Defender enables threat detection for App Service, providing threat intelligence, anomaly detection, and behavior analytics in the Azure Security Center."
  query       = query.securitycenter_azure_defender_on_for_appservice

  tags = merge(local.securitycenter_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "2.2"
    cis_type    = "manual"
    cis_level   = "2"
  })
}

control "securitycenter_azure_defender_on_for_containerregistry" {
  title       = "Ensure that Azure Defender is set to On for Container Registries"
  description = "Turning on Azure Defender enables threat detection for Container Registries, providing threat intelligence, anomaly detection, and behavior analytics in the Azure Security Center."
  query       = query.securitycenter_azure_defender_on_for_containerregistry

  tags = merge(local.securitycenter_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "2.7"
    cis_type    = "manual"
    cis_level   = "2"
  })
}

control "securitycenter_azure_defender_on_for_k8s" {
  title       = "Ensure that Azure Defender is set to On for Kubernetes"
  description = "Turning on Azure Defender enables threat detection for Kubernetes, providing threat intelligence, anomaly detection, and behavior analytics in the Azure Security Center."
  query       = query.securitycenter_azure_defender_on_for_k8s

  tags = merge(local.securitycenter_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "2.6"
    cis_type    = "manual"
    cis_level   = "2"
  })
}

control "securitycenter_azure_defender_on_for_keyvault" {
  title       = "Ensure that Azure Defender is set to On for Key Vault"
  description = "Turning on Azure Defender enables threat detection for Key Vault, providing threat intelligence, anomaly detection, and behavior analytics in the Azure Security Center."
  query       = query.securitycenter_azure_defender_on_for_keyvault

  tags = merge(local.securitycenter_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "2.8"
    cis_type    = "manual"
    cis_level   = "2"
  })
}

control "securitycenter_azure_defender_on_for_server" {
  title       = "Ensure that Azure Defender is set to On for Servers"
  description = "Turning on Azure Defender enables threat detection for Server, providing threat intelligence, anomaly detection, and behavior analytics in the Azure Security Center."
  query       = query.securitycenter_azure_defender_on_for_server

  tags = merge(local.securitycenter_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "2.1"
    cis_type    = "manual"
    cis_level   = "2"
  })
}

control "securitycenter_azure_defender_on_for_sqldb" {
  title       = "Ensure that Azure Defender is set to On for Azure SQL database servers"
  description = "Turning on Azure Defender enables threat detection for Azure SQL database servers, providing threat intelligence, anomaly detection, and behavior analytics in the Azure Security Center."
  query       = query.securitycenter_azure_defender_on_for_sqldb

  tags = merge(local.securitycenter_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "2.3"
    cis_type    = "manual"
    cis_level   = "2"
  })
}

control "securitycenter_azure_defender_on_for_storage" {
  title       = "Ensure that Azure Defender is set to On for Storage"
  description = "Turning on Azure Defender enables threat detection for Storage, providing threat intelligence, anomaly detection, and behavior analytics in the Azure Security Center."
  query       = query.securitycenter_azure_defender_on_for_storage

  tags = merge(local.securitycenter_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "2.5"
    cis_type    = "manual"
    cis_level   = "2"
  })
}
