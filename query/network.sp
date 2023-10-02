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
      a.address as resource,
      case
        when (s.attributes_std ->> 'subnet_id') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'subnet_id') is not null then ' associated with subnet'
        else ' not associated with subnet'
      end || '.' reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      all_subnet as a
      left join network_security_group_association as s on a.name = ( split_part((s.attributes_std ->> 'subnet_id'), '.', 2));
  EOQ
}

query "network_interface_ip_forwarding_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'enable_ip_forwarding')::boolean then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'enable_ip_forwarding')::boolean then ' network interface enabled with IP forwarding'
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
      a.address as resource,
      case
        when (a.attributes_std ->> 'name')::text = 'GatewaySubnet' and (s.attributes_std ->> 'subnet_id') is not null then 'alarm'
        when (a.attributes_std ->> 'name')::text = 'GatewaySubnet' and (s.attributes_std ->> 'subnet_id') is null then 'ok'
        else 'skip'
      end as status,
      split_part(a.address, '.', 2) || case
        when (a.attributes_std ->> 'name')::text = 'GatewaySubnet' and (s.attributes_std ->> 'subnet_id') is not null then ' Gateway subnet configured with network security group'
        when (a.attributes_std ->> 'name')::text = 'GatewaySubnet' and (s.attributes_std ->> 'subnet_id') is null then ' Gateway subnet not configured with network security group'
        else ' not of gateway subnet type'
      end || '.' reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      all_subnet as a
      left join network_security_group_association as s on a.name = ( split_part((s.attributes_std ->> 'subnet_id'), '.', 2));
  EOQ
}

query "network_watcher_flow_log_retention_period_90_days" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'retention_policy' ->> 'enabled') = 'false' then 'alarm'
        when (attributes_std -> 'retention_policy' ->> 'enabled') = 'true' and (attributes_std -> 'retention_policy' ->> 'days')::int >= 90 then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'retention_policy' ->> 'enabled') = 'false' then ' retention policy disabled'
        else ' retention set to ' || (attributes_std -> 'retention_policy' ->> 'days') || ' day(s)'
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
       distinct address as name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'security_rule')
          when 'array' then (attributes_std -> 'security_rule')
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
      r.address as resource,
      case
        when (attributes_std -> 'security_rule') is null then 'alarm'
        when s.name is not null then 'alarm'
        when lower(attributes_std -> 'security_rule' ->> 'protocol') = 'udp'
          and lower(attributes_std -> 'security_rule' ->> 'direction') = 'inbound'
          and lower(attributes_std -> 'security_rule' ->> 'access') = 'allow'
          and lower(attributes_std -> 'security_rule' ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') then 'alarm'
        else 'ok'
      end as status,
      split_part(r.address, '.', 2) || case
        when (attributes_std -> 'security_rule') is  null then ' security rule not defined'
        when s.name is not null then ' allows UDP services from internet'
        when lower(attributes_std -> 'security_rule' ->> 'protocol') = 'udp'
          and lower(attributes_std -> 'security_rule' ->> 'direction') = 'inbound'
          and lower(attributes_std -> 'security_rule' ->> 'access') = 'allow'
          and lower(attributes_std -> 'security_rule' ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') then ' allows UDP services from internet'
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
      address as resource,
      case
        when lower(attributes_std ->> 'protocol') = 'udp'
          and lower(attributes_std ->> 'direction') = 'inbound'
          and lower(attributes_std ->> 'access') = 'allow'
          and lower(attributes_std ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when lower(attributes_std ->> 'protocol') = 'udp'
          and lower(attributes_std ->> 'direction') = 'inbound'
          and lower(attributes_std ->> 'access') = 'allow'
          and lower(attributes_std ->> 'source_address_prefix') in ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') then ' allows UDP services from internet'
        else ' restricts UDP services from internet'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_network_security_rule';
  EOQ
}

query "network_security_rule_rdp_access_restricted" {
  sql = <<-EOQ
    with nsg_rule as (
      select
        distinct address as name
      from
        terraform_resource,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'destination_port_ranges') != 'null') and jsonb_array_length(attributes_std -> 'destination_port_ranges') > 0 then (attributes_std -> 'destination_port_ranges')
            else jsonb_build_array(attributes_std -> 'destination_port_range')
          end ) as dport,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_address_prefixes') != 'null') and jsonb_array_length(attributes_std -> 'source_address_prefixes') > 0 then (attributes_std -> 'source_address_prefixes')
            else jsonb_build_array(attributes_std -> 'source_address_prefix')
          end) as sip
      where
        type = 'azurerm_network_security_rule'
        and lower(attributes_std ->> 'access') = 'allow'
        and lower(attributes_std ->> 'direction') = 'inbound'
        and (lower(attributes_std ->> 'protocol') ilike 'TCP' or lower(attributes_std ->> 'protocol') = '*')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          dport in ('3389', '*')
          or (
            dport like '%-%'
            and split_part(dport, '-', 1) :: integer <= 3389
            and split_part(dport, '-', 2) :: integer >= 3389
          )
        )
    )
    select
      r.address as resource,
      case
        when rule.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when rule.name is null then ' restricts RDP access from internet'
        else ' allows RDP access from internet'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join nsg_rule as rule on rule.name = r.name
    where
      type = 'azurerm_network_security_rule';
  EOQ
}

query "network_security_group_rdp_access_restricted" {
  sql = <<-EOQ
    with nsg_group as (
      select
        distinct address as name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'security_rule')
            when 'array' then (attributes_std -> 'security_rule')
            when 'object' then jsonb_build_array(attributes_std -> 'security_rule')
            else null end
          ) sg,
        jsonb_array_elements_text(
          case
            when ((sg -> 'destination_port_ranges') != 'null') and jsonb_array_length(sg -> 'destination_port_ranges') > 0 then (sg -> 'destination_port_ranges')
            else jsonb_build_array(sg -> 'destination_port_range')
          end ) as dport,
        jsonb_array_elements_text(
          case
            when ((sg -> 'source_address_prefixes') != 'null') and jsonb_array_length(sg -> 'source_address_prefixes') > 0 then (sg -> 'source_address_prefixes')
            else jsonb_build_array(sg -> 'source_address_prefix')
          end) as sip
      where
        type = 'azurerm_network_security_group'
        and lower(sg ->> 'access') = 'allow'
        and lower(sg ->> 'direction') = 'inbound'
        and (lower(sg ->> 'protocol') ilike 'TCP' or lower(sg ->> 'protocol') = '*')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          dport in ('3389', '*')
          or (
            dport like '%-%'
            and split_part(dport, '-', 1) :: integer <= 3389
            and split_part(dport, '-', 2) :: integer >= 3389
          )
        )
    )
    select
      r.address as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.name is null then ' restricts RDP access from internet'
        else ' allows RDP access from internet'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join nsg_group as g on g.name = r.name
    where
      type = 'azurerm_network_security_group';
  EOQ
}

query "network_security_rule_ssh_access_restricted" {
  sql = <<-EOQ
    with nsg_rule as (
      select
        distinct address as name
      from
        terraform_resource,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'destination_port_ranges') != 'null') and jsonb_array_length(attributes_std -> 'destination_port_ranges') > 0 then (attributes_std -> 'destination_port_ranges')
            else jsonb_build_array(attributes_std -> 'destination_port_range')
          end ) as dport,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_address_prefixes') != 'null') and jsonb_array_length(attributes_std -> 'source_address_prefixes') > 0 then (attributes_std -> 'source_address_prefixes')
            else jsonb_build_array(attributes_std -> 'source_address_prefix')
          end) as sip
      where
        type = 'azurerm_network_security_rule'
        and lower(attributes_std ->> 'access') = 'allow'
        and lower(attributes_std ->> 'direction') = 'inbound'
        and (lower(attributes_std ->> 'protocol') ilike 'TCP' or lower(attributes_std ->> 'protocol') = '*')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          dport in ('22', '*')
          or (
            dport like '%-%'
            and split_part(dport, '-', 1) :: integer <= 22
            and split_part(dport, '-', 2) :: integer >= 22
          )
        )
    )
    select
      r.address as resource,
      case
        when rule.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when rule.name is null then ' restricts SSH access from internet'
        else ' allows SSH access from internet'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join nsg_rule as rule on rule.name = r.name
    where
      type = 'azurerm_network_security_rule';
  EOQ
}

query "network_security_group_ssh_access_restricted" {
  sql = <<-EOQ
    with nsg_group as (
      select
        distinct address as name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'security_rule')
            when 'array' then (attributes_std -> 'security_rule')
            when 'object' then jsonb_build_array(attributes_std -> 'security_rule')
            else null end
          ) sg,
        jsonb_array_elements_text(
          case
            when ((sg -> 'destination_port_ranges') != 'null') and jsonb_array_length(sg -> 'destination_port_ranges') > 0 then (sg -> 'destination_port_ranges')
            else jsonb_build_array(sg -> 'destination_port_range')
          end ) as dport,
        jsonb_array_elements_text(
          case
            when ((sg -> 'source_address_prefixes') != 'null') and jsonb_array_length(sg -> 'source_address_prefixes') > 0 then (sg -> 'source_address_prefixes')
            else jsonb_build_array(sg -> 'source_address_prefix')
          end) as sip
      where
        type = 'azurerm_network_security_group'
        and lower(sg ->> 'access') = 'allow'
        and lower(sg ->> 'direction') = 'inbound'
        and (lower(sg ->> 'protocol') ilike 'TCP' or lower(sg ->> 'protocol') = '*')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          dport in ('22', '*')
          or (
            dport like '%-%'
            and split_part(dport, '-', 1) :: integer <= 22
            and split_part(dport, '-', 2) :: integer >= 22
          )
        )
    )
    select
      r.address as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.name is null then ' restricts SSH access from internet'
        else ' allows SSH access from internet'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join nsg_group as g on g.name = r.name
    where
      type = 'azurerm_network_security_group';
  EOQ
}

query "network_security_rule_http_access_restricted" {
  sql = <<-EOQ
    with nsg_rule as (
      select
        distinct address as name
      from
        terraform_resource,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'destination_port_ranges') != 'null') and jsonb_array_length(attributes_std -> 'destination_port_ranges') > 0 then (attributes_std -> 'destination_port_ranges')
            else jsonb_build_array(attributes_std -> 'destination_port_range')
          end ) as dport,
        jsonb_array_elements_text(
          case
            when ((attributes_std -> 'source_address_prefixes') != 'null') and jsonb_array_length(attributes_std -> 'source_address_prefixes') > 0 then (attributes_std -> 'source_address_prefixes')
            else jsonb_build_array(attributes_std -> 'source_address_prefix')
          end) as sip
      where
        type = 'azurerm_network_security_rule'
        and lower(attributes_std ->> 'access') = 'allow'
        and lower(attributes_std ->> 'direction') = 'inbound'
        and (lower(attributes_std ->> 'protocol') ilike 'TCP' or lower(attributes_std ->> 'protocol') = '*')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          dport in ('80', '*')
          or (
            dport like '%-%'
            and split_part(dport, '-', 1) :: integer <= 80
            and split_part(dport, '-', 2) :: integer >= 80
          )
        )
    )
    select
      r.address as resource,
      case
        when rule.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when rule.name is null then ' restricts HTTP access from internet'
        else ' allows HTTP access from internet'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join nsg_rule as rule on rule.name = r.name
    where
      type = 'azurerm_network_security_rule';
  EOQ
}

query "network_security_group_http_access_restricted" {
  sql = <<-EOQ
    with nsg_group as (
      select
        distinct address as name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'security_rule')
            when 'array' then (attributes_std -> 'security_rule')
            when 'object' then jsonb_build_array(attributes_std -> 'security_rule')
            else null end
          ) sg,
        jsonb_array_elements_text(
          case
            when ((sg -> 'destination_port_ranges') != 'null') and jsonb_array_length(sg -> 'destination_port_ranges') > 0 then (sg -> 'destination_port_ranges')
            else jsonb_build_array(sg -> 'destination_port_range')
          end ) as dport,
        jsonb_array_elements_text(
          case
            when ((sg -> 'source_address_prefixes') != 'null') and jsonb_array_length(sg -> 'source_address_prefixes') > 0 then (sg -> 'source_address_prefixes')
            else jsonb_build_array(sg -> 'source_address_prefix')
          end) as sip
      where
        type = 'azurerm_network_security_group'
        and lower(sg ->> 'access') = 'allow'
        and lower(sg ->> 'direction') = 'inbound'
        and (lower(sg ->> 'protocol') ilike 'TCP' or lower(sg ->> 'protocol') = '*')
        and lower(sip) in ('*', '0.0.0.0', '0.0.0.0/0', 'internet', 'any', '<nw>/0', '/0')
        and (
          dport in ('80', '*')
          or (
            dport like '%-%'
            and split_part(dport, '-', 1) :: integer <= 80
            and split_part(dport, '-', 2) :: integer >= 80
          )
        )
    )
    select
      r.address as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.name is null then ' restricts HTTP access from internet'
        else ' allows HTTP access from internet'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join nsg_group as g on g.name = r.name
    where
      type = 'azurerm_network_security_group';
  EOQ
}
