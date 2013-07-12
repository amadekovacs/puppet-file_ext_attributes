Puppet::Type.type(:file).newproperty(:extattr) do
  desc "Add a single extended attribute to a file

    file { '/tmp/extattr':
      ensure => 'present',
      content => 'testy',
      mode    => '0644',
      extattr => 'myattr=myattrvalue',
    }
  
    Notes
      this calls out to the getfattr and setfattr and assums they are installed and in the path
      it also requires filesystem support for extended attributes
      only tested on linux
  "

  # we only allow the addition of 'user.' attributes
  munge do |value|
    unless value.match(/^user\./)
      value = 'user.' + value
    end

    value
  end

  validate do | value |
    raise ArgumentError, "Attributes are specified as key=value" unless value.match(/[\w\s]+=[\w\s]+/)
  end

  ##############################################

  def retrieve
    attr_name, attr_value = value.split('=')
    command = '/usr/bin/getfattr --only-values --absolute-names 2>/dev/null'

    # run the getfattr command line
    current_value = `#{command} #{resource[:path]} -n #{attr_name}`.chomp

    "#{attr_name}=#{current_value}"
  end

  def set(value)
  end

  def flush()
    attr_name, attr_value = value.split('=')
    `/usr/bin/setfattr -n #{attr_name} -v #{attr_value} #{resource[:path]}`
  end

end
