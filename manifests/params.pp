
class jail::params {

  $config_dir        = '/etc/jail.d/'
  $config_file_owner = 'root'
  $config_file_group = 'wheel'
  $config_file_mode  = '0444'


  $freebsd_arch      = "amd64" # From facter
  $freebsd_version   = $operatingsystemrelease # By default the
                                         # jails will be the same freebsd version
                                         # as the host system

  $freebsd_download_url  = "ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/${freebsd_arch}/${freebsd_arch}/${freebsd_version}"
  $freebsd_components    = ['base','doc','games','lib32','ports'] # Kernel is not required.
  $freebsd_download_path = '/usr/local/freebsd-dist'

  $jails_location    = '/usr/local/jails'
  $basejail_location = "${jails_location}/basejail"

  $scripts_dir = '/usr/local/puppet-jail-scripts'
}
