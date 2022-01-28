locals {
  datalakestore_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "datalakestore"
  })
}

benchmark "datalakestore" {
  title       = "Data lake Store"
  description = "This benchmark provides a set of controls that detect Terraform Azure Data Lake resources deviating from security best practices."

  children = [
    control.datalake_store_account_encryption_enabled
  ]
  
  tags = local.datalakestore_compliance_common_tags
}

control "datalake_store_account_encryption_enabled" {
  title       = "Require encryption on Data Lake Store accounts"
  description = "This policy ensures encryption is enabled on all Data Lake Store accounts."
  sql         = query.datalake_store_account_encryption_enabled.sql

  tags = merge(local.datalakestore_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}