locals {
  healthcare_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/HealthcareAPIs"
  })
}

benchmark "healthcare" {
  title       = "Healthcare APIs"
  description = "This benchmark provides a set of controls that detect Terraform Azure Healthcare APIs resources deviating from security best practices."

  children = [
    control.healthcare_fhir_azure_api_encrypted_at_rest_with_cmk,
    control.healthcare_fhir_public_network_access_disabled
  ]

  tags = merge(local.healthcare_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "healthcare_fhir_public_network_access_disabled" {
  title       = "Azure API for FHIR should disable public network access"
  description = "Disabling public network access improves security by ensuring that Healthcare API isn't exposed on the public internet. Creating private endpoints can limit exposure of Healthcare APIs."
  query       = query.healthcare_fhir_public_network_access_disabled

  tags = local.healthcare_compliance_common_tags
}

control "healthcare_fhir_azure_api_encrypted_at_rest_with_cmk" {
  title       = "Azure API for FHIR should use a customer-managed key to encrypt data at rest"
  description = "Use a customer-managed key to control the encryption at rest of the data stored in Azure API for FHIR when this is a regulatory or compliance requirement. Customer-managed keys also deliver double encryption by adding a second layer of encryption on top of the default one done with service-managed keys."
  query       = query.healthcare_fhir_azure_api_encrypted_at_rest_with_cmk

  tags = merge(local.healthcare_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}
