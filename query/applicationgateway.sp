query "application_gateway_uses_https_listener" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'http_listener' ->> 'protocol') = 'Https' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'http_listener' ->> 'protocol') = 'Https' then ' uses HTTPS listener'
        else ' does not use HTTPS listener'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_application_gateway';
  EOQ
}

query "application_gateway_waf_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'waf_configuration') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'waf_configuration') is not null then ' WAF enabled'
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

query "application_gateway_use_secure_ssl_cipher" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'ssl_policy') is null then 'alarm'
        when (attributes_std -> 'ssl_policy' -> 'policy_type') is null then 'alarm'
        when (attributes_std -> 'ssl_policy' ->> 'policy_type')  = 'Predefined'
          and (attributes_std -> 'ssl_policy' ->> 'policy_name') = 'AppGwSslPolicy20220101S' then 'ok'
        when (attributes_std -> 'ssl_policy' ->> 'policy_type')  = 'Predefined'
          and (attributes_std -> 'ssl_policy' ->> 'policy_name') <> 'AppGwSslPolicy20220101S' then 'alarm'
        when (attributes_std -> 'ssl_policy' ->> 'policy_type') <> 'Predefined'
          and (attributes_std -> 'ssl_policy' ->> 'min_protocol_version') IN ('TLSv1_2', 'TLSv1_3')
          and exists (
            select 1
            from jsonb_array_elements_text(attributes_std -> 'ssl_policy' -> 'cipher_suites') as cipher
            where cipher = ANY (ARRAY['TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384', 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA', 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA', 'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384', 'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256', 'TLS_DHE_RSA_WITH_AES_256_CBC_SHA', 'TLS_DHE_RSA_WITH_AES_128_CBC_SHA', 'TLS_RSA_WITH_AES_256_GCM_SHA384', 'TLS_RSA_WITH_AES_128_GCM_SHA256', 'TLS_RSA_WITH_AES_256_CBC_SHA256', 'TLS_RSA_WITH_AES_128_CBC_SHA256', 'TLS_RSA_WITH_AES_256_CBC_SHA', 'TLS_RSA_WITH_AES_128_CBC_SHA', 'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384 ', 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA', 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA', 'TLS_DHE_DSS_WITH_AES_256_CBC_SHA256', 'TLS_DHE_DSS_WITH_AES_128_CBC_SHA256 ', 'TLS_DHE_DSS_WITH_AES_256_CBC_SHA',
            'TLS_DHE_DSS_WITH_AES_128_CBC_SHA', 'TLS_RSA_WITH_3DES_EDE_CBC_SHA', 'TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA'])
          ) then 'alarm'

        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'ssl_policy') is null then ' SSL policy not defined'
         when (attributes_std -> 'ssl_policy' -> 'policy_type') is null then ' policy type not defined'
        when (attributes_std -> 'ssl_policy' ->> 'policy_type')  = 'Predefined'
          and (attributes_std -> 'ssl_policy' ->> 'policy_name') = 'AppGwSslPolicy20220101S' then ' uses secure SSL cipher'
         when (attributes_std -> 'ssl_policy' ->> 'policy_type')  = 'Predefined'
          and (attributes_std -> 'ssl_policy' ->> 'policy_name') <> 'AppGwSslPolicy20220101S' then ' not uses secure SSL cipher'
         when (attributes_std -> 'ssl_policy' ->> 'policy_type') <> 'Predefined'
          and (attributes_std -> 'ssl_policy' ->> 'min_protocol_version') IN ('TLSv1_2', 'TLSv1_3')
          and exists (
            select 1
            from jsonb_array_elements_text(attributes_std -> 'ssl_policy' -> 'cipher_suites') as cipher
            where cipher = ANY (ARRAY['TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384', 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA', 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA', 'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384', 'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256', 'TLS_DHE_RSA_WITH_AES_256_CBC_SHA', 'TLS_DHE_RSA_WITH_AES_128_CBC_SHA', 'TLS_RSA_WITH_AES_256_GCM_SHA384', 'TLS_RSA_WITH_AES_128_GCM_SHA256', 'TLS_RSA_WITH_AES_256_CBC_SHA256', 'TLS_RSA_WITH_AES_128_CBC_SHA256', 'TLS_RSA_WITH_AES_256_CBC_SHA', 'TLS_RSA_WITH_AES_128_CBC_SHA', 'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384 ', 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA', 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA', 'TLS_DHE_DSS_WITH_AES_256_CBC_SHA256', 'TLS_DHE_DSS_WITH_AES_128_CBC_SHA256 ', 'TLS_DHE_DSS_WITH_AES_256_CBC_SHA',
            'TLS_DHE_DSS_WITH_AES_128_CBC_SHA', 'TLS_RSA_WITH_3DES_EDE_CBC_SHA', 'TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA'])
          ) then  ' not uses secure SSL cipher'
        else ' uses secure SSL cipher'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_application_gateway';
  EOQ
}
