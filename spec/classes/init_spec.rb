require 'spec_helper'
describe 'jail', :type => :class do

  let :facts do
    {
      :kernel => 'FreeBSD',
      :osfamily => 'FreeBSD',
      :operatingsystem => 'FreeBSD',
      :operatingsystemrelease => '10.1-RELEASE',
      :hardwaremodel => 'amd64',
    }
  end


  context 'with defaults for all parameters' do
    it { should contain_file('jail.d').with(
      :ensure => 'directory'
    )}
    it { should contain_file('/usr/local/puppet-components').with(
      :ensure => 'directory'
    )}


  end
end
