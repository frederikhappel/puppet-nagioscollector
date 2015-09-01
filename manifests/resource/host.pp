define nagioscollector::resource::host (
  $address,
  $check_command = 'puppet_host-alive-ping',
  $parents = undef,
  $hostgroups = undef,
  $icon = $::operatingsystem,
  $template = undef,
  $template_override = undef,
  $escalation_type = undef,
  $escalation_type_override = undef,
  $active = undef,
  $passive = undef,
  $notifications_enabled = undef,
  $action_url = undef,
  $notes_url = undef,
  $ensure = present
) {
  # validate parameters
  validate_ip_address($address)
  validate_string(
    $check_command, $icon, $template, $escalation_type,
    $escalation_type, $escalation_type_override,
    $action_url, $notes_url,
  )
  if $parents != undef {
    validate_array($parents)
  }
  if $hostgroups != undef {
    validate_array($hostgroups)
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
  validate_re($ensure, '^(present|absent)$')

  # export self: gets collected in Nagioscollector
  export()
}
