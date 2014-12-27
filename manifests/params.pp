
class jail::params {

  $config_dir        = '/etc/jail.d/'
  $config_file_owner = 'root'
  $config_file_group = 'wheel'
  $config_file_mode  = '0444'
  $puppetconf_dir    = '/usr/local/jails/basejail/usr/local'

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

  $puppet_download_url='https://downloads.puppetlabs.com/puppet/puppet-3.7.1.tar.gz'
  $facter_download_url='http://downloads.puppetlabs.com/facter/facter-2.2.0.tar.gz'
  $hiera_download_url='https://downloads.puppetlabs.com/hiera/hiera-1.3.4.tar.gz'
  $puppet_components_download_path = '/usr/local/puppet-components'
}
