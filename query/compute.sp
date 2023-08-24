query "compute_vm_system_updates_installed" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'os_profile_windows_config' ->> 'enable_automatic_upgrades')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'os_profile_windows_config' ->> 'enable_automatic_upgrades')::boolean then ' automatic system updates enabled'
        else ' automatic system updates disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_virtual_machine';
  EOQ
}

query "compute_vm_guest_configuration_installed_windows" {
  sql = <<-EOQ
    with all_windows_vm as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_virtual_machine'
        and (arguments -> 'os_profile_windows_config') is not null
    ), vm_extensions as (
        select
          *
        from
          terraform_resource
        where
          type = 'azurerm_virtual_machine_extension'
    ),
    vm_guest_configuration as (
      select
        split_part((b.arguments ->> 'virtual_machine_id'), '.', 2) as vm_name
      from
        all_windows_vm as a
        left join vm_extensions as b on  (split_part((b.arguments ->> 'virtual_machine_id'), '.', 2)) = a.name
      where
        (b.arguments ->> 'publisher') = 'Microsoft.GuestConfiguration'
    )
    select
      type || ' ' || name as resource,
      case
        when d.vm_name is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when d.vm_name is null then ' have guest configuration extension not installed'
        else ' have guest configuration extension installed'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_windows_vm as c
      left join vm_guest_configuration as d on c.name = d.vm_name;
  EOQ
}

query "compute_vm_guest_configuration_installed" {
  sql = <<-EOQ
    with all_vm as (
      select
      *
      from
        terraform_resource
      where
        type = 'azurerm_virtual_machine'
    ), vm_extensions as (
        select
          *
        from
          terraform_resource
        where
          type = 'azurerm_virtual_machine_extension'
    ),
    vm_guest_configuration as (
      select
        split_part((b.arguments ->> 'virtual_machine_id'), '.', 2) as vm_name
      from
        all_vm as a
        left join vm_extensions as b on (split_part((b.arguments ->> 'virtual_machine_id'), '.', 2)) = a.name
      where
        (b.arguments ->> 'publisher') = 'Microsoft.GuestConfiguration'
    )
    select
      type || ' ' || name as resource,
      case
        when d.vm_name is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when d.vm_name is null then ' have guest configuration extension not installed'
        else ' have guest configuration extension installed'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_vm as c
      left join vm_guest_configuration as d on c.name = d.vm_name;
  EOQ
}

query "compute_vm_utilizing_managed_disk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'storage_os_disk' ->> 'managed_disk_type') is not null or
        (arguments -> 'storage_os_disk' ->> 'managed_disk_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'storage_os_disk' ->> 'managed_disk_type') is not null or
        (arguments -> 'storage_os_disk' ->> 'managed_disk_id') is not null  then ' utilizing managed disks'
        else ' not utilizing managed disks'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_virtual_machine';
  EOQ
}

query "compute_vm_guest_configuration_installed_linux" {
  sql = <<-EOQ
    with all_linux_vm as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_virtual_machine'
        and (arguments -> 'os_profile_linux_config') is not null
    ), vm_extensions as (
        select
          *
        from
          terraform_resource
        where
          type = 'azurerm_virtual_machine_extension'
    ),
    vm_guest_configuration as (
      select
        split_part((b.arguments ->> 'virtual_machine_id'), '.', 2) as vm_name
      from
        all_linux_vm as a
        left join vm_extensions as b on  split_part((b.arguments ->> 'virtual_machine_id'), '.', 2) = a.name
      where
        (b.arguments ->> 'publisher') = 'Microsoft.GuestConfiguration'
    )
    select
      type || ' ' || name as resource,
      case
        when d.vm_name is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when d.vm_name is null then ' have guest configuration extension not installed'
        else ' have guest configuration extension installed'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_linux_vm as c
      left join vm_guest_configuration as d on c.name = d.vm_name;
  EOQ
}

query "compute_vm_and_scale_set_encryption_at_host_enabled" {
  sql = <<-EOQ
    (
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_at_host_enabled') is null then 'alarm'
        when (arguments -> 'encryption_at_host_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encryption_at_host_enabled') is null then ' ''encryption_at_host_enabled'' is not defined'
        when (arguments -> 'encryption_at_host_enabled')::boolean then ' encryption at host enabled'
        else ' encryption at host disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_linux_virtual_machine_scale_set' or
      type = 'azurerm_windows_virtual_machine_scale_set'
    )
    union
    (
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_at_host_enabled') is null then 'alarm'
        when (arguments -> 'encryption_at_host_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encryption_at_host_enabled') is null then ' ''encryption_at_host_enabled'' is not defined'
        when (arguments -> 'encryption_at_host_enabled')::boolean then ' encryption at host enabled'
        else ' encryption at host disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_windows_virtual_machine' or
      type = 'azurerm_linux_virtual_machine'
    )
  EOQ
}

query "compute_vm_uses_azure_resource_manager" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_group_name') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'resource_group_name') is not null then ' uses azure resource manager'
        else ' uses azure resource manager'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_virtual_machine';
  EOQ
}

query "compute_vm_malware_agent_installed" {
  sql = <<-EOQ
    with all_vm as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_virtual_machine'
    ), vm_extensions as (
        select
          *
        from
          terraform_resource
        where
          type = 'azurerm_virtual_machine_extension'
    ),
    vm_amtimalware_extension as (
      select
        split_part((b.arguments ->> 'virtual_machine_id'), '.', 2) as vm_name
      from
        all_vm as a
        left join vm_extensions as b on (split_part((b.arguments ->> 'virtual_machine_id'), '.', 2)) = a.name
      where
        (b.arguments ->> 'publisher') = 'Microsoft.Azure.Security'
        and (b.arguments ->> 'type') = 'IaaSAntimalware'
    )
    select
      type || ' ' || name as resource,
      case
        when d.vm_name is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when d.vm_name is null then ' IaaSAntimalware extension not installed'
        else ' IaaSAntimalware extension installed'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_vm as c left join vm_amtimalware_extension as d on c.name = d.vm_name;
  EOQ
}

query "compute_managed_disk_set_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'disk_encryption_set_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'disk_encryption_set_id') is not null then ' encryption enabled'
        else ' encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_managed_disk';
  EOQ
}

query "compute_vm_allow_extension_operations_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'allow_extension_operations')::boolean or (arguments ->> 'allow_extension_operations') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'allow_extension_operations')::boolean or (arguments ->> 'allow_extension_operations') is null then ' allow extension operations'
        else ' disallow extension operations'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_linux_virtual_machine', 'azurerm_windows_virtual_machine');
  EOQ
}

query "compute_vm_disable_password_authentication_linux" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'disable_password_authentication')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'disable_password_authentication')::boolean then ' disable password authentication'
        else ' enable password authentication'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_linux_virtual_machine';
  EOQ
}

query "compute_vm_disable_password_authentication" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'os_profile_linux_config' ->> 'disable_password_authentication')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'os_profile_linux_config' ->> 'disable_password_authentication')::boolean then ' disable password authentication'
        else ' enable password authentication'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_virtual_machine';
  EOQ
}

query "compute_vm_scale_set_disable_password_authentication_linux" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'disable_password_authentication') = 'false' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'disable_password_authentication') = 'false' then ' password authentication enabled'
        else ' password authentication disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_linux_virtual_machine_scale_set';
  EOQ
}

query "compute_vm_and_scale_set_ssh_key_enabled_linux" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'admin_ssh_key') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'admin_ssh_key') is not null then ' SSH key enabled'
        else ' SSH key disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_linux_virtual_machine_scale_set', 'azurerm_windows_virtual_machine_scale_set');
  EOQ
}

query "compute_vm_scale_set_automatic_os_upgrade_enabled" {
  sql = <<-EOQ
     select
      type || ' ' || name as resource,
      case
        when (arguments -> 'automatic_os_upgrade_policy' ->> 'enable_automatic_os_upgrade') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'automatic_os_upgrade_policy' ->> 'enable_automatic_os_upgrade') = 'true' then ' automatic OS upgrade enabled'
        else ' automatic OS upgrade disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_linux_virtual_machine_scale_set', 'azurerm_windows_virtual_machine_scale_set');
  EOQ
}
