module Puppet::Parser::Functions
  newfunction(:nagioscollector_parent_hosts, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Creates a hash with child host as key and parent hosts as value.

    ENDHEREDOC

    error_head = "nagioscollector_parent_hosts(hostdependencies)"

    raise(Puppet::ParseError, "#{error_head}: Wrong number of arguments " +
      "given (#{args.size}; must be 1)") unless args.size == 1

    hostdependencies = args[0]
    raise Puppet::ParseError, "#{error_head}: expects the first argument to be an array," +
      "got #{hostdependencies.inspect} which is of type #{hostdependencies.class}" unless hostdependencies.is_a?(Array)

    parents = {}
    hostdependencies.each do |hostdependency|
      if hostdependency['parameters']['ensure'] == 'present'
        parent_host_name = hostdependency['title'].downcase
        [hostdependency['parameters']['dependent_host_names']].flatten.each do |dependent_host_name|
          dependent_host_name.downcase!
          if !parents.has_key?(dependent_host_name)
            parents[dependent_host_name] = [parent_host_name]
          else
            parents[dependent_host_name] << parent_host_name
          end
        end
      end
    end
    parents
  end
end
