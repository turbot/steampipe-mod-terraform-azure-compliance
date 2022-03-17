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
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'azurerm_app_service';