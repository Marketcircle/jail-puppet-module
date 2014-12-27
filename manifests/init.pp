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
  }
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
