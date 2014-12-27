# == Define: jail::puppet
#
# Sets puppet.conf
#
# === Parameters
#
# [*report*]
#
# [*graph*]
#
# [*server*]
#
# [*logdir*]
#
# [*rundir*]
#
# [*ssldir*]
#
# [*runinterval*]
#

define jail::puppetconf(
  $server,
  $report = false,
  $graph  = false,
  $logdir = "${jail::vardir}/log",
  $rundir = "${jail::vardir}/run",
  $ssldir = "${jail::confdir}/ssl",
  $runinterval = 600,
){
  $config_file = 'puppet.conf'
  $manage_file_path = '/usr/local/etc/puppet.conf'

  file { $config_file:
    ensure  => present,
    path    => $manage_file_path,
    owner   => $jail::config_file_owner,
    group   => $jail::config_file_group,
    mode    => $jail::config_file_mode,
    content => template('jail/puppet.conf.erb'),
  }
}

