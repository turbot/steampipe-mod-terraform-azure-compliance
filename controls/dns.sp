locals {
  dns_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "Azure/DNS"
  })
}

benchmark "dns" {
  title       = "DNS"
  description = "This benchmark provides a set of controls that detect Terraform Azure DNS resources deviating from security best practices."

  children = [
    control.dns_azure_defender_enabled
  ]

  tags = merge(local.dns_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "dns_azure_defender_enabled" {
  title       = "Azure Defender for DNS should be enabled"
  description = "Azure Defender for DNS provides an additional layer of protection for your cloud resources by continuously monitoring all DNS queries from your Azure resources. Azure Defender alerts you about suspicious activity at the DNS layer."
  sql         = query.dns_azure_defender_enabled.sql

  tags = merge(local.dns_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}
