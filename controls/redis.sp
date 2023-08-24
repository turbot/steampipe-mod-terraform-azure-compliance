locals {
  redis_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Redis"
  })
}

benchmark "redis" {
  title       = "Cache for Redis"
  description = "This benchmark provides a set of controls that detect Terraform Azure Cache for Redis resources deviating from security best practices."

  children = [
    control.azure_redis_cache_in_virtual_network,
    control.azure_redis_cache_ssl_enabled,
    control.redis_cache_min_tls_1_2,
    control.redis_cache_restrict_public_access
  ]

  tags = merge(local.redis_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "azure_redis_cache_ssl_enabled" {
  title       = "Only secure connections to your Azure Cache for Redis should be enabled"
  description = "Audit enabling of only connections via SSL to Azure Cache for Redis. Use of secure connections ensures authentication between the server and the service and protects data in transit from network layer attacks such as man-in-the-middle, eavesdropping, and session-hijacking."
  query       = query.azure_redis_cache_ssl_enabled

  tags = merge(local.redis_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "azure_redis_cache_in_virtual_network" {
  title       = "Azure Cache for Redis should reside within a virtual network"
  description = "Azure Virtual Network deployment provides enhanced security and isolation for your Azure Cache for Redis, as well as subnets, access control policies, and other features to further restrict access.When an Azure Cache for Redis instance is configured with a virtual network, it is not publicly addressable and can only be accessed from virtual machines and applications within the virtual network."
  query       = query.azure_redis_cache_in_virtual_network

  tags = merge(local.redis_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "redis_cache_min_tls_1_2" {
  title       = "Redis Caches 'Minimum TLS version' should be set to 'Version 1.2'"
  description = "This control checks whether 'Minimum TLS version' is set to 1.2. TLS 1.0 is a legacy version and has known vulnerabilities. This minimum TLS version can be configured to later protocols such as TLS 1.2."
  query       = query.redis_cache_min_tls_1_2

  tags = merge(local.redis_compliance_common_tags, {
    other_checks = "true"
  })
}

control "redis_cache_restrict_public_access" {
  title       = "Redis Caches should restrict public access"
  description = "Disabling public network access improves security by ensuring that Redis Cache isn't exposed on the public internet. Creating private endpoints can limit exposure of Redis Cache."
  query       = query.redis_cache_restrict_public_access

  tags = local.redis_compliance_common_tags
}

