class nagioscollector::monitoredhost (
  $host_template = undef,
  $service_template = undef,
  $escalation_type = undef,
  $collector_tag,
) {
  # validate parameters
  if !is_string($collector_tag) and !is_array($collector_tag) {
    fail('$collector_tag needs to be of type String or Array')
  }
  validate_string($host_template, $escalation_type, $service_template)

  # realize all defined nagios objects
  Nagioscollector::Resource::Host <||> {
    template => $host_template,
    escalation_type => $escalation_type,
    tag => $collector_tag,
  }
  Nagioscollector::Resource::Hostgroup <||> {
    tag => $collector_tag,
  }
  Nagioscollector::Resource::Hostdependency <||> {
    tag => $collector_tag,
  }
  Nagioscollector::Resource::Service <||> {
    template => $service_template,
    escalation_type => $escalation_type,
    tag => $collector_tag,
  }
}