locals {
  compute_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "compute"
  })
}

benchmark "compute" {
  title       = "Compute"
  description = "This benchmark provides a set of controls that detect Terraform Azure Compute resources deviating from security best practices."

  children = [
    control.compute_vm_and_scale_set_encryption_at_host_enabled,
    control.compute_vm_azure_defender_enabled,
    control.compute_vm_guest_configuration_installed_linux,
    control.compute_vm_guest_configuration_installed_windows,
    control.compute_vm_guest_configuration_installed,
    control.compute_vm_malware_agent_installed,
    control.compute_vm_system_updates_installed,
    control.compute_vm_uses_azure_resource_manager,
    control.network_interface_ip_forwarding_disabled
  ]
  
  tags = local.compute_compliance_common_tags
}

control "compute_vm_malware_agent_installed" {
  title       = "Deploy default Microsoft IaaSAntimalware extension for Windows Server"
  description = "This policy deploys a Microsoft IaaSAntimalware extension with a default configuration when a VM is not configured with the anti-malware extension."
  sql         = query.compute_vm_malware_agent_installed.sql

  tags = merge(local.compute_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "compute_vm_uses_azure_resource_manager" {
  title       = "Virtual machines should be migrated to new Azure Resource Manager resources"
  description = "Use new Azure Resource Manager for your virtual machines to provide security enhancements such as: stronger access control (RBAC), better auditing, Azure Resource Manager based deployment and governance, access to managed identities, access to key vault for secrets, Azure AD-based authentication and support for tags and resource groups for easier security management."
  sql         = query.compute_vm_uses_azure_resource_manager.sql

  tags = merge(local.compute_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_system_updates_installed" {
  title       = "System updates should be installed on your machines"
  description = "Missing security system updates on your servers will be monitored by Azure Security Center as recommendations."
  sql         = query.compute_vm_system_updates_installed.sql

  tags = merge(local.compute_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "compute_vm_azure_defender_enabled" {
  title       = "Azure Defender for servers should be enabled"
  description = "Azure Defender for servers provides real-time threat protection for server workloads and generates hardening recommendations as well as alerts about suspicious activities."
  sql         = query.securitycenter_azure_defender_on_for_server.sql

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_guest_configuration_installed_linux" {
  title       = "Deploy the Linux Guest Configuration extension to enable Guest Configuration assignments on Linux VMs"
  description = "This policy deploys the Linux Guest Configuration extension to Linux virtual machines hosted in Azure that are supported by Guest Configuration. The Linux Guest Configuration extension is a prerequisite for all Linux Guest Configuration assignments and must be deployed to machines before using any Linux Guest Configuration policy definition."
  sql         = query.compute_vm_guest_configuration_installed_linux.sql

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_guest_configuration_installed" {
  title       = "Guest Configuration extension should be installed on your machines"
  description = "To ensure secure configurations of in-guest settings of your machine, install the Guest Configuration extension. In-guest settings that the extension monitors include the configuration of the operating system, application configuration or presence, and environment settings. Once installed, in-guest policies will be available such as 'Windows Exploit guard should be enabled'."
  sql         = query.compute_vm_guest_configuration_installed.sql

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_guest_configuration_installed_windows" {
  title       = "Deploy the Windows Guest Configuration extension to enable Guest Configuration assignments on Windows VMs"
  description = "This policy deploys the Windows Guest Configuration extension to Windows virtual machines hosted in Azure that are supported by Guest Configuration. The Windows Guest Configuration extension is a prerequisite for all Windows Guest Configuration assignments and must be deployed to machines before using any Windows Guest Configuration policy definition."
  sql         = query.compute_vm_guest_configuration_installed_windows.sql

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "network_interface_ip_forwarding_disabled" {
  title       = "IP Forwarding on your virtual machine should be disabled"
  description = "Enabling IP forwarding on a virtual machine's NIC allows the machine to receive traffic addressed to other destinations. IP forwarding is rarely required (e.g., when using the VM as a network virtual appliance), and therefore, this should be reviewed by the network security team."
  sql         = query.network_interface_ip_forwarding_disabled.sql

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_and_scale_set_encryption_at_host_enabled" {
  title       = "Virtual machines and virtual machine scale sets should have encryption at host enabled"
  description = "Use encryption at host to get end-to-end encryption for your virtual machine and virtual machine scale set data. Encryption at host enables encryption at rest for your temporary disk and OS/data disk caches. Temporary and ephemeral OS disks are encrypted with platform-managed keys when encryption at host is enabled. OS/data disk caches are encrypted at rest with either customer-managed or platform-managed key, depending on the encryption type selected on the disk."
  sql         = query.compute_vm_and_scale_set_encryption_at_host_enabled.sql

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}
