locals {
  appservice_compliance_common_tags = merge(local.terraform_azure_compliance_common_tags, {
    service = "Azure/AppService"
  })
}

benchmark "appservice" {
  title       = "App Service"
  description = "This benchmark provides a set of controls that detect Terraform Azure App Service resources deviating from security best practices."

  children = [
    control.appservice_environment_internal_encryption_enabled,
    control.appservice_authentication_enabled,
    control.appservice_azure_defender_enabled,
    control.appservice_ftp_deployment_disabled,
    control.appservice_function_app_client_certificates_on,
    control.appservice_function_app_cors_no_star,
    control.appservice_function_app_ftps_enabled,
    control.appservice_function_app_latest_http_version,
    control.appservice_function_app_latest_java_version,
    control.appservice_function_app_latest_python_version,
    control.appservice_function_app_latest_tls_version,
    control.appservice_function_app_only_https_accessible,
    control.appservice_function_app_uses_managed_identity,
    control.appservice_web_app_client_certificates_on,
    control.appservice_web_app_cors_no_star,
    control.appservice_web_app_diagnostic_logs_enabled,
    control.appservice_web_app_ftps_enabled,
    control.appservice_web_app_incoming_client_cert_on,
    control.appservice_web_app_latest_http_version,
    control.appservice_web_app_latest_java_version,
    control.appservice_web_app_latest_php_version,
    control.appservice_web_app_latest_python_version,
    control.appservice_web_app_latest_tls_version,
    control.appservice_web_app_register_with_active_directory_enabled,
    control.appservice_web_app_remote_debugging_disabled,
    control.appservice_web_app_use_https,
    control.appservice_web_app_use_virtual_service_endpoint,
    control.appservice_web_app_uses_managed_identity
  ]

  tags = merge(local.appservice_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "appservice_web_app_use_https" {
  title       = "Web Application should only be accessible over HTTPS"
  description = "Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks."
  sql         = query.appservice_web_app_use_https.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_incoming_client_cert_on" {
  title       = "Ensure WEB app has 'Client Certificates (Incoming client certificates)' set to 'On'"
  description = "Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app."
  sql         = query.appservice_web_app_incoming_client_cert_on.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "appservice_web_app_remote_debugging_disabled" {
  title       = "Remote debugging should be turned off for Web Applications"
  description = "Remote debugging requires inbound ports to be opened on a web application. Remote debugging should be turned off."
  sql         = query.appservice_web_app_remote_debugging_disabled.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_latest_tls_version" {
  title       = "Latest TLS version should be used in your Function App"
  description = "App service currently allows the function app to set TLS versions 1.0, 1.1 and 1.2. It is highly recommended to use the latest TLS 1.2 version for function app secure connections."
  sql         = query.appservice_function_app_latest_tls_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_tls_version" {
  title       = "Latest TLS version should be used in your Web App"
  description = "App service currently allows the web app to set TLS versions 1.0, 1.1 and 1.2. It is highly recommended to use the latest TLS 1.2 version for web app secure connections."
  sql         = query.appservice_web_app_latest_tls_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_only_https_accessible" {
  title       = "Function App should only be accessible over HTTPS"
  description = "Use of HTTPS ensures server/service authentication and protects data in transit from network layer eavesdropping attacks."
  sql         = query.appservice_function_app_only_https_accessible.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_use_virtual_service_endpoint" {
  title       = "App Service should use a virtual network service endpoint"
  description = "This policy audits any App Service not configured to use a virtual network service endpoint."
  sql         = query.appservice_web_app_use_virtual_service_endpoint.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92 = "true"
  })
}

control "appservice_web_app_diagnostic_logs_enabled" {
  title       = "Diagnostic logs in App Services should be enabled"
  description = "Audit enabling of diagnostic logs on the app. This enables you to recreate activity trails for investigation purposes if a security incident occurs or your network is compromised."
  sql         = query.appservice_web_app_diagnostic_logs_enabled.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_cors_no_star" {
  title       = "CORS should not allow every resource to access your Web Applications"
  description = "Cross-Origin Resource Sharing (CORS) should not allow all domains to access your web application. Allow only required domains to interact with your web app."
  sql         = query.appservice_web_app_cors_no_star.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_cors_no_star" {
  title       = "CORS should not allow every resource to access your Function Apps"
  description = "Cross-Origin Resource Sharing (CORS) should not allow all domains to access your Function app. Allow only required domains to interact with your Function app."
  sql         = query.appservice_function_app_cors_no_star.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_uses_managed_identity" {
  title       = "Managed identity should be used in your Web App"
  description = "Use a managed identity for enhanced authentication security.A managed identity from Azure Active Directory (Azure AD) allows your app to easily access other Azure AD-protected resources such as Azure Key Vault. The identity is managed by the Azure platform and does not require you to provision or rotate any secrets"
  sql         = query.appservice_web_app_uses_managed_identity.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_uses_managed_identity" {
  title       = "Managed identity should be used in your Function App"
  description = "Use a managed identity for enhanced authentication security.A managed identity from Azure Active Directory (Azure AD) allows your app to easily access other Azure AD-protected resources such as Azure Key Vault. The identity is managed by the Azure platform and does not require you to provision or rotate any secrets"
  sql         = query.appservice_function_app_uses_managed_identity.sql

  tags = merge(local.appservice_compliance_common_tags, {
    hipaa_hitrust_v92    = "true"
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_azure_defender_enabled" {
  title       = "Azure Defender for App Service should be enabled"
  description = "Azure Defender for App Service leverages the scale of the cloud, and the visibility that Azure has as a cloud provider, to monitor for common web app attacks."
  sql         = query.appservice_azure_defender_enabled.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_client_certificates_on" {
  title       = "Ensure WEB app has 'Client Certificates (Incoming client certificates)' set to 'On'"
  description = "Client certificates allow for the app to request a certificate for incoming requests. Only clients that have a valid certificate will be able to reach the app."
  sql         = query.appservice_web_app_client_certificates_on.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_client_certificates_on" {
  title       = "Function apps should have 'Client Certificates (Incoming client certificates)' enabled"
  description = "Client certificates allow for the app to request a certificate for incoming requests. Only clients with valid certificates will be able to reach the app."
  sql         = query.appservice_function_app_client_certificates_on.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_ftps_enabled" {
  title       = "FTPS only should be required in your Function App"
  description = "Enable FTPS enforcement for enhanced security. For enhanced security, you should allow FTP over TLS/SSL only. You can also disable both FTP and FTPS if you don't use FTP deployment"
  sql         = query.appservice_function_app_ftps_enabled.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_ftps_enabled" {
  title       = "FTPS should be required in your Web App"
  description = "Enable FTPS enforcement for enhanced security. For enhanced security, you should allow FTP over TLS/SSL only. You can also disable both FTP and FTPS if you don't use FTP deployment"
  sql         = query.appservice_web_app_ftps_enabled.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_latest_http_version" {
  title       = "Ensure that 'HTTP Version' is the latest, if used to run the Function app"
  description = "Periodically, newer versions are released for HTTP either due to security flaws or to include additional functionality. Using the latest HTTP version for web apps to take advantage of security fixes, if any, and/or new functionalities of the newer version. Currently, this policy only applies to Linux web apps."
  sql         = query.appservice_function_app_latest_http_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_http_version" {
  title       = "Ensure that 'HTTP Version' is the latest, if used to run the Web app"
  description = "Periodically, newer versions are released for HTTP either due to security flaws or to include additional functionality. Using the latest HTTP version for web apps to take advantage of security fixes, if any, and/or new functionalities of the newer version. Currently, this policy only applies to Linux web apps."
  sql         = query.appservice_web_app_latest_http_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_environment_internal_encryption_enabled" {
  title       = "App Service Environment should enable internal encryption"
  description = "Setting InternalEncryption to true encrypts the pagefile, worker disks, and internal network traffic between the front ends and workers in an App Service Environment."
  sql         = query.appservice_environment_internal_encryption_enabled.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_latest_java_version" {
  title       = "Ensure that 'Java version' is the latest, if used as a part of the Function app"
  description = "Periodically, newer versions are released for Java software either due to security flaws or to include additional functionality. Using the latest Java version for Function apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  sql         = query.appservice_function_app_latest_java_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_java_version" {
  title       = "Ensure that 'Java version' is the latest, if used as a part of the Web app"
  description = "Periodically, newer versions are released for Java software either due to security flaws or to include additional functionality. Using the latest Java version for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  sql         = query.appservice_web_app_latest_java_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_php_version" {
  title       = "Ensure that 'PHP version' is the latest, if used as a part of the WEB app"
  description = "Periodically, newer versions are released for PHP software either due to security flaws or to include additional functionality. Using the latest PHP version for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  sql         = query.appservice_web_app_latest_php_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_function_app_latest_python_version" {
  title       = "Ensure that 'Python version' is the latest, if used as a part of the Function app"
  description = "Periodically, newer versions are released for Python software either due to security flaws or to include additional functionality. Using the latest Python version for Function apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  sql         = query.appservice_function_app_latest_python_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_web_app_latest_python_version" {
  title       = "Ensure that 'Python version' is the latest, if used as a part of the Web app"
  description = "Periodically, newer versions are released for Python software either due to security flaws or to include additional functionality. Using the latest Python version for web apps is recommended in order to take advantage of security fixes, if any, and/or new functionalities of the latest version. Currently, this policy only applies to Linux web apps."
  sql         = query.appservice_web_app_latest_python_version.sql

  tags = merge(local.appservice_compliance_common_tags, {
    nist_sp_800_53_rev_5 = "true"
  })
}

control "appservice_authentication_enabled" {
  title       = "Ensure App Service Authentication is set on Azure App Service"
  description = "Azure App Service Authentication is a feature that can prevent anonymous HTTP requests from reaching the API app, or authenticate those that have tokens before they reach the API app. If an anonymous request is received from a browser, App Service will redirect to a logon page. To handle the logon process, a choice from a set of identity providers can be made, or a custom authentication mechanism can be implemented."
  sql         = query.appservice_authentication_enabled.sql

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
  sql         = query.appservice_ftp_deployment_disabled.sql

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
  sql         = query.appservice_web_app_register_with_active_directory_enabled.sql

  tags = merge(local.appservice_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "9.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}