class jail::basejail (
    $basejail_location = $jail::params::basejail_location,
    $freebsd_download_url = $jail::params::freebsd_download_url,
    $freebsd_components = $jail::params::freebsd_components,
    $freebsd_download_path = $jail::params::freebsd_download_path
) inherits jail::params {

  $basejail_script = "${jail::scripts_dir}/build_basejail.sh"
  file {$basejail_script:
    ensure => present,
    mode   => 744,
    owner  => 'root',
    group  => 'wheel',
    source => 'puppet:///modules/jail/build_basejail.sh'
  }

  exec {'build basejail':
    command => "${basejail_script} -d ${freebsd_download_path} -b ${basejail_location}",
    creates => $basejail_location
  }
}
