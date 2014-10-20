Facter.add('jailed') do
  confine :kernel => :FreeBSD
  setcode do
    Facter::Util::Resolution.exec('/sbin/sysctl -n security.jail.jailed') == 1
  end
end
