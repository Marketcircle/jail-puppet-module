# == Define: jail::jail
#
# Creates a jail
#
# === Parameters
#
# [*hostname*]
#   Hostname of the jail
#
# [*ipv4_address*]
#
# [*ipv6_address*]
#
# [*interface*]
#
# [*mount_devfs*]
#
# [*allow_set_hostname*]
#
# [*allow_sysvipc*]
#
# [*allow_raw_sockets*]
#
# [*allow_chflags*]
#
# [*allow_mount*]
#
# [*allow_mount_nullfs*]
#
# [*allow_mount_procfs*]
#
# [*allow_mount_tmpfs*]
#
# [*allow_mount_zfs*]
#
# [*allow_quotas*]
#
# [*allow_socket_af*]
#
# [*ip4_addr*]
#
# [*ip6_addr*]

define jail::jail(
  $hostname,
  $ipv4_address,
  $ipv6_address,
  $interface,
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
  

  $install_puppet = true
){
  $jail_location = "${jail::jails_location}/${name}"
  $service_name = "jail-${name}"
  $config_file = "jail.conf-${name}"

  $manage_file_path = "${jail::config_dir}/${name}.conf"

  exec {"create-${name}-jail":
    command => "${jail::create_jail_script} -b ${jail::basejail_location} -l ${jail_location}",
    creates => $jail_location
  }

  file { $config_file:
    ensure  => present,
    path    => $manage_file_path,
    owner   => $jail::config_file_owner,
    group   => $jail::config_file_group,
    mode    => $jail::config_file_mode,
    content => template('jail/jail.conf.erb'),
    notify  => [Service[$service_name]]
  }

  service { $service_name:
    ensure     => running,
    hasrestart => false,
    start      => "/usr/sbin/jail -f ${manage_file_path} -c ${name}",
    stop       => "/usr/sbin/jail -f ${manage_file_path} -r ${name}",
    restart    => "/usr/sbin/jail -f ${manage_file_path} -mr ${name}",
    status     => "/usr/sbin/jls -j ${name}",
    require    => [File["jail.conf-${name}"], Exec["create-${name}-jail"]],
  }

}
