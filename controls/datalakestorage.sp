locals {
  datalakestorage_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "datalakestorage"
  })
}

benchmark "datalakestorage" {
  title       = "Data Lake Storage"
  description = "This benchmark provides a set of controls that detect Terraform Azure Data Lake Storage resources deviating from security best practices."

  children = [
    control.datalake_store_account_encryption_enabled
  ]
  
  tags = local.datalakestorage_compliance_common_tags
}

control "datalake_store_account_encryption_enabled" {
  title       = "Require encryption on Data Lake Store accounts"
  description = "This policy ensures encryption is enabled on all Data Lake Store accounts."
  sql         = query.datalake_store_account_encryption_enabled.sql

  tags = merge(local.datalakestorage_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}