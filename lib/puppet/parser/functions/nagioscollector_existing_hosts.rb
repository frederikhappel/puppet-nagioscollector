module Puppet::Parser::Functions
  newfunction(:nagioscollector_existing_hosts, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Return a hash with all existing hosts, their parameters and their services.

    ENDHEREDOC

    error_head = "nagioscollector_existing_hosts(collector_tag)"

    raise(Puppet::ParseError, "#{error_head}: Wrong number of arguments " +
      "given (#{args.size}; must be 1)") unless args.size == 1

    collector_tag = args[0]
    raise Puppet::ParseError, "#{error_head}: expects the first argument to be a string," +
      "got #{collector_tag.inspect} which is of type #{collector_tag.class}" unless collector_tag.is_a?(String)

    Puppet::Parser::Functions.autoloader.load(:pdbresourcequery) \
      unless Puppet::Parser::Functions.autoloader.loaded?(:pdbresourcequery)

    hosts = function_pdbresourcequery([
      ['and',
        ['=', 'tag', collector_tag],
        ['=', 'type', 'Nagioscollector::Resource::Host'],
        ['=', 'exported', true],
        ['=', ['parameter', 'ensure'], 'present'],
      ]
    ])
    existing_hosts = {}
    hosts.each do |host|
      hostname = host['title'].downcase
      existing_hosts[hostname] = host['parameters']
      existing_hosts[hostname]['services'] = {}
    end

    # add services
    services = function_pdbresourcequery([
      ['and',
        ['=', 'tag', collector_tag],
        ['=', 'type', 'Nagioscollector::Resource::Service'],
        ['=', 'exported', true],
        ['=', ['parameter', 'ensure'], 'present'],
      ]
    ])
    self_host_name = lookupvar('::fqdn').downcase
    services.each do |service|
      on_collector = [service['parameters']['only_on_collector']].flatten.compact
      service_host = service['parameters']['host_name'].downcase
      if !existing_hosts[service_host].nil? and (on_collector.empty? or on_collector.index(self_host_name) != nil)
        service_key = service['parameters']['service_description'].downcase
        existing_hosts[service_host]['services'][service_key] = service['parameters']
      end
    end

    existing_hosts
  end
end
