Facter.add('vimage_enabled') do
  confine :kernel => :FreeBSD
  setcode do
    Facter::Util::Resolution.exec('/sbin/sysctl -n kern.features.vimage') == 1
  end
end
