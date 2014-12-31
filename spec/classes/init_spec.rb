require 'spec_helper'
describe 'jail', :type => :class do

  let :facts do
   {:osfamily => 'FreeBSD', :hardwaremodel => 'amd64' }
 end

  context 'with defaults for all parameters' do
    it { should contain_file('jail.d').with(
      :ensure => 'directory'
    )}
    it { should contain_file('/usr/local/puppet-components').with(
      :ensure => 'directory'
    )}
    it { should contain_file('/usr/local/puppet-jail-scripts').with(
      :ensure => 'directory'
    )}

  end
end
