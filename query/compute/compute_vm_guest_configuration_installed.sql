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
    all_vm as a left join vm_extensions as b on (split_part((b.arguments ->> 'virtual_machine_id'), '.', 2)) = a.name
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
  end || '.' reason,
  path || ':' || start_line
from
  all_vm as c left join vm_guest_configuration as d on c.name = d.vm_name;