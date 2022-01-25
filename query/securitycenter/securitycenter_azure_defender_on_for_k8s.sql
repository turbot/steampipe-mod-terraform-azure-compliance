select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'resource_type') = 'KubernetesService' and (arguments ->> 'tier') = 'Standard' then 'ok'
    else 'skip'
  end status,
  name || case
    when (arguments ->> 'resource_type') = 'KubernetesService' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for Kubernetes Service'
    else ' Azure Defender off for Kubernetes Service'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'azurerm_security_center_subscription_pricing';