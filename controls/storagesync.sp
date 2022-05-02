locals {
  storagesync_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/StorageSync"
  })
}

benchmark "storagesync" {
  title       = "Storage Sync"
  description = "This benchmark provides a set of controls that detect Terraform Azure File Sync resources deviating from security best practices."

  children = [
    control.storage_sync_private_link_used
  ]

  tags = merge(local.storagesync_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "storage_sync_private_link_used" {
  title       = "Azure File Sync should use private link"
  description = "Creating a private endpoint for the indicated Storage Sync Service resource allows you to address your Storage Sync Service resource from within the private IP address space of your organization's network, rather than through the internet-accessible public endpoint. Creating a private endpoint by itself does not disable the public endpoint."
  sql         = query.storage_sync_private_link_used.sql

  tags = merge(local.storagesync_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

