define nagioscollector::resource::service (
  $host_name = $::fqdn,
  $service_description = $name,
  $max_check_attempts = undef,
  $check_interval_in_min = undef,
  $retry_interval_in_min = undef,
  $first_notification_delay_in_min = undef,
  $check_command = undef,
  $template = undef,
  $template_override = undef,
  $escalation_type = undef,
  $escalation_type_override = undef,
  $active = undef,
  $passive = undef,
  $notifications_enabled = undef,
  $freshness_threshold_in_seconds = undef,
  $event_handler = undef,
  $only_on_collector = undef,
  $dependent_host_name = undef,
  $dependent_service_description = undef,
  $execution_failure_criteria = 'w,u,c',
  $notification_failure_criteria = 'w,u,c,p',
  $action_url = undef,
  $inherits_parent = true,
  $ensure = present
) {
  # validate parameters
  if $max_check_attempts != undef {
    validate_integer($max_check_attempts)
  }
  if $check_interval_in_min != undef {
    validate_integer($check_interval_in_min)
  }
  if $retry_interval_in_min != undef {
    validate_integer($retry_interval_in_min)
  }
  if $first_notification_delay_in_min != undef {
    validate_integer($first_notification_delay_in_min)
  }
  if $freshness_threshold_in_seconds != undef {
    validate_integer($freshness_threshold_in_seconds)
  }
  if $only_on_collector != undef {
    validate_array($only_on_collector)
  }
  if $active != undef {
    validate_bool($active)
  }
  if $passive != undef {
    validate_bool($passive)
  }
  if $notifications_enabled != undef {
    validate_bool($notifications_enabled)
  }
  validate_string(
    $service_description, $host_name, $check_command, $event_handler,
    $template, $template_override, $escalation_type, $escalation_type_override,
    $dependent_host_name, $dependent_service_description,
  )
  validate_bool($inherits_parent)
  validate_re($execution_failure_criteria, '^(n|[owucp](,[owucp]|)*)$')
  validate_re($notification_failure_criteria, '^(n|[owucp](,[owucp]|)*)$')
  validate_re($ensure, '^(present|absent)$')

  # export self: gets collected in Nagioscollector
  export()
}
