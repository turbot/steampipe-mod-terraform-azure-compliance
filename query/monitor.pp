query "monitor_log_profile_enabled_for_all_regions" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'locations') @> '["global", "australiacentral", "australiacentral2", "australiaeast", "australiasoutheast", "brazilsouth", "brazilsoutheast", "canadacentral", "canadaeast", "centralindia", "centralus", "eastasia", "eastus", "eastus2", "francecentral", "francesouth","germanynorth", "germanywestcentral", "japaneast", "japanwest", "jioindiawest", "koreacentral", "koreasouth", "northcentralus", "northeurope",
        "norwayeast", "norwaywest", "southafricanorth", "southafricawest", "southcentralus", "southeastasia", "southindia", "switzerlandnorth", "switzerlandwest", "uaecentral", "uaenorth", "uksouth", "ukwest", "westcentralus", "westeurope", "westindia", "westus", "westus2", "westus3"]' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'locations') @> '["global", "australiacentral", "australiacentral2", "australiaeast", "australiasoutheast", "brazilsouth", "brazilsoutheast", "canadacentral", "canadaeast", "centralindia", "centralus", "eastasia", "eastus", "eastus2", "francecentral", "francesouth","germanynorth", "germanywestcentral", "japaneast", "japanwest", "jioindiawest", "koreacentral", "koreasouth", "northcentralus", "northeurope",
        "norwayeast", "norwaywest", "southafricanorth", "southafricawest", "southcentralus", "southeastasia", "southindia", "switzerlandnorth", "switzerlandwest", "uaecentral", "uaenorth", "uksouth", "ukwest", "westcentralus", "westeurope", "westindia", "westus", "westus2", "westus3"]' then ' collect activity logs from all regions'
        else ' not collect activity logs from all regions'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_monitor_log_profile';
  EOQ
}

query "monitor_logs_storage_container_not_public_accessible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'container_access_type') is null then 'ok'
        when (attributes_std ->> 'container_access_type') ilike 'Private' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'container_access_type') is null then ' container insights-operational-logs storing activity logs not publicly accessible'
        when (attributes_std ->> 'container_access_type') ilike 'Private' then ' container insights-operational-logs storing activity logs not publicly accessible'
        else ' container insights-operational-logs storing activity logs publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_storage_container'
      and (attributes_std ->> 'name') ilike 'insights-operational-logs';
  EOQ
}

query "monitor_log_profile_enabled_for_all_categories" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'categories') @> '["Write", "Action", "Delete"]' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'categories') @> '["Write", "Action", "Delete"]' then ' collects logs for categories write, delete and action'
        else ' does not collects logs for all categories.'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_monitor_log_profile';
  EOQ
}

query "monitor_log_profile_retention_365_days" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'retention_policy' ->> 'enabled')::boolean and (attributes_std -> 'retention_policy' ->> 'days')::int < 365 then 'alarm'
        when (attributes_std -> 'retention_policy' ->> 'enabled')::boolean and (attributes_std -> 'retention_policy' ->> 'days')::int >= 365 then 'ok'
        else 'alarm'
      end as status,
      case
        when (attributes_std -> 'retention_policy' ->> 'enabled')::boolean and (attributes_std -> 'retention_policy' ->> 'days')::int < 365 then ' retention policy enabled but set to ' || (attributes_std -> 'retention_policy' ->> 'days') || ' days'
        when (attributes_std -> 'retention_policy' ->> 'enabled')::boolean and (attributes_std -> 'retention_policy' ->> 'days')::int >= 365 then ' retention policy enabled and set to ' || (attributes_std -> 'retention_policy' ->> 'days') || ' days.'
        else ' retention policy disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_monitor_log_profile';
  EOQ
}
