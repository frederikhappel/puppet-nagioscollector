class nagioscollector::params (
  $cfgdir = '/etc/nagios',
  $cfgddir = '/etc/nagios/conf.d',
  $service_name = 'nagios',
  $user = 'nagios',
  $group = 'nagios'
) {
  # files and directories
  $resourcesdir = "${cfgddir}/collector"
}
