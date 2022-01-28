with synapse_workspaces as (
  select
    '${azurerm_synapse_workspace.' || name || '.id}' as sw_id,
    *
  from
    terraform_resource
  where
    type = 'azurerm_synapse_workspace'
), synapse_workspace_private_link as (
    select
      *
    from
      terraform_resource
    where
      type = 'azurerm_synapse_managed_private_endpoint'
)
select
  a.type || ' ' || a.name as resource,
  case
    when (s.arguments ->> 'synapse_workspace_id') is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when (s.arguments ->> 'synapse_workspace_id') is not null then ' uses private link'
    else ' not uses private link'
  end || '.' reason,
  a.path
from
  synapse_workspaces as a
  left join synapse_workspace_private_link as s on a.sw_id = ( s.arguments ->> 'synapse_workspace_id');