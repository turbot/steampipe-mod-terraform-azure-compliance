locals {
  iothub_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "Azure/IoTHub"
  })
}

benchmark "iothub" {
  title       = "IoT Hub"
  description = "This benchmark provides a set of controls that detect Terraform Azure IoT Hub resources deviating from security best practices."

  children = [
    control.iot_hub_logging_enabled
  ]

  tags = merge(local.iothub_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "iot_hub_logging_enabled" {
  title       = "Resource logs in IoT Hub should be enabled"
  description = "Audit enabling of resource logs. This enables you to recreate activity trails to use for investigation purposes; when a security incident occurs or when your network is compromised."
  sql         = query.iot_hub_logging_enabled.sql

  tags = merge(local.iothub_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}