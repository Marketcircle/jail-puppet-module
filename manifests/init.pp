#
class jail (
  $config_dir = $jail::params::config_dir,  $scripts_dir = $jail::params::scripts_dir,
  $jails_location = $jail::params::jails_location,
  $basejail_location = $jail::params::basejail_location,
  $freebsd_arch = $jail::params::freebsd_arch,
  $freebsd_version = $jail::params::freebsd_version,
  $freebsd_download_url = $jail::params::freebsd_download_url,
  $scripts_dir = $jail::params::scripts_dir,
  $puppet_download_url = $jail::params::puppet_download_url,
  $facter_download_url = $jail::params::facter_download_url,
  $hiera_download_url = $jail::params::hiera_download_url,
  $puppet_components_download_path = $jail::params::puppet_components_download_path,
) inherits jail::params {

  file { 'jail.d':
    ensure => directory,
    path   => $config_dir,
  }

  file { $jail::params::freebsd_download_path:
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
    mode    => '0744',
    owner   => 'root',
    group   => 'wheel',
    source  => 'puppet:///modules/jail/build_jail.sh',
    require => [File[$scripts_dir]]
  }

}
