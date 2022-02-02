locals {
  cognitiveservice_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "cognitiveservice"
  })
}

benchmark "cognitiveservice" {
  title       = "Cognitive Service"
  description = "This benchmark provides a set of controls that detect Terraform Azure Cognitive Service resources deviating from security best practices."

  children = [
    control.cognitive_account_encrypted_with_cmk,    
    control.cognitive_account_public_network_access_disabled,
    control.cognitive_account_restrict_public_access,
    control.cognitive_service_local_auth_disabled
  ]
  
  tags = local.cognitiveservice_compliance_common_tags
}

control "cognitive_service_local_auth_disabled" {
  title       = "Cognitive Services accounts should have local authentication methods disabled"
  description = "Disabling local authentication methods improves security by ensuring that Cognitive Services accounts require Azure Active Directory identities exclusively for authentication."
  sql         = query.cognitive_service_local_auth_disabled.sql

  tags = merge(local.cognitiveservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "cognitive_account_public_network_access_disabled" {
  title       = "Cognitive Services accounts should disable public network access"
  description = "Disabling public network access improves security by ensuring that Cognitive Services account isn't exposed on the public internet. Creating private endpoints can limit exposure of Cognitive Services account."
  sql         = query.cognitive_account_public_network_access_disabled.sql

  tags = merge(local.cognitiveservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "cognitive_account_restrict_public_access" {
  title       = "Cognitive Services accounts should restrict network access"
  description = "Network access to Cognitive Services accounts should be restricted. Configure network rules so only applications from allowed networks can access the Cognitive Services account. To allow connections from specific internet or on-premises clients, access can be granted to traffic from specific Azure virtual networks or to public internet IP address ranges."
  sql         = query.cognitive_account_restrict_public_access.sql

  tags = merge(local.cognitiveservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "cognitive_account_encrypted_with_cmk" {
  title       = "Cognitive Services accounts should enable data encryption with a customer-managed key"
  description = "Customer-managed keys are commonly required to meet regulatory compliance standards. Customer-managed keys enable the data stored in Cognitive Services to be encrypted with an Azure Key Vault key created and owned by you. You have full control and responsibility for the key lifecycle, including rotation and management."
  sql         = query.cognitive_account_encrypted_with_cmk.sql

  tags = merge(local.cognitiveservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

