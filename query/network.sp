query "application_gateway_waf_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'waf_configuration') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'waf_configuration') is not null then ' WAF enabled'
        else ' WAF disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_application_gateway';
  EOQ
}

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

