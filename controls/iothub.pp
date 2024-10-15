locals {
  iothub_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/IoTHub"
  })
}

benchmark "iothub" {
  title       = "IoT Hub"
  description = "This benchmark provides a set of controls that detect Terraform Azure IoT Hub resources deviating from security best practices."

  children = [
    control.iot_hub_logging_enabled,
    control.iot_hub_restrict_public_access
  ]

  tags = merge(local.iothub_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "iot_hub_logging_enabled" {
  title       = "Resource logs in IoT Hub should be enabled"
  description = "Audit enabling of resource logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised."
  query       = query.iot_hub_logging_enabled

  tags = merge(local.iothub_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "iot_hub_restrict_public_access" {
  title       = "IoT Hubs should disable public network access"
  description = "Disabling public network access improves security by ensuring that IoT Hub isn't exposed on the public internet. Creating private endpoints can limit exposure of IoT Hub."
  query       = query.iot_hub_restrict_public_access

  tags = local.iothub_compliance_common_tags
}
