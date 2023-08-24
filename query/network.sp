query "network_security_group_subnet_associated" {
  sql = <<-EOQ
    with all_subnet as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_subnet'
    ), network_security_group_association as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_subnet_network_security_group_association'
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when (s.arguments ->> 'subnet_id') is not null then 'ok'
        else 'alarm'
      end as status,
      a.name || case
        when (s.arguments ->> 'subnet_id') is not null then ' associated with subnet'
        else ' not associated with subnet'
      end || '.' reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      all_subnet as a
      left join network_security_group_association as s on a.name = ( split_part((s.arguments ->> 'subnet_id'), '.', 2));
  EOQ
}

query "network_interface_ip_forwarding_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'enable_ip_forwarding')::boolean then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'enable_ip_forwarding')::boolean then ' network interface enabled with IP forwarding'
        else ' network interface disabled with IP forwarding'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_network_interface'
  EOQ
}

query "network_security_group_not_configured_gateway_subnets" {
  sql = <<-EOQ
    with all_subnet as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_subnet'
    ), network_security_group_association as (
      select
        *
      from
        terraform_resource
      where
        type = 'azurerm_subnet_network_security_group_association'
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when (a.arguments ->> 'name')::text = 'GatewaySubnet' and (s.arguments ->> 'subnet_id') is not null then 'alarm'
        when (a.arguments ->> 'name')::text = 'GatewaySubnet' and (s.arguments ->> 'subnet_id') is null then 'ok'
        else 'skip'
      end as status,
      a.name || case
        when (a.arguments ->> 'name')::text = 'GatewaySubnet' and (s.arguments ->> 'subnet_id') is not null then ' Gateway subnet configured with network security group'
        when (a.arguments ->> 'name')::text = 'GatewaySubnet' and (s.arguments ->> 'subnet_id') is null then ' Gateway subnet not configured with network security group'
        else ' not of gateway subnet type'
      end || '.' reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      all_subnet as a
      left join network_security_group_association as s on a.name = ( split_part((s.arguments ->> 'subnet_id'), '.', 2));
  EOQ
}

query "network_watcher_flow_log_retention_period_90_days" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'retention_policy' ->> 'enabled') = 'false' then 'alarm'
        when (arguments -> 'retention_policy' ->> 'enabled') = 'true' and (arguments -> 'retention_policy' ->> 'days')::int >= 90 then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'retention_policy' ->> 'enabled') = 'false' then ' retention policy disabled'
        else ' retention set to ' || (arguments -> 'retention_policy' ->> 'days') || ' day(s)'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_network_watcher_flow_log';
  EOQ
}

query "network_security_group_udp_access_restricted" {
  sql = <<-EOQ
    with nsg_udp_access as (
      select
       distinct name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(arguments -> 'security_rule')
          when 'array' then (arguments -> 'security_rule')
          else null end
         ) as s
      where
        type = 'azurerm_network_security_group'
        and lower(s ->> 'protocol') = 'udp'
        and lower(s ->> 'direction') = 'inbound'
        and lower(s ->> 'access') = 'allow'
        and lower(s ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any')
    )
    select
      type || ' ' || r.name as resource,
      case
        when (arguments -> 'security_rule') is null then 'alarm'
        when s.name is not null then 'alarm'
        when lower(arguments -> 'security_rule' ->> 'protocol') = 'udp'
          and lower(arguments -> 'security_rule' ->> 'direction') = 'inbound'
          and lower(arguments -> 'security_rule' ->> 'access') = 'allow'
          and lower(arguments -> 'security_rule' ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') then 'alarm'
        else 'ok'
      end as status,
      r.name || case
        when (arguments -> 'security_rule') is  null then ' security rule not defined'
        when s.name is not null then ' allows UDP services from internet'
        when lower(arguments -> 'security_rule' ->> 'protocol') = 'udp'
          and lower(arguments -> 'security_rule' ->> 'direction') = 'inbound'
          and lower(arguments -> 'security_rule' ->> 'access') = 'allow'
          and lower(arguments -> 'security_rule' ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') then ' allows UDP services from internet'
        else ' restricts UDP services from internet'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join nsg_udp_access as s on s.name = r.name
    where
      type = 'azurerm_network_security_group';
  EOQ
}

query "network_security_rule_udp_access_restricted" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when lower(arguments ->> 'protocol') = 'udp'
          and lower(arguments ->> 'direction') = 'inbound'
          and lower(arguments ->> 'access') = 'allow'
          and lower(arguments ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') then 'alarm'
        else 'ok'
      end as status,
      name || case
        when lower(arguments ->> 'protocol') = 'udp'
          and lower(arguments ->> 'direction') = 'inbound'
          and lower(arguments ->> 'access') = 'allow'
          and lower(arguments ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') then ' allows UDP services from internet'
        else ' restricts UDP services from internet'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_network_security_rule';
  EOQ
}
