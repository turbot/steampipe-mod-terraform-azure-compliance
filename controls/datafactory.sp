locals {
  datafactory_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "datafactory"
  })
}

benchmark "datafactory" {
  title       = "Data Factory"
  description = "This benchmark provides a set of controls that detect Terraform Azure Data Factory resources deviating from security best practices."

  children = [
    control.data_factory_encrypted_with_cmk
  ]
  
  tags = local.datafactory_compliance_common_tags
}

control "data_factory_encrypted_with_cmk" {
  title       = "Azure data factories should be encrypted with a customer-managed key"
  description = "Use customer-managed keys to manage the encryption at rest of your Azure Data Factory. By default, customer data is encrypted with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  sql         = query.data_factory_encrypted_with_cmk.sql

  tags = merge(local.datafactory_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

