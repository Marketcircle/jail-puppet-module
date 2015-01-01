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

  $link_ensure = $file_ensure ? {
    present => link,
    absent  => absent,
  }

  $directory_ensure = $file_ensure ? {
    present => directory,
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
    ensure => $directory_ensure,
    path   => $jail_location,
  }

  anchor {"setup-${name}":}

  # Create folders
  # This cries for the foreach stuff in the future parser
  if $basejail != undef {
    $basejail_location = $jail::basejails_location

    file {"/basejail in ${name}":
      ensure  => $directory_ensure,
      path    => "${jail_location}/basejail",
      require => File[$jail_location]
    } -> Anchor["setup-${name}"]

    file {"/mnt in ${name}":
      ensure  => $directory_ensure,
      path    => "${jail_location}/mnt",
      require => File[$jail_location]
    } -> Anchor["setup-${name}"]

    file {"/usr in ${name}":
      ensure  => $directory_ensure,
      path    => "${jail_location}/usr",
      require => File[$jail_location]
    } -> Anchor["setup-${name}"]

    file {"/tmp in ${name}":
      ensure  => $directory_ensure,
      path    => "${jail_location}/tmp",
      require => File[$jail_location]
    } -> Anchor["setup-${name}"]


    exec {"/bin/cp -R ${basejail_location} ${jail_location}/etc":
      creates => "${jail_location}/etc",
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    exec {"/bin/cp -R ${basejail_location} ${jail_location}/root":
      creates => "${jail_location}/root",
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    exec {"/bin/cp -R ${basejail_location} ${jail_location}/var":
      creates => "${jail_location}/var",
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    exec {"/bin/cp -R ${basejail_location} ${jail_location}/usr/games":
      creates => "${jail_location}/usr/games",
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    exec {"/bin/cp -R ${basejail_location} ${jail_location}/usr/local":
      creates => "${jail_location}/usr/local",
      require => File["${jail_location}"]
    }  -> Anchor["setup-${name}"]

    exec {"/bin/cp -R ${basejail_location} ${jail_location}/usr/obj":
      creates => "${jail_location}/usr/obj",
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/bin":
      ensure  => $link_ensure,
      target  => 'basejail/bin',
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/lib":
      ensure  => $link_ensure,
      target  => 'basejail/lib',
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/libexec":
      ensure  => $link_ensure,
      target  => 'basejail/libexec',
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/sbin":
      ensure  => $link_ensure,
      target  => 'basejail/sbin',
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/sys":
      ensure  => $link_ensure,
      target  => 'basejail/sys',
      require => File["${jail_location}"]
    } -> Anchor["setup-${name}"]


    file {"${jail_location}/usr/bin":
      ensure => $link_ensure,
      target => 'basejail/usr/bin',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/games":
      ensure  => $link_ensure,
      target  => 'basejail/usr/games',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/include":
      ensure  => $link_ensure,
      target  => 'basejail/usr/include',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/lib":
      ensure  => $link_ensure,
      target  => 'basejail/usr/lib',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/lib32":
      ensure  => $link_ensure,
      target  => 'basejail/usr/lib32',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/libdata":
      ensure  => $link_ensure,
      target  => 'basejail/usr/libdata',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/libexec":
      ensure  => $link_ensure,
      target  => 'basejail/usr/libexec',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/ports":
      ensure  => $link_ensure,
      target  => 'basejail/usr/ports',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/sbin":
      ensure  => $link_ensure,
      target  => 'basejail/usr/sbin',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/share":
      ensure  => $link_ensure,
      target  => 'basejail/usr/share',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]

    file {"${jail_location}/usr/src":
      ensure  => $link_ensure,
      target  => 'basejail/usr/src',
      require => File["${jail_location}/usr"]
    } -> Anchor["setup-${name}"]
  } else {
    $freebsd_version = "${::kernelversion}-RELEASE"
    $architecture = $::hardwareisa
    $download_path = "${jail::freebsd_download_path}/${architecture}-${freebsd_version}"

    jail::download {$freebsd_version:
      architecture => $architecture
    } -> Anchor["setup-${name}"]

    exec {"Extract base.txz in ${name}":
      path    => '/usr/bin',
      command => "tar --unlink -xpJf ${download_path}/base.txz",
      cwd     => $jail_location,
      creates => "${jail_location}/var",
      returns => [0,1],
      require => Jail::Download[$freebsd_version]
    } -> Anchor["setup-${name}"]

    exec {"Extract doc.txz in ${name}":
      path    => '/usr/bin',
      command => "tar --unlink -xpJf ${download_path}/doc.txz",
      cwd     => $jail_location,
      creates => "${jail_location}/usr/share/doc/papers",
      require => Jail::Download[$freebsd_version]
    } -> Anchor["setup-${name}"]
  }


  if $install_puppet {
    exec {"Install puppet in ${name}":
      command => "/usr/sbin/pkg -c ${jail_location} install puppet"
    } <- Anchor["setup-${name}"]
  }

  file {"/etc/rc.conf for ${name}":
    ensure  => $file_ensure,
    content => template('jail/rc.conf.erb')
  } <- Anchor["setup-${name}"]
}
