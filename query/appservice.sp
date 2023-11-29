query "appservice_web_app_remote_debugging_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'site_config' ->> 'remote_debugging_enabled') = 'true' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config' ->> 'remote_debugging_enabled') = 'true' then ' remote debugging enabled'
        else ' remote debugging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_app_service', 'azurerm_linux_web_app', 'azurerm_windows_web_app');
  EOQ
}

query "appservice_web_app_incoming_client_cert_on" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'client_cert_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'client_cert_enabled')::boolean then ' incoming client certificates set to on'
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
      address as resource,
      case
        when (attributes_std -> 'auth_settings') is null then 'alarm'
        when (attributes_std -> 'auth_settings' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'auth_settings') is null then ' ''auth_settings'' not defined'
        when (attributes_std -> 'auth_settings' ->> 'enabled')::boolean then ' authentication set'
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
      address as resource,
      case
        when (attributes_std ->> 'client_cert_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'client_cert_enabled')::boolean then ' client certificate enabled'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'min_tls_version')::float < 1.2 then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''min_tls_version'' not defined'
        when (attributes_std -> 'site_config' ->> 'min_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
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
      address as resource,
      case
        when (attributes_std ->> 'resource_type') = 'AppServices' and (attributes_std ->> 'tier') = 'Standard' then 'ok'
        else 'info'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'resource_type') = 'AppServices' and (attributes_std ->> 'tier') = 'Standard' then ' Azure Defender on for AppServices'
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
      address as resource,
      case
        when (attributes_std -> 'identity') is null then 'alarm'
        when (attributes_std -> 'identity' ->> 'type')::text = 'SystemAssigned' then 'ok'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity') is null then ' ''identity'' not defined'
        when (attributes_std -> 'identity' ->> 'type')::text = 'SystemAssigned' then ' register with azure active directory enabled'
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
      address as resource,
      case
        when (attributes_std -> 'cluster_setting') is null then 'alarm'
        when
          (attributes_std -> 'cluster_setting' ->> 'name')::text = 'InternalEncryption'
          and (attributes_std -> 'cluster_setting' ->> 'value')::text = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'cluster_setting') is null then ' ''cluster_setting'' not defined'
        when
          (attributes_std -> 'cluster_setting' ->> 'name')::text = 'InternalEncryption'
          and (attributes_std -> 'cluster_setting' ->> 'value')::text = 'true' then ' internal encryption enabled'
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
      address as resource,
      case
        when (attributes_std -> 'https_only')::boolean then 'ok'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'https_only')::boolean then ' https-only accessible enabled'
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
      address as resource,
      case
        when (attributes_std -> 'logs') is null then 'alarm'
        when
          (attributes_std -> 'logs' ->> 'detailed_error_messages_enabled')::boolean
          and (attributes_std -> 'logs' ->> 'failed_request_tracing_enabled')::boolean
          and (attributes_std -> 'logs' -> 'http_logs') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'logs') is null then ' ''logs'' not defined'
        when
          (attributes_std -> 'logs' ->> 'detailed_error_messages_enabled')::boolean
          and (attributes_std -> 'logs' ->> 'failed_request_tracing_enabled')::boolean
          and (attributes_std -> 'logs' -> 'http_logs' -> 'file_system') is not null then ' diagnostic logs enabled'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'PHP%' then 'ok'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'PHP%' then' not using php version'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text = 'PHP|8.0' then ' using the latest php version'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then ' CORS allow all domains to access the application'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'http2_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' HTTP version not defined'
        when (attributes_std -> 'site_config' ->> 'http2_enabled')::boolean then ' HTTP version is latest'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then 'ok'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then' not using JAVA version'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text like '%11' then ' using the latest JAVA version'
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
      address as resource,
      case
        when (attributes_std -> 'client_cert_mode') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'client_cert_mode') is not null then ' cilient certificate enabled'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'min_tls_version')::float < 1.2 then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''min_tls_version'' not defined'
        when (attributes_std -> 'site_config' ->> 'min_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'http2_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' HTTP version not defined'
        when (attributes_std -> 'site_config' ->> 'http2_enabled')::boolean then ' HTTP version is latest'
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
      address as resource,
      case
        when (attributes_std -> 'identity') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity') is null then ' ''identity'' is not defined'
        else ' uses ' || (attributes_std -> 'identity' ->> 'type') || ' identity'
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
      address as resource,
      case
        when (attributes_std -> 'identity') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'identity') is null then ' ''identity'' is not defined'
        else ' uses ' || (attributes_std -> 'identity' ->> 'type') || ' identity'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' -> 'cors' -> 'allowed_origins') @> '["*"]' then ' CORS allow all domains to access the application'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then 'ok'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then' not using python version'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then ' using the latest python version'
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
      address as resource,
      case
        when (attributes_std -> 'https_only')::boolean then 'ok'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'https_only')::boolean then ' redirects all HTTP traffic to HTTPS'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'ftps_state')::text = 'FtpsOnly' then ' FTPS enabled'
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
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then 'ok'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'PYTHON%' then' not using python version'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then ' using the latest python version'
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
          and (attributes_std ->> 'subnet_id') is not null
    )
    select
      a.address as resource,
      case
        when (s.attributes_std ->> 'app_service_id') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(a.address, '.', 2) || case
        when (s.attributes_std ->> 'app_service_id') is null then  ' not configured with virtual network service endpoint'
        else ' configured with virtual network service endpoint'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      app_service as a
      left join app_service_vnet as s on a.id = (s.attributes_std ->> 'app_service_id');
  EOQ
}

query "appservice_web_app_latest_java_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'site_config') is null then 'alarm'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then 'ok'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text = 'PYTHON|3.9' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config') is null then ' ''site_config'' not defined'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text not like 'JAVA%' then' not using JAVA version'
        when (attributes_std -> 'site_config' ->> 'linux_fx_version')::text like '%11' then ' using the latest JAVA version'
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

query "appservice_web_app_always_on" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'site_config' ->> 'always_on') = 'false' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config' ->> 'always_on') = 'false' then ' alwaysOn disabled'
        else ' alwaysOn enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_linux_web_app', 'azurerm_windows_web_app');
  EOQ
}

query "appservice_web_app_detailed_error_messages_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'logs' ->> 'detailed_error_messages_enabled') = 'true') or ((attributes_std -> 'logs' ->> 'detailed_error_messages') = 'true') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'logs' ->> 'detailed_error_messages_enabled') = 'true') or ((attributes_std -> 'logs' ->> 'detailed_error_messages') = 'true') then ' detailed error messages enabled'
        else ' detailed error messages disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_app_service', 'azurerm_linux_web_app', 'azurerm_windows_web_app');
  EOQ
}

query "appservice_web_app_latest_dotnet_framework_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'site_config' ->> 'dotnet_framework_version') is null then 'skip'
        when (attributes_std -> 'site_config' ->> 'dotnet_framework_version') = 'v6.0' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config' ->> 'dotnet_framework_version') is null then ' not using dotnet framework'
        when (attributes_std -> 'site_config' ->> 'dotnet_framework_version') = 'v6.0' then ' using latest dotnet framework version'
        else ' not using latest dotnet framework version'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service';
  EOQ
}

query "appservice_web_app_failed_request_tracing_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'logs' ->> 'failed_request_tracing') = 'true') or ((attributes_std -> 'logs' ->> 'failed_request_tracing_enabled') = 'true') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'logs' ->> 'failed_request_tracing') = 'true') or ((attributes_std -> 'logs' ->> 'failed_request_tracing_enabled') = 'true') then ' failed request tracing enabled'
        else ' failed request tracing disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_app_service', 'azurerm_linux_web_app', 'azurerm_windows_web_app');
  EOQ
}

query "appservice_web_app_http_logs_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'logs' -> 'http_logs') is not null) or ((attributes_std -> 'logs' -> 'dynamic' -> 'http_logs') is not null) then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'logs' -> 'http_logs') is not null) or ((attributes_std -> 'logs' -> 'dynamic' -> 'http_logs') is not null) then ' HTTP logs enabled'
        else ' HTTP logs disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_app_service', 'azurerm_linux_web_app', 'azurerm_windows_web_app');
  EOQ
}

query "appservice_web_app_worker_more_than_one" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'worker_count')::int >= 2 then 'ok'
        when (attributes_std ->> 'worker_count')::int < 2 then 'alarm'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'worker_count')::int >= 2 then ' has ' || (attributes_std ->> 'worker_count') || ' number of workers'
        when (attributes_std ->> 'worker_count')::int < 2 then ' has ' || (attributes_std ->> 'worker_count') || ' number of workers'
        else ' worker count is not set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_service_plan';
  EOQ
}

query "appservice_web_app_health_check_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'site_config' -> 'health_check_path') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config' -> 'health_check_path') is not null then ' health check enabled'
        else ' health check disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_app_service', 'azurerm_linux_web_app', 'azurerm_windows_web_app');
  EOQ
}

query "appservice_plan_minimum_sku" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->>'sku_name') in ('F1', 'D1', 'B1', 'B2', 'B3') then 'alarm'
        else 'ok'
      end status,
      name || ' is of ' || (attributes_std ->>'sku_name') || ' SKU family.' as  reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_service_plan';
  EOQ
}

query "appservice_web_app_slot_remote_debugging_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'site_config' ->> 'remote_debugging_enabled') = 'true' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config' ->> 'remote_debugging_enabled') = 'true' then ' remote debugging enabled'
        else ' remote debugging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service_slot';
  EOQ
}

query "appservice_web_app_slot_use_https" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'https_only') = 'true' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'https_only') ='true' then ' accessible over HTTPS'
        else ' not accessible over HTTPS'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service_slot';
  EOQ
}

query "appservice_web_app_slot_latest_tls_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'site_config' ->> 'min_tls_version')::float < 1.2 then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'site_config' ->> 'min_tls_version')::float < 1.2 then ' not using the latest version of TLS encryption'
        else ' using the latest version of TLS encryption'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service_slot';
  EOQ
}

query "appservice_web_app_uses_azure_file" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'storage_account' ->> 'type') = 'AzureFiles' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'storage_account' ->> 'type') = 'AzureFiles' then ' uses Azure files'
        else ' not uses Azure files'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_app_service', 'azurerm_linux_web_app', 'azurerm_windows_web_app');
  EOQ
}

query "appservice_function_app_builtin_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'enable_builtin_logging') = 'false' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'enable_builtin_logging') = 'false' then ' builtin logging disabled'
        else ' builtin logging enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_function_app', 'azurerm_function_app_slot');
  EOQ
}

query "appservice_plan_zone_redundant" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'zone_balancing_enabled') is null then 'alarm'
        when (attributes_std ->> 'zone_balancing_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'zone_balancing_enabled') is null then ' ''zone_balancing_enabled'' is not set'
        when (attributes_std ->> 'zone_balancing_enabled')::bool then ' zone redundant'
        else ' not zone redundant'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_service_plan';
  EOQ
}

query "appservice_web_app_public_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'public_network_access_enabled') is null or (attributes_std ->> 'public_network_access_enabled')::bool then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'public_network_access_enabled') is null or (attributes_std ->> 'public_network_access_enabled')::bool then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_linux_web_app', 'azurerm_windows_web_app');
  EOQ
}

query "appservice_environment_zone_redundant_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'zone_redundant') is null then 'alarm'
        when (attributes_std ->> 'zone_redundant')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'zone_redundant') is null then ' ''zone_redundant'' is not set'
        when (attributes_std ->> 'zone_redundant')::bool then ' zone redundant'
        else ' not zone redundant'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'azurerm_app_service_environment_v3';
  EOQ
}

query "appservice_function_app_public_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'public_network_access_enabled') is null or (attributes_std ->> 'public_network_access_enabled')::bool then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'public_network_access_enabled') is null or (attributes_std ->> 'public_network_access_enabled')::bool then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('azurerm_linux_function_app', 'azurerm_linux_function_app_slot', 'azurerm_windows_function_app', 'azurerm_windows_function_app_slot');
  EOQ
}