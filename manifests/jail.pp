# == Define: jail::jail
#
# Creates a jail
#
# === Parameters
#
# [*hostname*]
#   Hostname of the jail
#
# [* vnet_enable *]
# Create the	prison with its	own virtual network stack, with	its
# own network interfaces, addresses,	routing	table, etc.
define jail::jail(
  $ensure = running,
  $hostname = $name,
  $basejail = undef,
  $vnet_enable = false,
  $vnet_mode = 'new',
  $vnet_interfaces = undef,
  $vnet_interfaces_bridge = undef,
  $ip4 = 'inherit',
  $ip4_addr = undef,
  $ip6 = 'inherit',
  $ip6_addr = undef,
  $mount_devfs = true,
  $allow_set_hostname = false,
  $allow_sysvipc = false,
  $allow_raw_sockets = false,
  $allow_chflags = false,
  $allow_mount = false,
  $allow_mount_devfs = false,
  $allow_mount_nullfs = false,
  $allow_mount_procfs = false,
  $allow_mount_tmpfs = false,
  $allow_mount_zfs = false,
  $allow_quotas = false,
  $allow_socket_af = false,
  $install_puppet = true,
  $files_jail_create = $jail::files_jail_create,
  $files_basejail_links = $jail::files_basejail_links,
  $files_basejail_copy = $jail::files_basejail_copy,

){
  $jail_location = "${jail::jails_location}/${name}"
  $service_name = "jail-${name}"
  $config_file = "jail.conf-${name}"

  $manage_file_path = "${jail::config_dir}/${name}.conf"

  $file_ensure = $ensure ? {
    running => present,
    present => present,
    stopped => present,
    absent  => absent
  }
  $service_ensure = $ensure ? {
    running => running,
    present => stopped,
    stopped => stopped,
    absent  => stopped

  }

  # Check if the kernel has VIMAGE enabled if the jail has it's own vnet
  # network stack
  if $vnet_enable and !$::vimage_enabled {
    fail("vnet for jail ${name} enabled. But no VIMAGE support in Kernel")
  }


  # Make sure the config file exists
  file { $config_file:
    ensure  => $file_ensure,
    path    => $manage_file_path,
    owner   => $jail::config_file_owner,
    group   => $jail::config_file_group,
    mode    => $jail::config_file_mode,
    content => template('jail/jail.conf.erb'),
    notify  => [Service[$service_name]]
  }

  service { $service_name:
    ensure     => $service_ensure,
    hasrestart => true,
    start      => "/usr/sbin/jail -f ${manage_file_path} -c ${name}",
    stop       => "/usr/sbin/jail -f ${manage_file_path} -r ${name}",
    restart    => "/usr/sbin/jail -f ${manage_file_path} -rc ${name}",
    status     => "/usr/sbin/jls -j ${name}",
    require    => [File["jail.conf-${name}"]],
  }

  file {$jail_location:
    path   => $jail_location,
    ensure => directory
  }

  
  # Create folders
  # This cries for the foreach stuff in the future parser
  if $basejail != undef {
    $basejail_location = $jail::basejails_location
    file {"/mnt in ${name}":
      path    => "${jail_location}/mnt",
      ensure  => directory,
      require => File[$jail_location]
    }

    file {"/usr in ${name}":
      path    => "${jail_location}/usr",
      ensure  => directory,
      require => File[$jail_location]
    }

    exec {"/bin/cp -R ${basejail_location} ${jail_location}/etc":
      creates => "${jail_location}/etc"
    }
  } else {
    $freebsd_version = "${::kernelversion}-RELEASE"
    $architecture = $::hardwareisa
    $download_path = "${jail::freebsd_download_path}/${architecture}-${freebsd_version}"

    jail::download {$freebsd_version:
      architecture => $architecture
    }

    exec {"Extract base.txz in ${name}":
      path    => "/usr/bin",
      command => "tar --unlink -xvpJf ${download_path}/base.txz",
      cwd     => "${jail_location}",
      creates => "${jail_location}/README",
      require => Jail::Download[$freebsd_version]
    }

    exec {"Extract doc.txz in ${name}":
      path    => "/usr/bin",
      command => "tar --unlink -xvpJf ${download_path}/doc.txz",
      cwd     => "${jail_location}",
      creates => "${jail_location}/usr/share/doc/papers",
      require => Jail::Download[$freebsd_version]
    }
  }
}
