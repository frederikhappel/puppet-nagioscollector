define nagioscollector::resource::hostgroup (
  $members = [],
  $hostgroup_members = [],
  $description = undef,
  $force = false,
  $ensure = present
) {
  # validate parameters
  validate_array($members, $hostgroup_members)
  validate_string($description)
  validate_bool($force)
  validate_re($ensure, '^(present|absent)$')
  if empty($members) and empty($hostgroup_members) {
    fail('You have to specify at least $members or $hostgroup_members')
  }

  # export self: gets collected in Nagioscollector
  export()
}
