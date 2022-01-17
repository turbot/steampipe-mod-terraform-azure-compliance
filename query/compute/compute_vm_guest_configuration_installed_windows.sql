with all_windows_vm as (
  select
  '${azurerm_virtual_machine.' || name || '.id}' as id,
  *
  from
    terraform_resource
  where
    type = 'azurerm_virtual_machine' and (arguments -> 'os_profile_windows_config') is not null
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
    a.id,
    b.arguments ->> 'virtual_machine_id' as vm_id
  from
    all_windows_vm as a left join vm_extensions as b on  (b.arguments ->> 'virtual_machine_id') = a.id
  where
    (b.arguments ->> 'publisher') = 'Microsoft.GuestConfiguration'
)
select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when d.id is null then 'alarm'
    else 'ok'
  end as status,
  name || case
    when d.id is null then ' have guest configuration extension not installed'
    else ' have guest configuration extension installed'
  end || '.' reason,
  path
from
  all_windows_vm as c left join vm_guest_configuration as d on c.id = d.vm_id;