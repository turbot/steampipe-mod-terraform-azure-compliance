locals {
  compute_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/Compute"
  })
}

benchmark "compute" {
  title       = "Compute"
  description = "This benchmark provides a set of controls that detect Terraform Azure Compute resources deviating from security best practices."

  children = [
    control.compute_managed_disk_set_encryption_enabled,
    control.compute_vm_allow_extension_operations_disabled,
    control.compute_vm_and_scale_set_agent_installed,
    control.compute_vm_and_scale_set_encryption_at_host_enabled,
    control.compute_vm_and_scale_set_ssh_key_enabled_linux,
    control.compute_vm_automatic_updates_enabled_windows,
    control.compute_vm_azure_defender_enabled,
    control.compute_vm_disable_password_authentication_linux,
    control.compute_vm_disable_password_authentication,
    control.compute_vm_guest_configuration_installed_linux,
    control.compute_vm_guest_configuration_installed_windows,
    control.compute_vm_guest_configuration_installed,
    control.compute_vm_malware_agent_installed,
    control.compute_vm_scale_set_automatic_os_upgrade_enabled,
    control.compute_vm_scale_set_disable_password_authentication_linux,
    control.compute_vm_system_updates_installed,
    control.compute_vm_uses_azure_resource_manager,
    control.network_interface_ip_forwarding_disabled
  ]

  tags = merge(local.compute_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "compute_vm_malware_agent_installed" {
  title       = "Deploy default Microsoft IaaSAntimalware extension for Windows Server"
  description = "This policy deploys a Microsoft IaaSAntimalware extension with a default configuration when a VM is not configured with the anti-malware extension."
  query       = query.compute_vm_malware_agent_installed

  tags = merge(local.compute_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "compute_vm_uses_azure_resource_manager" {
  title       = "Virtual machines should be migrated to new Azure Resource Manager resources"
  description = "Use new Azure Resource Manager for your virtual machines to provide security enhancements such as: stronger access control (RBAC), better auditing, Azure Resource Manager based deployment and governance, access to managed identities, access to key vault for secrets, Azure AD-based authentication and support for tags and resource groups for easier security management."
  query       = query.compute_vm_uses_azure_resource_manager

  tags = merge(local.compute_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_system_updates_installed" {
  title       = "System updates should be installed on your machines"
  description = "Missing security system updates on your servers will be monitored by Azure Security Center as recommendations."
  query       = query.compute_vm_system_updates_installed

  tags = merge(local.compute_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "compute_vm_azure_defender_enabled" {
  title       = "Azure Defender for servers should be enabled"
  description = "Azure Defender for servers provides real-time threat protection for server workloads and generates hardening recommendations as well as alerts about suspicious activities."
  query       = query.securitycenter_azure_defender_on_for_server

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_guest_configuration_installed_linux" {
  title       = "Deploy the Linux Guest Configuration extension to enable Guest Configuration assignments on Linux VMs"
  description = "This policy deploys the Linux Guest Configuration extension to Linux virtual machines hosted in Azure that are supported by Guest Configuration. The Linux Guest Configuration extension is a prerequisite for all Linux Guest Configuration assignments and must be deployed to machines before using any Linux Guest Configuration policy definition."
  query       = query.compute_vm_guest_configuration_installed_linux

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_guest_configuration_installed" {
  title       = "Guest Configuration extension should be installed on your machines"
  description = "To ensure secure configurations of in-guest settings of your machine, install the Guest Configuration extension. In-guest settings that the extension monitors include the configuration of the operating system, application configuration or presence, and environment settings. Once installed, in-guest policies will be available such as 'Windows Exploit guard should be enabled'."
  query       = query.compute_vm_guest_configuration_installed

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_guest_configuration_installed_windows" {
  title       = "Deploy the Windows Guest Configuration extension to enable Guest Configuration assignments on Windows VMs"
  description = "This policy deploys the Windows Guest Configuration extension to Windows virtual machines hosted in Azure that are supported by Guest Configuration. The Windows Guest Configuration extension is a prerequisite for all Windows Guest Configuration assignments and must be deployed to machines before using any Windows Guest Configuration policy definition."
  query       = query.compute_vm_guest_configuration_installed_windows

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "network_interface_ip_forwarding_disabled" {
  title       = "IP Forwarding on your virtual machine should be disabled"
  description = "Enabling IP forwarding on a virtual machine's NIC allows the machine to receive traffic addressed to other destinations. IP forwarding is rarely required (e.g., when using the VM as a network virtual appliance), and therefore, this should be reviewed by the network security team."
  query       = query.network_interface_ip_forwarding_disabled

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_vm_and_scale_set_encryption_at_host_enabled" {
  title       = "Virtual machines and virtual machine scale sets should have encryption at host enabled"
  description = "Use encryption at host to get end-to-end encryption for your virtual machine and virtual machine scale set data. Encryption at host enables encryption at rest for your temporary disk and OS/data disk caches. Temporary and ephemeral OS disks are encrypted with platform-managed keys when encryption at host is enabled. OS/data disk caches are encrypted at rest with either customer-managed or platform-managed key, depending on the encryption type selected on the disk."
  query       = query.compute_vm_and_scale_set_encryption_at_host_enabled

  tags = merge(local.compute_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "compute_managed_disk_set_encryption_enabled" {
  title       = "Managed disks should be encrypted"
  description = "Managed disks should be encrypted to protect data at rest. Encryption at rest is enabled by default for all new managed disks."
  query       = query.compute_managed_disk_set_encryption_enabled

  tags = local.compute_compliance_common_tags
}

control "compute_vm_allow_extension_operations_disabled" {
  title       = "Virtual machines should not allow extension operations"
  description = "Virtual machines should not allow extension operations to prevent unauthorized users from adding extensions to virtual machines."
  query       = query.compute_vm_allow_extension_operations_disabled

  tags = local.compute_compliance_common_tags
}

control "compute_vm_disable_password_authentication" {
  title       = "Virtual machines should disable password authentication"
  description = "Virtual machines should disable password authentication to prevent brute-force attacks."
  query       = query.compute_vm_disable_password_authentication

  tags = local.compute_compliance_common_tags
}

control "compute_vm_disable_password_authentication_linux" {
  title       = "Linux virtual machines should disable password authentication"
  description = "Linux virtual machines should disable password authentication to prevent brute-force attacks."
  query       = query.compute_vm_disable_password_authentication_linux

  tags = local.compute_compliance_common_tags
}

control "compute_vm_scale_set_disable_password_authentication_linux" {
  title       = "Linux virtual machines scale sets should disable password authentication"
  description = "Linux virtual machines scale sets should disable password authentication to prevent brute-force attacks."
  query       = query.compute_vm_scale_set_disable_password_authentication_linux

  tags = local.compute_compliance_common_tags
}

control "compute_vm_and_scale_set_ssh_key_enabled_linux" {
  title       = "Linux Virtual machines and scale sets should enable SSH key authentication"
  description = "Ensure linux VM enables SSH with keys for secure communication."
  query       = query.compute_vm_and_scale_set_ssh_key_enabled_linux

  tags = local.compute_compliance_common_tags
}

control "compute_vm_scale_set_automatic_os_upgrade_enabled" {
  title       = "Compute virtual machine scale sets should have automatic OS image patching enabled"
  description = "This control checks whether virtual machine scale sets have automatic OS image patching enabled."
  query       = query.compute_vm_scale_set_automatic_os_upgrade_enabled

  tags = merge(local.compute_compliance_common_tags, {
    other_checks = "true"
  })
}

control "compute_vm_automatic_updates_enabled_windows" {
  title       = "Windows Virtual machines and scale sets should have automatic updates enabled."
  description = "This control checks whether windows virtual machine and scale sets have automatic updates enabled."
  query       = query.compute_vm_automatic_updates_enabled_windows

  tags = local.compute_compliance_common_tags
}

control "compute_vm_and_scale_set_agent_installed" {
  title       = "Virtual machines and scale sets should have agent installed."
  description = "This control checks whether windows virtual machine and scale sets have automatic updates enabled."
  query       = query.compute_vm_and_scale_set_agent_installed

  tags = local.compute_compliance_common_tags
}
