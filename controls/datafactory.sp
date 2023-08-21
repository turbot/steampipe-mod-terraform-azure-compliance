locals {
  datafactory_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/DataFactory"
  })
}

benchmark "datafactory" {
  title       = "Data Factory"
  description = "This benchmark provides a set of controls that detect Terraform Azure Data Factory resources deviating from security best practices."

  children = [
    control.data_factory_encrypted_with_cmk,
    control.data_factory_public_network_access_disabled,
    control.data_factory_uses_git_repository
  ]

  tags = merge(local.datafactory_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "data_factory_encrypted_with_cmk" {
  title       = "Azure data factories should be encrypted with a customer-managed key"
  description = "Use customer-managed keys to manage the encryption at rest of your Azure Data Factory. By default, customer data is encrypted with service-managed keys, but customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  query       = query.data_factory_encrypted_with_cmk

  tags = merge(local.datafactory_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "data_factory_public_network_access_disabled" {
  title       = "Data factories should have public network access disabled"
  description = "Disable public network access on your Data factory to prevent the account from being accessed from the public internet. This prevents the account from being accessed from the public internet."
  query       = query.data_factory_public_network_access_disabled

  tags = local.datafactory_compliance_common_tags
}

control "data_factory_uses_git_repository" {
  title       = "Data factories should use GitHub repository"
  description = "Ensure that Data Factory utilizes a Git repository as its source control mechanism. This control is non-compliant if Data Factory Git repository is not configured."
  query       = query.data_factory_uses_git_repository

  tags = merge(local.datafactory_compliance_common_tags, {
    fundamental_security = "true"
  })
}
