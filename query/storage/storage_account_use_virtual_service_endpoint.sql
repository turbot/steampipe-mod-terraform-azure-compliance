with storage_account_network_rules as (
    select
      name,
      type,
      path,
      start_line,
      split_part((arguments ->> 'storage_account_name'), '.',2) as storage_account_name
    from
      terraform_resource
    where
      type = 'azurerm_storage_account_network_rules' and (arguments ->> 'default_action') = 'Deny'
), storage_account_name as (
    select
      name,
      type,
      path,
      start_line
    from
      terraform_resource
    where
      type = 'azurerm_storage_account'
)
select
  san.type || ' ' || san.name as resource,
  case
    when sanr.name is null then 'alarm'
    else 'ok'
  end status,
  san.name || case
    when sanr.name is null then ' does not use virtual service endpoint'
    else ' uses virtual service endpoint'
  end || '.' reason,
  san.path || ':' || san.start_line
from
  storage_account_name as san
  left join storage_account_network_rules as sanr on sanr.storage_account_name = san.name;
