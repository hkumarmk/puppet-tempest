Puppet::Type.newtype(:tempest_config) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Section/setting name to manage from tempest.conf'
    newvalues(/\S+\/\S+/)
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |value|
      value = value.to_s.strip
      value.capitalize! if value =~ /^(true|false)$/i
      value
    end

    def is_to_s( currentvalue )
      if resource.secret?
        return '[old secret redacted]'
      else
        return currentvalue
      end
    end

    def should_to_s( newvalue )
      if resource.secret?
        return '[new secret redacted]'
      else
        return newvalue
      end
    end
  end

  newparam(:secret, :boolean => true) do
    desc 'Whether to hide the value from Puppet logs. Defaults to `false`.'

    newvalues(:true, :false)

    defaultto false
  end

  newparam(:path) do
    desc 'The ini file Puppet will ensure contains the specified setting.'
    validate do |value|
      unless (Puppet.features.posix? and value =~ /^\//) or (Puppet.features.microsoft_windows? and (value =~ /^.:\// or value =~ /^\/\/[^\/]+\/[^\/]+/))
        raise(Puppet::Error, "File paths must be fully qualified, not '#{value}'")
      end
    end
  end

  newparam(:set_id) do
    desc 'Write id of given value rather than value itself.
          This is required as sometimes tempest need id(uuid) rather than name such as for image_ref, public_network_id.
          The values glance_image and network are valid.'
    validate do |value|
      if value !~ /(glance_image|network|flavor)/
        raise(Puppet::Error, "Invalid values, Valid values are: glance_image, network")
      end
    end
  end
end
