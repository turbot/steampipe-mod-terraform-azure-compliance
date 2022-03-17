select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'purge_protection_enabled') is null then 'alarm'
    when (arguments ->> 'purge_protection_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'purge_protection_enabled') is null then ' ''purge_protection_enabled'' not set'
    when (arguments ->> 'purge_protection_enabled')::boolean then  ' purge protection enabled'
    else ' purge protection disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_key_vault_managed_hardware_security_module';
