# Class: mysql::server
#
# manages the installation of the mysql server.  manages the package, service,
# my.cnf
#
# Parameters:
#   [*package_name*] - name of package
#   [*service_name*] - name of service
#   [*config_hash*]  - hash of config parameters that need to be set.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql::server (
  $package_name     = $mysql::params::server_package_name,
  $package_ensure   = 'present',
  $service_name     = $mysql::params::service_name,
  $service_provider = $mysql::params::service_provider,
  $config_hash      = {},
  $enabled          = true,
  $replication      = undef,
  $logbin           = 'mysql-bin',
  $server_id        = undef,
  $manage_service   = true
) inherits mysql::params {

  Class['mysql::server'] -> Class['mysql::config']

  if $replication {
    validate_re($replication, '^(master|slave)$',
    validate_re($server_id, '^\d+$',
  }

  $config_class = { 'mysql::config' => $config_hash }

  create_resources( 'class', $config_class )

  package { 'mysql-server':
    ensure => $package_ensure,
    name   => $package_name,
  }

  case $replication {
    'master': {
      validate_string($logbin)
      mysql::server::config { 'master_replication':
        settings => {
          'mysqld' => {
            'log-bin' => $logbin,
            'server-id' => $server_id,
          }
        },
        notify_service => true,
      }
    }
    'slave': {
      mysql::server::config { 'slave_replication':
        settings => {
          'mysqld' => {
            'server-id' => $server_id,
          }
        },
        notify_service => true,
      }
    }
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  if $manage_service {
    service { 'mysqld':
      ensure   => $service_ensure,
      name     => $service_name,
      enable   => $enabled,
      require  => Package['mysql-server'],
      provider => $service_provider,
    }
  }
}
