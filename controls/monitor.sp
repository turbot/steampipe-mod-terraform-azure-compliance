locals {
  monitor_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "Azure/Monitor"
  })
}

benchmark "monitor" {
  title       = "Monitor"
  description = "This benchmark provides a set of controls that detect Terraform Azure Monitor resources deviating from security best practices."

  children = [
    control.monitor_log_profile_enabled_for_all_categories,
    control.monitor_log_profile_enabled_for_all_regions,
    control.monitor_logs_storage_container_not_public_accessible
  ]

  tags = merge(local.monitor_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "monitor_log_profile_enabled_for_all_categories" {
  title       = "Azure Monitor log profile should collect logs for categories 'write', 'delete' and 'action'"
  description = "This policy ensures that a log profile collects logs for categories 'write', 'delete' and 'action'."
  sql         = query.monitor_log_profile_enabled_for_all_categories.sql

  tags = merge(local.monitor_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "monitor_log_profile_enabled_for_all_regions" {
  title       = "Azure Monitor should collect activity logs from all regions"
  description = "This policy audits the Azure Monitor log profile which does not export activities from all Azure supported regions including global."
  sql         = query.monitor_log_profile_enabled_for_all_regions.sql

  tags = merge(local.monitor_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "monitor_logs_storage_container_not_public_accessible" {
  title       = "Ensure the storage container storing the activity logs is not publicly accessible"
  description = "The storage account container containing the activity log export should not be publicly accessible."
  sql         = query.monitor_logs_storage_container_not_public_accessible.sql

  tags = merge(local.monitor_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "5.1.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}