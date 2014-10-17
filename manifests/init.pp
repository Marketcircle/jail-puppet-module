# == Class: jail
#
# Full description of class jail here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { jail:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#

# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class jail (
  $config_dir = $jail::params::config_dir,  $scripts_dir = $jail::params::scripts_dir,
  $jails_location = $jail::params::jails_location,
  $basejail_location = $jail::params::basejail_location
) inherits jail::params {

  file { 'jail.d':
    ensure => directory,
    path   => $config_dir,
  }

  file { $freebsd_download_path:
    ensure => directory,
  }
  
  file { $puppet_components_download_path:
  	ensure => directory,

  file {$scripts_dir:
    ensure => directory,
  }

  $create_jail_script = "${jail::scripts_dir}/build_jail.sh"
  file {$create_jail_script:
    ensure  => present,
    mode    => 744,
    owner   => 'root',
    group   => 'wheel',
    source  => 'puppet:///modules/jail/build_jail.sh',
    require => [File[$scripts_dir]]
  }

}
