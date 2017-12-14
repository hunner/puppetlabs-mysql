require 'spec_helper_acceptance'

describe 'MODULES-4794 MariaDB from RedHat Software Collections' do
  before(:all) do
    shell "yum install -y centos-release-scl-rh"
  end

  describe 'installing' do
    let(:pp) do
      <<-EOS
        $mariadb_package = 'rh-mariadb101'
        $mysql_root_pass = 'password'
        $mysql_pass = 'password'

        ## very ugly workaround for this bug
        #file { '/usr/libexec/mysqld':
        #  ensure => 'link',
        #  target => "/opt/rh/$mariadb_package/root/usr/libexec/mysqld",
        #  require => Class['mysql::server'],
        #}
        file { ['/etc/opt','/etc/opt/rh']: ensure => directory }
        class { 'mysql::server':
          config_file => "/etc/opt/rh/$mariadb_package/my.cnf",
          includedir => "/etc/opt/rh/$mariadb_package/my.cnf.d",
          root_password => $mysql_root_pass,
          package_name => $mariadb_package,
          service_name => "$mariadb_package-mariadb",
          users => {
            'user@localhost' => {
              ensure => present,
              password_hash => mysql_password($mysql_pass),
            }
          },
          override_options => {
            mysqld => {
              log-error => "/var/opt/rh/$mariadb_package/log/mariadb/mariadb.log",
              datadir => "/var/opt/rh/$mariadb_package/lib/mysql",
              pid-file => "/var/run/$mariadb_package-mariadb/mariadb.pid",
              socket => '/var/lib/mysql/mysql.sock',
            },
            mysqld_safe => {
              log-error => "/var/opt/rh/$mariadb_package/log/mariadb/mariadb.log",
            }
          }
        }
      EOS
    end

    it_behaves_like 'a idempotent resource'
  end
end
