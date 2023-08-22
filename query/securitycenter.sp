query "securitycenter_security_alerts_to_owner_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'alerts_to_admins')::bool is true and (arguments -> 'alert_notifications')::bool is true then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'alerts_to_admins')::bool is true and (arguments -> 'alert_notifications')::bool is true then ' notify alerts to admins configured'
        else ' notify alerts to admin not configured'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_contact';
  EOQ
}

query "securitycenter_azure_defender_on_for_sqldb" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'SqlServers' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'SqlServers' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for SQL database servers'
        else ' Azure Defender off for SQL database servers'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "securitycenter_azure_defender_on_for_appservice" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'AppServices' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'AppServices' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for App Services'
        else ' Azure Defender off for App Services'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "securitycenter_azure_defender_on_for_containerregistry" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'ContainerRegistry' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'ContainerRegistry' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Container Registry'
        else ' Azure Defender off for Container Registry'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "securitycenter_azure_defender_on_for_server" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'VirtualMachines' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'VirtualMachines' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Servers'
        else ' Azure Defender off for Servers'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "securitycenter_azure_defender_on_for_k8s" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'KubernetesService' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'KubernetesService' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Kubernetes Service'
        else ' Azure Defender off for Kubernetes Service'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "securitycenter_azure_defender_on_for_sqlservervm" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'SqlServerVirtualMachines' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'SqlServerVirtualMachines' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for SQL servers on machines'
        else ' Azure Defender off for SQL servers on machines'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "securitycenter_notify_alerts_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'alert_notifications')::bool is true then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'alert_notifications')::bool is true then ' notify alerts configured'
        else ' notify alerts not configured'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_contact';
  EOQ
}

query "securitycenter_azure_defender_on_for_keyvault" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'KeyVaults' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'KeyVaults' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Key Vaults'
        else ' Azure Defender off for Key Vaults'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "securitycenter_azure_defender_on_for_storage" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'StorageAccounts' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'skip'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'StorageAccounts' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Storage'
        else ' Azure Defender off for Storage'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "securitycenter_email_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'email') is not null and (arguments -> 'alert_notifications')::bool is true then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'email') is not null and (arguments -> 'alert_notifications')::bool is true then ' additional email & alert notifications configured'
        else ' additional email & alert notifications not configured'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_contact';
  EOQ
}

query "securitycenter_automatic_provisioning_monitoring_agent_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'auto_provision') = 'On' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'auto_provision') = 'On' then ' automatic provisioning of monitoring agent is on'
        else ' automatic provisioning of monitoring agent is off'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_auto_provisioning';
  EOQ
}

query "securitycenter_contact_number_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'phone') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'phone') is not null then ' contact number is configured'
        else ' contact number is not configured'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_contact';
  EOQ
}

query "securitycenter_uses_standard_pricing_tier" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'tier') = 'Standard' then ' uses standard pricing tier'
        else ' does not use standard pricing tier'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}