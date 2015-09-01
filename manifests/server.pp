# Class: nagioscollector
#
# This module manages nagioscollector
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class nagioscollector::server (
  $collector_tag,
  $master_host = undef,
  $master_event_handler = 'handle-master-host-event',
  $item_types = {},
  $host_checks_active = true,
  $host_checks_passive = false,
  $write_debug_file = false,
  $ensure = present
) inherits nagioscollector::params {
  # validate parameters
  if !is_string($collector_tag) and !is_array($collector_tag) {
    fail('$collector_tag needs to be of type String or Array')
  }
  validate_hash($item_types)
  validate_string($master_host, $master_event_handler)
  validate_bool($host_checks_active, $host_checks_passive, $write_debug_file)
  validate_absolute_path($resourcesdir)
  validate_re($ensure, '^(present|absent)$')

  # files and directories
  $cfgfile_hosts = "${resourcesdir}/hosts.cfg"
  $cfgfile_hostescalations = "${resourcesdir}/hostescalations.cfg"
  $cfgfile_hostgroups = "${resourcesdir}/hostgroups.cfg"
  $cfgfile_hostdependencies = "${resourcesdir}/hostdependencies.cfg"
  $cfgfile_services = "${resourcesdir}/services.cfg"
  $cfgfile_serviceescalations = "${resourcesdir}/serviceescalations.cfg"
  $cfgfile_parent_hosts = "${cfgdir}/parent_hosts.txt"

  case $ensure {
    present: {
      # manage directories
      File {
          owner => $user,
          group => $group,
          mode => '0600',
          backup => false,
      }
      file {
        $resourcesdir :
          ensure => directory,
          recurse => true,
          purge => true,
          force => true ;
      }

      # collect exported host related resources and populate nagios configuration files
      $existing_hosts = nagioscollector_existing_hosts($collector_tag)
      $exported_hostgroups = pdbresourcequery(
        [ 'and',
          [ '=', 'tag', $collector_tag ],
          [ '=', 'type', 'Nagioscollector::Resource::Hostgroup' ],
          [ '=', 'exported', true ],
          [ '=', ['parameter', 'ensure'], 'present'],
        ]
      )
      $exported_hostdependencies = pdbresourcequery(
        [ 'and',
          [ '=', 'tag', $collector_tag ],
          [ '=', 'type', 'Nagioscollector::Resource::Hostdependency' ],
          [ '=', 'exported', true ],
          [ '=', ['parameter', 'ensure'], 'present'],
        ]
      )
      $parent_hosts = nagioscollector_parent_hosts($exported_hostdependencies)
      if $write_debug_file {
        file {
          '/tmp/nagiosCollectorServer.debug' :
            content => template('nagioscollector/debug.erb') ;
        }
      }
      file {
        $cfgfile_hosts :
          content => template('nagioscollector/hosts.cfg.erb'),
          notify => Service[$service_name] ;

        $cfgfile_hostgroups :
          content => template('nagioscollector/hostgroups.cfg.erb'),
          notify => Service[$service_name] ;

        $cfgfile_hostdependencies :
          content => template('nagioscollector/hostdependencies.cfg.erb'),
          notify => Service[$service_name] ;

        $cfgfile_parent_hosts :
          content => template('nagioscollector/parent_hosts.txt.erb') ;

        $cfgfile_hostescalations :
          ensure => empty($item_types) ? { false => present, default => absent },
          content => template('nagioscollector/hostescalations.cfg.erb'),
          notify => Service[$service_name] ;
      }

      # collect exported service resources and populate nagios configuration files
      file {
        $cfgfile_services :
          content => template('nagioscollector/services.cfg.erb'),
          notify => Service[$service_name] ;

        $cfgfile_serviceescalations :
          ensure => empty($item_types) ? { false => present, default => absent },
          content => template('nagioscollector/serviceescalations.cfg.erb'),
          notify => Service[$service_name] ;
      }
    }

    absent: {
      # remove leftovers
      file {
        [$resourcesdir] :
          ensure => absent,
          force => true,
          recurse => true ;
      }
    }
  }
}
