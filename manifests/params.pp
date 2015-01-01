#
class jail::params {

  $config_dir        = '/usr/local/etc/jail.d'
  $config_file_owner = 'root'
  $config_file_group = 'wheel'
  $config_file_mode  = '0444'
  $puppetconf_dir    = '/usr/local/jails/basejail/usr/local'

  $freebsd_arch      = $::hardwaremodel # From facter

  # By default the jails will be the same freebsd version as the host system
  $freebsd_version   = $::operatingsystemrelease

  $freebsd_download_url  = 'ftp://ftp.FreeBSD.org/pub/FreeBSD/releases'
  $freebsd_components    = ['base','doc','games','lib32','ports'] # Kernel is not required.
  $freebsd_download_path = '/usr/local/freebsd-dist'
  
  $jails_location = '/usr/local/jails'
  $puppet_download_url='https://downloads.puppetlabs.com/puppet/puppet-3.7.1.tar.gz'
  $facter_download_url='http://downloads.puppetlabs.com/facter/facter-2.2.0.tar.gz'
  $hiera_download_url='https://downloads.puppetlabs.com/hiera/hiera-1.3.4.tar.gz'

  $puppet_components_download_path = '/usr/local/puppet-components'


  $files_jail_create = ['usr','mnt']
  $files_basejail_links = ['bin', 'boot', 'lib', 'libexec', 'rescue', 'sbin',
                          'sys', 'usr/bin', 'usr/include', 'usr/lib', 'usr/lib32',
                          'usr/libdata', 'usr/ports', 'usr/sbin', 'usr/share', 'usr/src'
  ]

  $files_basejail_copy = ['etc', 'root', 'tmp', 'usr', 'var']


}
