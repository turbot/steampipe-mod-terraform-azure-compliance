query "appservice_web_app_remote_debugging_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' -> 'remote_debugging_enabled')::boolean then 'ok'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' -> 'remote_debugging_enabled')::boolean then ' remote debugging enabled'
        else ' remote debugging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_web_app_incoming_client_cert_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'client_cert_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'client_cert_enabled')::boolean then ' incoming client certificates set to on'
        else ' incoming client certificates set to off'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_authentication_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'auth_settings') is null then 'alarm'
        when (arguments -> 'auth_settings' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'auth_settings') is null then ' ''auth_settings'' not defined'
        when (arguments -> 'auth_settings' ->> 'enabled')::boolean then ' authentication set'
        else ' authentication not set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_web_app_client_certificates_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'client_cert_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'client_cert_enabled')::boolean then ' client certificate enabled'
        else ' client certificate disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_function_app_latest_tls_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'min_tls_version')::float < 1.2 then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''min_tls_version'' not defined'
        when (arguments -> 'site_config' ->> 'min_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
        else ' using the latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_azure_defender_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'resource_type') = 'AppServices' and (arguments ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      name || case
        when (arguments ->> 'resource_type') = 'AppServices' and (arguments ->> 'tier') = 'Standard' then ' Azure Defender on for AppServices'
        else ' Azure Defender off for AppServices'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_security_center_subscription_pricing';
  EOQ
}

query "appservice_web_app_register_with_active_directory_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'identity') is null then 'alarm'
        when (arguments -> 'identity' ->> 'type')::text = 'SystemAssigned' then 'ok'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'identity') is null then ' ''identity'' not defined'
        when (arguments -> 'identity' ->> 'type')::text = 'SystemAssigned' then ' register with azure active directory enabled'
        else ' register with azure active directory disabled.'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_environment_internal_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'cluster_setting') is null then 'alarm'
        when
          (arguments -> 'cluster_setting' ->> 'name')::text = 'InternalEncryption'
          and (arguments -> 'cluster_setting' ->> 'value')::text = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'cluster_setting') is null then ' ''cluster_setting'' not defined'
        when
          (arguments -> 'cluster_setting' ->> 'name')::text = 'InternalEncryption'
          and (arguments -> 'cluster_setting' ->> 'value')::text = 'true' then ' internal encryption enabled'
        else ' internal encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service_environment';
  EOQ
}

query "appservice_function_app_only_https_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'https_only')::boolean then 'ok'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'https_only')::boolean then ' https-only accessible enabled'
        else ' https-only accessible disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_web_app_diagnostic_logs_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logs') is null then 'alarm'
        when
          (arguments -> 'logs' ->> 'detailed_error_messages_enabled')::boolean
          and (arguments -> 'logs' ->> 'failed_request_tracing_enabled')::boolean
          and (arguments -> 'logs' -> 'http_logs') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'logs') is null then ' ''logs'' not defined'
        when
          (arguments -> 'logs' ->> 'detailed_error_messages_enabled')::boolean
          and (arguments -> 'logs' ->> 'failed_request_tracing_enabled')::boolean
          and (arguments -> 'logs' -> 'http_logs' -> 'file_system') is not null then ' diagnostic logs enabled'
        else ' diagnostic logs disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_web_app_latest_php_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PHP%' then 'ok'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PHP%' then' not using php version'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PHP|8.0' then ' using the latest php version'
        else ' not using latest php version'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_web_app_cors_no_star" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then ' CORS allow all domains to access the application'
        else ' CORS does not all domains to access the application'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_function_app_ftps_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
        else '  FTPS disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_web_app_latest_http_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'http2_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' HTTP version not defined'
        when (arguments -> 'site_config' ->> 'http2_enabled')::boolean then ' HTTP version is latest'
        else ' HTTP version not latest'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_ftp_deployment_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
        else '  FTPS disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app'

    union

    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
        else '  FTPS disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_function_app_latest_java_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then 'ok'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then' not using JAVA version'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text like '%11' then ' using the latest JAVA version'
        else ' not using latest JAVA version'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_function_app_client_certificates_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'client_cert_mode') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'client_cert_mode') is not null then ' cilient certificate enabled'
        else ' client certificate disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_web_app_latest_tls_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'min_tls_version')::float < 1.2 then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''min_tls_version'' not defined'
        when (arguments -> 'site_config' ->> 'min_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
        else ' using the latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_function_app_latest_http_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'http2_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' HTTP version not defined'
        when (arguments -> 'site_config' ->> 'http2_enabled')::boolean then ' HTTP version is latest'
        else ' HTTP version not latest'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_web_app_uses_managed_identity" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'identity') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'identity') is null then ' ''identity'' is not defined'
        else ' uses ' || (arguments -> 'identity' ->> 'type') || ' identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_function_app_uses_managed_identity" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'identity') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'identity') is null then ' ''identity'' is not defined'
        else ' uses ' || (arguments -> 'identity' ->> 'type') || ' identity'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_function_app_cors_no_star" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then ' CORS allow all domains to access the application'
        else ' CORS does not all domains to access the application'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_function_app_latest_python_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then 'ok'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then' not using python version'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then ' using the latest python version'
        else ' not using latest python version'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_function_app';
  EOQ
}

query "appservice_web_app_use_https" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'https_only')::boolean then 'ok'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'https_only')::boolean then ' redirects all HTTP traffic to HTTPS'
        else ' does not redirect all HTTP traffic to HTTPS'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_web_app_ftps_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
        else '  FTPS disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_web_app_latest_python_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then 'ok'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then' not using python version'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then ' using the latest python version'
        else ' not using latest python version'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_web_app_use_virtual_service_endpoint" {
  sql = <<-EOQ
    with app_service as (
      select
        '$${azurerm_app_service.' || name || '.id}' as id,
        *
      from
        terraform_resource
      where
        type = 'azurerm_app_service'
    ), app_service_vnet as (
        select
          *
        from
          terraform_resource
        where
          type = 'azurerm_app_service_slot_virtual_network_swift_connection'
          and (arguments ->> 'subnet_id') is not null
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when (s.arguments ->> 'app_service_id') is null then 'alarm'
        else 'ok'
      end as status,
      a.name || case
        when (s.arguments ->> 'app_service_id') is null then  ' not configured with virtual network service endpoint'
        else ' configured with virtual network service endpoint'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      app_service as a
      left join app_service_vnet as s on a.id = (s.arguments ->> 'app_service_id');
  EOQ
}

query "appservice_web_app_latest_java_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'site_config') is null then 'alarm'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then 'ok'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'site_config') is null then ' ''site_config'' not defined'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then' not using JAVA version'
        when (arguments -> 'site_config' ->> 'linux_fx_version')::text like '%11' then ' using the latest JAVA version'
        else ' not using latest JAVA version'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}
