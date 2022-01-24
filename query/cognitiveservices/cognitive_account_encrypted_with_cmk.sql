with all_cognitive_account as (
  select
  *
  from
    terraform_resource
  where
    type = 'azurerm_cognitive_account'
), cognitive_account_cmk as (
    select
      *
    from
      terraform_resource
    where
      type = 'azurerm_cognitive_account_customer_managed_key'
)
select
  -- Required Columns
  c.type || ' ' || c.name as resource,
  case
    when (b.arguments ->> 'cognitive_account_id') is not null then 'ok'
    else 'alarm'
  end as status,
  c.name || case
    when (b.arguments ->> 'cognitive_account_id') is not null then ' encrypted with CMK'
    else ' not encrypted with CMK'
  end || '.' reason,
  c.path
from
  all_cognitive_account as c left join cognitive_account_cmk as b on c.name = (split_part((b.arguments ->> 'cognitive_account_id'), '.', 2))