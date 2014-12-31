require 'spec_helper'

describe 'jail::jail', :type => :define do

  let(:title) {'testjail'}

  let :facts do
    {
      :osfamily => 'FreeBSD',
      :operatingsystem => 'FreeBSD',
      :operatingsystemrelease => '10.1-RELEASE',
      :hardwaremodel => 'amd64',
    }
  end


  let :pre_condition do
    "class {'jail':}"
  end
  describe 'it should work with default parameters' do
    it { is_expected.to contain_service('jail-testjail').with({
      :ensure => 'running',
      :hasrestart => true,
      :start => '/usr/sbin/jail -f /usr/local/etc/jail.d/testjail.conf -c testjail'
    })}
  end
end
