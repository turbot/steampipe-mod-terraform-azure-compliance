locals {
  containerinstance_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/ContainerInstance"
  })
}

benchmark "containerinstance" {
  title       = "Container Instance"
  description = "This benchmark provides a set of controls that detect Terraform Azure Container Instance resources deviating from security best practices."

  children = [
    control.container_instance_container_group_in_virtual_network,
    control.container_instance_container_group_secure_environment_variable
  ]

  tags = merge(local.containerinstance_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "container_instance_container_group_in_virtual_network" {
  title       = "Container instance container groups should be in virtual network"
  description = "This control ensures that the container group is deployed into a virtual network."
  query       = query.container_instance_container_group_in_virtual_network

  tags = local.containerinstance_compliance_common_tags
}

control "container_instance_container_group_secure_environment_variable" {
  title       = "Container instance container groups should use secure environment variable"
  description = "This control ensures that the container group uses secure environment variable."
  query       = query.container_instance_container_group_secure_environment_variable

  tags = local.containerinstance_compliance_common_tags
}