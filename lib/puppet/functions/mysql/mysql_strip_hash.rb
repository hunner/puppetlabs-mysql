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
#   TEMPORARY FUNCTION: EXPIRES 2014-03-10
#When given a hash this function strips out all blank entries.
#
#
Puppet::Functions.create_function(:'mysql::mysql_strip_hash') do
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
    

    hash = args[0]
    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'mysql_strip_hash(): Requires hash to work with')
    end

    # Filter out all the top level blanks.
    hash.reject{|k,v| v == ''}.each do |k,v|
      if v.is_a?(Hash)
        v.reject!{|ki,vi| vi == '' }
      end
    end

  
  end
end
