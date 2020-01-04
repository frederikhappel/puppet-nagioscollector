# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#       Creates a hash with child host as key and parent hosts as value.
#
#
#
Puppet::Functions.create_function(:'nagioscollector::nagioscollector_parent_hosts') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    

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
