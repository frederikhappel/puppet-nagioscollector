define nagioscollector::resource::hostdependency (
  $dependent_host_names = [],
  $dependent_hostgroup_names = [],
  $inherits_parent = true,
  $execution_failure_criteria = 'n',
  $notification_failure_criteria = 'n',
  $hostgroup_description = undef,
  $force = false,
  $ensure = present
) {
  # validate parameters
  validate_array($dependent_host_names, $dependent_hostgroup_names)
  validate_bool($inherits_parent, $force)
  validate_string($execution_failure_criteria, $notification_failure_criteria, $hostgroup_description)
  validate_re($ensure, '^(present|absent)$')
  if empty($dependent_host_names) and empty($dependent_hostgroup_names) {
    fail('You have to specify at least $dependent_host_names or $dependent_hostgroup_names')
  }

  # create a hostgroup?
  if $hostgroup_description != undef {
    nagioscollector::resource::hostgroup {
      $name :
        ensure => $ensure,
        description => $hostgroup_description,
        members => $dependent_host_names,
        hostgroup_members => $dependent_hostgroup_names,
        force => $force ;
    }
  }

  # export self: gets collected in Nagioscollector
  export()
}
