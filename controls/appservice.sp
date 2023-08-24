locals {
  appservice_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/AppService"
  })
}

benchmark "appservice" {
  title       = "App Service"
  description = "This benchmark provides a set of controls that detect Terraform Azure App Service resources deviating from security best practices."

  children = [
    control.appservice_authentication_enabled,
    control.appservice_azure_defender_enabled,
    control.appservice_environment_internal_encryption_enabled,
    control.appservice_ftp_deployment_disabled,
    control.appservice_function_app_builtin_logging_enabled,
    control.appservice_function_app_client_certificates_on,
    control.appservice_function_app_cors_no_star,
    control.appservice_function_app_ftps_enabled,
    control.appservice_function_app_latest_http_version,
    control.appservice_function_app_latest_java_version,
    control.appservice_function_app_latest_python_version,
    control.appservice_function_app_latest_tls_version,
    control.appservice_function_app_only_https_accessible,
    control.appservice_function_app_uses_managed_identity,
    control.appservice_plan_minimum_sku,
    control.appservice_web_app_always_on,
    control.appservice_web_app_client_certificates_on,
    control.appservice_web_app_cors_no_star,
    control.appservice_web_app_detailed_error_messages_enabled,
    control.appservice_web_app_diagnostic_logs_enabled,
    control.appservice_web_app_failed_request_tracing_enabled,
    control.appservice_web_app_ftps_enabled,
    control.appservice_web_app_health_check_enabled,
    control.appservice_web_app_http_logs_enabled,
    control.appservice_web_app_incoming_client_cert_on,
    control.appservice_web_app_latest_dotnet_framework_version,
    control.appservice_web_app_latest_http_version,
    control.appservice_web_app_latest_java_version,
    control.appservice_web_app_latest_php_version,
    control.appservice_web_app_latest_python_version,
    control.appservice_web_app_latest_tls_version,
    control.appservice_web_app_register_with_active_directory_enabled,
    control.appservice_web_app_remote_debugging_disabled,
    control.appservice_web_app_slot_latest_tls_version,
    control.appservice_web_app_slot_remote_debugging_disabled,
    control.appservice_web_app_slot_use_https,
    control.appservice_web_app_use_https,
    control.appservice_web_app_use_virtual_service_endpoint,
    control.appservice_web_app_uses_azure_file,
    control.appservice_web_app_uses_managed_identity,
    control.appservice_web_app_worker_more_than_one
  ]

  tags = merge(local.appservice_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "appservice_web_app_use_https" {
  title       = "Web Application should only be accessible over HTTPS"
  description = "Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks."
  query       = query.appservice_web_app_use_https

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_incoming_client_cert_on" {
  title       = "Ensure WEB app has 'Client Certificates (Incoming client certificates)' set to 'On'"
  description = "Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app."
  query       = query.appservice_web_app_incoming_client_cert_on

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "appservice_web_app_remote_debugging_disabled" {
  title       = "Remote debugging should be turned off for Web Applications"
  description = "Remote debugging requires inbound ports to be opened on a web application. Remote debugging should be turned off."
  query       = query.appservice_web_app_remote_debugging_disabled

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_latest_tls_version" {
  title       = "Latest TLS version should be used in your Function App"
  description = "App service currently allows the function app to set TLS versions 1.0, 1.1 and 1.2. It is highly recommended to use the latest TLS 1.2 version for function app secure connections."
  query       = query.appservice_function_app_latest_tls_version

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_tls_version" {
  title       = "Latest TLS version should be used in your Web App"
  description = "App service currently allows the web app to set TLS versions 1.0, 1.1 and 1.2. It is highly recommended to use the latest TLS 1.2 version for web app secure connections."
  query       = query.appservice_web_app_latest_tls_version

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_only_https_accessible" {
  title       = "Function App should only be accessible over HTTPS"
  description = "Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks."
  query       = query.appservice_function_app_only_https_accessible

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_use_virtual_service_endpoint" {
  title       = "App Service should use a virtual network service endpoint"
  description = "This policy audits any App Service not configured to use a virtual network service endpoint."
  query       = query.appservice_web_app_use_virtual_service_endpoint

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "appservice_web_app_diagnostic_logs_enabled" {
  title       = "Diagnostic logs in App Services should be enabled"
  description = "Audit enabling of diagnostic logs on the app. This enables you to recreate activity trails for investigation purposes if a security incident occurs or your network is compromised."
  query       = query.appservice_web_app_diagnostic_logs_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_cors_no_star" {
  title       = "CORS should not allow every resource to access your Web Applications"
  description = "Cross-Origin Resource Sharing (CORS) should not allow all domains to access your web application. Allow only required domains to interact with your web app."
  query       = query.appservice_web_app_cors_no_star

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_cors_no_star" {
  title       = "CORS should not allow every resource to access your Function Apps"
  description = "Cross-Origin Resource Sharing (CORS) should not allow all domains to access your Function app. Allow only required domains to interact with your Function app."
  query       = query.appservice_function_app_cors_no_star

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_uses_managed_identity" {
  title       = "Managed identity should be used in your Web App"
  description = "Use a managed identity for enhanced authentication security.A managed identity from Azure Active Directory (Azure AD) allows your app to easily access other Azure AD-protected resources such as Azure Key Vault. The identity is managed by the Azure platform and does not require you to provision or rotate any secrets"
  query       = query.appservice_web_app_uses_managed_identity

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_uses_managed_identity" {
  title       = "Managed identity should be used in your Function App"
  description = "Use a managed identity for enhanced authentication security.A managed identity from Azure Active Directory (Azure AD) allows your app to easily access other Azure AD-protected resources such as Azure Key Vault. The identity is managed by the Azure platform and does not require you to provision or rotate any secrets"
  query       = query.appservice_function_app_uses_managed_identity

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_azure_defender_enabled" {
  title       = "Azure Defender for App Service should be enabled"
  description = "Azure Defender for App Service leverages the scale of the cloud, and the visibility that Azure has as a cloud provider, to monitor for common web app attacks."
  query       = query.appservice_azure_defender_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_client_certificates_on" {
  title       = "Ensure WEB app has 'Client Certificates (Incoming client certificates)' set to 'On'"
  description = "Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app."
  query       = query.appservice_web_app_client_certificates_on

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_client_certificates_on" {
  title       = "Function apps should have 'Client Certificates (Incoming client certificates)' enabled"
  description = "Client certificates allow for the app to request a certificate for incoming requests. Only clients with valid certificates will be able to reach the app."
  query       = query.appservice_function_app_client_certificates_on

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_ftps_enabled" {
  title       = "FTPS only should be required in your Function App"
  description = "Enable FTPS enforcement for enhanced security. For enhanced security, you should allow FTP over TLS/SSL only. You can also disable both FTP and FTPS if you don't use FTP deployment"
  query       = query.appservice_function_app_ftps_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_ftps_enabled" {
  title       = "FTPS should be required in your Web App"
  description = "Enable FTPS enforcement for enhanced security. For enhanced security, you should allow FTP over TLS/SSL only. You can also disable both FTP and FTPS if you don't use FTP deployment"
  query       = query.appservice_web_app_ftps_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_latest_http_version" {
  title       = "Ensure that 'HTTP Version' is the latest, if used to run the Function app"
  description = "Periodically, newer versions are released for HTTP either due to security flaws or to include additional functionality. Using the latest HTTP version for web apps to take advantage of security fixes, if any, and/or new functionalities of the newer version. Currently, this policy only applies to Linux web apps."
  query       = query.appservice_function_app_latest_http_version

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_http_version" {
  title       = "Ensure that 'HTTP Version' is the latest, if used to run the Web app"
  description = "Periodically, newer versions are released for HTTP either due to security flaws or to include additional functionality. Using the latest HTTP version for web apps to take advantage of security fixes, if any, and/or new functionalities of the newer version. Currently, this policy only applies to Linux web apps."
  query       = query.appservice_web_app_latest_http_version

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_environment_internal_encryption_enabled" {
  title       = "App Service Environment should enable internal encryption"
  description = "Setting InternalEncryption to true encrypts the pagefile, worker disks, and internal network traffic between the front ends and workers in an App Service Environment."
  query       = query.appservice_environment_internal_encryption_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_latest_java_version" {
  title       = "Ensure that 'Java version' is the latest, if used as a part of the Function app"
  description = "Periodically, newer versions are released for Java software either due to security flaws or to include additional functionality. Using the latest Java version for Function apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  query       = query.appservice_function_app_latest_java_version

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_java_version" {
  title       = "Ensure that 'Java version' is the latest, if used as a part of the Web app"
  description = "Periodically, newer versions are released for Java software either due to security flaws or to include additional functionality. Using the latest Java version for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  query       = query.appservice_web_app_latest_java_version

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_php_version" {
  title       = "Ensure that 'PHP version' is the latest, if used as a part of the WEB app"
  description = "Periodically, newer versions are released for PHP software either due to security flaws or to include additional functionality. Using the latest PHP version for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  query       = query.appservice_web_app_latest_php_version

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_latest_python_version" {
  title       = "Ensure that 'Python version' is the latest, if used as a part of the Function app"
  description = "Periodically, newer versions are released for Python software either due to security flaws or to include additional functionality. Using the latest Python version for Function apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  query       = query.appservice_function_app_latest_python_version

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_python_version" {
  title       = "Ensure that 'Python version' is the latest, if used as a part of the Web app"
  description = "Periodically, newer versions are released for Python software either due to security flaws or to include additional functionality. Using the latest Python version for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  query       = query.appservice_web_app_latest_python_version

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_authentication_enabled" {
  title       = "Ensure App Service Authentication is set on Azure App Service"
  description = "Azure App Service Authentication is a feature that can prevent anonymous HTTP requests from reaching the API app, or authenticate those that have tokens before they reach the API app. If an anonymous request is received from a browser, App Service will redirect to a logon page. To handle the logon process, a choice from a set of identity providers can be made, or a custom authentication mechanism can be implemented."
  query       = query.appservice_authentication_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "9.1"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "appservice_ftp_deployment_disabled" {
  title       = "Ensure FTP deployments are disabled"
  description = "By default, Azure Functions, Web and API Services can be deployed over FTP. If FTP is required for an essential deployment workflow, FTPS should be required for FTP login for all App Service Apps and Functions."
  query       = query.appservice_ftp_deployment_disabled

  tags = merge(local.appservice_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "9.1"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "appservice_web_app_register_with_active_directory_enabled" {
  title       = "Ensure that Register with Azure Active Directory is enabled on App Service"
  description = "Managed service identity in App Service makes the app more secure by eliminating secrets from the app, such as credentials in the connection strings. When registering with Azure Active Directory in the app service, the app will connect to other Azure services securely without the need of username and passwords."
  query       = query.appservice_web_app_register_with_active_directory_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "9.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "appservice_web_app_always_on" {
  title       = "Web apps should be configured to always be on"
  description = "This control ensures that a web app is configured with settings to keep it consistently active. Always On feature of Azure App Service, keeps the host process running. This allows your site to be more responsive to requests after significant idle periods."
  query       = query.appservice_web_app_always_on

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_web_app_detailed_error_messages_enabled" {
  title       = "Web apps detailed error messages should be enabled"
  description = "This control ensures that a web app detailed error message is enabled."
  query       = query.appservice_web_app_detailed_error_messages_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_web_app_latest_dotnet_framework_version" {
  title       = "Web apps should use the latest 'Net Framework' version"
  description = "Periodically, newer versions are released for Net Framework software either due to security flaws or to include additional functionality. Using the latest Net Framework for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version."
  query       = query.appservice_web_app_latest_dotnet_framework_version

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_web_app_failed_request_tracing_enabled" {
  title       = "Web apps failed request tracing should be enabled"
  description = "Ensure that Web app enables failed request tracing. This control is non-compliant if Web app failed request tracing is disabled."
  query       = query.appservice_web_app_failed_request_tracing_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_web_app_http_logs_enabled" {
  title       = "Web apps HTTP logs should be enabled"
  description = "Ensure that Web app HTTP logs is enabled. This control is non-compliant if Web app HTTP logs is disabled."
  query       = query.appservice_web_app_http_logs_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_web_app_worker_more_than_one" {
  title       = "Web apps should have more than one worker"
  description = "It is recommended to have more than one worker for failover. This control is non-compliant if Web apps have one or less than one worker."
  query       = query.appservice_web_app_worker_more_than_one

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_web_app_health_check_enabled" {
  title       = "Web apps should have health check enabled"
  description = "Health check increases your application's availability by rerouting requests away from unhealthy instances and replacing instances if they remain unhealthy."
  query       = query.appservice_web_app_health_check_enabled

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_plan_minimum_sku" {
  title       = "App Service plans should not use free, shared or basic SKU"
  description = "The Free, Shared, and Basic plans are suitable for constrained testing and development purposes. This control is considered non-compliant when free, shared, or basic SKUs are utilized."
  query       = query.appservice_plan_minimum_sku

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_web_app_slot_remote_debugging_disabled" {
  title       = "Web app slots remote debugging should be disabled"
  description = "Remote debugging requires inbound ports to be opened on a web application. Remote debugging should be turned off."
  sql         = query.appservice_web_app_slot_remote_debugging_disabled.sql

  tags = local.appservice_compliance_common_tags
}

control "appservice_web_app_slot_use_https" {
  title       = "Web app slots should only be accessible over HTTPS"
  description = "Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks."
  query       = query.appservice_web_app_slot_use_https

  tags = merge(local.appservice_compliance_common_tags, {
    other_checks = "true"
  })
}

control "appservice_web_app_slot_latest_tls_version" {
  title       = "Web app slots should use the latest TLS version"
  description = "Periodically, newer versions are released for TLS either due to security flaws, include additional functionality, and enhance speed. Upgrade to the latest TLS version for Function apps to take advantage of security fixes, if any, and/or new functionalities of the latest version."
  query       = query.appservice_web_app_slot_latest_tls_version

  tags = local.appservice_compliance_common_tags
}

control "appservice_web_app_uses_azure_file" {
  title       = "Web apps should use Azure files"
  description = "Ensure that the application services are configured to utilize Azure Files."
  query       = query.appservice_web_app_uses_azure_file

  tags = local.appservice_compliance_common_tags
}

control "appservice_function_app_builtin_logging_enabled" {
  title       = "Function Apps builtin logging should be enabled"
  description = "Ensure that builtin logging is enabled for Function Apps."
  query       = query.appservice_function_app_builtin_logging_enabled

  tags = local.appservice_compliance_common_tags
}