require 'puppet/provider/mysql'

Puppet.features.add(:mysql_exists) do
  # Puppet::Provider::Mysql requires this file before it is defined
  false #Puppet::Provider::Mysql.mysql_command_exists?('mysql')
end

Puppet.features.add(:mysqld_exists) do
  # Puppet::Provider::Mysql requires this file before it is defined
  false #Puppet::Provider::Mysql.mysql_command_exists?('mysqld')
end

# Workaround for PUP-5985
Puppet.features.send :meta_def, 'mysql_exists?' do
  name = :mysql_exists
  final = @results[name]
  @results[name] = Puppet::Provider::Mysql.mysql_command_exists?('mysql') unless final
  @results[name]
end

# Workaround for PUP-5985
Puppet.features.send :meta_def, 'mysqld_exists?' do
  name = :mysqld_exists
  final = @results[name]
  @results[name] = Puppet::Provider::Mysql.mysql_command_exists?('mysqld') unless final
  @results[name]
end
